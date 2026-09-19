import 'package:pangankita/features/discovery/domain/listing.dart';

/// Indonesian prototype copy in one place for later localization work.
abstract final class DiscoveryCopy {
  /// Label for the deliberately fixed mock area.
  static const areaLabel = 'Area contoh';

  /// Accessible name of the official brandmark.
  static const logoLabel = 'Logo PanganKita';

  /// Heading for the first consumer screen.
  static const discoverTitle = 'Temukan makanan surplus di sekitarmu';

  /// Explains the pickup-first purpose without a measured impact claim.
  static const discoverSubtitle =
      'Ambil sebelum batas pickup dari penjual sekitar.';

  /// Search field label.
  static const searchLabel = 'Cari makanan atau penjual';

  /// Search field hint.
  static const searchHint = 'Cari makanan, penjual, atau area';

  /// Label for all categories.
  static const allCategories = 'Semua';

  /// Heading for listings with an approaching pickup deadline.
  static const urgentTitle = 'Pickup dalam 60 menit';

  /// Heading for the remaining nearby listings.
  static const nearbyTitle = 'Terdekat dari area contoh';

  /// Prefix for a visible absolute pickup deadline.
  static const pickupBefore = 'Pickup sebelum';

  /// Loading state.
  static const loading = 'Memuat makanan surplus contoh…';

  /// Recoverable repository error.
  static const loadError = 'Daftar makanan belum bisa dimuat.';

  /// Retry action.
  static const retry = 'Coba lagi';

  /// Empty feed or filtered result.
  static const empty = 'Belum ada makanan yang cocok di area ini.';

  /// Clears local search and category selection.
  static const clearFilters = 'Hapus pencarian dan filter';

  /// Detail loading state.
  static const detailLoading = 'Memuat rincian makanan…';

  /// App bar title for a selected listing.
  static const detailTitle = 'Rincian makanan';

  /// Detail missing result.
  static const missingListing = 'Listing contoh ini tidak tersedia lagi.';

  /// Detail error state.
  static const detailError = 'Rincian makanan belum bisa dimuat.';

  /// Seller information heading.
  static const sellerInformation = 'Informasi dari penjual';

  /// Explains the attribution of food information.
  static const sellerDisclaimer = 'Informasi ini disediakan penjual.';

  /// Surplus reason label.
  static const surplusReason = 'Alasan surplus';

  /// Condition label.
  static const condition = 'Kondisi makanan';

  /// Storage label.
  static const storage = 'Penyimpanan';

  /// Allergen label.
  static const allergens = 'Alergen';

  /// Pickup place label.
  static const pickupLocation = 'Lokasi pickup';

  /// Pickup window label.
  static const pickupWindow = 'Waktu pickup';

  /// Photo attribution for generated mock imagery.
  static const illustrativePhoto = 'Foto ilustrasi untuk data contoh';

  /// Price note for the future reservation flow.
  static const payAtPickup =
      'Bayar saat pickup dengan metode yang diterima penjual.';

  /// Reservation handoff button.
  static const continueToReservation = 'Lanjut ke reservasi';

  /// Unavailable listing action state.
  static const unavailable = 'Tidak tersedia';

  /// Boundary message heading.
  static const reservationUnavailable = 'Reservasi belum tersedia';

  /// Boundary message body; no reservation is created.
  static const reservationBoundary =
      'Alur reservasi akan tersedia pada fase berikutnya. '
      'Belum ada pesanan yang dibuat.';

  /// Dismisses the boundary message.
  static const understood = 'Mengerti';

  /// Back action label.
  static const back = 'Kembali';

  /// Category name for one of the supported fixtures.
  static String category(ListingCategory category) => switch (category) {
    ListingCategory.bakery => 'Roti & pastry',
    ListingCategory.meal => 'Nasi & lauk',
  };

  /// Availability label for a local snapshot.
  static String available(int quantity) => '$quantity paket tersedia';

  /// Price savings based on the seller-provided original price.
  static String savings(int percent) => 'Hemat $percent%';

  /// Accessible description for an illustrative product photo.
  static String photoOf(String name) => 'Foto contoh $name';
}
