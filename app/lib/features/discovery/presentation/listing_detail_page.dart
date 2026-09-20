import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/domain/listing_repository.dart';
import 'package:pangankita/features/discovery/presentation/discovery_copy.dart';
import 'package:pangankita/features/discovery/presentation/discovery_format.dart';

/// Consumer detail for one listing, reloaded by its stable identifier.
class ListingDetailPage extends StatefulWidget {
  /// Creates the detail page for a selected listing.
  const new({
    required this.listingId,
    required this.listings,
    required this.referenceTime,
    required this.onReserve,
    super.key,
  });

  /// Stable identifier selected from Discover.
  final String listingId;

  /// Source used to retrieve the latest available mock snapshot.
  final ListingRepository listings;

  /// Injected time used to display the local availability boundary.
  final DateTime referenceTime;

  /// Opens a review screen without creating the reservation yet.
  final ValueChanged<Listing> onReserve;

  @override
  State<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  Future<Listing?>? _listingFuture;

  @override
  void initState() {
    super.initState();
    _listingFuture = widget.listings.getListing(widget.listingId);
  }

  @override
  void didUpdateWidget(covariant ListingDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listingId != widget.listingId ||
        oldWidget.listings != widget.listings) {
      _listingFuture = widget.listings.getListing(widget.listingId);
    }
  }

  void _retry() => setState(() {
    _listingFuture = widget.listings.getListing(widget.listingId);
  });

  @override
  Widget build(BuildContext context) => FutureBuilder<Listing?>(
    future: _listingFuture,
    builder: (context, snapshot) {
      if (!snapshot.hasData &&
          !snapshot.hasError &&
          snapshot.connectionState != ConnectionState.done) {
        return Scaffold(
          appBar: AppBar(title: const Text(DiscoveryCopy.detailTitle)),
          body: const _DetailState(
            message: DiscoveryCopy.detailLoading,
            loading: true,
          ),
        );
      }
      if (snapshot.hasError) {
        return Scaffold(
          appBar: AppBar(title: const Text(DiscoveryCopy.detailTitle)),
          body: _DetailState(
            message: DiscoveryCopy.detailError,
            onRetry: _retry,
          ),
        );
      }
      final listing = snapshot.data;
      if (listing == null) {
        return Scaffold(
          appBar: AppBar(title: const Text(DiscoveryCopy.detailTitle)),
          body: const _DetailState(message: DiscoveryCopy.missingListing),
        );
      }
      return Scaffold(
        appBar: AppBar(title: const Text(DiscoveryCopy.detailTitle)),
        body: _DetailBody(listing: listing),
        bottomNavigationBar: _ReservationBoundary(
          listing: listing,
          referenceTime: widget.referenceTime,
          onReserve: widget.onReserve,
        ),
      );
    },
  );
}

class _DetailBody extends StatelessWidget {
  const new({required this.listing});

  final Listing listing;
  static const _heroHeight = 220.0;

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      Image.asset(
        listing.content.imageAsset,
        width: double.infinity,
        height: _heroHeight,
        fit: BoxFit.cover,
        semanticLabel: DiscoveryCopy.photoOf(listing.name),
      ),
      Padding(
        padding: const EdgeInsets.all(PanganKitaSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DiscoveryCopy.illustrativePhoto,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: PanganKitaSpacing.md),
            Text(
              listing.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: PanganKitaSpacing.sm),
            Text(
              listing.content.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: PanganKitaSpacing.md),
            _ListingOverview(listing: listing),
            const SizedBox(height: PanganKitaSpacing.md),
            _PickupInformation(listing: listing),
            const SizedBox(height: PanganKitaSpacing.md),
            _SellerInformation(info: listing.content.sellerInfo),
            const SizedBox(height: PanganKitaSpacing.md),
            _PickupLocation(merchant: listing.merchant),
          ],
        ),
      ),
    ],
  );
}

