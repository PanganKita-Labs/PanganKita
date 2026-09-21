import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/presentation/discovery_copy.dart';
import 'package:pangankita/features/discovery/presentation/discovery_format.dart';

/// Compact listing summary for the consumer Discover feed.
class ListingCard extends StatelessWidget {
  /// Creates a tappable listing summary.
  const new({
    required this.listing,
    required this.referenceTime,
    required this.onTap,
    super.key,
  });

  /// Listing snapshot displayed by the card.
  final Listing listing;

  /// Same injected clock used to group the Discover feed.
  final DateTime referenceTime;

  /// Opens the selected listing's current detail.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(PanganKitaSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ListingSummary(listing: listing),
            const SizedBox(height: PanganKitaSpacing.sm),
            const Divider(height: 1),
            const SizedBox(height: PanganKitaSpacing.sm),
            _ListingMetadata(listing: listing, referenceTime: referenceTime),
          ],
        ),
      ),
    ),
  );
}

class _ListingMetadata extends StatelessWidget {
  const new({required this.listing, required this.referenceTime});

  static const _iconSize = 18.0;

  final Listing listing;
  final DateTime referenceTime;

  @override
  Widget build(BuildContext context) {
    final deadline = listing.offer.pickupDeadline;
    final remainingTime = formatRemainingTime(deadline, referenceTime);
    return Wrap(
      spacing: PanganKitaSpacing.sm,
      runSpacing: PanganKitaSpacing.md,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(
          Symbols.schedule,
          size: _iconSize,
          color: deadline.difference(referenceTime) <= const Duration(hours: 1)
              ? PanganKitaColors.brandAccent
              : PanganKitaColors.brandPrimary,
        ),
        Text(
          '${DiscoveryCopy.pickupBefore} '
          '${formatPickupTime(deadline)} · '
          '$remainingTime',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Icon(
          Symbols.near_me,
          size: _iconSize,
          color: PanganKitaColors.brandPrimary,
        ),
        Text(
          '${listing.merchant.area} · '
          '${formatDistance(listing.merchant.distanceMeters)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        DecoratedBox(
          decoration: const BoxDecoration(
            color: PanganKitaColors.urgencySurface,
            borderRadius: BorderRadius.all(
              Radius.circular(PanganKitaRadii.control),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PanganKitaSpacing.sm,
              vertical: PanganKitaSpacing.xs,
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: PanganKitaSpacing.xs,
              children: [
                const Icon(
                  Symbols.takeout_dining,
                  size: 16,
                  color: PanganKitaColors.brandAccent,
                ),
                Text(
                  DiscoveryCopy.remaining(listing.offer.availableQuantity),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ListingSummary extends StatelessWidget {
  const new({required this.listing});

  final Listing listing;
  static const _photoSize = 104.0;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox.square(
        dimension: _photoSize,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(PanganKitaRadii.control),
                ),
                child: Image.asset(
                  listing.content.imageAsset,
                  fit: BoxFit.cover,
                  semanticLabel: DiscoveryCopy.photoOf(listing.name),
                ),
              ),
            ),
            if (listing.offer.savingsPercent > 0)
              Positioned(
                top: PanganKitaSpacing.xs,
                left: PanganKitaSpacing.sm,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: PanganKitaColors.savingsSurface,
                    borderRadius: BorderRadius.all(
                      Radius.circular(PanganKitaRadii.control),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PanganKitaSpacing.xs,
                    ),
                    child: Text(
                      DiscoveryCopy.savings(listing.offer.savingsPercent),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: PanganKitaColors.brandPrimaryStrong,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(width: PanganKitaSpacing.sm),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listing.merchant.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(listing.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: PanganKitaSpacing.sm),
            Wrap(
              spacing: PanganKitaSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  formatRupiah(listing.offer.priceRupiah),
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(color: PanganKitaColors.brandPrimary),
                ),
                Text(
                  formatRupiah(listing.offer.originalPriceRupiah),
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(decoration: TextDecoration.lineThrough),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
