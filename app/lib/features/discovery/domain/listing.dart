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
    required this.status,
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

  /// Current local listing lifecycle state.
  final ListingStatus status;

  /// Replaces only the mutable prototype fields.
  Listing copyWith({ListingOffer? offer, ListingStatus? status}) => Listing(
    id: id,
    name: name,
    category: category,
    content: content,
    offer: offer ?? this.offer,
    merchant: merchant,
    status: status ?? this.status,
  );
}

/// Listing states shown in the local merchant experience.
enum ListingStatus {
  /// Saved but hidden from consumer discovery.
  draft,

  /// Available for local discovery and reservation.
  active,

  /// No reservable quantity remains.
  soldOut,

  /// Pickup deadline passed.
  expired,

  /// Merchant intentionally closed the listing.
  cancelled,
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
    required this.totalQuantity,
    required this.pickupStartsAt,
    required this.pickupDeadline,
    int? availableQuantity,
  }) : availableQuantity = availableQuantity ?? totalQuantity;

  static const _percentScale = 100;

  /// Surplus price in whole rupiah.
  final int priceRupiah;

  /// Seller-provided original price in whole rupiah.
  final int originalPriceRupiah;

  /// Total quantity published or set by the merchant in the local demo.
  final int totalQuantity;

  /// Units available in this local snapshot, after local demo holds.
  final int availableQuantity;

  /// Start of the seller's pickup window.
  final DateTime pickupStartsAt;

  /// End of the seller's pickup window.
  final DateTime pickupDeadline;

  /// Returns an offer after a permitted quantity change.
  ListingOffer withQuantity({required int total, int? available}) =>
      ListingOffer(
        priceRupiah: priceRupiah,
        originalPriceRupiah: originalPriceRupiah,
        totalQuantity: total,
        availableQuantity: available,
        pickupStartsAt: pickupStartsAt,
        pickupDeadline: pickupDeadline,
      );

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
    required this.id,
    required this.name,
    required this.area,
    required this.distanceMeters,
    required this.pickupAddress,
  });

  /// Stable local business identifier, not an authorization grant.
  final String id;

  /// Fictional business name in prototype data.
  final String name;

  /// Area shown without requesting device location.
  final String area;

  /// Illustrative distance from the selected prototype area.
  final int distanceMeters;

  /// Fictional pickup address for the prototype.
  final String pickupAddress;
}

/// Values entered before a local merchant listing is saved or published.
class ListingDraft {
  /// Creates an unvalidated form snapshot.
  const new({
    required this.merchant,
    required this.name,
    required this.category,
    required this.description,
    required this.imageAsset,
    required this.originalPriceRupiah,
    required this.priceRupiah,
    required this.quantity,
    required this.pickupStartsAt,
    required this.pickupDeadline,
    required this.surplusReason,
    required this.condition,
    this.storage = '',
    this.allergens = '',
  });

  /// Fixed demo business, supplied by application composition.
  final ListingMerchant merchant;

  /// Food or package name.
  final String name;

  /// Existing discovery category.
  final ListingCategory category;

  /// Seller's short description.
  final String description;

  /// Existing local illustrative asset.
  final String imageAsset;

  /// Seller-provided reference price in whole rupiah.
  final int originalPriceRupiah;

  /// Surplus price in whole rupiah.
  final int priceRupiah;

  /// Initial number of packages.
  final int quantity;

  /// Pickup window start.
  final DateTime pickupStartsAt;

  /// Absolute pickup deadline.
  final DateTime pickupDeadline;

  /// Seller's reason for offering surplus food.
  final String surplusReason;

  /// Seller-provided condition statement, not a platform certification.
  final String condition;

  /// Optional seller-provided storage statement.
  final String storage;

  /// Optional seller-provided allergen statement.
  final String allergens;

  /// Validates only concrete form and timing rules for the local demo.
  bool isValidAt(DateTime now) =>
      name.trim().isNotEmpty &&
      description.trim().isNotEmpty &&
      surplusReason.trim().isNotEmpty &&
      condition.trim().isNotEmpty &&
      originalPriceRupiah > 0 &&
      priceRupiah >= 0 &&
      priceRupiah <= originalPriceRupiah &&
      quantity > 0 &&
      pickupStartsAt.isBefore(pickupDeadline) &&
      pickupDeadline.isAfter(now);
}

/// Reasons a local listing action can be rejected.
enum ListingFailure {
  /// Entered values or pickup time are invalid.
  invalidDraft,

  /// Requested local listing is absent.
  notFound,

  /// Current state does not permit the action.
  invalidTransition,

  /// Quantity is below held stock or pickup is still active.
  heldQuantity,
}

/// Typed failure from a local listing operation.
class ListingException implements Exception {
  /// Creates a typed failure.
  const new(this.failure);

  /// Why the operation was rejected.
  final ListingFailure failure;
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
