import 'package:pangankita/features/discovery/data/mock_listing_repository.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';
import 'package:pangankita/features/reservations/domain/reservation_repository.dart';

/// In-memory reservation state shared by the local consumer screens.
class MockReservationRepository implements ReservationRepository {
  /// Creates the demo store with one listing source and replaceable clock.
  new(this._listings, this._now);

  static const _codeWidth = 4;

  final MockListingRepository _listings;
  final DateTime Function() _now;
  final List<Reservation> _reservations = [];
  int _nextId = 0;

  @override
  Future<Reservation> create(String listingId, int quantity) async {
    final now = _now();
    final listing = _listings.reserve(listingId, quantity, now);
    if (listing == null) {
      throw const ReservationException(ReservationFailure.unavailable);
    }
    final sequence = ++_nextId;
    final reservation = Reservation(
      id: 'demo-$sequence',
      listing: listing,
      quantity: quantity,
      pickupCode: 'PK-${sequence.toString().padLeft(_codeWidth, '0')}',
      createdAt: now,
      status: ReservationStatus.reserved,
    );
    _reservations.add(reservation);
    return reservation;
  }

  @override
  Future<List<Reservation>> loadReservations() async {
    _expirePastDeadlines();
    return List<Reservation>.unmodifiable(_reservations.reversed);
  }

  @override
  Future<Reservation?> getReservation(String id) async {
    _expirePastDeadlines();
    for (final reservation in _reservations) {
      if (reservation.id == id) return reservation;
    }
    return null;
  }

  @override
  Future<List<Reservation>> loadMerchantReservations(String merchantId) async {
    _expirePastDeadlines();
    return List<Reservation>.unmodifiable(
      _reservations.reversed.where(
        (item) => item.listing.merchant.id == merchantId,
      ),
    );
  }

  @override
  Future<Reservation?> getMerchantReservation(
    String id,
    String merchantId,
  ) async {
    final reservation = await getReservation(id);
    return reservation?.listing.merchant.id == merchantId ? reservation : null;
  }

  @override
  Future<Reservation> markReady(String id) async => _transition(
    id,
    from: ReservationStatus.reserved,
    to: ReservationStatus.readyForPickup,
  );

  Reservation _complete(String id) {
    final completed = _transition(
      id,
      from: ReservationStatus.readyForPickup,
      to: ReservationStatus.completed,
    );
    _listings.finishHold(completed.listing.id, completed.quantity);
    return completed;
  }

  @override
  Future<Reservation> verifyPickup(
    String id,
    String merchantId,
    String code,
  ) async {
    final reservation = await getMerchantReservation(id, merchantId);
    if (reservation == null) {
      throw const ReservationException(ReservationFailure.notFound);
    }
    if (reservation.pickupCode != code.trim().toUpperCase()) {
      throw const ReservationException(ReservationFailure.invalidCode);
    }
    if (reservation.status == ReservationStatus.completed) return reservation;
    return _complete(id);
  }

  @override
  Future<Reservation> cancel(String id) async {
    final reservation = _transition(
      id,
      from: ReservationStatus.reserved,
      to: ReservationStatus.cancelled,
    );
    _listings.release(reservation.listing.id, reservation.quantity);
    return reservation;
  }

  Reservation _transition(
    String id, {
    required ReservationStatus from,
    required ReservationStatus to,
  }) {
    _expirePastDeadlines();
    for (var index = 0; index < _reservations.length; index++) {
      final reservation = _reservations[index];
      if (reservation.id != id) continue;
      if (reservation.status != from) {
        throw const ReservationException(ReservationFailure.invalidTransition);
      }
      final updated = reservation.withStatus(to);
      _reservations[index] = updated;
      return updated;
    }
    throw const ReservationException(ReservationFailure.notFound);
  }

  void _expirePastDeadlines() {
    final now = _now();
    for (var index = 0; index < _reservations.length; index++) {
      final reservation = _reservations[index];
      if ((reservation.status == ReservationStatus.reserved ||
              reservation.status == ReservationStatus.readyForPickup) &&
          !reservation.listing.offer.pickupDeadline.isAfter(now)) {
        _listings.finishHold(reservation.listing.id, reservation.quantity);
        _reservations[index] = reservation.withStatus(
          ReservationStatus.expired,
        );
      }
    }
  }
}
