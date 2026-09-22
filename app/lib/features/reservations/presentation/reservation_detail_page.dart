import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
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
    required this.now,
    super.key,
  });

  /// Stable local reservation identifier.
  final String reservationId;

  /// Source and transition authority for local demo state.
  final ReservationRepository reservations;

  /// Notifies the application shell to refresh discovery availability.
  final VoidCallback onChanged;

  /// Shared prototype clock for the remaining-time display.
  final DateTime Function() now;

  @override
  State<ReservationDetailPage> createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  Future<Reservation?>? _future;
  String? _error;
  bool _saving = false;

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
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
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
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _cancel() async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Symbols.warning, color: PanganKitaColors.brandAccent),
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
    appBar: AppBar(
      leading: IconButton(
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Symbols.arrow_back),
      ),
      title: const Text(ReservationCopy.detailTitle),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: PanganKitaSpacing.sm),
          child: CircleAvatar(
            backgroundColor: PanganKitaColors.brandPrimary,
            child: Icon(Symbols.person, color: Colors.white, fill: 1),
          ),
        ),
      ],
    ),
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
          referenceTime: widget.now(),
          error: _error,
          saving: _saving,
          onCancel: () => unawaited(_cancel()),
        );
      },
    ),
  );
}

class _ReservationBody extends StatelessWidget {
  const new({
    required this.reservation,
    required this.referenceTime,
    required this.onCancel,
    required this.saving,
    this.error,
  });

  final Reservation reservation;
  final DateTime referenceTime;
  final VoidCallback onCancel;
  final String? error;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(PanganKitaSpacing.md),
        children: [
          _PickupInformation(
            reservation: reservation,
            referenceTime: referenceTime,
          ),
          if (error case final message?) ...[
            const SizedBox(height: PanganKitaSpacing.sm),
            Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          _CancellationAction(
            status: reservation.status,
            saving: saving,
            onCancel: onCancel,
          ),
        ],
      ),
    );
  }
}

class _PickupInformation extends StatelessWidget {
  const new({required this.reservation, required this.referenceTime});

  static const _ticketImageWidth = 56.0;
  static const _pickupCodeLetterSpacing = 3.0;
  static const _qrVisualSize = 112.0;
  static const _mapPlaceholderHeight = 120.0;

  final Reservation reservation;
  final DateTime referenceTime;

