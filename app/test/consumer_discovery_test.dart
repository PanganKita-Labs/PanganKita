import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/prototype_shell.dart';
import 'package:pangankita/features/discovery/data/mock_listing_repository.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/domain/listing_repository.dart';
import 'package:pangankita/features/discovery/presentation/discover_page.dart';
import 'package:pangankita/features/discovery/presentation/listing_detail_page.dart';
import 'package:pangankita/features/reservations/data/mock_reservation_repository.dart';

void main() {
  final now = DateTime(2026, 9, 19, 18);

  testWidgets('search, category, detail and reservation review entry', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = MockListingRepository(referenceTime: now);
    final reservations = MockReservationRepository(repository, () => now);
    await tester.pumpWidget(
      MaterialApp(
        home: PrototypeShell(
          listings: repository,
          reservations: reservations,
          now: () => now,
          areaName: MockListingRepository.prototypeArea,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Paket pastry pilihan'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'nasi');
    await tester.pumpAndSettle();
    expect(find.text('Paket nasi ayam'), findsOneWidget);
    expect(find.text('Paket pastry pilihan'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('Roti & pastry'));
    await tester.pumpAndSettle();
    expect(find.text('Paket pastry pilihan'), findsOneWidget);
    expect(find.text('Paket nasi ayam'), findsNothing);

    await tester.tap(find.text('Paket pastry pilihan'));
    await tester.pumpAndSettle();
    expect(find.text('Toko Roti Contoh'), findsOneWidget);
    expect(find.text('Rp 22.000'), findsOneWidget);
    expect(find.text('Rp 50.000'), findsOneWidget);
    expect(find.textContaining('Pickup sebelum'), findsOneWidget);
    expect(find.text('3 paket tersedia'), findsOneWidget);

    await tester.tap(find.text('Lanjut ke reservasi'));
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi reservasi'), findsWidgets);
    expect(
      find.textContaining('Penjual tidak menerima pesanan nyata'),
      findsOneWidget,
    );
  });

  testWidgets('empty, loading, error and retry states stay understandable', (
    tester,
  ) async {
    final pending = Completer<List<Listing>>();
    var loads = 0;
    final repository = _FakeListingRepository(
      load: () {
        loads++;
        return loads == 1 ? pending.future : Future.value([]);
      },
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DiscoverPage(
            listings: repository,
            referenceTime: now,
            areaName: MockListingRepository.prototypeArea,
            onOpenListing: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Memuat makanan surplus contoh…'), findsOneWidget);

    pending.completeError(StateError('fixture failure'));
    await tester.pumpAndSettle();
    expect(find.text('Daftar makanan belum bisa dimuat.'), findsOneWidget);
    expect(find.textContaining('fixture failure'), findsNothing);

    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(
      find.text('Belum ada makanan yang cocok di area ini.'),
      findsOneWidget,
    );
  });

  testWidgets('missing detail and 320-pixel layout fail gracefully', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = MockListingRepository(referenceTime: now);
    final reservations = MockReservationRepository(repository, () => now);
    await tester.pumpWidget(
      MaterialApp(
        home: PrototypeShell(
          listings: repository,
          reservations: reservations,
          now: () => now,
          areaName: MockListingRepository.prototypeArea,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      MaterialApp(
        home: ListingDetailPage(
          listingId: 'sample-bread',
          listings: repository,
          referenceTime: now,
          onReserve: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Lanjut ke reservasi'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      MaterialApp(
        home: ListingDetailPage(
          listingId: 'missing',
          listings: repository,
          referenceTime: now,
          onReserve: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Listing contoh ini tidak tersedia lagi.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}

class _FakeListingRepository implements ListingRepository {
  new({required this.load});

  final Future<List<Listing>> Function() load;

  @override
  Future<List<Listing>> loadListings() => load();

  @override
  Future<Listing?> getListing(String id) async => null;
}