class _ListingOverview extends StatelessWidget {
  const new({required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(PanganKitaSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listing.merchant.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            '${listing.merchant.area} · '
            '${formatDistance(listing.merchant.distanceMeters)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: PanganKitaSpacing.md),
          Wrap(
            spacing: PanganKitaSpacing.sm,
            runSpacing: PanganKitaSpacing.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                formatRupiah(listing.offer.priceRupiah),
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(color: PanganKitaColors.brandPrimary),
              ),
              Text(
                formatRupiah(listing.offer.originalPriceRupiah),
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(decoration: TextDecoration.lineThrough),
              ),
              Text(
                DiscoveryCopy.savings(listing.offer.savingsPercent),
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: PanganKitaColors.brandPrimaryStrong),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _PickupInformation extends StatelessWidget {
  const new({required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(PanganKitaSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DiscoveryCopy.pickupWindow,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: PanganKitaSpacing.sm),
          Text(
            '${formatPickupTime(listing.offer.pickupStartsAt)} – '
            '${formatPickupTime(listing.offer.pickupDeadline)}',
          ),
          const SizedBox(height: PanganKitaSpacing.sm),
          Row(
            children: [
              const Icon(Icons.schedule, color: PanganKitaColors.brandAccent),
              const SizedBox(width: PanganKitaSpacing.sm),
              Expanded(
                child: Text(
                  '${DiscoveryCopy.pickupBefore} '
                  '${formatPickupTime(listing.offer.pickupDeadline)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: PanganKitaSpacing.sm),
          Text(
            DiscoveryCopy.available(listing.offer.availableQuantity),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    ),
  );
}

class _SellerInformation extends StatelessWidget {
  const new({required this.info});

  final SellerFoodInfo info;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(PanganKitaSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DiscoveryCopy.sellerInformation,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            DiscoveryCopy.sellerDisclaimer,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: PanganKitaSpacing.sm),
          _SellerFact(
            label: DiscoveryCopy.surplusReason,
            value: info.surplusReason,
          ),
          _SellerFact(label: DiscoveryCopy.condition, value: info.condition),
          if (info.storage case final storage?)
            _SellerFact(label: DiscoveryCopy.storage, value: storage),
          if (info.allergens case final allergens?)
            _SellerFact(label: DiscoveryCopy.allergens, value: allergens),
        ],
      ),
    ),
  );
}

class _SellerFact extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: PanganKitaSpacing.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ),
  );
}

class _PickupLocation extends StatelessWidget {
  const new({required this.merchant});

  final ListingMerchant merchant;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(PanganKitaSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DiscoveryCopy.pickupLocation,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: PanganKitaSpacing.sm),
          Text(merchant.pickupAddress),
        ],
      ),
    ),
  );
}

class _ReservationBoundary extends StatelessWidget {
  const new({
    required this.listing,
    required this.referenceTime,
    required this.onReserve,
  });

  final Listing listing;
  final DateTime referenceTime;
  final ValueChanged<Listing> onReserve;

  @override
  Widget build(BuildContext context) {
    final available =
        listing.offer.availableQuantity > 0 &&
        listing.offer.pickupDeadline.isAfter(referenceTime);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(PanganKitaSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: available ? () => onReserve(listing) : null,
              child: Text(
                available
                    ? DiscoveryCopy.continueToReservation
                    : DiscoveryCopy.unavailable,
              ),
            ),
            const SizedBox(height: PanganKitaSpacing.sm),
            Text(
              DiscoveryCopy.payAtPickup,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailState extends StatelessWidget {
  const new({required this.message, this.onRetry, this.loading = false});

  final String message;
  final VoidCallback? onRetry;
  final bool loading;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(PanganKitaSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading) const CircularProgressIndicator(),
            if (loading) const SizedBox(height: PanganKitaSpacing.md),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: const Text(DiscoveryCopy.retry),
              ),
          ],
        ),
      ),
    ),
  );
}
