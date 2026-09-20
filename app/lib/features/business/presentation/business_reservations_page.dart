import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/business/presentation/business_copy.dart';
import 'package:pangankita/features/discovery/presentation/discovery_format.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';
import 'package:pangankita/features/reservations/domain/reservation_repository.dart';
import 'package:pangankita/features/reservations/presentation/reservation_copy.dart';

/// Merchant queue using the existing consumer reservation snapshots.
class BusinessReservationsPage extends StatefulWidget {
  /// Creates the queue for one fictional merchant.
  const new({
    required this.reservations,
    required this.merchantId,
    required this.revision,
    required this.onOpen,
    super.key,
  });

  /// Shared reservation state.
  final ReservationRepository reservations;

  /// Selected demo merchant.
  final String merchantId;

  /// Changes when shared state changes.
  final int revision;

  /// Opens a selected reservation.
  final ValueChanged<String> onOpen;

  @override
  State<BusinessReservationsPage> createState() =>
      _BusinessReservationsPageState();
}

class _BusinessReservationsPageState extends State<BusinessReservationsPage> {
  Future<List<Reservation>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void didUpdateWidget(covariant BusinessReservationsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.revision != widget.revision ||
        oldWidget.merchantId != widget.merchantId) {
      _future = _load();
    }
  }

  Future<List<Reservation>> _load() =>
      widget.reservations.loadMerchantReservations(widget.merchantId);

  void _retry() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) => SafeArea(
    child: FutureBuilder<List<Reservation>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData && !snapshot.hasError) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: TextButton(
              onPressed: _retry,
              child: const Text(BusinessCopy.retry),
            ),
          );
        }
        final items = snapshot.data;
        if (items == null) {
          return const Center(child: Text(BusinessCopy.loadError));
        }
        if (items.isEmpty) {
          return const Center(child: Text(BusinessCopy.emptyReservations));
        }
        final active =
            items
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
        final history = items.where(
          (item) =>
              item.status != ReservationStatus.reserved &&
              item.status != ReservationStatus.readyForPickup,
        );
        return ListView(
          padding: const EdgeInsets.all(PanganKitaSpacing.md),
          children: [
            Text(
              BusinessCopy.reservationsTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(BusinessCopy.demoNotice),
            _QueueSection(
              title: BusinessCopy.pickupQueue,
              items: active,
              onOpen: widget.onOpen,
            ),
            _QueueSection(
              title: BusinessCopy.closed,
              items: history,
              onOpen: widget.onOpen,
            ),
          ],
        );
      },
    ),
  );
}

class _QueueSection extends StatelessWidget {
  const new({required this.title, required this.items, required this.onOpen});

  final String title;
  final Iterable<Reservation> items;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: PanganKitaSpacing.lg),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        for (final reservation in items)
          Card(
            child: ListTile(
              onTap: () => onOpen(reservation.id),
              title: Text(reservation.listing.name),
              subtitle: Text(
                '${ReservationCopy.status(reservation.status)} · '
                '${reservation.quantity} paket · '
                '${formatPickupTime(reservation.listing.offer.pickupDeadline)}',
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
      ],
    );
  }
}
