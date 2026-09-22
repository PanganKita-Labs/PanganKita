import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/business/presentation/business_copy.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/domain/listing_repository.dart';
import 'package:pangankita/features/discovery/presentation/discovery_format.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';
import 'package:pangankita/features/reservations/domain/reservation_repository.dart';

/// Local listing status and permitted merchant management actions.
class BusinessListingDetailPage extends StatefulWidget {
  /// Creates a merchant listing detail route.
  const new({
    required this.listingId,
    required this.merchantId,
    required this.listings,
    required this.reservations,
    required this.onChanged,
    super.key,
  });

  /// Selected local listing.
  final String listingId;

  /// Fictional merchant scope, not a security boundary.
  final String merchantId;

  /// Shared listing state.
  final ListingRepository listings;

  /// Shared reservation state.
  final ReservationRepository reservations;

  /// Refreshes the shell after a successful mutation.
  final VoidCallback onChanged;

  @override
  State<BusinessListingDetailPage> createState() =>
      _BusinessListingDetailPageState();
}

typedef _ListingDetails = ({Listing? listing, List<Reservation> reservations});

class _BusinessListingDetailPageState extends State<BusinessListingDetailPage> {
  Future<_ListingDetails>? _future;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_ListingDetails> _load() async {
    final listing = await widget.listings.getListing(widget.listingId);
    final reservations = await widget.reservations.loadMerchantReservations(
      widget.merchantId,
    );
    return (
      listing: listing?.merchant.id == widget.merchantId ? listing : null,
      reservations: reservations
          .where((item) => item.listing.id == widget.listingId)
          .toList(),
    );
  }

  Future<void> _apply(Future<Listing> Function() action) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final updated = await action();
      if (!mounted) return;
      final reservations = await widget.reservations.loadMerchantReservations(
        widget.merchantId,
      );
      if (!mounted) return;
      setState(() {
        _saving = false;
        _future = Future<_ListingDetails>.value((
          listing: updated,
          reservations: reservations
              .where((item) => item.listing.id == widget.listingId)
              .toList(),
        ));
      });
      widget.onChanged();
    } on ListingException catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _future = _load();
          _error = BusinessCopy.failure(error.failure);
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

  Future<void> _changeQuantity(Listing listing) async {
    int? enteredQuantity = listing.offer.totalQuantity;
    final quantity = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(BusinessCopy.updateQuantity),
        content: TextFormField(
          initialValue: '${listing.offer.totalQuantity}',
          onChanged: (value) => enteredQuantity = int.tryParse(value),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: BusinessCopy.totalQuantity,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(BusinessCopy.keep),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, enteredQuantity),
            child: const Text(BusinessCopy.updateQuantity),
          ),
        ],
      ),
    );
    if (quantity != null && mounted) {
      await _apply(() => widget.listings.updateQuantity(listing.id, quantity));
    }
  }

  Future<void> _close(Listing listing) async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(BusinessCopy.closeQuestion),
        content: const Text(BusinessCopy.closeExplanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(BusinessCopy.keep),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(BusinessCopy.closeListing),
          ),
        ],
      ),
    );
    if (approved == true && mounted) {
      await _apply(() => widget.listings.close(listing.id));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(BusinessCopy.manageTitle)),
    body: FutureBuilder<_ListingDetails>(
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
            child: Padding(
              padding: const EdgeInsets.all(PanganKitaSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    BusinessCopy.loadError,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () => setState(() => _future = _load()),
                    child: const Text(BusinessCopy.retry),
                  ),
                ],
              ),
            ),
          );
        }
        final details = snapshot.data;
        if (details == null) {
          return const Center(child: Text(BusinessCopy.loadError));
        }
        final listing = details.listing;
        if (listing == null) {
          return const Center(child: Text(BusinessCopy.missingListing));
        }
        return _ListingDetailsBody(
          listing: listing,
          reservations: details.reservations,
          saving: _saving,
          error: _error,
          onPublish: () =>
              unawaited(_apply(() => widget.listings.publish(listing.id))),
          onQuantity: () => unawaited(_changeQuantity(listing)),
          onClose: () => unawaited(_close(listing)),
        );
      },
    ),
  );
}

class _ListingDetailsBody extends StatelessWidget {
  const new({
    required this.listing,
    required this.reservations,
    required this.saving,
    required this.onPublish,
    required this.onQuantity,
    required this.onClose,
    this.error,
  });

  final Listing listing;
  final List<Reservation> reservations;
  final bool saving;
  final VoidCallback onPublish;
  final VoidCallback onQuantity;
  final VoidCallback onClose;
  final String? error;

  static const _imageHeight = 170.0;

  @override
  Widget build(BuildContext context) {
    final active = reservations
        .where(
          (item) =>
              item.status == ReservationStatus.reserved ||
              item.status == ReservationStatus.readyForPickup,
        )
        .fold<int>(0, (sum, item) => sum + item.quantity);
    final completed = reservations
        .where((item) => item.status == ReservationStatus.completed)
        .fold<int>(0, (sum, item) => sum + item.quantity);
    final editable =
        listing.status == ListingStatus.active ||
        listing.status == ListingStatus.draft ||
        listing.status == ListingStatus.soldOut;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(PanganKitaSpacing.md),
        children: [
          Wrap(
            spacing: PanganKitaSpacing.sm,
            runSpacing: PanganKitaSpacing.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Chip(label: Text(BusinessCopy.listingStatus(listing.status))),
              Text(
                listing.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: PanganKitaSpacing.md),
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(PanganKitaRadii.card),
            ),
            child: Image.asset(
              listing.content.imageAsset,
              height: _imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: PanganKitaSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(PanganKitaSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.content.description),
                  Text(
                    formatRupiah(listing.offer.priceRupiah),
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(color: PanganKitaColors.brandPrimaryStrong),
                  ),
                  Text(
                    '${BusinessCopy.pickupDeadline}: '
                    '${formatPickupTime(listing.offer.pickupDeadline)}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: PanganKitaSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(PanganKitaSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status batch surplus',
                    style: Theme.of(context).textTheme.titleMedium,
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
                      Text(
                        '${BusinessCopy.totalQuantity}: '
                        '${listing.offer.totalQuantity}',
                      ),
                      Text(
                        '${BusinessCopy.availableQuantity}: '
                        '${listing.offer.availableQuantity}',
                      ),
                      Text('${BusinessCopy.reservedQuantity}: $active'),
                      Text('${BusinessCopy.completedQuantity}: $completed'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: PanganKitaSpacing.sm),
          const Text(BusinessCopy.demoNotice),
          if (error case final message?) ...[
            const SizedBox(height: PanganKitaSpacing.sm),
            Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (editable) ...[
            const SizedBox(height: PanganKitaSpacing.lg),
            if (listing.status == ListingStatus.draft)
              ElevatedButton.icon(
                onPressed: saving ? null : onPublish,
                icon: const Icon(Symbols.publish),
                label: const Text(BusinessCopy.publish),
              ),
            OutlinedButton.icon(
              key: const Key('update-listing-quantity'),
              onPressed: saving ? null : onQuantity,
              icon: const Icon(Symbols.tune),
              label: const Text(BusinessCopy.updateQuantity),
            ),
            TextButton.icon(
              key: const Key('close-listing'),
              onPressed: saving ? null : onClose,
              icon: const Icon(Symbols.close),
              label: const Text(BusinessCopy.closeListing),
            ),
          ],
        ],
      ),
    );
  }
}
