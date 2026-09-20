import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/app/prototype_shell.dart';
import 'package:pangankita/features/discovery/data/mock_listing_repository.dart';
import 'package:pangankita/features/reservations/data/mock_reservation_repository.dart';

/// Composes the local PanganKita prototype.
class PanganKitaApp extends StatefulWidget {
  /// Creates the application root.
  const new({super.key});

  @override
  State<PanganKitaApp> createState() => _PanganKitaAppState();
}

class _PanganKitaAppState extends State<PanganKitaApp> {
  final ({
    MockListingRepository listings,
    MockReservationRepository reservations,
  })
  _dependencies = _createDependencies();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PanganKita',
      theme: PanganKitaTheme.light,
      home: PrototypeShell(
        listings: _dependencies.listings,
        reservations: _dependencies.reservations,
        now: DateTime.now,
        areaName: MockListingRepository.prototypeArea,
        merchant: MockListingRepository.prototypeMerchant,
      ),
    );
  }
}

({MockListingRepository listings, MockReservationRepository reservations})
_createDependencies() {
  final listings = MockListingRepository(
    referenceTime: DateTime.now(),
    now: DateTime.now,
  );
  return (
    listings: listings,
    reservations: MockReservationRepository(listings, DateTime.now),
  );
}
