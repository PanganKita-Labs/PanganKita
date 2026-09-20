import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/domain/listing_repository.dart';

/// Deterministic, prototype-only listing source.
class MockListingRepository implements ListingRepository {
  /// Captures one reference time so fixture deadlines stay stable per session.
  new({required DateTime referenceTime})
    : _listings = List<Listing>.unmodifiable(_fixtures(referenceTime));

  /// Selected area used by the local prototype, not device location.
  static const prototypeArea = 'Tebet Barat, Jakarta Selatan';

  final List<Listing> _listings;
  final Map<String, int> _heldQuantities = {};

  @override
  Future<List<Listing>> loadListings() async =>
      List<Listing>.unmodifiable(_listings.map(_withCurrentQuantity));

  @override
  Future<Listing?> getListing(String id) async {
    for (final listing in _listings) {
      if (listing.id == id) return _withCurrentQuantity(listing);
    }
    return null;
  }

  /// Holds local demo stock atomically and returns the pre-hold snapshot.
  Listing? reserve(String id, int quantity, DateTime now) {
    if (quantity <= 0) return null;
    for (final listing in _listings) {
      if (listing.id != id) continue;
      final current = _withCurrentQuantity(listing);
      if (!listing.offer.pickupDeadline.isAfter(now) ||
          current.offer.availableQuantity < quantity) {
        return null;
      }
      _heldQuantities[id] = (_heldQuantities[id] ?? 0) + quantity;
      return current;
    }
    return null;
  }

  /// Releases a cancelled local demo hold.
  void release(String id, int quantity) {
    final held = _heldQuantities[id] ?? 0;
    if (quantity <= 0 || quantity > held) throw StateError('Invalid hold');
    _heldQuantities[id] = held - quantity;
  }

  Listing _withCurrentQuantity(Listing listing) {
    final offer = listing.offer;
    return Listing(
      id: listing.id,
      name: listing.name,
      category: listing.category,
      content: listing.content,
      merchant: listing.merchant,
      offer: ListingOffer(
        priceRupiah: offer.priceRupiah,
        originalPriceRupiah: offer.originalPriceRupiah,
        availableQuantity:
            offer.availableQuantity - (_heldQuantities[listing.id] ?? 0),
        pickupStartsAt: offer.pickupStartsAt,
        pickupDeadline: offer.pickupDeadline,
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
    availableQuantity: _breadQuantity,
    pickupStartsAt: now,
    pickupDeadline: now.add(const Duration(minutes: 45)),
  ),
  merchant: const ListingMerchant(
    name: 'Toko Roti Contoh',
    area: 'Tebet Barat',
    distanceMeters: 800,
    pickupAddress: 'Area Tebet Barat, Jakarta Selatan (alamat contoh)',
  ),
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
    availableQuantity: 2,
    pickupStartsAt: now.add(const Duration(minutes: 30)),
    pickupDeadline: now.add(const Duration(minutes: 105)),
  ),
  merchant: const ListingMerchant(
    name: 'Dapur Contoh',
    area: 'Tebet Timur',
    distanceMeters: 1200,
    pickupAddress: 'Area Tebet Timur, Jakarta Selatan (alamat contoh)',
  ),
);
