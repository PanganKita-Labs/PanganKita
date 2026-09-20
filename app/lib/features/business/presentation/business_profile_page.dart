import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/business/presentation/business_copy.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';

/// Read-only identity of the fictional local merchant.
class BusinessProfilePage extends StatelessWidget {
  /// Creates the small Business destination.
  const new({required this.merchant, super.key});

  /// Deterministic merchant fixture.
  final ListingMerchant merchant;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(PanganKitaSpacing.md),
      children: [
        Text(
          BusinessCopy.profileTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: PanganKitaSpacing.md),
        Text(merchant.name, style: Theme.of(context).textTheme.titleLarge),
        Text(merchant.area),
        Text(merchant.pickupAddress),
        const SizedBox(height: PanganKitaSpacing.md),
        const Text(BusinessCopy.profileNotice),
      ],
    ),
  );
}
