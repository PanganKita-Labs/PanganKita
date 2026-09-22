import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
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
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Symbols.arrow_back),
            ),
            title: const Text(DiscoveryCopy.detailTitle),
          ),
          body: const _DetailState(
            message: DiscoveryCopy.detailLoading,
            loading: true,
          ),
        );
      }
      if (snapshot.hasError) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Symbols.arrow_back),
            ),
            title: const Text(DiscoveryCopy.detailTitle),
          ),
          body: _DetailState(
            message: DiscoveryCopy.detailError,
            onRetry: _retry,
          ),
        );
      }
      final listing = snapshot.data;
      if (listing == null) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Symbols.arrow_back),
            ),
            title: const Text(DiscoveryCopy.detailTitle),
          ),
          body: const _DetailState(message: DiscoveryCopy.missingListing),
        );
      }
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Symbols.arrow_back),
          ),
          title: const Text(DiscoveryCopy.detailTitle),
          actions: [
            IconButton(
              tooltip: DiscoveryCopy.saveListing,
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(DiscoveryCopy.saveUnavailable)),
              ),
              icon: const Icon(Symbols.bookmark),
            ),
            const Padding(
              padding: EdgeInsets.only(right: PanganKitaSpacing.sm),
              child: CircleAvatar(
                backgroundColor: PanganKitaColors.brandPrimary,
                child: Icon(Symbols.person, color: Colors.white, fill: 1),
              ),
            ),
          ],
        ),
        body: _DetailBody(
          listing: listing,
          referenceTime: widget.referenceTime,
        ),
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
  const new({required this.listing, required this.referenceTime});

  final Listing listing;
  final DateTime referenceTime;
  static const _heroHeight = 280.0;
  static const double _heroHorizontalInset = PanganKitaSpacing.md;

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      SizedBox(
        height: _heroHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              listing.content.imageAsset,
              fit: BoxFit.cover,
              semanticLabel: DiscoveryCopy.photoOf(listing.name),
            ),
            Positioned(
              top: PanganKitaSpacing.md,
              left: _heroHorizontalInset,
              child: Chip(
                avatar: const Icon(Symbols.eco, size: 18, fill: 1),
                label: Text(
                  DiscoveryCopy.savings(listing.offer.savingsPercent),
                ),
                backgroundColor: PanganKitaColors.savingsSurface,
              ),
            ),
            Positioned(
              top: PanganKitaSpacing.md,
              right: _heroHorizontalInset,
              child: Chip(
                avatar: const Icon(
                  Symbols.local_fire_department,
                  size: 18,
                  color: PanganKitaColors.brandAccent,
                  fill: 1,
                ),
                label: Text(
                  DiscoveryCopy.available(listing.offer.availableQuantity),
                ),
              ),
            ),
          ],
        ),
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
            _ListingOverview(listing: listing),
            const SizedBox(height: PanganKitaSpacing.md),
            _FoodSummary(listing: listing),
            const SizedBox(height: PanganKitaSpacing.md),
            _PickupInformation(listing: listing, referenceTime: referenceTime),
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
          Row(
            children: [
              const CircleAvatar(child: Icon(Symbols.storefront)),
              const SizedBox(width: PanganKitaSpacing.sm),
              Expanded(
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
                  ],
                ),
              ),
              const Icon(Symbols.near_me, color: PanganKitaColors.brandPrimary),
            ],
          ),
        ],
      ),
    ),
  );
}

