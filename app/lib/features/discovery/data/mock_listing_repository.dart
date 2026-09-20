import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/domain/listing_repository.dart';

/// Deterministic, prototype-only listing source.
class MockListingRepository implements ListingRepository {
  /// Captures one reference time so fixture deadlines stay stable per session.
  new({required DateTime referenceTime, required this.now})
    : _listings = _fixtures(referenceTime);

  /// Selected area used by the local prototype, not device location.
  static const prototypeArea = 'Tebet Barat, Jakarta Selatan';

  /// Fictional business selected by the local Business mode.
  static const prototypeMerchant = ListingMerchant(
    id: 'demo-bakery',
    name: 'Toko Roti Contoh',
    area: 'Tebet Barat',
    distanceMeters: 800,
    pickupAddress: 'Area Tebet Barat, Jakarta Selatan (alamat contoh)',
  );

  /// Replaceable clock for deterministic listing lifecycle transitions.
  final DateTime Function() now;
  final List<Listing> _listings;
  final Map<String, int> _heldQuantities = {};
  final Map<String, int> _activeHolds = {};
  int _nextListingId = 0;

  @override
  Future<List<Listing>> loadListings() async => List<Listing>.unmodifiable(
    _listings.map((item) => _snapshot(item, now())),
  );

  @override
  Future<Listing?> getListing(String id) async {
    for (final listing in _listings) {
      if (listing.id == id) return _snapshot(listing, now());
    }
    return null;
  }

  @override
  Future<List<Listing>> loadMerchantListings(String merchantId) async =>
      List<Listing>.unmodifiable(
        _listings.reversed
            .where((item) => item.merchant.id == merchantId)
            .map((item) => _snapshot(item, now())),
      );

  @override
  Future<Listing> createDraft(ListingDraft draft) async {
    if (!draft.isValidAt(now())) {
      throw const ListingException(ListingFailure.invalidDraft);
    }
    final storage = draft.storage.trim();
    final allergens = draft.allergens.trim();
    final listing = Listing(
      id: 'merchant-${++_nextListingId}',
      name: draft.name.trim(),
      category: draft.category,
      content: ListingContent(
        description: draft.description.trim(),
        imageAsset: draft.imageAsset,
        sellerInfo: SellerFoodInfo(
          surplusReason: draft.surplusReason.trim(),
          condition: draft.condition.trim(),
          storage: storage.isEmpty ? null : storage,
          allergens: allergens.isEmpty ? null : allergens,
        ),
      ),
      offer: ListingOffer(
        priceRupiah: draft.priceRupiah,
        originalPriceRupiah: draft.originalPriceRupiah,
        totalQuantity: draft.quantity,
        pickupStartsAt: draft.pickupStartsAt,
        pickupDeadline: draft.pickupDeadline,
      ),
      merchant: draft.merchant,
      status: ListingStatus.draft,
    );
    _listings.add(listing);
    return listing;
  }

  @override
  Future<Listing> publish(String id) async {
    final index = _indexOf(id);
    final listing = _listings[index];
    if (listing.status != ListingStatus.draft ||
        listing.offer.totalQuantity <= 0 ||
        !listing.offer.pickupDeadline.isAfter(now())) {
      throw const ListingException(ListingFailure.invalidTransition);
    }
    final published = listing.copyWith(status: ListingStatus.active);
    _listings[index] = published;
    return _snapshot(published, now());
  }

  @override
  Future<Listing> updateQuantity(String id, int totalQuantity) async {
    final index = _indexOf(id);
    final listing = _listings[index];
    final held = _heldQuantities[id] ?? 0;
    if (totalQuantity < held) {
      throw const ListingException(ListingFailure.heldQuantity);
    }
    if (totalQuantity < 0 ||
        (listing.status != ListingStatus.active &&
            listing.status != ListingStatus.draft) ||
        !listing.offer.pickupDeadline.isAfter(now())) {
      throw const ListingException(ListingFailure.invalidTransition);
    }
    final updated = listing.copyWith(
      offer: listing.offer.withQuantity(total: totalQuantity),
    );
    _listings[index] = updated;
    return _snapshot(updated, now());
  }

  @override
  Future<Listing> close(String id) async {
    final index = _indexOf(id);
    final listing = _listings[index];
    if ((_activeHolds[id] ?? 0) > 0) {
      throw const ListingException(ListingFailure.heldQuantity);
    }
    if (listing.status != ListingStatus.active &&
        listing.status != ListingStatus.draft) {
      throw const ListingException(ListingFailure.invalidTransition);
    }
    if (listing.status == ListingStatus.active &&
        !listing.offer.pickupDeadline.isAfter(now())) {
      throw const ListingException(ListingFailure.invalidTransition);
    }
    final closed = listing.copyWith(status: ListingStatus.cancelled);
    _listings[index] = closed;
    return _snapshot(closed, now());
  }

