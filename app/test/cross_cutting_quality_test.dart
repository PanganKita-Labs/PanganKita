import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/prototype_shell.dart';
import 'package:pangankita/features/business/presentation/business_copy.dart';
import 'package:pangankita/features/business/presentation/business_impact_page.dart';
import 'package:pangankita/features/business/presentation/business_listing_detail_page.dart';
import 'package:pangankita/features/business/presentation/business_listings_page.dart';
import 'package:pangankita/features/business/presentation/business_reservation_detail_page.dart';
import 'package:pangankita/features/business/presentation/business_reservations_page.dart';
import 'package:pangankita/features/discovery/data/mock_listing_repository.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/presentation/discovery_copy.dart';
import 'package:pangankita/features/discovery/presentation/listing_card.dart';
import 'package:pangankita/features/reservations/data/mock_reservation_repository.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';
import 'package:pangankita/features/reservations/presentation/reservation_copy.dart';

void main() {
  final now = DateTime(2026, 9, 19, 18);

  testWidgets('navigation stays readable at supported widths and text scale', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final width in [320.0, 360.0, 390.0, 412.0]) {
      tester.view.physicalSize = Size(width, 844);
      tester.view.devicePixelRatio = 1;
      final listings = MockListingRepository(
        referenceTime: now,
        now: () => now,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
            child: PrototypeShell(
              listings: listings,
              reservations: MockReservationRepository(listings, () => now),
              now: () => now,
              areaName: MockListingRepository.prototypeArea,
              merchant: MockListingRepository.prototypeMerchant,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$width px consumer');
      expect(find.text('Jelajahi'), findsOneWidget);
      for (var index = 0; index < 4; index++) {
        await tester.tap(find.byType(NavigationDestination).at(index));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<NavigationBar>(find.byType(NavigationBar))
              .selectedIndex,
          index,
        );
        expect(
          tester.takeException(),
          isNull,
          reason: '$width px consumer tab $index',
        );
      }
      await tester.tap(find.text('Mode Bisnis'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$width px business');
      expect(find.text('Listing'), findsOneWidget);
      for (var index = 0; index < 4; index++) {
        await tester.tap(find.byType(NavigationDestination).at(index));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<NavigationBar>(find.byType(NavigationBar))
              .selectedIndex,
          index,
        );
        expect(
          tester.takeException(),
          isNull,
          reason: '$width px business tab $index',
        );
      }
      await tester.tap(find.text('Mode Konsumen'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$width px role switch');
    }
  });

  testWidgets('brand, search, and role switch expose readable semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
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
    expect(find.bySemanticsLabel(DiscoveryCopy.logoLabel), findsOneWidget);
    expect(find.bySemanticsLabel(DiscoveryCopy.searchLabel), findsOneWidget);
    expect(find.bySemanticsLabel('Mode Bisnis'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('long food and merchant names remain readable on listing card', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = MockListingRepository(
      referenceTime: now,
      now: () => now,
    );
    final fixture = (await repository.loadListings()).first;
    const foodName = 'Paket pilihan roti dan pastry dari etalase sore hari';
    const merchantName = 'Toko Roti Contoh di Tebet Barat Jakarta Selatan';
    final listing = Listing(
      id: fixture.id,
      name: foodName,
      category: fixture.category,
      content: fixture.content,
      offer: fixture.offer,
      merchant: ListingMerchant(
        id: fixture.merchant.id,
        name: merchantName,
        area: fixture.merchant.area,
        distanceMeters: fixture.merchant.distanceMeters,
        pickupAddress: fixture.merchant.pickupAddress,
      ),
      status: fixture.status,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
            child: SingleChildScrollView(
              child: ListingCard(listing: listing, onTap: () {}),
            ),
          ),
        ),
      ),
    );
    expect(tester.widget<Text>(find.text(foodName)).overflow, isNull);
    expect(tester.widget<Text>(find.text(merchantName)).overflow, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('business data errors explain the failure and offer retry', (
    tester,
  ) async {
    final listings = MockListingRepository(referenceTime: now, now: () => now);
    final reservations = _FailingReservations(listings, () => now);
    for (final page in [
      BusinessReservationsPage(
        reservations: reservations,
        merchantId: MockListingRepository.prototypeMerchant.id,
        revision: 0,
        onOpen: (_) {},
      ),
      BusinessImpactPage(
        listings: listings,
        reservations: reservations,
        merchantId: MockListingRepository.prototypeMerchant.id,
        revision: 0,
      ),
      BusinessListingDetailPage(
        listingId: 'sample-bread',
        merchantId: MockListingRepository.prototypeMerchant.id,
        listings: listings,
        reservations: reservations,
        onChanged: () {},
      ),
      BusinessReservationDetailPage(
        reservationId: 'missing',
        merchantId: MockListingRepository.prototypeMerchant.id,
        reservations: reservations,
        onChanged: () {},
      ),
    ]) {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: page)));
      await tester.pumpAndSettle();
      expect(find.text(BusinessCopy.loadError), findsOneWidget);
      expect(find.text(BusinessCopy.retry), findsOneWidget);
    }
  });

  testWidgets('business loading is named for assistive technology', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final listings = MockListingRepository(referenceTime: now, now: () => now);
    final reservations = _LoadingReservations(listings, () => now);
    for (final page in [
      BusinessListingsPage(
        listings: listings,
        reservations: reservations,
        merchant: MockListingRepository.prototypeMerchant,
        revision: 0,
        onCreate: () {},
        onOpenListing: (_) {},
        onOpenReservation: (_) {},
      ),
      BusinessReservationsPage(
        reservations: reservations,
        merchantId: MockListingRepository.prototypeMerchant.id,
        revision: 0,
        onOpen: (_) {},
      ),
      BusinessImpactPage(
        listings: listings,
        reservations: reservations,
        merchantId: MockListingRepository.prototypeMerchant.id,
        revision: 0,
      ),
      BusinessListingDetailPage(
        listingId: 'sample-bread',
        merchantId: MockListingRepository.prototypeMerchant.id,
        listings: listings,
        reservations: reservations,
        onChanged: () {},
      ),
      BusinessReservationDetailPage(
        reservationId: 'pending',
        merchantId: MockListingRepository.prototypeMerchant.id,
        reservations: reservations,
        onChanged: () {},
      ),
    ]) {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: page)));
      await tester.pump();
      expect(
        find.bySemanticsLabel('Memuat data bisnis contoh…'),
        findsOneWidget,
      );
    }
    semantics.dispose();
  });

  testWidgets('merchant readiness action is disabled while pending', (
    tester,
  ) async {
    final listings = MockListingRepository(referenceTime: now, now: () => now);
    final reservations = _PendingReadyReservations(listings, () => now);
    final created = await reservations.create('sample-bread', 1);
    await tester.pumpWidget(
      MaterialApp(
        home: BusinessReservationDetailPage(
          reservationId: created.id,
          merchantId: MockListingRepository.prototypeMerchant.id,
          reservations: reservations,
          onChanged: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    final ready = find.widgetWithText(ElevatedButton, BusinessCopy.markReady);
    await tester.scrollUntilVisible(ready, 160);
    await tester.ensureVisible(ready);
    await tester.tap(ready);
    await tester.pump();
    expect(reservations.readyCalls, 1);
    expect(tester.widget<ElevatedButton>(ready).onPressed, isNull);
    reservations.finish();
    await tester.pumpAndSettle();
    expect(
      find.text(ReservationCopy.status(ReservationStatus.readyForPickup)),
      findsOneWidget,
    );
  });
}

class _FailingReservations extends MockReservationRepository {
  new(super._listings, super._now);

  @override
  Future<List<Reservation>> loadMerchantReservations(String merchantId) =>
      Future.error(StateError('fixture failure'));

  @override
  Future<Reservation?> getMerchantReservation(String id, String merchantId) =>
      Future.error(StateError('fixture failure'));
}

class _PendingReadyReservations extends MockReservationRepository {
  new(super._listings, super._now);

  final Completer<void> _pending = Completer<void>();
  int readyCalls = 0;

  @override
  Future<Reservation> markReady(String id) async {
    readyCalls++;
    await _pending.future;
    return await super.markReady(id);
  }

  void finish() => _pending.complete();
}

class _LoadingReservations extends MockReservationRepository {
  new(super._listings, super._now);

  final _pendingList = Completer<List<Reservation>>();
  final _pendingDetail = Completer<Reservation?>();

  @override
  Future<List<Reservation>> loadMerchantReservations(String merchantId) =>
      _pendingList.future;

  @override
  Future<Reservation?> getMerchantReservation(String id, String merchantId) =>
      _pendingDetail.future;
}
