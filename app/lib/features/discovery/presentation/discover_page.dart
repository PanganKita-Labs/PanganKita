import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/domain/discover_listings.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/domain/listing_repository.dart';
import 'package:pangankita/features/discovery/presentation/discovery_copy.dart';
import 'package:pangankita/features/discovery/presentation/listing_card.dart';

/// Consumer feed backed only by the injected listing repository.
class DiscoverPage extends StatefulWidget {
  /// Creates the Discover page for a selected prototype area.
  const new({
    required this.listings,
    required this.referenceTime,
    required this.areaName,
    required this.onOpenListing,
    super.key,
  });

  /// Source of listing snapshots.
  final ListingRepository listings;

  /// Injected time used for deterministic discovery grouping.
  final DateTime referenceTime;

  /// Fixed prototype area, without device location access.
  final String areaName;

  /// Opens the selected listing by identifier.
  final ValueChanged<String> onOpenListing;

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final _searchController = TextEditingController();
  Future<List<Listing>>? _listingsFuture;
  String _query = '';
  ListingCategory? _category;

  @override
  void initState() {
    super.initState();
    _listingsFuture = widget.listings.loadListings();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _retry() => setState(() {
    _listingsFuture = widget.listings.loadListings();
  });

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _category = null;
    });
  }

  void _selectCategory(ListingCategory? category) => setState(() {
    _category = category;
  });

  void _unavailable(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(PanganKitaSpacing.md),
      children: [
        _DiscoverHeader(areaName: widget.areaName, onUnavailable: _unavailable),
        const SizedBox(height: PanganKitaSpacing.md),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  labelText: DiscoveryCopy.searchLabel,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: DiscoveryCopy.searchHint,
                  prefixIcon: Icon(Symbols.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(PanganKitaRadii.control),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: PanganKitaSpacing.sm),
            IconButton.filled(
              tooltip: DiscoveryCopy.moreFilters,
              onPressed: () => _unavailable(DiscoveryCopy.filtersUnavailable),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: PanganKitaColors.textPrimary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(PanganKitaRadii.control),
                  ),
                ),
              ),
              icon: const Icon(Symbols.tune),
            ),
          ],
        ),
        const SizedBox(height: PanganKitaSpacing.md),
        _CategoryFilters(selected: _category, onSelected: _selectCategory),
        const SizedBox(height: PanganKitaSpacing.lg),
        _DiscoverResults(
          future: _listingsFuture,
          referenceTime: widget.referenceTime,
          query: _query,
          category: _category,
          onOpenListing: widget.onOpenListing,
          onRetry: _retry,
          onClearFilters: _clearFilters,
          onOpenMap: () => _unavailable(DiscoveryCopy.mapUnavailable),
        ),
      ],
    ),
  );
}

class _DiscoverHeader extends StatelessWidget {
  const new({required this.areaName, required this.onUnavailable});

  final String areaName;
  final ValueChanged<String> onUnavailable;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DecoratedBox(
        decoration: const BoxDecoration(
          color: PanganKitaColors.surfaceContainerLow,
          borderRadius: BorderRadius.all(Radius.circular(PanganKitaRadii.card)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(PanganKitaSpacing.md),
          child: Row(
            children: [
              const Icon(
                Symbols.location_on,
                color: PanganKitaColors.brandPrimary,
              ),
              const SizedBox(width: PanganKitaSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DiscoveryCopy.areaLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      areaName,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () =>
                    onUnavailable(DiscoveryCopy.locationUnavailable),
                icon: const Text(DiscoveryCopy.changeArea),
                label: const Icon(Symbols.tune, size: 16),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: PanganKitaSpacing.lg),
      Text(
        DiscoveryCopy.discoverTitle,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: PanganKitaColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: PanganKitaSpacing.sm),
      Text(
        DiscoveryCopy.discoverSubtitle,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ],
  );
}

class _CategoryFilters extends StatelessWidget {
  const new({required this.selected, required this.onSelected});

  final ListingCategory? selected;
  final ValueChanged<ListingCategory?> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        ChoiceChip(
          label: const Text(DiscoveryCopy.allCategories),
          selected: selected == null,
          showCheckmark: false,
          selectedColor: PanganKitaColors.brandPrimaryStrong,
          side: BorderSide.none,
          shape: const StadiumBorder(),
          labelStyle: TextStyle(
            color: selected == null
                ? Colors.white
                : PanganKitaColors.textPrimary,
          ),
          backgroundColor: Colors.white,
          onSelected: (_) => onSelected(null),
        ),
        for (final category in ListingCategory.values) ...[
          const SizedBox(width: PanganKitaSpacing.sm),
          ChoiceChip(
            label: Text(DiscoveryCopy.category(category)),
            selected: selected == category,
            showCheckmark: false,
            selectedColor: PanganKitaColors.brandPrimaryStrong,
            side: BorderSide.none,
            shape: const StadiumBorder(),
            labelStyle: TextStyle(
              color: selected == category
                  ? Colors.white
                  : PanganKitaColors.textPrimary,
            ),
            backgroundColor: Colors.white,
            onSelected: (_) => onSelected(category),
          ),
        ],
        const SizedBox(width: PanganKitaSpacing.sm),
        const ChoiceChip(
          label: Text(DiscoveryCopy.unsupportedCategoryCoffee),
          selected: false,
          side: BorderSide.none,
          shape: StadiumBorder(),
        ),
        const SizedBox(width: PanganKitaSpacing.sm),
        const ChoiceChip(
          label: Text(DiscoveryCopy.unsupportedCategoryHealthy),
          selected: false,
          side: BorderSide.none,
          shape: StadiumBorder(),
        ),
      ],
    ),
  );
}

class _DiscoverResults extends StatelessWidget {
  const new({
    required this.future,
    required this.referenceTime,
    required this.query,
    required this.category,
    required this.onOpenListing,
    required this.onRetry,
    required this.onClearFilters,
    required this.onOpenMap,
  });

