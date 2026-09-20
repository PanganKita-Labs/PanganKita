import 'package:pangankita/features/reservations/domain/reservation.dart';

/// Reservation operations used by the consumer prototype screens.
abstract interface class ReservationRepository {
  /// Creates a local reservation when stock and time still permit it.
  Future<Reservation> create(String listingId, int quantity);

  /// Returns current local reservations, newest first.
  Future<List<Reservation>> loadReservations();

  /// Returns the current reservation or null when absent.
  Future<Reservation?> getReservation(String id);

  /// Returns reservations for one fictional merchant, newest first.
  Future<List<Reservation>> loadMerchantReservations(String merchantId);

  /// Returns one merchant reservation without exposing another merchant's.
  Future<Reservation?> getMerchantReservation(String id, String merchantId);

  /// Simulates the merchant marking an existing reservation ready.
  Future<Reservation> markReady(String id);

  /// Simulates pickup completion after readiness.
  Future<Reservation> complete(String id);

  /// Completes one ready reservation after matching its local demo code.
  /// Repeated verification of the completed code returns the same result.
  Future<Reservation> verifyPickup(String id, String merchantId, String code);

  /// Cancels a reservation while it remains reserved.
  Future<Reservation> cancel(String id);
}
