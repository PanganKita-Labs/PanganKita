/// A local snapshot of food offered for pickup.
class Listing {
  /// Creates a listing snapshot.
  const new({
    required this.id,
    required this.name,
    required this.category,
    required this.content,
    required this.offer,
    required this.merchant,
  });

  /// Stable listing identifier.
  final String id;

  /// Food name supplied by the business.
  final String name;

  /// Category used by local discovery filters.
  final ListingCategory category;

  /// Description, photo, and seller-provided food information.
  final ListingContent content;

  /// Price, quantity, and pickup window in this snapshot.
  final ListingOffer offer;

  /// Seller and pickup location shown to the consumer.
  final ListingMerchant merchant;
}

/// Categories supported by the current discovery fixtures.
enum ListingCategory {
  /// Bread and pastry fixtures.
  bakery,

  /// Ready-to-pick-up meal fixtures.
  meal,
}

/// Listing text and imagery supplied for the prototype.
class ListingContent {
  /// Creates the content of a listing.
  const new({
    required this.description,
    required this.imageAsset,
    required this.sellerInfo,
  });

  /// Short description of the food.
  final String description;

  /// Local image for the mock listing.
  final String imageAsset;

  /// Food information explicitly attributed to the seller.
  final SellerFoodInfo sellerInfo;
}

/// Price and availability within a pickup window.
class ListingOffer {
  /// Creates an offer snapshot.
  const new({
    required this.priceRupiah,
    required this.originalPriceRupiah,
    required this.availableQuantity,
    required this.pickupStartsAt,
    required this.pickupDeadline,
  });

  static const _percentScale = 100;

  /// Surplus price in whole rupiah.
  final int priceRupiah;

  /// Seller-provided original price in whole rupiah.
  final int originalPriceRupiah;

  /// Units available in this local snapshot, not reserved inventory.
  final int availableQuantity;

  /// Start of the seller's pickup window.
  final DateTime pickupStartsAt;

  /// End of the seller's pickup window.
  final DateTime pickupDeadline;

  /// Difference between original and surplus price, never below zero.
  int get savingsRupiah =>
      originalPriceRupiah > priceRupiah ? originalPriceRupiah - priceRupiah : 0;

  /// Whole-number savings percentage for the mock display.
  int get savingsPercent => originalPriceRupiah > 0
      ? savingsRupiah * _percentScale ~/ originalPriceRupiah
      : 0;
}

/// Public merchant and pickup location information.
class ListingMerchant {
  /// Creates the merchant summary shown with a listing.
  const new({
    required this.name,
    required this.area,
    required this.distanceMeters,
    required this.pickupAddress,
  });

  /// Fictional business name in prototype data.
  final String name;

  /// Area shown without requesting device location.
  final String area;

  /// Illustrative distance from the selected prototype area.
  final int distanceMeters;

  /// Fictional pickup address for the prototype.
  final String pickupAddress;
}

/// Information attributed to the listing's seller, not verified by PanganKita.
class SellerFoodInfo {
  /// Creates seller-provided food information.
  const new({
    required this.surplusReason,
    required this.condition,
    this.storage,
    this.allergens,
  });

  /// Why the seller offers the item as surplus.
  final String surplusReason;

  /// Seller's condition statement.
  final String condition;

  /// Seller's storage statement, when supplied.
  final String? storage;

  /// Seller's allergen statement, when supplied.
  final String? allergens;
}
