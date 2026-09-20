import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/business/presentation/business_copy.dart';
import 'package:pangankita/features/discovery/presentation/discovery_format.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';
import 'package:pangankita/features/reservations/domain/reservation_repository.dart';
import 'package:pangankita/features/reservations/presentation/reservation_copy.dart';

/// Merchant view and code-based completion of one local reservation.
class BusinessReservationDetailPage extends StatefulWidget {
  /// Creates the merchant reservation detail route.
  const new({
    required this.reservationId,
    required this.merchantId,
    required this.reservations,
    required this.onChanged,
    super.key,
  });

  /// Selected local reservation.
  final String reservationId;

  /// Fictional merchant scope, not authentication.
  final String merchantId;

  /// Shared reservation state.
  final ReservationRepository reservations;

  /// Refreshes both roles after a successful change.
  final VoidCallback onChanged;

  @override
  State<BusinessReservationDetailPage> createState() =>
      _BusinessReservationDetailPageState();
}

class _BusinessReservationDetailPageState
    extends State<BusinessReservationDetailPage> {
  final _code = TextEditingController();
  Future<Reservation?>? _future;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<Reservation?> _load() => widget.reservations.getMerchantReservation(
    widget.reservationId,
    widget.merchantId,
  );

  Future<void> _apply(Future<Reservation> Function() action) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final reservation = await action();
      if (!mounted) return;
      setState(() {
        _saving = false;
        _future = Future<Reservation>.value(reservation);
      });
      widget.onChanged();
    } on ReservationException catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _future = _load();
          _error = ReservationCopy.failure(error.failure);
        });
      }
    } on Exception {
      if (mounted) {
        setState(() {
          _saving = false;
          _future = _load();
          _error = BusinessCopy.actionError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(BusinessCopy.reservationTitle)),
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
            child: TextButton(
              onPressed: () => setState(() => _future = _load()),
              child: const Text(BusinessCopy.retry),
            ),
          );
        }
        final reservation = snapshot.data;
        if (reservation == null) {
          return const Center(child: Text(BusinessCopy.missingReservation));
        }
        return _ReservationDetails(
          reservation: reservation,
          code: _code,
          saving: _saving,
          error: _error,
          onReady: () => unawaited(
            _apply(() => widget.reservations.markReady(reservation.id)),
          ),
          onVerify: () => unawaited(
            _apply(
              () => widget.reservations.verifyPickup(
                reservation.id,
                widget.merchantId,
                _code.text,
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _ReservationDetails extends StatelessWidget {
  const new({
    required this.reservation,
    required this.code,
    required this.saving,
    required this.onReady,
    required this.onVerify,
    this.error,
  });

  final Reservation reservation;
  final TextEditingController code;
  final bool saving;
  final VoidCallback onReady;
  final VoidCallback onVerify;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final listing = reservation.listing;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(PanganKitaSpacing.md),
        children: [
          Text(
            ReservationCopy.status(reservation.status),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Text(BusinessCopy.demoNotice),
          const SizedBox(height: PanganKitaSpacing.md),
          Text(
            '${ReservationCopy.pickupBefore} '
            '${formatPickupTime(listing.offer.pickupDeadline)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(listing.name, style: Theme.of(context).textTheme.headlineSmall),
          Text('${reservation.quantity} paket · ${reservation.id}'),
          Text(listing.merchant.name),
          Text(listing.merchant.pickupAddress),
          const SizedBox(height: PanganKitaSpacing.md),
          Text(
            '${ReservationCopy.amountDue}: '
            '${formatRupiah(reservation.amountDueRupiah)}',
          ),
          const Text(ReservationCopy.payment),
          const SizedBox(height: PanganKitaSpacing.md),
          const Text(BusinessCopy.codeNotice),
          if (error case final message?) ...[
            const SizedBox(height: PanganKitaSpacing.sm),
            Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (reservation.status == ReservationStatus.reserved) ...[
            const SizedBox(height: PanganKitaSpacing.lg),
            ElevatedButton(
              onPressed: saving ? null : onReady,
              child: const Text(BusinessCopy.markReady),
            ),
          ],
          if (reservation.status == ReservationStatus.readyForPickup) ...[
            TextField(
              controller: code,
              decoration: const InputDecoration(
                labelText: BusinessCopy.pickupCode,
              ),
              textCapitalization: TextCapitalization.characters,
              autocorrect: false,
            ),
            const SizedBox(height: PanganKitaSpacing.md),
            ElevatedButton(
              onPressed: saving ? null : onVerify,
              child: const Text(BusinessCopy.verifyPickup),
            ),
          ],
        ],
      ),
    );
  }
}
