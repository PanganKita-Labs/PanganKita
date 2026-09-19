import 'package:pangankita/features/discovery/domain/listing.dart';

/// Filters active mock listings and groups them without opaque ranking.
({List<Listing> urgent, List<Listing> nearby}) discoverListings(
  List<Listing> listings, {
  required DateTime now,
  String query = '',
  ListingCategory? category,
}) {
  final search = query.trim().toLowerCase();
  final urgent = <Listing>[];
  final nearby = <Listing>[];

  for (final listing in listings) {
    if (!_isVisible(listing, now, search, category)) continue;

    final remaining = listing.offer.pickupDeadline.difference(now);
    if (remaining <= const Duration(hours: 1)) {
      urgent.add(listing);
    } else {
      nearby.add(listing);
    }
  }

  urgent.sort((a, b) {
    final deadline = a.offer.pickupDeadline.compareTo(b.offer.pickupDeadline);
    return deadline != 0 ? deadline : a.id.compareTo(b.id);
  });
  nearby.sort((a, b) {
    final distance = a.merchant.distanceMeters.compareTo(
      b.merchant.distanceMeters,
    );
    return distance != 0 ? distance : a.id.compareTo(b.id);
  });

  return (urgent: urgent, nearby: nearby);
}

bool _isVisible(
  Listing listing,
  DateTime now,
  String search,
  ListingCategory? category,
) =>
    listing.offer.availableQuantity > 0 &&
    listing.offer.pickupDeadline.isAfter(now) &&
    (category == null || listing.category == category) &&
    (search.isEmpty || _matches(listing, search));

bool _matches(Listing listing, String search) =>
    listing.name.toLowerCase().contains(search) ||
    listing.merchant.name.toLowerCase().contains(search) ||
    listing.merchant.area.toLowerCase().contains(search);