  final Future<List<Listing>>? future;
  final DateTime referenceTime;
  final String query;
  final ListingCategory? category;
  final ValueChanged<String> onOpenListing;
  final VoidCallback onRetry;
  final VoidCallback onClearFilters;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Listing>>(
    future: future,
    builder: (context, snapshot) {
      if (!snapshot.hasData && !snapshot.hasError) {
        return const _DiscoverState(
          message: DiscoveryCopy.loading,
          loading: true,
        );
      }
      if (snapshot.hasError) {
        return _DiscoverState(
          message: DiscoveryCopy.loadError,
          actionLabel: DiscoveryCopy.retry,
          onAction: onRetry,
        );
      }
      final sections = discoverListings(
        snapshot.data ?? [],
        now: referenceTime,
        query: query,
        category: category,
      );
      if (sections.urgent.isEmpty && sections.nearby.isEmpty) {
        return _DiscoverState(
          message: DiscoveryCopy.empty,
          actionLabel: DiscoveryCopy.clearFilters,
          onAction: onClearFilters,
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LocalContextStrip(),
          const SizedBox(height: PanganKitaSpacing.lg),
          if (sections.urgent.isNotEmpty)
            _ListingSection(
              title: DiscoveryCopy.urgentTitle,
              icon: Symbols.bolt,
              iconColor: PanganKitaColors.brandAccent,
              referenceTime: referenceTime,
              listings: sections.urgent,
              onOpenListing: onOpenListing,
            ),
          if (sections.urgent.isNotEmpty && sections.nearby.isNotEmpty)
            const _PickupTip(),
          if (sections.nearby.isNotEmpty)
            _ListingSection(
              title: DiscoveryCopy.nearbyTitle,
              icon: Symbols.explore,
              iconColor: PanganKitaColors.brandPrimary,
              referenceTime: referenceTime,
              listings: sections.nearby,
              onOpenListing: onOpenListing,
            ),
          const SizedBox(height: PanganKitaSpacing.md),
          _MapPromo(onOpen: onOpenMap),
        ],
      );
    },
  );
}

class _LocalContextStrip extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Card(
    color: PanganKitaColors.savingsSurface,
    child: Padding(
      padding: const EdgeInsets.all(PanganKitaSpacing.md),
      child: Row(
        children: [
          const Icon(Symbols.eco, color: PanganKitaColors.brandPrimaryStrong),
          const SizedBox(width: PanganKitaSpacing.sm),
          Expanded(
            child: Text(
              DiscoveryCopy.localContext,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const Icon(Symbols.chevron_right),
        ],
      ),
    ),
  );
}

class _MapPromo extends StatelessWidget {
  const new({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(PanganKitaSpacing.md),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: PanganKitaColors.savingsSurface,
            child: Icon(
              Symbols.map,
              color: PanganKitaColors.brandPrimaryStrong,
            ),
          ),
          const SizedBox(width: PanganKitaSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DiscoveryCopy.mapTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Text(DiscoveryCopy.mapSubtitle),
              ],
            ),
          ),
          TextButton(
            onPressed: onOpen,
            child: const Text(DiscoveryCopy.openMap),
          ),
        ],
      ),
    ),
  );
}

class _ListingSection extends StatelessWidget {
  const new({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.referenceTime,
    required this.listings,
    required this.onOpenListing,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final DateTime referenceTime;
  final List<Listing> listings;
  final ValueChanged<String> onOpenListing;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: PanganKitaSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ],
      ),
      const SizedBox(height: PanganKitaSpacing.sm),
      for (final listing in listings) ...[
        ListingCard(
          listing: listing,
          referenceTime: referenceTime,
          onTap: () => onOpenListing(listing.id),
        ),
        const SizedBox(height: PanganKitaSpacing.sm),
      ],
    ],
  );
}

class _PickupTip extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: PanganKitaSpacing.md),
    child: DecoratedBox(
      decoration: const BoxDecoration(
        color: PanganKitaColors.borderNeutral,
        borderRadius: BorderRadius.all(Radius.circular(PanganKitaRadii.card)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PanganKitaSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DiscoveryCopy.pickupTipTitle,
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(color: PanganKitaColors.brandPrimaryStrong),
                  ),
                  const SizedBox(height: PanganKitaSpacing.sm),
                  Text(
                    DiscoveryCopy.pickupTipHeading,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: PanganKitaSpacing.sm),
                  const Text(DiscoveryCopy.pickupTipBody),
                ],
              ),
            ),
            const SizedBox(width: PanganKitaSpacing.sm),
            const CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: Icon(
                Symbols.shopping_bag,
                color: PanganKitaColors.brandPrimaryStrong,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _DiscoverState extends StatelessWidget {
  const new({
    required this.message,
    this.actionLabel,
    this.onAction,
    this.loading = false,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool loading;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: PanganKitaSpacing.lg),
    child: Column(
      children: [
        if (loading) const CircularProgressIndicator(),
        if (loading) const SizedBox(height: PanganKitaSpacing.md),
        Text(message, textAlign: TextAlign.center),
        if (onAction != null)
          TextButton(onPressed: onAction, child: Text(actionLabel ?? '')),
      ],
    ),
  );
}
