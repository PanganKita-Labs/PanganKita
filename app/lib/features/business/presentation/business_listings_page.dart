import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
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
        Card(
          child: Padding(
            padding: const EdgeInsets.all(PanganKitaSpacing.md),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final badgeFits =
                        constraints.maxWidth >= 300 &&
                        MediaQuery.textScalerOf(context).scale(1) <= 1.3;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              child: Icon(Symbols.bakery_dining, fill: 1),
                            ),
                            const SizedBox(width: PanganKitaSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    merchant.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Symbols.near_me,
                                        size: 16,
                                        color: PanganKitaColors.brandAccent,
                                      ),
                                      const SizedBox(
                                        width: PanganKitaSpacing.xs,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${merchant.area} · '
                                          '${BusinessCopy.demoIdentity}',
                                          maxLines: 2,
                                        ),
                                      ),
                                      const Icon(Symbols.expand_more, size: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (badgeFits) ...[
                              const SizedBox(width: PanganKitaSpacing.sm),
                              const _DemoBadge(),
                            ],
                          ],
                        ),
                        if (!badgeFits) ...[
                          const SizedBox(height: PanganKitaSpacing.sm),
                          const _DemoBadge(),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: PanganKitaSpacing.md),
                _DashboardMetrics(data: data, waitingCount: waiting.length),
              ],
            ),
          ),
        ),
        const SizedBox(height: PanganKitaSpacing.md),
        ElevatedButton.icon(
          onPressed: onCreate,
          icon: const Icon(Symbols.add_circle),
          label: const Text(BusinessCopy.createListing),
        ),
        const SizedBox(height: PanganKitaSpacing.md),
        if (waiting.isNotEmpty) ...[
          const SizedBox(height: PanganKitaSpacing.lg),
          Row(
            children: [
              const Icon(
                Symbols.notifications_active,
                color: PanganKitaColors.brandAccent,
              ),
              const SizedBox(width: PanganKitaSpacing.sm),
              Expanded(
                child: Text(
                  BusinessCopy.pickupQueue,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Chip(label: Text('${waiting.length} aktif')),
            ],
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
          reservations: data.reservations,
          onOpen: onOpenListing,
        ),
        _ListingGroup(
          title: BusinessCopy.drafts,
          items: data.listings.where(
            (item) => item.status == ListingStatus.draft,
          ),
          reservations: data.reservations,
          onOpen: onOpenListing,
        ),
        _ListingGroup(
          title: BusinessCopy.closed,
          items: data.listings.where(
            (item) =>
                item.status != ListingStatus.active &&
                item.status != ListingStatus.draft,
          ),
          reservations: data.reservations,
          onOpen: onOpenListing,
        ),
        _CompletedActivity(reservations: data.reservations),
      ],
    );
  }
}

