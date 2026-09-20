import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/prototype_shell.dart';
import 'package:pangankita/features/discovery/data/mock_listing_repository.dart';
import 'package:pangankita/features/reservations/data/mock_reservation_repository.dart';
import 'package:pangankita/features/reservations/presentation/reservation_detail_page.dart';

void main() {
  final now = DateTime(2026, 9, 19, 18);

  testWidgets('consumer can reserve two packages and finish the demo pickup', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final listings = MockListingRepository(referenceTime: now, now: () => now);
    final reservations = MockReservationRepository(listings, () => now);
    await tester.pumpWidget(
      MaterialApp(
        home: PrototypeShell(
          listings: listings,
          reservations: reservations,
          now: () => now,
          areaName: MockListingRepository.prototypeArea,
          merchant: MockListingRepository.prototypeMerchant,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Paket pastry pilihan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lanjut ke reservasi'));
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi reservasi'), findsOneWidget);
    await tester.tap(find.byTooltip('Tambah jumlah paket'));
    await tester.pumpAndSettle();
    expect(find.text('Rp 44.000'), findsOneWidget);

    await tester.tap(find.text('Konfirmasi reservasi contoh'));
    await tester.pumpAndSettle();
    expect(find.text('Dipesan'), findsOneWidget);
    expect(find.text('PK-0001'), findsOneWidget);
    expect(find.text('Rp 44.000'), findsOneWidget);
    expect(
      find.textContaining('Penjual tidak menerima pesanan nyata'),
      findsOneWidget,
    );
    expect(
      (await listings.getListing('sample-bread'))?.offer.availableQuantity,
      1,
    );

    await tester.scrollUntilVisible(find.text('Simulasikan penjual siap'), 180);
    await tester.tap(find.text('Simulasikan penjual siap'));
    await tester.pumpAndSettle();
    expect(find.text('Siap diambil'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Simulasikan pickup selesai'),
      180,
    );
    await tester.tap(find.text('Simulasikan pickup selesai'));
    await tester.pumpAndSettle();
    expect(find.text('Selesai'), findsOneWidget);
    expect(find.text('Simulasikan pickup selesai'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Paket pastry pilihan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('consumer can cancel a reserved demo at 320 pixels', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final listings = MockListingRepository(referenceTime: now, now: () => now);
    final reservations = MockReservationRepository(listings, () => now);
    await tester.pumpWidget(
      MaterialApp(
        home: PrototypeShell(
          listings: listings,
          reservations: reservations,
          now: () => now,
          areaName: MockListingRepository.prototypeArea,
          merchant: MockListingRepository.prototypeMerchant,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -150));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paket pastry pilihan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lanjut ke reservasi'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Konfirmasi reservasi contoh'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Batalkan reservasi contoh'),
      180,
    );
    await tester.ensureVisible(find.text('Batalkan reservasi contoh'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Batalkan reservasi contoh'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Batalkan reservasi contoh').last);
    await tester.pumpAndSettle();
    expect(find.text('Dibatalkan'), findsOneWidget);
    expect(
      (await listings.getListing('sample-bread'))?.offer.availableQuantity,
      3,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('empty Reservations and deadline expiry are explicit', (
    tester,
  ) async {
    var current = now;
    final listings = MockListingRepository(
      referenceTime: now,
      now: () => current,
    );
    final reservations = MockReservationRepository(listings, () => current);
    await tester.pumpWidget(
      MaterialApp(
        home: PrototypeShell(
          listings: listings,
          reservations: reservations,
          now: () => current,
          areaName: MockListingRepository.prototypeArea,
          merchant: MockListingRepository.prototypeMerchant,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reservations'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada reservasi contoh.'), findsOneWidget);

    final created = await reservations.create('sample-bread', 1);
    current = current.add(const Duration(minutes: 45));
    await tester.pumpWidget(
      MaterialApp(
        home: ReservationDetailPage(
          reservationId: created.id,
          reservations: reservations,
          onChanged: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Lewat batas pickup'), findsOneWidget);
    expect(find.textContaining('Pickup sebelum'), findsOneWidget);
    expect(find.text('Simulasikan penjual siap'), findsNothing);
  });
}
