import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/domain/listing_repository.dart';
import 'package:pangankita/features/discovery/presentation/discover_page.dart';
import 'package:pangankita/features/discovery/presentation/discovery_copy.dart';
import 'package:pangankita/features/discovery/presentation/listing_detail_page.dart';

/// Local-only prototype roles; these do not grant authorization.
enum _PrototypeRole { consumer, business }

/// Temporary navigation shell for the two future experiences.
class PrototypeShell extends StatefulWidget {
  /// Creates the shell with its discovery data source.
  const new({
    required this.listings,
    required this.referenceTime,
    required this.areaName,
    super.key,
  });

  /// Listing source injected at application composition.
  final ListingRepository listings;

  /// One reference time shared by the mock repository and discovery UI.
  final DateTime referenceTime;

  /// Fixed area selected for this local prototype.
  final String areaName;

  @override
  State<PrototypeShell> createState() => _PrototypeShellState();
}

class _PrototypeShellState extends State<PrototypeShell> {
  static const _logoSize = 48.0;

  _PrototypeRole _role = _PrototypeRole.consumer;
  int _selectedIndex = 0;

  static const List<({String label, IconData icon})> _consumerTabs = [
    (label: 'Discover', icon: Icons.search),
    (label: 'Reservations', icon: Icons.bookmark_outline),
    (label: 'Impact', icon: Icons.insights_outlined),
    (label: 'Profile', icon: Icons.person_outline),
  ];
  static const List<({String label, IconData icon})> _businessTabs = [
    (label: 'Listings', icon: Icons.storefront_outlined),
    (label: 'Reservations', icon: Icons.bookmark_outline),
    (label: 'Impact', icon: Icons.insights_outlined),
    (label: 'Business', icon: Icons.business_outlined),
  ];

  void _switchRole() {
    setState(() {
      _role = _role == _PrototypeRole.consumer
          ? _PrototypeRole.business
          : _PrototypeRole.consumer;
      _selectedIndex = 0;
    });
  }

  void _openListing(String id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ListingDetailPage(
          listingId: id,
          listings: widget.listings,
          referenceTime: widget.referenceTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _role == _PrototypeRole.consumer
        ? _consumerTabs
        : _businessTabs;
    final selected = tabs[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: SizedBox.square(
          dimension: _logoSize,
          child: Image.asset(
            'assets/brand/logo-primary.png',
            semanticLabel: DiscoveryCopy.logoLabel,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _switchRole,
            child: Text(
              _role == _PrototypeRole.consumer
                  ? 'Mode Bisnis'
                  : 'Mode Konsumen',
            ),
          ),
        ],
      ),
      body: _role == _PrototypeRole.consumer && _selectedIndex == 0
          ? DiscoverPage(
              listings: widget.listings,
              referenceTime: widget.referenceTime,
              areaName: widget.areaName,
              onOpenListing: _openListing,
            )
          : _PrototypeDestination(title: selected.label),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: [
          for (final tab in tabs)
            NavigationDestination(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}

class _PrototypeDestination extends StatelessWidget {
  const new({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(PanganKitaSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: PanganKitaSpacing.sm),
            const Text('Halaman sementara untuk fondasi prototipe.'),
          ],
        ),
      ),
    ),
  );
}
