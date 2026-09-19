import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/app/prototype_shell.dart';
import 'package:pangankita/features/discovery/mock_listing_repository.dart';

/// Composes the local PanganKita prototype.
class PanganKitaApp extends StatelessWidget {
  /// Creates the application root.
  const new({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'PanganKita',
    theme: PanganKitaTheme.light,
    home: const PrototypeShell(listings: MockListingRepository()),
  );
}
