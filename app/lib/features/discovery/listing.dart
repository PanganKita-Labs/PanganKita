/// A prototype listing available for upcoming discovery screens.
class Listing {
  /// Creates an immutable listing snapshot.
  const new({
    required this.id,
    required this.name,
    required this.businessName,
    required this.priceRupiah,
    required this.availableQuantity,
    required this.pickupDeadline,
  });

  /// Stable listing identifier.
  final String id;

  /// Food name supplied by the business.
  final String name;

  /// Display name of the business.
  final String businessName;

  /// Integer rupiah amount; no floating-point money.
  final int priceRupiah;

  /// Available units in this local snapshot.
  final int availableQuantity;

  /// Unambiguous pickup deadline.
  final DateTime pickupDeadline;
}
