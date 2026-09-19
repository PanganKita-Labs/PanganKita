import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(PanganKitaSpacing.md),
      children: [
        _DiscoverHeader(areaName: widget.areaName),
        const SizedBox(height: PanganKitaSpacing.md),
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            labelText: DiscoveryCopy.searchLabel,
            hintText: DiscoveryCopy.searchHint,
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(PanganKitaRadii.control),
              ),
            ),
          ),
        ),
        const SizedBox(height: PanganKitaSpacing.sm),
        _CategoryFilters(selected: _category, onSelected: _selectCategory),
        const SizedBox(height: PanganKitaSpacing.md),
        _DiscoverResults(
          future: _listingsFuture,
          referenceTime: widget.referenceTime,
          query: _query,
          category: _category,
          onOpenListing: widget.onOpenListing,
          onRetry: _retry,
          onClearFilters: _clearFilters,
        ),
      ],
    ),
  );
}

class _DiscoverHeader extends StatelessWidget {
  const new({required this.areaName});

  final String areaName;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Icon(Icons.location_on_outlined),
          const SizedBox(width: PanganKitaSpacing.sm),
          Expanded(
            child: Text(
              '${DiscoveryCopy.areaLabel}: $areaName',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
      const SizedBox(height: PanganKitaSpacing.md),
      Text(
        DiscoveryCopy.discoverTitle,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: PanganKitaSpacing.sm),
      Text(
        DiscoveryCopy.discoverSubtitle,
        style: Theme.of(context).textTheme.bodyMedium,
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
          onSelected: (_) => onSelected(null),
        ),
        for (final category in ListingCategory.values) ...[
          const SizedBox(width: PanganKitaSpacing.sm),
          ChoiceChip(
            label: Text(DiscoveryCopy.category(category)),
            selected: selected == category,
            onSelected: (_) => onSelected(category),
          ),
        ],
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
  });

  final Future<List<Listing>>? future;
  final DateTime referenceTime;
  final String query;
  final ListingCategory? category;
  final ValueChanged<String> onOpenListing;
  final VoidCallback onRetry;
  final VoidCallback onClearFilters;

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
          if (sections.urgent.isNotEmpty)
            _ListingSection(
              title: DiscoveryCopy.urgentTitle,
              listings: sections.urgent,
              onOpenListing: onOpenListing,
            ),
          if (sections.nearby.isNotEmpty)
            _ListingSection(
              title: DiscoveryCopy.nearbyTitle,
              listings: sections.nearby,
              onOpenListing: onOpenListing,
            ),
        ],
      );
    },
  );
}

class _ListingSection extends StatelessWidget {
  const new({
    required this.title,
    required this.listings,
    required this.onOpenListing,
  });

  final String title;
  final List<Listing> listings;
  final ValueChanged<String> onOpenListing;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: PanganKitaSpacing.sm),
      for (final listing in listings) ...[
        ListingCard(listing: listing, onTap: () => onOpenListing(listing.id)),
        const SizedBox(height: PanganKitaSpacing.md),
      ],
    ],
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
