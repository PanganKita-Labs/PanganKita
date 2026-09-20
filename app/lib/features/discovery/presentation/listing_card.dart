import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/presentation/discovery_copy.dart';
import 'package:pangankita/features/discovery/presentation/discovery_format.dart';

/// Compact listing summary for the consumer Discover feed.
class ListingCard extends StatelessWidget {
  /// Creates a tappable listing summary.
  const new({required this.listing, required this.onTap, super.key});

  /// Listing snapshot displayed by the card.
  final Listing listing;

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
            Row(
              children: [
                const Icon(
                  Icons.schedule,
                  size: 18,
                  color: PanganKitaColors.brandAccent,
                ),
                const SizedBox(width: PanganKitaSpacing.sm),
                Expanded(
                  child: Text(
                    '${DiscoveryCopy.pickupBefore} '
                    '${formatPickupTime(listing.offer.pickupDeadline)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: PanganKitaSpacing.sm),
            Wrap(
              spacing: PanganKitaSpacing.md,
              runSpacing: PanganKitaSpacing.sm,
              children: [
                Text(
                  '${listing.merchant.area} · '
                  '${formatDistance(listing.merchant.distanceMeters)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  DiscoveryCopy.available(listing.offer.availableQuantity),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _ListingSummary extends StatelessWidget {
  const new({required this.listing});

  final Listing listing;
  static const _photoSize = 96.0;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(PanganKitaRadii.control),
        ),
        child: SizedBox.square(
          dimension: _photoSize,
          child: Image.asset(
            listing.content.imageAsset,
            fit: BoxFit.cover,
            semanticLabel: DiscoveryCopy.photoOf(listing.name),
          ),
        ),
      ),
      const SizedBox(width: PanganKitaSpacing.sm),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listing.merchant.name,
              style: Theme.of(context).textTheme.bodySmall,
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
