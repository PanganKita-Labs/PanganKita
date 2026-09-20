import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/features/discovery/data/mock_listing_repository.dart';
import 'package:pangankita/features/discovery/domain/discover_listings.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/reservations/data/mock_reservation_repository.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';

void main() {
  final start = DateTime(2026, 9, 19, 18);

  ListingDraft draft(DateTime now) => ListingDraft(
    merchant: MockListingRepository.prototypeMerchant,
    name: 'Paket roti sore',
    category: ListingCategory.bakery,
    description: 'Dua roti dari etalase hari ini.',
    imageAsset: 'assets/food/pastry-box.png',
    originalPriceRupiah: 30000,
    priceRupiah: 15000,
    quantity: 2,
    pickupStartsAt: now.add(const Duration(minutes: 10)),
    pickupDeadline: now.add(const Duration(hours: 2)),
    surplusReason: 'Belum terjual menjelang tutup.',
    condition: 'Informasi kondisi dari penjual.',
  );

  test(
    'draft, publish and close use the same consumer listing state',
    () async {
      final listings = MockListingRepository(
        referenceTime: start,
        now: () => start,
      );
      final saved = await listings.createDraft(draft(start));
      expect(saved.status, ListingStatus.draft);
      expect(saved.content.sellerInfo.storage, isNull);
      expect(saved.content.sellerInfo.allergens, isNull);
      expect(
        discoverListings(
          await listings.loadListings(),
          now: start,
        ).nearby.map((item) => item.id),
        isNot(contains(saved.id)),
      );
      final published = await listings.publish(saved.id);
      expect(published.status, ListingStatus.active);
      expect(
        discoverListings(
          await listings.loadListings(),
          now: start,
        ).nearby.map((item) => item.id),
        contains(saved.id),
      );
      expect(
        (await listings.loadMerchantListings('demo-kitchen'))
            .map((item) => item.id),
        isNot(contains(saved.id)),
      );
      await listings.close(saved.id);
      expect(
        (await listings.getListing(saved.id))?.status,
        ListingStatus.cancelled,
      );
      expect(
        discoverListings(
          await listings.loadListings(),
          now: start,
        ).nearby.map((item) => item.id),
        isNot(contains(saved.id)),
      );
    },
  );

  test(
    'validation, holds and merchant code verification preserve state',
    () async {
      var now = start;
      final listings = MockListingRepository(
        referenceTime: start,
        now: () => now,
      );
      final reservations = MockReservationRepository(listings, () => now);
      final invalid = ListingDraft(
        merchant: MockListingRepository.prototypeMerchant,
        name: '',
        category: ListingCategory.bakery,
        description: '',
        imageAsset: 'assets/food/pastry-box.png',
        originalPriceRupiah: 100,
        priceRupiah: 200,
        quantity: 0,
        pickupStartsAt: now,
        pickupDeadline: now,
        surplusReason: '',
        condition: '',
      );
      await expectLater(
        listings.createDraft(invalid),
        throwsA(isA<ListingException>()),
      );
      final saved = await listings.createDraft(draft(now));
      await listings.updateQuantity(saved.id, 0);
      await expectLater(
        listings.publish(saved.id),
        throwsA(isA<ListingException>()),
      );
      await listings.updateQuantity(saved.id, 2);
      await listings.publish(saved.id);
      final reservation = await reservations.create(saved.id, 1);
      expect((await listings.getListing(saved.id))?.offer.availableQuantity, 1);
      await expectLater(
        listings.updateQuantity(saved.id, 0),
        throwsA(isA<ListingException>()),
      );
      await expectLater(
        listings.close(saved.id),
        throwsA(isA<ListingException>()),
      );
      final merchantQueue = await reservations.loadMerchantReservations(
        MockListingRepository.prototypeMerchant.id,
      );
      expect(merchantQueue.single.id, reservation.id);
      expect(
        (await reservations.markReady(reservation.id)).status,
        ReservationStatus.readyForPickup,
      );
      await expectLater(
        reservations.verifyPickup(reservation.id, 'demo-bakery', 'wrong'),
        throwsA(isA<ReservationException>()),
      );
      final completed = await reservations.verifyPickup(
        reservation.id,
        'demo-bakery',
        reservation.pickupCode,
      );
      expect(completed.status, ReservationStatus.completed);
      expect(
        await reservations.verifyPickup(
          reservation.id,
          'demo-bakery',
          reservation.pickupCode,
        ),
        same(completed),
      );
      await listings.updateQuantity(saved.id, 2);
      await listings.close(saved.id);
      expect(
        (await listings.getListing(saved.id))?.status,
        ListingStatus.cancelled,
      );
      now = now.add(const Duration(hours: 3));
      expect(
        (await reservations.getReservation(reservation.id))?.status,
        ReservationStatus.completed,
      );
    },
  );
}