class _FoodSummary extends StatelessWidget {
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
          Text(listing.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: PanganKitaSpacing.sm),
          Text(listing.content.description),
          const SizedBox(height: PanganKitaSpacing.md),
          Wrap(
            spacing: PanganKitaSpacing.sm,
            runSpacing: PanganKitaSpacing.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                formatRupiah(listing.offer.priceRupiah),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: PanganKitaColors.brandPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                formatRupiah(listing.offer.originalPriceRupiah),
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(decoration: TextDecoration.lineThrough),
              ),
              Chip(
                label: Text(
                  DiscoveryCopy.savings(listing.offer.savingsPercent),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _PickupInformation extends StatelessWidget {
  const new({required this.listing, required this.referenceTime});

  final Listing listing;
  final DateTime referenceTime;

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
              const Icon(
                Symbols.schedule,
                color: PanganKitaColors.brandAccent,
                fill: 1,
              ),
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
          const SizedBox(height: PanganKitaSpacing.sm),
          LinearProgressIndicator(
            value: listing.offer.totalQuantity == 0
                ? 0
                : listing.offer.availableQuantity / listing.offer.totalQuantity,
            backgroundColor: PanganKitaColors.borderNeutral,
          ),
          const SizedBox(height: PanganKitaSpacing.sm),
          Text(
            formatRemainingTime(listing.offer.pickupDeadline, referenceTime),
          ),
          const SizedBox(height: PanganKitaSpacing.sm),
          const Text(DiscoveryCopy.pickupDeadlineNotice),
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
          Row(
            children: [
              const Icon(Symbols.info, color: PanganKitaColors.brandPrimary),
              const SizedBox(width: PanganKitaSpacing.sm),
              Expanded(
                child: Text(
                  DiscoveryCopy.sellerInformation,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          Text(
            DiscoveryCopy.sellerDisclaimer,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: PanganKitaSpacing.sm),
          _SellerFact(
            icon: Symbols.inventory_2,
            label: DiscoveryCopy.surplusReason,
            value: info.surplusReason,
          ),
          _SellerFact(
            icon: Symbols.task_alt,
            label: DiscoveryCopy.condition,
            value: info.condition,
          ),
          if (info.storage case final storage?)
            _SellerFact(
              icon: Symbols.restaurant,
              label: DiscoveryCopy.storage,
              value: storage,
            ),
          if (info.allergens case final allergens?)
            _SellerFact(
              icon: Symbols.warning,
              label: DiscoveryCopy.allergens,
              value: allergens,
            ),
          const _SellerFact(
            icon: Symbols.assignment,
            label: DiscoveryCopy.sellerDeclaration,
            value: DiscoveryCopy.sellerDisclaimer,
          ),
        ],
      ),
    ),
  );
}

class _SellerFact extends StatelessWidget {
  const new({required this.icon, required this.label, required this.value});

  static const _iconSize = 16.0;

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: PanganKitaSpacing.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: PanganKitaColors.surfaceWarm,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(PanganKitaSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: _iconSize),
                    const SizedBox(width: PanganKitaSpacing.sm),
                    Expanded(
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PanganKitaSpacing.sm),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _PickupLocation extends StatelessWidget {
  const new({required this.merchant});

  static const _mapPlaceholderHeight = 132.0;

  final ListingMerchant merchant;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(PanganKitaSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Symbols.pin_drop,
                color: PanganKitaColors.brandPrimary,
              ),
              const SizedBox(width: PanganKitaSpacing.sm),
              Text(
                DiscoveryCopy.pickupLocation,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: PanganKitaSpacing.sm),
          Text(merchant.pickupAddress),
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
                Icon(Symbols.store, color: PanganKitaColors.brandPrimary),
                SizedBox(height: PanganKitaSpacing.xs),
                Text(DiscoveryCopy.mapPlaceholder),
              ],
            ),
          ),
          const SizedBox(height: PanganKitaSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(DiscoveryCopy.mapActionUnavailable)),
            ),
            icon: const Icon(Symbols.near_me),
            label: const Text(DiscoveryCopy.pickupLocation),
          ),
          const SizedBox(height: PanganKitaSpacing.sm),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Symbols.shopping_bag, color: PanganKitaColors.brandPrimary),
              SizedBox(width: PanganKitaSpacing.sm),
              Expanded(child: Text(DiscoveryCopy.pickupGuidance)),
            ],
          ),
          TextButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(DiscoveryCopy.reportUnavailable)),
            ),
            icon: const Icon(Symbols.flag),
            label: const Text(DiscoveryCopy.reportListing),
          ),
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
        listing.status == ListingStatus.active &&
        listing.offer.availableQuantity > 0 &&
        listing.offer.pickupDeadline.isAfter(referenceTime);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(PanganKitaSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(DiscoveryCopy.totalPayment),
                  Text(
                    formatRupiah(listing.offer.priceRupiah),
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(color: PanganKitaColors.brandPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PanganKitaSpacing.sm),
            ElevatedButton.icon(
              onPressed: available ? () => onReserve(listing) : null,
              icon: const Icon(Symbols.lock),
              label: Text(
                available
                    ? DiscoveryCopy.continueToReservation
                    : DiscoveryCopy.unavailable,
              ),
            ),
            const SizedBox(height: PanganKitaSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Symbols.shield, size: 16),
                const SizedBox(width: PanganKitaSpacing.xs),
                Flexible(
                  child: Text(
                    DiscoveryCopy.payAtPickup,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
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
