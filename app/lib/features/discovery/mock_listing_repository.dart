import 'package:pangankita/features/discovery/listing.dart';
import 'package:pangankita/features/discovery/listing_repository.dart';

// Invented examples for prototype use only; these are not real merchants.
final _fixtures = [
  Listing(
    id: 'sample-bread',
    name: 'Paket roti',
    businessName: 'Toko Roti Contoh',
    priceRupiah: 22000,
    availableQuantity: 3,
    pickupDeadline: DateTime.utc(2030, 1, 1, 12),
  ),
  Listing(
    id: 'sample-meal',
    name: 'Paket makan siang',
    businessName: 'Dapur Contoh',
    priceRupiah: 18000,
    availableQuantity: 2,
    pickupDeadline: DateTime.utc(2030, 1, 1, 13),
  ),
];

/// Deterministic, prototype-only listing source.
class MockListingRepository implements ListingRepository {
  /// Creates the local mock repository.
  const new();

  @override
  Future<List<Listing>> loadListings() async => List.unmodifiable(_fixtures);
}
