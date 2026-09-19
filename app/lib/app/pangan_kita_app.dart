import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/app/prototype_shell.dart';
import 'package:pangankita/features/discovery/data/mock_listing_repository.dart';

/// Composes the local PanganKita prototype.
class PanganKitaApp extends StatelessWidget {
  /// Creates the application root.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final referenceTime = DateTime.now();
    return MaterialApp(
      title: 'PanganKita',
      theme: PanganKitaTheme.light,
      home: PrototypeShell(
        listings: MockListingRepository(referenceTime: referenceTime),
        referenceTime: referenceTime,
        areaName: MockListingRepository.prototypeArea,
      ),
    );
  }
}
