import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/listing_repository.dart';

/// Local-only prototype roles; these do not grant authorization.
enum _PrototypeRole { consumer, business }

/// Temporary navigation shell for the two future experiences.
class PrototypeShell extends StatefulWidget {
  /// Creates the shell with its discovery data source.
  const new({required this.listings, super.key});

  /// Listing source used to confirm prototype data is wired up.
  final ListingRepository listings;

  @override
  State<PrototypeShell> createState() => _PrototypeShellState();
}

class _PrototypeShellState extends State<PrototypeShell> {
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

  @override
  Widget build(BuildContext context) {
    final tabs = _role == _PrototypeRole.consumer
        ? _consumerTabs
        : _businessTabs;
    final selected = tabs[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PanganKita'),
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
      body: _PrototypeDestination(
        title: selected.label,
        showListingCount:
            _role == _PrototypeRole.consumer && _selectedIndex == 0,
        listings: widget.listings,
      ),
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
  const new({
    required this.title,
    required this.showListingCount,
    required this.listings,
  });

  final String title;
  final bool showListingCount;
  final ListingRepository listings;

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
            if (showListingCount)
              FutureBuilder(
                future: listings.loadListings(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Data contoh tidak tersedia.');
                  }
                  if (!snapshot.hasData) {
                    return const Text('Memuat data contoh…');
                  }
                  return Text(
                    '${snapshot.data?.length} listing contoh siap '
                    'untuk fase berikutnya.',
                  );
                },
              ),
          ],
        ),
      ),
    ),
  );
}
