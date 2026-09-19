import 'package:flutter/material.dart';
import 'package:pangankita/home_page.dart';

/// Root application widget for PanganKita.
class PanganKitaApp extends StatelessWidget {
  /// Creates the PanganKita application.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
