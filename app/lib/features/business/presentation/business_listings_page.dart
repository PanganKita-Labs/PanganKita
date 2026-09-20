import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/business/presentation/business_copy.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/domain/listing_repository.dart';
import 'package:pangankita/features/discovery/presentation/discovery_format.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';
import 'package:pangankita/features/reservations/domain/reservation_repository.dart';

/// Merchant dashboard backed by the same listing and reservation state.
class BusinessListingsPage extends StatefulWidget {
  /// Creates the local business listings destination.
  const new({
    required this.listings,
    required this.reservations,
    required this.merchant,
    required this.revision,
    required this.onCreate,
    required this.onOpenListing,
    required this.onOpenReservation,
    super.key,
  });

  /// Canonical listing repository.
  final ListingRepository listings;

  /// Canonical reservation repository.
  final ReservationRepository reservations;

  /// Fictional merchant selected by local Business mode.
  final ListingMerchant merchant;

  /// Changes after shared prototype state changes.
  final int revision;

  /// Opens listing creation.
  final VoidCallback onCreate;

  /// Opens one merchant listing.
  final ValueChanged<String> onOpenListing;

  /// Opens one merchant reservation.
  final ValueChanged<String> onOpenReservation;

  @override
  State<BusinessListingsPage> createState() => _BusinessListingsPageState();
}

typedef _DashboardData = ({
  List<Listing> listings,
  List<Reservation> reservations,
});

class _BusinessListingsPageState extends State<BusinessListingsPage> {
  Future<_DashboardData>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void didUpdateWidget(covariant BusinessListingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.revision != widget.revision ||
        oldWidget.merchant.id != widget.merchant.id) {
      _future = _load();
    }
  }

  Future<_DashboardData> _load() async => (
    listings: await widget.listings.loadMerchantListings(widget.merchant.id),
    reservations: await widget.reservations.loadMerchantReservations(
      widget.merchant.id,
    ),
  );

  void _retry() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) => SafeArea(
    child: FutureBuilder<_DashboardData>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData && !snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(
              semanticsLabel: BusinessCopy.loading,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(BusinessCopy.loadError),
                TextButton(
                  onPressed: _retry,
                  child: const Text(BusinessCopy.retry),
                ),
              ],
            ),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: Text(BusinessCopy.loadError));
        }
        return _DashboardBody(
          data: data,
          merchant: widget.merchant,
          onCreate: widget.onCreate,
          onOpenListing: widget.onOpenListing,
          onOpenReservation: widget.onOpenReservation,
        );
      },
    ),
  );
}

class _DashboardBody extends StatelessWidget {
  const new({
    required this.data,
    required this.merchant,
    required this.onCreate,
    required this.onOpenListing,
    required this.onOpenReservation,
  });

  final _DashboardData data;
  final ListingMerchant merchant;
  final VoidCallback onCreate;
  final ValueChanged<String> onOpenListing;
  final ValueChanged<String> onOpenReservation;

  @override
  Widget build(BuildContext context) {
    final waiting =
        data.reservations
            .where(
              (item) =>
                  item.status == ReservationStatus.reserved ||
                  item.status == ReservationStatus.readyForPickup,
            )
            .toList()
          ..sort(
            (a, b) => a.listing.offer.pickupDeadline.compareTo(
              b.listing.offer.pickupDeadline,
            ),
          );
    return ListView(
      padding: const EdgeInsets.all(PanganKitaSpacing.md),
      children: [
        Text(merchant.name, style: Theme.of(context).textTheme.headlineMedium),
        Text('${merchant.area} · ${BusinessCopy.demoNotice}'),
        const SizedBox(height: PanganKitaSpacing.md),
        ElevatedButton.icon(
          onPressed: onCreate,
          icon: const Icon(Icons.add),
          label: const Text(BusinessCopy.createListing),
        ),
        const SizedBox(height: PanganKitaSpacing.md),
        _DashboardMetrics(data: data, waitingCount: waiting.length),
        if (waiting.isNotEmpty) ...[
          const SizedBox(height: PanganKitaSpacing.lg),
          Text(
            BusinessCopy.pickupQueue,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          for (final reservation in waiting.take(2))
            _PickupQueueCard(
              reservation: reservation,
              onOpen: onOpenReservation,
            ),
        ],
        if (data.listings.isEmpty) ...[
          const SizedBox(height: PanganKitaSpacing.lg),
          const Text(BusinessCopy.emptyListings),
        ],
        _ListingGroup(
          title: BusinessCopy.active,
          items: data.listings.where(
            (item) => item.status == ListingStatus.active,
          ),
          onOpen: onOpenListing,
        ),
        _ListingGroup(
          title: BusinessCopy.drafts,
          items: data.listings.where(
            (item) => item.status == ListingStatus.draft,
          ),
          onOpen: onOpenListing,
        ),
        _ListingGroup(
          title: BusinessCopy.closed,
          items: data.listings.where(
            (item) =>
                item.status != ListingStatus.active &&
                item.status != ListingStatus.draft,
          ),
          onOpen: onOpenListing,
        ),
      ],
    );
  }
}

class _DashboardMetrics extends StatelessWidget {
  const new({required this.data, required this.waitingCount});

  final _DashboardData data;
  final int waitingCount;

  @override
  Widget build(BuildContext context) {
    final active = data.listings.where(
      (item) => item.status == ListingStatus.active,
    );
    final completed = data.reservations
        .where((item) => item.status == ReservationStatus.completed)
        .fold<int>(0, (sum, item) => sum + item.quantity);
    return Wrap(
      spacing: PanganKitaSpacing.md,
      runSpacing: PanganKitaSpacing.sm,
      children: [
        Text(BusinessCopy.activeListings(active.length)),
        Text(BusinessCopy.activeReservations(waitingCount)),
        Text(BusinessCopy.completedPackages(completed)),
      ],
    );
  }
}

class _PickupQueueCard extends StatelessWidget {
  const new({required this.reservation, required this.onOpen});

  final Reservation reservation;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final deadline = formatPickupTime(reservation.listing.offer.pickupDeadline);
    return Card(
      child: ListTile(
        onTap: () => onOpen(reservation.id),
        title: Text(reservation.listing.name),
        subtitle: Text(
          BusinessCopy.pickupQueueSummary(reservation.quantity, deadline),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _ListingGroup extends StatelessWidget {
  const new({required this.title, required this.items, required this.onOpen});

  static const _thumbnailSize = 48.0;

  final String title;
  final Iterable<Listing> items;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: PanganKitaSpacing.lg),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        for (final listing in items)
          Card(
            child: ListTile(
              onTap: () => onOpen(listing.id),
              leading: SizedBox.square(
                dimension: _thumbnailSize,
                child: Image.asset(
                  listing.content.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(listing.name),
              subtitle: Text(
                '${BusinessCopy.listingStatus(listing.status)} · '
                '${listing.offer.availableQuantity} tersedia · '
                '${formatPickupTime(listing.offer.pickupDeadline)}',
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
      ],
    );
  }
}
