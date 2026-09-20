import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/business/presentation/business_copy.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/domain/listing_repository.dart';
import 'package:pangankita/features/discovery/presentation/discovery_format.dart';

/// Reviews the consumer-facing details before a local save or publish.
class ListingPreviewPage extends StatefulWidget {
  /// Creates the preview from validated form values.
  const new({
    required this.draft,
    required this.listings,
    required this.onSaved,
    super.key,
  });

  /// Form snapshot to display and persist.
  final ListingDraft draft;

  /// Shared listing repository.
  final ListingRepository listings;

  /// Returns to the shell after a successful save.
  final VoidCallback onSaved;

  @override
  State<ListingPreviewPage> createState() => _ListingPreviewPageState();
}

class _ListingPreviewPageState extends State<ListingPreviewPage> {
  static const _imageHeight = 180.0;
  static const _secondaryActionGap = 12.0;
  bool _saving = false;
  String? _savedId;
  String? _error;

  Future<void> _save({required bool publish}) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final id =
          _savedId ?? (await widget.listings.createDraft(widget.draft)).id;
      _savedId = id;
      if (publish) {
        final published = await widget.listings.publish(id);
        _savedId = published.id;
      }
      if (mounted) widget.onSaved();
    } on ListingException catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = BusinessCopy.failure(error.failure);
        });
      }
    } on Exception {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = BusinessCopy.actionError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final storage = draft.storage.trim();
    final allergens = draft.allergens.trim();
    return Scaffold(
      appBar: AppBar(title: const Text(BusinessCopy.previewTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PanganKitaSpacing.md),
          children: [
            const Text(BusinessCopy.demoNotice),
            const SizedBox(height: PanganKitaSpacing.md),
            Image.asset(
              draft.imageAsset,
              height: _imageHeight,
              fit: BoxFit.cover,
            ),
            const Text(BusinessCopy.photoNotice),
            const SizedBox(height: PanganKitaSpacing.md),
            Text(
              draft.name.trim(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(draft.merchant.name),
            Text(draft.description.trim()),
            const SizedBox(height: PanganKitaSpacing.md),
            Text(
              formatRupiah(draft.priceRupiah),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              BusinessCopy.originalPricePreview(
                formatRupiah(draft.originalPriceRupiah),
              ),
            ),
            Text(BusinessCopy.packagesAvailable(draft.quantity)),
            const SizedBox(height: PanganKitaSpacing.md),
            Text(
              '${BusinessCopy.pickupStart}: '
              '${formatPickupTime(draft.pickupStartsAt)}',
            ),
            Text(
              '${BusinessCopy.pickupDeadline}: '
              '${formatPickupTime(draft.pickupDeadline)}',
            ),
            Text('${BusinessCopy.condition}: ${draft.condition.trim()}'),
            if (storage.isNotEmpty) Text('${BusinessCopy.storage}: $storage'),
            if (allergens.isNotEmpty)
              Text('${BusinessCopy.allergens}: $allergens'),
            if (_error case final message?) ...[
              const SizedBox(height: PanganKitaSpacing.sm),
              Text(
                message,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: PanganKitaSpacing.lg),
            OutlinedButton(
              onPressed: _saving ? null : () => Navigator.of(context).pop(),
              child: const Text(BusinessCopy.edit),
            ),
            const SizedBox(height: _secondaryActionGap),
            OutlinedButton(
              onPressed: _saving
                  ? null
                  : () => unawaited(_save(publish: false)),
              child: const Text(BusinessCopy.saveDraft),
            ),
            const SizedBox(height: PanganKitaSpacing.md),
            ElevatedButton(
              onPressed: _saving ? null : () => unawaited(_save(publish: true)),
              child: Text(_saving ? BusinessCopy.saving : BusinessCopy.publish),
            ),
            const SizedBox(height: PanganKitaSpacing.sm),
          ],
        ),
      ),
    );
  }
}
