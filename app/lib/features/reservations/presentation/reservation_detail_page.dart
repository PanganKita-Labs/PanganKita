import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/presentation/discovery_format.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';
import 'package:pangankita/features/reservations/domain/reservation_repository.dart';
import 'package:pangankita/features/reservations/presentation/reservation_copy.dart';

/// Consumer pickup information and explicit local demo transitions.
class ReservationDetailPage extends StatefulWidget {
  /// Creates a reservation detail route.
  const new({
    required this.reservationId,
    required this.reservations,
    required this.onChanged,
    super.key,
  });

  /// Stable local reservation identifier.
  final String reservationId;

  /// Source and transition authority for local demo state.
  final ReservationRepository reservations;

  /// Notifies the application shell to refresh discovery availability.
  final VoidCallback onChanged;

  @override
  State<ReservationDetailPage> createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  Future<Reservation?>? _future;
  String? _error;

  @override
  void initState() {
    super.initState();
    _future = widget.reservations.getReservation(widget.reservationId);
  }

  @override
  void didUpdateWidget(covariant ReservationDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reservationId != widget.reservationId ||
        oldWidget.reservations != widget.reservations) {
      _future = widget.reservations.getReservation(widget.reservationId);
    }
  }

  Future<void> _apply(Future<Reservation> Function(String) action) async {
    try {
      final updated = await action(widget.reservationId);
      if (!mounted) return;
      setState(() {
        _future = Future<Reservation>.value(updated);
        _error = null;
      });
      widget.onChanged();
    } on ReservationException catch (error) {
      if (!mounted) return;
      setState(() {
        _future = widget.reservations.getReservation(widget.reservationId);
        _error = ReservationCopy.failure(error.failure);
      });
    } on Exception {
      if (!mounted) return;
      setState(() {
        _future = widget.reservations.getReservation(widget.reservationId);
        _error = ReservationCopy.actionError;
      });
    }
  }

  Future<void> _cancel() async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(ReservationCopy.cancelQuestion),
        content: const Text(ReservationCopy.cancelExplanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(ReservationCopy.keep),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(ReservationCopy.cancel),
          ),
        ],
      ),
    );
    if (approved == true && mounted) {
      await _apply(widget.reservations.cancel);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(ReservationCopy.detailTitle)),
    body: FutureBuilder<Reservation?>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(ReservationCopy.loadError),
                TextButton(
                  onPressed: () => setState(() {
                    _future = widget.reservations.getReservation(
                      widget.reservationId,
                    );
                  }),
                  child: const Text(ReservationCopy.retry),
                ),
              ],
            ),
          );
        }
        final reservation = snapshot.data;
        if (reservation == null) {
          return const Center(child: Text(ReservationCopy.missing));
        }
        return _ReservationBody(
          reservation: reservation,
          error: _error,
          onReady: () => unawaited(_apply(widget.reservations.markReady)),
          onComplete: () => unawaited(_apply(widget.reservations.complete)),
          onCancel: () => unawaited(_cancel()),
        );
      },
    ),
  );
}

class _ReservationBody extends StatelessWidget {
  const new({
    required this.reservation,
    required this.onReady,
    required this.onComplete,
    required this.onCancel,
    this.error,
  });

  final Reservation reservation;
  final VoidCallback onReady;
  final VoidCallback onComplete;
  final VoidCallback onCancel;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(PanganKitaSpacing.md),
        children: [
          _PickupInformation(reservation: reservation),
          if (error case final message?) ...[
            const SizedBox(height: PanganKitaSpacing.sm),
            Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          _DemoActions(
            status: reservation.status,
            onReady: onReady,
            onComplete: onComplete,
            onCancel: onCancel,
          ),
        ],
      ),
    );
  }
}

class _PickupInformation extends StatelessWidget {
  const new({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final listing = reservation.listing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ReservationCopy.status(reservation.status),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Text(ReservationCopy.demoNotice),
        const SizedBox(height: PanganKitaSpacing.md),
        Row(
          children: [
            const Icon(Icons.schedule, color: PanganKitaColors.brandAccent),
            const SizedBox(width: PanganKitaSpacing.sm),
            Expanded(
              child: Text(
                '${ReservationCopy.pickupBefore} '
                '${formatPickupTime(listing.offer.pickupDeadline)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: PanganKitaSpacing.md),
        Text(listing.name, style: Theme.of(context).textTheme.titleLarge),
        Text(
          ReservationCopy.packageSummary(
            reservation.quantity,
            listing.merchant.name,
          ),
        ),
        const SizedBox(height: PanganKitaSpacing.md),
        Text(
          ReservationCopy.pickupPlace,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(listing.merchant.pickupAddress),
        const SizedBox(height: PanganKitaSpacing.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(PanganKitaSpacing.md),
            child: Column(
              children: [
                const Text(ReservationCopy.pickupCode),
                Text(
                  reservation.pickupCode,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const Text(ReservationCopy.codeNotice),
              ],
            ),
          ),
        ),
        const SizedBox(height: PanganKitaSpacing.md),
        Text(
          ReservationCopy.amountDue,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          formatRupiah(reservation.amountDueRupiah),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Text(ReservationCopy.payment),
        const SizedBox(height: PanganKitaSpacing.md),
        const Text(ReservationCopy.instruction),
      ],
    );
  }
}

class _DemoActions extends StatelessWidget {
  const new({
    required this.status,
    required this.onReady,
    required this.onComplete,
    required this.onCancel,
  });

  final ReservationStatus status;
  final VoidCallback onReady;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    if (status != ReservationStatus.reserved &&
        status != ReservationStatus.readyForPickup) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: PanganKitaSpacing.lg),
        Text(
          ReservationCopy.demoControls,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: PanganKitaSpacing.sm),
        if (status == ReservationStatus.reserved) ...[
          ElevatedButton(
            onPressed: onReady,
            child: const Text(ReservationCopy.simulateReady),
          ),
          TextButton(
            onPressed: onCancel,
            child: const Text(ReservationCopy.cancel),
          ),
        ],
        if (status == ReservationStatus.readyForPickup)
          ElevatedButton(
            onPressed: onComplete,
            child: const Text(ReservationCopy.simulateComplete),
          ),
      ],
    );
  }
}
