import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/features/discovery/mock_listing_repository.dart';

void main() {
  test('mock listing snapshots are stable and cannot be mutated', () async {
    const repository = MockListingRepository();
    final first = await repository.loadListings();
    final second = await repository.loadListings();

    expect(first.map((listing) => listing.id), ['sample-bread', 'sample-meal']);
    expect(second.map((listing) => listing.id), [
      'sample-bread',
      'sample-meal',
    ]);
    expect(first.first.pickupDeadline, DateTime.utc(2030, 1, 1, 12));
    expect(first.clear, throwsUnsupportedError);
  });
}