class _DemoBadge extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      color: PanganKitaColors.savingsSurface,
      borderRadius: BorderRadius.all(Radius.circular(PanganKitaRadii.control)),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: PanganKitaSpacing.sm,
        vertical: PanganKitaSpacing.xs,
      ),
      child: Text(
        BusinessCopy.demoBadge,
        style: TextStyle(
          color: PanganKitaColors.brandPrimaryStrong,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
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
    return Column(
      children: [
        const Row(
          children: [
            Icon(Symbols.eco, color: PanganKitaColors.brandPrimary, fill: 1),
            SizedBox(width: PanganKitaSpacing.sm),
            Expanded(child: Text(BusinessCopy.impactTitle)),
          ],
        ),
        const SizedBox(height: PanganKitaSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: BusinessCopy.activeListings(active.length),
                value: '${active.length}',
              ),
            ),
            Expanded(
              child: _Metric(
                label: BusinessCopy.activeReservations(waitingCount),
                value: '$waitingCount',
              ),
            ),
            Expanded(
              child: _Metric(
                label: BusinessCopy.completedPackages(completed),
                value: '$completed',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      Text(
        value,
        style: Theme.of(context).textTheme.headlineSmall
            ?.copyWith(color: PanganKitaColors.brandPrimaryStrong),
      ),
    ],
  );
}

class _PickupQueueCard extends StatelessWidget {
  const new({required this.reservation, required this.onOpen});

  final Reservation reservation;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final deadline = formatPickupTime(reservation.listing.offer.pickupDeadline);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PanganKitaSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: PanganKitaSpacing.sm,
              children: [
                Text(
                  'ID ${reservation.id}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Chip(
                  label: Text(
                    reservation.status == ReservationStatus.readyForPickup
                        ? 'Siap diambil'
                        : 'Dipesan',
                  ),
                ),
              ],
            ),
            Text(reservation.listing.name),
            Text(
              BusinessCopy.pickupQueueSummary(reservation.quantity, deadline),
            ),
            const SizedBox(height: PanganKitaSpacing.sm),
            Text(
              '${BusinessCopy.surplusPrice}: '
              '${formatRupiah(reservation.amountDueRupiah)}',
            ),
            const SizedBox(height: PanganKitaSpacing.sm),
            ElevatedButton.icon(
              onPressed: () => onOpen(reservation.id),
              icon: const Icon(Symbols.qr_code_scanner),
              label: Text(
                reservation.status == ReservationStatus.readyForPickup
                    ? BusinessCopy.verifyPickup
                    : BusinessCopy.markReady,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingGroup extends StatelessWidget {
  const new({
    required this.title,
    required this.items,
    required this.reservations,
    required this.onOpen,
  });

  static const _thumbnailSize = 48.0;

  final String title;
  final Iterable<Listing> items;
  final List<Reservation> reservations;
  final ValueChanged<String> onOpen;

  String _pickupDeadline(Listing listing) =>
      '${BusinessCopy.pickupDeadline}: '
      '${formatPickupTime(listing.offer.pickupDeadline)}';

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: PanganKitaSpacing.lg),
        Text(
          title == BusinessCopy.active ? 'Listing Aktif Toko' : title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        for (final listing in items)
          Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => onOpen(listing.id),
              child: Padding(
                padding: const EdgeInsets.all(PanganKitaSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        SizedBox.square(
                          dimension: _thumbnailSize * 2,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(PanganKitaRadii.control),
                            ),
                            child: Image.asset(
                              listing.content.imageAsset,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: PanganKitaSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Symbols.schedule,
                                    size: 16,
                                    color: PanganKitaColors.brandAccent,
                                  ),
                                  const SizedBox(width: PanganKitaSpacing.xs),
                                  Expanded(
                                    child: Text(
                                      _pickupDeadline(listing),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                listing.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                formatRupiah(listing.offer.priceRupiah),
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color:
                                          PanganKitaColors.brandPrimaryStrong,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PanganKitaSpacing.md),
                    _StockBreakdown(
                      listing: listing,
                      reservations: reservations,
                    ),
                    const SizedBox(height: PanganKitaSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: () => onOpen(listing.id),
                      icon: const Icon(Symbols.tune),
                      label: const Text(BusinessCopy.updateQuantity),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StockBreakdown extends StatelessWidget {
  const new({required this.listing, required this.reservations});

  final Listing listing;
  final List<Reservation> reservations;

  @override
  Widget build(BuildContext context) {
    final items = reservations.where((item) => item.listing.id == listing.id);
    final held = items
        .where(
          (item) =>
              item.status == ReservationStatus.reserved ||
              item.status == ReservationStatus.readyForPickup,
        )
        .fold<int>(0, (sum, item) => sum + item.quantity);
    final completed = items
        .where((item) => item.status == ReservationStatus.completed)
        .fold<int>(0, (sum, item) => sum + item.quantity);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Symbols.task_alt,
              size: 18,
              color: PanganKitaColors.brandPrimary,
            ),
            const SizedBox(width: PanganKitaSpacing.xs),
            Expanded(
              child: Text(
                'Status batch surplus · '
                '${BusinessCopy.listingStatus(listing.status)}',
              ),
            ),
          ],
        ),
        const SizedBox(height: PanganKitaSpacing.sm),
        LinearProgressIndicator(
          value: listing.offer.totalQuantity == 0
              ? 0
              : completed / listing.offer.totalQuantity,
          backgroundColor: PanganKitaColors.borderNeutral,
        ),
        const SizedBox(height: PanganKitaSpacing.sm),
        Wrap(
          spacing: PanganKitaSpacing.md,
          runSpacing: PanganKitaSpacing.sm,
          children: [
            Text('${listing.offer.availableQuantity} tersedia'),
            Text('$held dipesan'),
            Text('$completed selesai'),
          ],
        ),
      ],
    );
  }
}

class _CompletedActivity extends StatelessWidget {
  const new({required this.reservations});

  static const _recentActivityLimit = 3;

  final List<Reservation> reservations;

  @override
  Widget build(BuildContext context) {
    final completed = reservations
        .where((item) => item.status == ReservationStatus.completed)
        .toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PanganKitaSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Symbols.task_alt,
                  color: PanganKitaColors.brandPrimary,
                ),
                const SizedBox(width: PanganKitaSpacing.sm),
                Expanded(
                  child: Text(
                    'Selesai di demo lokal',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            Text(
              completed.isEmpty
                  ? BusinessCopy.emptyCompleted
                  : BusinessCopy.completedReservations(completed.length),
            ),
            for (final item in completed.take(_recentActivityLimit))
              ListTile(
                leading: const Icon(
                  Symbols.check_circle,
                  color: PanganKitaColors.brandPrimary,
                ),
                title: Text(item.listing.name),
                subtitle: Text('ID ${item.id} · ${item.quantity} paket'),
              ),
          ],
        ),
      ),
    );
  }
}
