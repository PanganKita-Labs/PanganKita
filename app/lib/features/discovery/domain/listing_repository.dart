import 'package:pangankita/features/discovery/domain/listing.dart';

/// Data source boundary for discovery listings.
abstract interface class ListingRepository {
  /// Loads a snapshot of available prototype listings.
  Future<List<Listing>> loadListings();

  /// Loads one listing or returns null when it is no longer present.
  Future<Listing?> getListing(String id);

  /// Loads every local listing owned by the selected demo merchant.
  Future<List<Listing>> loadMerchantListings(String merchantId);

  /// Saves a validated local draft without exposing it to discovery.
  Future<Listing> createDraft(ListingDraft draft);

  /// Publishes a draft while its pickup deadline is still in the future.
  Future<Listing> publish(String id);

  /// Changes total quantity without reducing it below existing holds.
  Future<Listing> updateQuantity(String id, int totalQuantity);

  /// Closes a listing when no active reservation still needs pickup.
  Future<Listing> close(String id);
}
