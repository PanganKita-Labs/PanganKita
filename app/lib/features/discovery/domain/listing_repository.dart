import 'package:pangankita/features/discovery/domain/listing.dart';

/// Data source boundary for discovery listings.
abstract interface class ListingRepository {
  /// Loads a snapshot of available prototype listings.
  Future<List<Listing>> loadListings();

  /// Loads one listing or returns null when it is no longer present.
  Future<Listing?> getListing(String id);
}
