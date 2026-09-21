import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/prototype_shell.dart';
import 'package:pangankita/features/discovery/data/mock_listing_repository.dart';
import 'package:pangankita/features/reservations/data/mock_reservation_repository.dart';
import 'package:pangankita/features/reservations/presentation/reservation_copy.dart';
import 'package:pangankita/features/reservations/presentation/reservation_detail_page.dart';

void main() {
  final now = DateTime(2026, 9, 19, 18);

  testWidgets('consumer reserves two packages and sees the pickup code', (
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

    await tester.ensureVisible(find.text('Paket pastry pilihan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paket pastry pilihan'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Lanjut ke reservasi'));
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
    await tester.scrollUntilVisible(
      find.text(ReservationCopy.qrVisual),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(ReservationCopy.ticketTitle), findsOneWidget);
    expect(find.text(ReservationCopy.qrVisual), findsOneWidget);

    expect(find.text('Simulasikan penjual siap'), findsNothing);
    expect(find.text('Simulasikan pickup selesai'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Aktif'), findsOneWidget);
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
    await tester.scrollUntilVisible(
      find.text('Paket pastry pilihan'),
      150,
      scrollable: find
          .descendant(
            of: find.byType(ListView).first,
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.ensureVisible(find.text('Paket pastry pilihan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paket pastry pilihan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lanjut ke reservasi'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Konfirmasi reservasi contoh'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final cancelButton = find.byKey(const Key('cancel-reservation'));
    await tester.scrollUntilVisible(
      cancelButton,
      180,
      scrollable: find
          .descendant(
            of: find.byType(ListView).first,
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.ensureVisible(cancelButton);
    await tester.pumpAndSettle();
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(ReservationCopy.cancel),
      ),
    );
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
    await tester.tap(find.text('Reservasi'));
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
          now: () => current,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Lewat batas pickup'), findsOneWidget);
    expect(find.textContaining('Pickup sebelum'), findsOneWidget);
    expect(find.text('Batalkan reservasi contoh'), findsNothing);
  });
}
