import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/presentation/discovery_format.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';
import 'package:pangankita/features/reservations/domain/reservation_repository.dart';
import 'package:pangankita/features/reservations/presentation/reservation_copy.dart';

/// Review and confirm one local-only reservation.
class ReservationConfirmationPage extends StatefulWidget {
  /// Creates the confirmation page for a selected listing.
  const new({
    required this.listing,
    required this.reservations,
    required this.onCreated,
    super.key,
  });

  /// Listing snapshot selected from discovery.
  final Listing listing;

  /// Local reservation operations.
  final ReservationRepository reservations;

  /// Called after a reservation is successfully created.
  final ValueChanged<Reservation> onCreated;

  @override
  State<ReservationConfirmationPage> createState() =>
      _ReservationConfirmationPageState();
}

class _ReservationConfirmationPageState
    extends State<ReservationConfirmationPage> {
  static const _minimumQuantity = 1;

  int _quantity = _minimumQuantity;
  bool _saving = false;
  String? _error;

  Future<void> _confirm() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final reservation = await widget.reservations.create(
        widget.listing.id,
        _quantity,
      );
      if (mounted) widget.onCreated(reservation);
    } on ReservationException catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = ReservationCopy.failure(error.failure);
      });
    } on Exception {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = ReservationCopy.createError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Symbols.arrow_back),
        ),
        title: const Text(ReservationCopy.confirmationTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PanganKitaSpacing.md),
          children: [
            const Text(ReservationCopy.demoNotice),
            const SizedBox(height: PanganKitaSpacing.md),
            Text(
              listing.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(listing.merchant.name),
            const SizedBox(height: PanganKitaSpacing.md),
            _QuantitySelector(
              quantity: _quantity,
              maximum: listing.offer.availableQuantity,
              onChanged: (value) => setState(() => _quantity = value),
            ),
            const SizedBox(height: PanganKitaSpacing.md),
            _ReviewFacts(listing: listing, quantity: _quantity),
            if (_error case final error?) ...[
              const SizedBox(height: PanganKitaSpacing.sm),
              Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PanganKitaSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : () => unawaited(_confirm()),
              icon: const Icon(Symbols.check),
              label: Text(
                _saving ? ReservationCopy.saving : ReservationCopy.confirm,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const new({
    required this.quantity,
    required this.maximum,
    required this.onChanged,
  });

  final int quantity;
  final int maximum;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        ReservationCopy.quantity,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Row(
        children: [
          IconButton(
            onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
            tooltip: ReservationCopy.decreaseQuantity,
            icon: const Icon(Symbols.remove),
          ),
          Text('$quantity'),
          IconButton(
            onPressed: quantity < maximum
                ? () => onChanged(quantity + 1)
                : null,
            tooltip: ReservationCopy.increaseQuantity,
            icon: const Icon(Symbols.add),
          ),
          Flexible(
            child: Text(
              ReservationCopy.maximumQuantity(maximum),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    ],
  );
}

class _ReviewFacts extends StatelessWidget {
  const new({required this.listing, required this.quantity});

  final Listing listing;
  final int quantity;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        ReservationCopy.amountDue,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Text(
        formatRupiah(quantity * listing.offer.priceRupiah),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: PanganKitaSpacing.md),
      Text(
        ReservationCopy.pickupPlace,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Text(listing.merchant.pickupAddress),
      const SizedBox(height: PanganKitaSpacing.md),
      Text(
        ReservationCopy.pickupWindow,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Text(
        '${formatPickupTime(listing.offer.pickupStartsAt)} – '
        '${formatPickupTime(listing.offer.pickupDeadline)}',
      ),
      const SizedBox(height: PanganKitaSpacing.md),
      const Text(ReservationCopy.payment),
      const SizedBox(height: PanganKitaSpacing.sm),
      const Text(ReservationCopy.cancellationRule),
    ],
  );
}
