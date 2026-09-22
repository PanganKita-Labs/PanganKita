import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/prototype_shell.dart';
import 'package:pangankita/features/business/presentation/business_copy.dart';
import 'package:pangankita/features/business/presentation/listing_preview_page.dart';
import 'package:pangankita/features/discovery/data/mock_listing_repository.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/reservations/data/mock_reservation_repository.dart';

void main() {
  final now = DateTime(2026, 9, 19, 18);

  testWidgets('merchant publishes, prepares and completes a local pickup', (
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

    await _switchRole(tester, 'Mode Bisnis');
    await tester.ensureVisible(find.text(BusinessCopy.createListing));
    await tester.pumpAndSettle();
    expect(
      find.text(MockListingRepository.prototypeMerchant.name),
      findsOneWidget,
    );
    expect(find.text('1 listing aktif'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Listing Aktif Toko'), 180);
    await tester.scrollUntilVisible(
      find.text(BusinessCopy.emptyCompleted),
      180,
    );
    expect(find.text(BusinessCopy.emptyCompleted), findsOneWidget);
    await tester.ensureVisible(find.text(BusinessCopy.createListing));
    await tester.pumpAndSettle();
    await tester.tap(find.text(BusinessCopy.createListing));
    await tester.pumpAndSettle();

    final values = {
      BusinessCopy.name: 'Paket roti sore',
      BusinessCopy.description: 'Roti dari etalase hari ini.',
      BusinessCopy.originalPrice: '30000',
      BusinessCopy.surplusPrice: '15000',
      BusinessCopy.quantity: '2',
      BusinessCopy.surplusReason: 'Belum terjual menjelang tutup.',
      BusinessCopy.condition: 'Menurut penjual masih baik.',
    };
    for (final entry in values.entries) {
      final field = find.widgetWithText(TextFormField, entry.key);
      await tester.scrollUntilVisible(
        field,
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(field, entry.value);
      await tester.pump();
    }
    final previewButton = find.widgetWithText(
      ElevatedButton,
      BusinessCopy.preview,
    );
    await tester.ensureVisible(previewButton);
    await tester.tap(previewButton);
    await tester.pumpAndSettle();
    expect(find.text(BusinessCopy.fieldRequired), findsNothing);
    expect(find.text(BusinessCopy.invalidNumber), findsNothing);
    expect(find.text(BusinessCopy.invalidTime), findsNothing);
    expect(find.text(BusinessCopy.previewTitle), findsWidgets);
    expect(find.text('Paket roti sore'), findsOneWidget);
    expect(find.text('Rp 15.000'), findsOneWidget);
    await tester.scrollUntilVisible(find.text(BusinessCopy.publish), 160);
    await tester.ensureVisible(find.text(BusinessCopy.publish));
    await tester.pumpAndSettle();
    await tester.tap(find.text(BusinessCopy.publish));
    await tester.pumpAndSettle();

    expect(find.text('2 listing aktif'), findsOneWidget);
    expect(
      (await listings.loadMerchantListings('demo-bakery'))
          .where((item) => item.name == 'Paket roti sore')
          .single
          .status,
      ListingStatus.active,
    );
    await _switchRole(tester, 'Mode Konsumen');
    expect(find.text('Paket roti sore'), findsOneWidget);

    await tester.ensureVisible(find.text('Paket roti sore'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paket roti sore'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lanjut ke reservasi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Konfirmasi reservasi contoh'));
    await tester.pumpAndSettle();
    expect(find.text('PK-0001'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await _switchRole(tester, 'Mode Bisnis');
    await tester.tap(find.text('Reservasi'));
    await tester.pumpAndSettle();
    expect(find.text('Paket roti sore'), findsOneWidget);
    await tester.tap(find.text('Paket roti sore'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(BusinessCopy.markReady));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'PK-0001');
    await tester.tap(find.byKey(const Key('verify-pickup')));
    await tester.pumpAndSettle();
    expect(find.text('Selesai'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dampak'));
    await tester.pumpAndSettle();
    expect(find.text('1 reservasi selesai'), findsOneWidget);
    expect(find.text('1 paket pickup selesai'), findsOneWidget);
    await _switchRole(tester, 'Mode Konsumen');
    await tester.tap(find.text('Reservasi'));
    await tester.pumpAndSettle();
    expect(find.text('Paket roti sore'), findsOneWidget);
    expect(find.textContaining('Selesai ·'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('merchant listing form validates on a 320 pixel screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final listings = MockListingRepository(referenceTime: now, now: () => now);
    await tester.pumpWidget(
      MaterialApp(
        home: PrototypeShell(
          listings: listings,
          reservations: MockReservationRepository(listings, () => now),
          now: () => now,
          areaName: MockListingRepository.prototypeArea,
          merchant: MockListingRepository.prototypeMerchant,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _switchRole(tester, 'Mode Bisnis');
    await tester.tap(find.text(BusinessCopy.createListing));
    await tester.pumpAndSettle();
    final previewButton = find.widgetWithText(
      ElevatedButton,
      BusinessCopy.preview,
    );
    await tester.scrollUntilVisible(
      previewButton,
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(previewButton);
    await tester.pumpAndSettle();
    await tester.tap(previewButton);
    await tester.pumpAndSettle();
    expect(find.text(BusinessCopy.fieldRequired), findsWidgets);
    expect(find.text(BusinessCopy.previewTitle), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('merchant manages fixture quantity and closes it locally', (
    tester,
  ) async {
    final listings = MockListingRepository(referenceTime: now, now: () => now);
    await tester.pumpWidget(
      MaterialApp(
        home: PrototypeShell(
          listings: listings,
          reservations: MockReservationRepository(listings, () => now),
          now: () => now,
          areaName: MockListingRepository.prototypeArea,
          merchant: MockListingRepository.prototypeMerchant,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _switchRole(tester, 'Mode Bisnis');
    await tester.ensureVisible(find.text('Paket pastry pilihan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paket pastry pilihan'));
    await tester.pumpAndSettle();
    final updateButton = find.byKey(const Key('update-listing-quantity'));
    await tester.scrollUntilVisible(updateButton, 240);
    await tester.drag(find.byType(ListView).last, const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(updateButton);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '4');
    await tester.tap(find.text(BusinessCopy.updateQuantity).last);
    await tester.pumpAndSettle();
    expect(find.text('${BusinessCopy.availableQuantity}: 4'), findsOneWidget);

    final closeButton = find.byKey(const Key('close-listing'));
    await tester.ensureVisible(closeButton);
    await tester.pumpAndSettle();
    await tester.tap(closeButton);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(BusinessCopy.closeListing),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      (await listings.getListing('sample-bread'))?.status,
      ListingStatus.cancelled,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, 1000));
    await tester.pumpAndSettle();
    expect(find.text('Ditutup'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('preview actions remain separated at 320 pixels', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final listings = MockListingRepository(referenceTime: now, now: () => now);
    await tester.pumpWidget(
      MaterialApp(
        home: ListingPreviewPage(
          draft: ListingDraft(
            merchant: MockListingRepository.prototypeMerchant,
            name: 'Paket roti sore',
            category: ListingCategory.bakery,
            description: 'Roti dari etalase hari ini.',
            imageAsset: BusinessCopy.imageAsset(ListingCategory.bakery),
            originalPriceRupiah: 30000,
            priceRupiah: 15000,
            quantity: 2,
            pickupStartsAt: now.add(const Duration(minutes: 15)),
            pickupDeadline: now.add(const Duration(hours: 2)),
            surplusReason: 'Belum terjual.',
            condition: 'Menurut penjual masih baik.',
          ),
          listings: listings,
          onSaved: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    final edit = find.widgetWithText(OutlinedButton, BusinessCopy.edit);
    final save = find.widgetWithText(OutlinedButton, BusinessCopy.saveDraft);
    final publish = find.widgetWithText(ElevatedButton, BusinessCopy.publish);
    await tester.scrollUntilVisible(
      publish,
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(publish);
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(save).dy - tester.getBottomLeft(edit).dy, 12);
    expect(tester.getTopLeft(publish).dy - tester.getBottomLeft(save).dy, 16);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _switchRole(WidgetTester tester, String label) async {
  await tester.tap(find.byTooltip(label));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}
