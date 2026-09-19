import 'package:pangankita/features/discovery/listing.dart';

/// Data source boundary for discovery listings.
abstract interface class ListingRepository {
  /// Loads a snapshot of available prototype listings.
  Future<List<Listing>> loadListings();
}
