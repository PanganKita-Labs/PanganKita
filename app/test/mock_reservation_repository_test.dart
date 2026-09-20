import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/features/discovery/data/mock_listing_repository.dart';
import 'package:pangankita/features/reservations/data/mock_reservation_repository.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';

void main() {
  late DateTime now;
  late MockListingRepository listings;
  late MockReservationRepository reservations;

  setUp(() {
    now = DateTime.utc(2026, 9, 19, 12);
    listings = MockListingRepository(referenceTime: now, now: () => now);
    reservations = MockReservationRepository(listings, () => now);
  });

  test(
    'creation holds stock and cancellation releases only a reserved hold',
    () async {
      final reservation = await reservations.create('sample-bread', 2);
      expect(reservation.status, ReservationStatus.reserved);
      expect(reservation.quantity, 2);
      expect(reservation.amountDueRupiah, 44000);
      expect(reservation.pickupCode, 'PK-0001');
      expect(
        (await listings.getListing('sample-bread'))?.offer.availableQuantity,
        1,
      );
      await expectLater(
        reservations.create('sample-bread', 2),
        throwsA(isA<ReservationException>()),
      );

      final cancelled = await reservations.cancel(reservation.id);
      expect(cancelled.status, ReservationStatus.cancelled);
      expect(
        (await listings.getListing('sample-bread'))?.offer.availableQuantity,
        3,
      );
      await expectLater(
        reservations.cancel(reservation.id),
        throwsA(isA<ReservationException>()),
      );
    },
  );

  test('ready, completion and deadline transitions remain legal', () async {
    final reservation = await reservations.create('sample-bread', 1);
    await expectLater(
      reservations.complete(reservation.id),
      throwsA(isA<ReservationException>()),
    );
    final ready = await reservations.markReady(reservation.id);
    expect(ready.status, ReservationStatus.readyForPickup);
    await expectLater(
      reservations.cancel(reservation.id),
      throwsA(isA<ReservationException>()),
    );
    final completed = await reservations.complete(reservation.id);
    expect(completed.status, ReservationStatus.completed);
    now = now.add(const Duration(minutes: 45));
    expect(
      (await reservations.getReservation(reservation.id))?.status,
      ReservationStatus.completed,
    );
    await expectLater(
      reservations.complete(reservation.id),
      throwsA(isA<ReservationException>()),
    );
  });

  test(
    'deadline expires active reservations and prevents late creation',
    () async {
      final reservation = await reservations.create('sample-bread', 1);
      now = now.add(const Duration(minutes: 45));
      expect(
        (await reservations.getReservation(reservation.id))?.status,
        ReservationStatus.expired,
      );
      await expectLater(
        reservations.markReady(reservation.id),
        throwsA(isA<ReservationException>()),
      );
      await expectLater(
        reservations.create('sample-bread', 1),
        throwsA(isA<ReservationException>()),
      );
    },
  );
}
