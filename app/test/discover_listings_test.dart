import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/features/discovery/data/mock_listing_repository.dart';
import 'package:pangankita/features/discovery/domain/discover_listings.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';

void main() {
  test('search and category filter only matching active listings', () async {
    final now = DateTime.utc(2026, 9, 19, 12);
    final listings = await MockListingRepository(referenceTime: now)
        .loadListings();

    final all = discoverListings(listings, now: now);
    expect(all.urgent.map((listing) => listing.id), ['sample-bread']);
    expect(all.nearby.map((listing) => listing.id), ['sample-meal']);

    final meals = discoverListings(
      listings,
      now: now,
      query: ' DAPUR ',
      category: ListingCategory.meal,
    );
    expect(meals.urgent, isEmpty);
    expect(meals.nearby.map((listing) => listing.id), ['sample-meal']);
    expect(
      discoverListings(listings, now: now, query: 'tidak ada').nearby,
      isEmpty,
    );
  });

  test('a passed pickup deadline removes a listing from discovery', () async {
    final start = DateTime.utc(2026, 9, 19, 12);
    final listings = await MockListingRepository(referenceTime: start)
        .loadListings();

    final afterFirstDeadline = discoverListings(
      listings,
      now: start.add(const Duration(minutes: 45)),
    );
    expect(afterFirstDeadline.urgent.map((listing) => listing.id), [
      'sample-meal',
    ]);
    expect(afterFirstDeadline.nearby, isEmpty);
  });
}