  /// Holds local demo stock atomically and returns the pre-hold snapshot.
  Listing? reserve(String id, int quantity, DateTime now) {
    if (quantity <= 0) return null;
    for (final listing in _listings) {
      if (listing.id != id) continue;
      final current = _snapshot(listing, now);
      if (current.status != ListingStatus.active ||
          current.offer.availableQuantity < quantity) {
        return null;
      }
      _heldQuantities[id] = (_heldQuantities[id] ?? 0) + quantity;
      _activeHolds[id] = (_activeHolds[id] ?? 0) + quantity;
      return current;
    }
    return null;
  }

  /// Releases a cancelled local demo hold.
  void release(String id, int quantity) {
    final held = _heldQuantities[id] ?? 0;
    if (quantity <= 0 || quantity > held) throw StateError('Invalid hold');
    _heldQuantities[id] = held - quantity;
    finishHold(id, quantity);
  }

  /// Ends an active hold after local completion or expiry without restocking.
  void finishHold(String id, int quantity) {
    final active = _activeHolds[id] ?? 0;
    if (quantity <= 0 || quantity > active) throw StateError('Invalid hold');
    _activeHolds[id] = active - quantity;
  }

  int _indexOf(String id) {
    final index = _listings.indexWhere((item) => item.id == id);
    if (index < 0) throw const ListingException(ListingFailure.notFound);
    return index;
  }

  Listing _snapshot(Listing listing, DateTime now) {
    final offer = listing.offer;
    final available = offer.totalQuantity - (_heldQuantities[listing.id] ?? 0);
    final status = switch (listing.status) {
      ListingStatus.active when !offer.pickupDeadline.isAfter(now) =>
        ListingStatus.expired,
      ListingStatus.active when available == 0 => ListingStatus.soldOut,
      _ => listing.status,
    };
    return listing.copyWith(
      status: status,
      offer: offer.withQuantity(
        total: offer.totalQuantity,
        available: available,
      ),
    );
  }
}

// Invented examples only. Names, prices, addresses, and distances are not real.
const _breadPriceRupiah = 22000;
const _breadOriginalPriceRupiah = 50000;
const _breadQuantity = 3;
const _mealPriceRupiah = 18000;
const _mealOriginalPriceRupiah = 38000;

List<Listing> _fixtures(DateTime now) => [
  _breadFixture(now),
  _mealFixture(now),
];

Listing _breadFixture(DateTime now) => Listing(
  id: 'sample-bread',
  name: 'Paket pastry pilihan',
  category: ListingCategory.bakery,
  content: const ListingContent(
    description: 'Pilihan roti dan pastry yang belum terjual hari ini.',
    imageAsset: 'assets/food/pastry-box.png',
    sellerInfo: SellerFoodInfo(
      surplusReason: 'Stok etalase belum terjual menjelang tutup.',
      condition: 'Penjual menyatakan produk dikemas untuk pickup.',
      storage: 'Penjual menyatakan produk disimpan tertutup.',
      allergens: 'Penjual menyatakan mengandung gandum, susu, dan telur.',
    ),
  ),
  offer: ListingOffer(
    priceRupiah: _breadPriceRupiah,
    originalPriceRupiah: _breadOriginalPriceRupiah,
    totalQuantity: _breadQuantity,
    pickupStartsAt: now,
    pickupDeadline: now.add(const Duration(minutes: 45)),
  ),
  merchant: MockListingRepository.prototypeMerchant,
  status: ListingStatus.active,
);

Listing _mealFixture(DateTime now) => Listing(
  id: 'sample-meal',
  name: 'Paket nasi ayam',
  category: ListingCategory.meal,
  content: const ListingContent(
    description: 'Satu porsi nasi, ayam, sayur, dan sambal.',
    imageAsset: 'assets/food/rice-meal.png',
    sellerInfo: SellerFoodInfo(
      surplusReason: 'Porsi siap jual belum terjual menjelang tutup.',
      condition: 'Penjual menyatakan porsi dikemas untuk pickup.',
    ),
  ),
  offer: ListingOffer(
    priceRupiah: _mealPriceRupiah,
    originalPriceRupiah: _mealOriginalPriceRupiah,
    totalQuantity: 2,
    pickupStartsAt: now.add(const Duration(minutes: 30)),
    pickupDeadline: now.add(const Duration(minutes: 105)),
  ),
  merchant: const ListingMerchant(
    id: 'demo-kitchen',
    name: 'Dapur Contoh',
    area: 'Tebet Timur',
    distanceMeters: 1200,
    pickupAddress: 'Area Tebet Timur, Jakarta Selatan (alamat contoh)',
  ),
  status: ListingStatus.active,
);
