import 'package:pangankita/features/discovery/domain/listing.dart';

/// Indonesian prototype copy in one place for later localization work.
abstract final class DiscoveryCopy {
  /// Label for the deliberately fixed mock area.
  static const areaLabel = 'Lokasi Pencarian';

  /// Compact area label used in the reference header pill.
  static const compactArea = 'Tebet, Jaksel';

  /// Attempts to change the fixed prototype area.
  static const changeArea = 'Ubah';

  /// Explains the fixed prototype area.
  static const locationUnavailable = 'Area pencarian tetap pada prototipe ini.';

  /// Notification action label.
  static const notifications = 'Notifikasi';

  /// Explains that notification infrastructure is absent.
  static const notificationsUnavailable =
      'Notifikasi belum tersedia pada prototipe.';

  /// Profile action label.
  static const profile = 'Profil';

  /// Fallback when a profile route is unavailable.
  static const profileUnavailable = 'Profil belum tersedia pada prototipe.';

  /// Advanced filter action label.
  static const moreFilters = 'Filter lainnya';

  /// Explains that advanced filters are absent.
  static const filtersUnavailable =
      'Filter lanjutan belum tersedia pada prototipe.';

  /// Neutral context strip for deterministic local fixtures.
  static const localContext = 'Listing contoh di area pencarian';

  /// Visual map-promotion heading.
  static const mapTitle = 'Tampilan Peta Interaktif';

  /// Truthful map-promotion supporting copy.
  static const mapSubtitle = 'Lihat titik pickup di area contoh';

  /// Map promotion action.
  static const openMap = 'Buka Peta';

  /// Explains that no map SDK is installed.
  static const mapUnavailable = 'Peta belum tersedia pada prototipe.';

  /// Accessible name of the official brandmark.
  static const logoLabel = 'Logo PanganKita';

  /// Heading for the first consumer screen.
  static const discoverTitle = 'Temukan makanan surplus sebelum batas pickup!';

  /// Explains the pickup-first purpose without a measured impact claim.
  static const discoverSubtitle =
      'Pilih makanan dari penjual sekitar dan ambil tepat waktu.';

  /// Search field label.
  static const searchLabel = 'Cari bakery, resto, atau menu lezat…';

  /// Search field hint.
  static const searchHint = 'Cari makanan, penjual, atau area';

  /// Label for all categories.
  static const allCategories = 'Semua';

  /// Reference category without a matching domain value in this prototype.
  static const unsupportedCategoryCoffee = 'Kopi & minuman';

  /// Reference category without a matching domain value in this prototype.
  static const unsupportedCategoryHealthy = 'Sehat & salad';

  /// Heading for listings with an approaching pickup deadline.
  static const urgentTitle = 'Pickup Segera (< 60 Menit)';

  /// Heading for the remaining nearby listings.
  static const nearbyTitle = 'Terdekat dari Area Contoh';

  /// Short pickup advice without a reward or impact claim.
  static const pickupTipTitle = 'Tips Pickup';

  /// Practical advice for collecting a reservation.
  static const pickupTipHeading = 'Bawa tas atau wadah sendiri';

  /// Advice is optional and does not promise a merchant incentive.
  static const pickupTipBody =
      'Jika memungkinkan, bawa tas atau wadah saat mengambil pesanan.';

  /// Label for quantity remaining in a local listing snapshot.
  static String remaining(int quantity) => 'Tersisa $quantity paket';

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

  /// Seller statement label without platform verification.
  static const sellerDeclaration = 'Pernyataan penjual';

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

  /// Neutral deadline reminder.
  static const pickupDeadlineNotice =
      'Ambil sebelum batas waktu yang ditetapkan penjual.';

  /// Placeholder shown instead of a fabricated live map.
  static const mapPlaceholder = 'Pratinjau peta belum tersedia';

  /// Truthful response to the visual location action.
  static const mapActionUnavailable =
      'Navigasi peta belum tersedia pada prototipe.';

  /// Save action label retained from the reference screen.
  static const saveListing = 'Simpan listing';

  /// Truthful response while favorites are outside the local prototype.
  static const saveUnavailable =
      'Penyimpanan favorit belum tersedia pada prototipe.';

  /// Listing report action retained from the reference screen.
  static const reportListing = 'Laporkan listing';

  /// Truthful response while reporting infrastructure is absent.
  static const reportUnavailable = 'Pelaporan belum tersedia pada prototipe.';

  /// General pickup guidance.
  static const pickupGuidance =
      'Periksa alamat dan tunjukkan kode pickup saat mengambil pesanan.';

  /// Price summary label above the reservation action.
  static const totalPayment = 'Total bayar saat pickup';

  /// Photo attribution for generated mock imagery.
  static const illustrativePhoto = 'Foto ilustrasi untuk data contoh';

  /// Price note for the reservation flow.
  static const payAtPickup =
      'Bayar saat pickup dengan metode yang diterima penjual.';

  /// Reservation handoff button.
  static const continueToReservation = 'Lanjut ke reservasi';

  /// Unavailable listing action state.
  static const unavailable = 'Tidak tersedia';

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
