import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_copy.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/business/presentation/business_impact_page.dart';
import 'package:pangankita/features/business/presentation/business_listing_detail_page.dart';
import 'package:pangankita/features/business/presentation/business_listings_page.dart';
import 'package:pangankita/features/business/presentation/business_profile_page.dart';
import 'package:pangankita/features/business/presentation/business_reservation_detail_page.dart';
import 'package:pangankita/features/business/presentation/business_reservations_page.dart';
import 'package:pangankita/features/business/presentation/create_listing_page.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/domain/listing_repository.dart';
import 'package:pangankita/features/discovery/presentation/discover_page.dart';
import 'package:pangankita/features/discovery/presentation/discovery_copy.dart';
import 'package:pangankita/features/discovery/presentation/listing_detail_page.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';
import 'package:pangankita/features/reservations/domain/reservation_repository.dart';
import 'package:pangankita/features/reservations/presentation/reservation_confirmation_page.dart';
import 'package:pangankita/features/reservations/presentation/reservation_detail_page.dart';
import 'package:pangankita/features/reservations/presentation/reservations_page.dart';

/// Local-only prototype roles; these do not grant authorization.
enum _PrototypeRole { consumer, business }

/// Temporary navigation shell for the two future experiences.
class PrototypeShell extends StatefulWidget {
  /// Creates the shell with its discovery data source.
  const new({
    required this.listings,
    required this.reservations,
    required this.now,
    required this.areaName,
    required this.merchant,
    super.key,
  });

  /// Listing source injected at application composition.
  final ListingRepository listings;

  /// Local reservation state shared across consumer routes.
  final ReservationRepository reservations;

  /// Clock injected at application composition.
  final DateTime Function() now;

  /// Fixed area selected for this local prototype.
  final String areaName;

  /// Fictional merchant selected by the local Business mode.
  final ListingMerchant merchant;

  @override
  State<PrototypeShell> createState() => _PrototypeShellState();
}

class _PrototypeShellState extends State<PrototypeShell> {
  static const _logoSize = 48.0;

  _PrototypeRole _role = _PrototypeRole.consumer;
  int _selectedIndex = 0;
  int _inventoryRevision = 0;

  static const List<({String label, IconData icon})> _consumerTabs = [
    (label: PanganKitaCopy.discover, icon: Icons.search),
    (label: PanganKitaCopy.reservations, icon: Icons.bookmark_outline),
    (label: PanganKitaCopy.impact, icon: Icons.insights_outlined),
    (label: PanganKitaCopy.profile, icon: Icons.person_outline),
  ];
  static const List<({String label, IconData icon})> _businessTabs = [
    (label: PanganKitaCopy.listings, icon: Icons.storefront_outlined),
    (label: PanganKitaCopy.reservations, icon: Icons.bookmark_outline),
    (label: PanganKitaCopy.impact, icon: Icons.insights_outlined),
    (label: PanganKitaCopy.business, icon: Icons.business_outlined),
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
          referenceTime: widget.now(),
          onReserve: _openConfirmation,
        ),
      ),
    );
  }

  void _openConfirmation(Listing listing) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ReservationConfirmationPage(
          listing: listing,
          reservations: widget.reservations,
          onCreated: _reservationCreated,
        ),
      ),
    );
  }

  void _reservationCreated(Reservation reservation) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    setState(() {
      _selectedIndex = 1;
      _inventoryRevision++;
    });
    _openReservation(reservation.id);
  }

  void _dataChanged() => setState(() => _inventoryRevision++);

  void _listingSaved() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    _dataChanged();
  }

  void _openCreateListing() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CreateListingPage(
          listings: widget.listings,
          merchant: widget.merchant,
          now: widget.now,
          onSaved: _listingSaved,
        ),
      ),
    );
  }

  void _openBusinessListing(String id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => BusinessListingDetailPage(
          listingId: id,
          merchantId: widget.merchant.id,
          listings: widget.listings,
          reservations: widget.reservations,
          onChanged: _dataChanged,
        ),
      ),
    );
  }

  void _openBusinessReservation(String id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => BusinessReservationDetailPage(
          reservationId: id,
          merchantId: widget.merchant.id,
          reservations: widget.reservations,
          onChanged: _dataChanged,
        ),
      ),
    );
  }

  void _openReservation(String id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ReservationDetailPage(
          reservationId: id,
          reservations: widget.reservations,
          onChanged: _dataChanged,
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
                  ? PanganKitaCopy.businessMode
                  : PanganKitaCopy.consumerMode,
            ),
          ),
        ],
      ),
      body: _role == _PrototypeRole.consumer
          ? switch (_selectedIndex) {
              0 => DiscoverPage(
                key: ValueKey(_inventoryRevision),
                listings: widget.listings,
                referenceTime: widget.now(),
                areaName: widget.areaName,
                onOpenListing: _openListing,
              ),
              1 => ReservationsPage(
                reservations: widget.reservations,
                revision: _inventoryRevision,
                onOpen: _openReservation,
                onBrowse: () => setState(() => _selectedIndex = 0),
              ),
              _ => _PrototypeDestination(title: selected.label),
            }
          : switch (_selectedIndex) {
              0 => BusinessListingsPage(
                listings: widget.listings,
                reservations: widget.reservations,
                merchant: widget.merchant,
                revision: _inventoryRevision,
                onCreate: _openCreateListing,
                onOpenListing: _openBusinessListing,
                onOpenReservation: _openBusinessReservation,
              ),
              1 => BusinessReservationsPage(
                reservations: widget.reservations,
                merchantId: widget.merchant.id,
                revision: _inventoryRevision,
                onOpen: _openBusinessReservation,
              ),
              2 => BusinessImpactPage(
                listings: widget.listings,
                reservations: widget.reservations,
                merchantId: widget.merchant.id,
                revision: _inventoryRevision,
              ),
              _ => BusinessProfilePage(merchant: widget.merchant),
            },
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
            const Text(PanganKitaCopy.temporaryPage),
          ],
        ),
      ),
    ),
  );
}
