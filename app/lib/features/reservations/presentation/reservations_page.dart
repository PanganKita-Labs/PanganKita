import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/presentation/discovery_format.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';
import 'package:pangankita/features/reservations/domain/reservation_repository.dart';
import 'package:pangankita/features/reservations/presentation/reservation_copy.dart';

/// Consumer list of active and historical local reservations.
class ReservationsPage extends StatefulWidget {
  /// Creates the consumer Reservations destination.
  const new({
    required this.reservations,
    required this.revision,
    required this.onOpen,
    required this.onBrowse,
    super.key,
  });

  /// Local reservation source.
  final ReservationRepository reservations;

  /// Changes when local reservation or stock state changes.
  final int revision;

  /// Opens a selected reservation.
  final ValueChanged<String> onOpen;

  /// Returns to Discover from the empty state.
  final VoidCallback onBrowse;

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  Future<List<Reservation>>? _future;

  @override
  void initState() {
    super.initState();
    _future = widget.reservations.loadReservations();
  }

  @override
  void didUpdateWidget(covariant ReservationsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reservations != widget.reservations ||
        oldWidget.revision != widget.revision) {
      _future = widget.reservations.loadReservations();
    }
  }

  void _retry() => setState(() {
    _future = widget.reservations.loadReservations();
  });

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(ReservationCopy.loadError),
                TextButton(
                  onPressed: _retry,
                  child: const Text(ReservationCopy.retry),
                ),
              ],
            ),
          );
        }
        return _ReservationList(
          items: snapshot.data ?? [],
          onOpen: widget.onOpen,
          onBrowse: widget.onBrowse,
        );
      },
    ),
  );
}

class _ReservationList extends StatelessWidget {
  const new({
    required this.items,
    required this.onOpen,
    required this.onBrowse,
  });

  final List<Reservation> items;
  final ValueChanged<String> onOpen;
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(ReservationCopy.empty),
            TextButton(
              onPressed: onBrowse,
              child: const Text(ReservationCopy.browse),
            ),
          ],
        ),
      );
    }
    final active = items.where(
      (item) =>
          item.status == ReservationStatus.reserved ||
          item.status == ReservationStatus.readyForPickup,
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
          ReservationCopy.reservationsTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: PanganKitaSpacing.sm),
        const Text(ReservationCopy.demoNotice),
        if (active.isNotEmpty)
          _ReservationSection(
            title: ReservationCopy.active,
            items: active,
            onOpen: onOpen,
          ),
        if (history.isNotEmpty)
          _ReservationSection(
            title: ReservationCopy.history,
            items: history,
            onOpen: onOpen,
          ),
      ],
    );
  }
}

class _ReservationSection extends StatelessWidget {
  const new({required this.title, required this.items, required this.onOpen});

  final String title;
  final Iterable<Reservation> items;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: PanganKitaSpacing.lg),
      Text(title, style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: PanganKitaSpacing.sm),
      for (final reservation in items)
        Card(
          child: ListTile(
            onTap: () => onOpen(reservation.id),
            title: Text(reservation.listing.name),
            subtitle: Text(
              '${ReservationCopy.status(reservation.status)} · '
              '${reservation.listing.merchant.name}\n'
              'Pickup sebelum '
              '${formatPickupTime(reservation.listing.offer.pickupDeadline)}',
            ),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
    ],
  );
}
