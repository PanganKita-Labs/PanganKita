import 'package:pangankita/features/discovery/domain/listing.dart';

/// One local prototype reservation and its immutable listing snapshot.
class Reservation {
  /// Creates a reservation snapshot.
  const new({
    required this.id,
    required this.listing,
    required this.quantity,
    required this.pickupCode,
    required this.createdAt,
    required this.status,
  });

  /// Local-only identifier.
  final String id;

  /// Listing details captured when the reservation was created.
  final Listing listing;

  /// Number of packages reserved.
  final int quantity;

  /// Predictable demonstration code, never a secure pickup credential.
  final String pickupCode;

  /// Time the local reservation was created.
  final DateTime createdAt;

  /// Current prototype lifecycle state.
  final ReservationStatus status;

  /// Amount to pay to the merchant at pickup, in whole rupiah.
  int get amountDueRupiah => quantity * listing.offer.priceRupiah;

  /// Returns a new snapshot after a validated repository transition.
  Reservation withStatus(ReservationStatus next) => Reservation(
    id: id,
    listing: listing,
    quantity: quantity,
    pickupCode: pickupCode,
    createdAt: createdAt,
    status: next,
  );
}

/// States supported by the Phase 03 local prototype.
enum ReservationStatus {
  /// Quantity is held in the local demo.
  reserved,

  /// Merchant readiness is simulated for the local demo.
  readyForPickup,

  /// Pickup completion is simulated for the local demo.
  completed,

  /// Consumer cancelled before readiness.
  cancelled,

  /// Pickup deadline passed without completion.
  expired,
}

/// Reasons a local reservation action can be rejected.
enum ReservationFailure {
  /// Listing, quantity, or pickup time no longer permits creation.
  unavailable,

  /// The requested local reservation does not exist.
  notFound,

  /// The requested state change is not legal now.
  invalidTransition,
}

/// Typed failure from the local reservation repository.
class ReservationException implements Exception {
  /// Creates a typed failure.
  const new(this.failure);

  /// Why the action failed.
  final ReservationFailure failure;
}
