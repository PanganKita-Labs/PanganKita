import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/features/discovery/data/mock_listing_repository.dart';

void main() {
  test('mock listing snapshots are stable and cannot be mutated', () async {
    final now = DateTime.utc(2026, 9, 19, 12);
    final repository = MockListingRepository(
      referenceTime: now,
      now: () => now,
    );
    final first = await repository.loadListings();
    final second = await repository.loadListings();

    expect(first.map((listing) => listing.id), ['sample-bread', 'sample-meal']);
    expect(second.map((listing) => listing.id), [
      'sample-bread',
      'sample-meal',
    ]);
    expect(
      first.first.offer.pickupDeadline,
      now.add(const Duration(minutes: 45)),
    );
    expect(
      (await repository.getListing('sample-meal'))?.name,
      'Paket nasi ayam',
    );
    expect(await repository.getListing('missing'), isNull);
    expect(first.clear, throwsUnsupportedError);
  });
}