  @override
  Widget build(BuildContext context) {
    final listing = reservation.listing;
    final ready = reservation.status == ReservationStatus.readyForPickup;
    final pickupDeadline = formatPickupTime(listing.offer.pickupDeadline);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(PanganKitaSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: PanganKitaSpacing.sm,
                  children: [
                    Chip(
                      avatar: const Icon(Symbols.circle, size: 12, fill: 1),
                      label: Text(ReservationCopy.status(reservation.status)),
                      backgroundColor: PanganKitaColors.savingsSurface,
                    ),
                    Text(
                      'ID ${reservation.id}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Text(
                  ready
                      ? ReservationCopy.readyHeading
                      : ReservationCopy.reservedHeading,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: PanganKitaSpacing.sm),
                Text(
                  ready
                      ? ReservationCopy.readySummary
                      : ReservationCopy.reservedSummary,
                ),
                const SizedBox(height: PanganKitaSpacing.md),
                Card(
                  color: PanganKitaColors.surfaceWarm,
                  child: Padding(
                    padding: const EdgeInsets.all(PanganKitaSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Symbols.schedule,
                              color: PanganKitaColors.brandAccent,
                              fill: 1,
                            ),
                            const SizedBox(width: PanganKitaSpacing.sm),
                            Expanded(
                              child: Text(
                                '${ReservationCopy.pickupBefore} '
                                '$pickupDeadline',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          formatRemainingTime(
                            listing.offer.pickupDeadline,
                            referenceTime,
                          ),
                        ),
                        const SizedBox(height: PanganKitaSpacing.sm),
                        LinearProgressIndicator(
                          value: _remainingFraction(reservation, referenceTime),
                          backgroundColor: PanganKitaColors.borderNeutral,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: PanganKitaSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(PanganKitaSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  ReservationCopy.ticketTitle,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        listing.merchant.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const CircleAvatar(child: Icon(Symbols.bakery_dining)),
                  ],
                ),
                const SizedBox(height: PanganKitaSpacing.md),
                Card(
                  color: PanganKitaColors.surfaceWarm,
                  child: ListTile(
                    leading: Image.asset(
                      listing.content.imageAsset,
                      width: _ticketImageWidth,
                      fit: BoxFit.cover,
                    ),
                    title: Text(listing.name),
                    subtitle: Text('${reservation.quantity} paket'),
                  ),
                ),
                const SizedBox(height: PanganKitaSpacing.lg),
                const Text(
                  ReservationCopy.pickupCode,
                  textAlign: TextAlign.center,
                ),
                SelectableText(
                  reservation.pickupCode,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: PanganKitaColors.brandPrimaryStrong,
                    letterSpacing: _pickupCodeLetterSpacing,
                  ),
                ),
                const SizedBox(height: PanganKitaSpacing.sm),
                const Icon(
                  Symbols.qr_code_2,
                  size: _qrVisualSize,
                  semanticLabel: ReservationCopy.qrVisual,
                ),
                const Text(
                  ReservationCopy.qrVisual,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: PanganKitaSpacing.sm),
                const Text(
                  ReservationCopy.codeNotice,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: PanganKitaSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(PanganKitaSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ReservationCopy.amountDue,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  formatRupiah(reservation.amountDueRupiah),
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(color: PanganKitaColors.brandPrimaryStrong),
                ),
                const Divider(),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Symbols.payments,
                      color: PanganKitaColors.brandPrimary,
                    ),
                    SizedBox(width: PanganKitaSpacing.sm),
                    Expanded(child: Text(ReservationCopy.payment)),
                  ],
                ),
                const SizedBox(height: PanganKitaSpacing.sm),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Symbols.info, color: PanganKitaColors.brandAccent),
                    SizedBox(width: PanganKitaSpacing.sm),
                    Expanded(child: Text(ReservationCopy.instruction)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: PanganKitaSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(PanganKitaSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Symbols.storefront,
                      color: PanganKitaColors.brandPrimary,
                    ),
                    const SizedBox(width: PanganKitaSpacing.sm),
                    Text(
                      ReservationCopy.pickupPlace,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: PanganKitaSpacing.sm),
                Text(listing.merchant.pickupAddress),
                const SizedBox(height: PanganKitaSpacing.md),
                Container(
                  height: _mapPlaceholderHeight,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: PanganKitaColors.borderNeutral,
                    borderRadius: BorderRadius.all(
                      Radius.circular(PanganKitaRadii.control),
                    ),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.pin_drop,
                        color: PanganKitaColors.brandPrimary,
                      ),
                      SizedBox(height: PanganKitaSpacing.xs),
                      Text(ReservationCopy.mapUnavailable),
                    ],
                  ),
                ),
                const SizedBox(height: PanganKitaSpacing.sm),
                Wrap(
                  spacing: PanganKitaSpacing.sm,
                  runSpacing: PanganKitaSpacing.xs,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text(
                                ReservationCopy.mapActionUnavailable,
                              ),
                            ),
                          ),
                      icon: const Icon(Symbols.directions),
                      label: const Text(ReservationCopy.openMap),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text(ReservationCopy.contactUnavailable),
                            ),
                          ),
                      icon: const Icon(Symbols.call),
                      label: const Text(ReservationCopy.contactSeller),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: PanganKitaSpacing.sm),
        const Card(
          child: ListTile(
            leading: Icon(Symbols.info),
            title: Text(ReservationCopy.pickupNoteTitle),
            subtitle: Text(ReservationCopy.instruction),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Symbols.help_outline),
            title: Text(ReservationCopy.helpTitle),
            subtitle: Text(ReservationCopy.helpUnavailable),
          ),
        ),
        const SizedBox(height: PanganKitaSpacing.sm),
        const Text(ReservationCopy.demoNotice, textAlign: TextAlign.center),
      ],
    );
  }

  double _remainingFraction(Reservation reservation, DateTime now) {
    final window = reservation.listing.offer.pickupDeadline
        .difference(reservation.createdAt)
        .inSeconds;
    if (window <= 0) return 0;
    return (reservation.listing.offer.pickupDeadline.difference(now).inSeconds /
            window)
        .clamp(0, 1);
  }
}

class _CancellationAction extends StatelessWidget {
  const new({
    required this.status,
    required this.onCancel,
    required this.saving,
  });

  final ReservationStatus status;
  final bool saving;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    if (status != ReservationStatus.reserved) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: PanganKitaSpacing.lg),
        OutlinedButton.icon(
          key: const Key('cancel-reservation'),
          onPressed: saving ? null : onCancel,
          icon: const Icon(Symbols.cancel),
          label: const Text(ReservationCopy.cancel),
        ),
      ],
    );
  }
}
