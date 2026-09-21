import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
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

enum _HeaderAction { profile, switchRole }

/// Navigation shell for the local consumer and business prototype.
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
  static const _profileTabIndex = 3;
  static const _headerHeight = 64.0;

  _PrototypeRole _role = _PrototypeRole.consumer;
  int _selectedIndex = 0;
  int _inventoryRevision = 0;

  static const List<({String label, IconData icon})> _consumerTabs = [
    (label: PanganKitaCopy.discover, icon: Symbols.storefront),
    (label: PanganKitaCopy.reservations, icon: Symbols.receipt_long),
    (label: PanganKitaCopy.impact, icon: Symbols.eco),
    (label: PanganKitaCopy.profile, icon: Symbols.person),
  ];
  static const List<({String label, IconData icon})> _businessTabs = [
    (label: PanganKitaCopy.listings, icon: Symbols.storefront),
    (label: PanganKitaCopy.reservations, icon: Symbols.receipt_long),
    (label: PanganKitaCopy.impact, icon: Symbols.eco),
    (label: PanganKitaCopy.business, icon: Symbols.person),
  ];

  void _switchRole() {
    setState(() {
      _role = _role == _PrototypeRole.consumer
          ? _PrototypeRole.business
          : _PrototypeRole.consumer;
      _selectedIndex = 0;
    });
  }

  void _handleHeaderAction(_HeaderAction action) {
    if (action == _HeaderAction.switchRole) {
      _switchRole();
      return;
    }
    setState(() => _selectedIndex = _profileTabIndex);
  }

  void _showUnavailable(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

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
          now: widget.now,
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
    final switchLabel = _role == _PrototypeRole.consumer
        ? PanganKitaCopy.businessMode
        : PanganKitaCopy.consumerMode;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _headerHeight,
        title: const _BrandTitle(),
        actions: [
          _HeaderArea(
            onPressed: () =>
                _showUnavailable(DiscoveryCopy.locationUnavailable),
          ),
          IconButton(
            tooltip: DiscoveryCopy.notifications,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            onPressed: () =>
                _showUnavailable(DiscoveryCopy.notificationsUnavailable),
            icon: const Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Symbols.notifications, size: 22),
                Positioned(
                  top: -1,
                  right: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: PanganKitaColors.brandAccent,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox.square(dimension: 8),
                  ),
                ),
              ],
            ),
          ),
          Semantics(
            label: switchLabel,
            button: true,
            excludeSemantics: true,
            child: PopupMenuButton<_HeaderAction>(
              tooltip: switchLabel,
              onSelected: _handleHeaderAction,
              icon: const CircleAvatar(
                radius: 16,
                backgroundColor: PanganKitaColors.brandPrimary,
                child: Icon(
                  Symbols.person,
                  size: 18,
                  color: Colors.white,
                  fill: 1,
                ),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _HeaderAction.profile,
                  child: Text(
                    _role == _PrototypeRole.consumer
                        ? PanganKitaCopy.profile
                        : PanganKitaCopy.business,
                  ),
                ),
                PopupMenuItem(
                  value: _HeaderAction.switchRole,
                  child: Text(switchLabel),
                ),
              ],
            ),
          ),
          const SizedBox(width: PanganKitaSpacing.sm),
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

class _HeaderArea extends StatelessWidget {
  const new({required this.onPressed});

  static const _width = 140.0;
  static const _height = 40.0;
  static const _radius = 20.0;
  static const _horizontalPadding = 10.0;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: _width,
    height: _height,
    child: Material(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(_radius)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: const BorderRadius.all(Radius.circular(_radius)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Row(
            children: [
              const Icon(
                Symbols.near_me,
                size: 16,
                color: PanganKitaColors.brandAccent,
              ),
              const SizedBox(width: PanganKitaSpacing.xs),
              Expanded(
                child: Text(
                  DiscoveryCopy.compactArea,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              const Icon(Symbols.expand_more, size: 16),
            ],
          ),
        ),
      ),
    ),
  );
}

class _BrandTitle extends StatelessWidget {
  const new();

  static const _logoSize = 36.0;
  static const _minWordmarkWidth = 140.0;
  static const _maxWordmarkTextScale = 1.3;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: constraints.maxWidth < _logoSize
              ? constraints.maxWidth
              : _logoSize,
          child: Image.asset(
            'assets/brand/logo-primary.png',
            semanticLabel: DiscoveryCopy.logoLabel,
          ),
        ),
        if (constraints.maxWidth >= _minWordmarkWidth &&
            MediaQuery.textScalerOf(context).scale(1) <=
                _maxWordmarkTextScale) ...[
          const SizedBox(width: PanganKitaSpacing.sm),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                PanganKitaCopy.appName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: PanganKitaColors.brandPrimaryStrong,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  );
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
