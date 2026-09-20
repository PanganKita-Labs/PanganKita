import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/business/presentation/business_copy.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/domain/listing_repository.dart';
import 'package:pangankita/features/reservations/domain/reservation.dart';
import 'package:pangankita/features/reservations/domain/reservation_repository.dart';

/// Facts calculated only from this session's local merchant state.
class BusinessImpactPage extends StatefulWidget {
  /// Creates the operational summary destination.
  const new({
    required this.listings,
    required this.reservations,
    required this.merchantId,
    required this.revision,
    super.key,
  });

  /// Shared listing source.
  final ListingRepository listings;

  /// Shared reservation source.
  final ReservationRepository reservations;

  /// Selected fictional merchant.
  final String merchantId;

  /// Changes after a local state mutation.
  final int revision;

  @override
  State<BusinessImpactPage> createState() => _BusinessImpactPageState();
}

typedef _ImpactData = ({
  List<Listing> listings,
  List<Reservation> reservations,
});

class _BusinessImpactPageState extends State<BusinessImpactPage> {
  Future<_ImpactData>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void didUpdateWidget(covariant BusinessImpactPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.revision != widget.revision ||
        oldWidget.merchantId != widget.merchantId) {
      _future = _load();
    }
  }

  Future<_ImpactData> _load() async => (
    listings: await widget.listings.loadMerchantListings(widget.merchantId),
    reservations: await widget.reservations.loadMerchantReservations(
      widget.merchantId,
    ),
  );

  @override
  Widget build(BuildContext context) => SafeArea(
    child: FutureBuilder<_ImpactData>(
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
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: Text(BusinessCopy.loadError));
        }
        final completed = data.reservations.where(
          (item) => item.status == ReservationStatus.completed,
        );
        final completedPackages = completed.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );
        final available = data.listings
            .where((item) => item.status == ListingStatus.active)
            .fold<int>(0, (sum, item) => sum + item.offer.availableQuantity);
        final expired = data.listings
            .where((item) => item.status == ListingStatus.expired)
            .length;
        return ListView(
          padding: const EdgeInsets.all(PanganKitaSpacing.md),
          children: [
            Text(
              BusinessCopy.impactTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: PanganKitaSpacing.sm),
            const Text(BusinessCopy.impactNotice),
            const SizedBox(height: PanganKitaSpacing.lg),
            Text(BusinessCopy.completedReservations(completed.length)),
            Text(BusinessCopy.completedPickupPackages(completedPackages)),
            Text(BusinessCopy.availablePackages(available)),
            Text(BusinessCopy.expiredListings(expired)),
          ],
        );
      },
    ),
  );
}
