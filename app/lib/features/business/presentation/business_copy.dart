import 'package:pangankita/features/discovery/domain/listing.dart';

/// Bahasa Indonesia copy for the local merchant prototype.
abstract final class BusinessCopy {
  /// Explains the local nature of the merchant controls.
  static const demoNotice =
      'Mode bisnis contoh. Perubahan hanya tersimpan selama aplikasi terbuka.';

  /// Main listing creation action.
  static const createListing = 'Buat listing';

  /// Empty listing state.
  static const emptyListings = 'Belum ada listing untuk bisnis contoh ini.';

  /// Active listing section.
  static const active = 'Aktif';

  /// Unpublished listing section.
  static const drafts = 'Draft';

  /// Closed listing section.
  static const closed = 'Tidak aktif';

  /// Pickup queue heading.
  static const pickupQueue = 'Antrean pickup';

  /// Missing reservations message.
  static const emptyReservations = 'Belum ada reservasi untuk bisnis contoh.';

  /// Data loading failure.
  static const loadError = 'Data bisnis contoh belum bisa dimuat.';

  /// Retry action.
  static const retry = 'Coba lagi';

  /// Listing creation form title.
  static const formTitle = 'Buat listing surplus';

  /// Consumer-facing preview title.
  static const previewTitle = 'Pratinjau listing';

  /// Listing name field.
  static const name = 'Nama paket';

  /// Listing category field.
  static const category = 'Kategori';

  /// Short description field.
  static const description = 'Deskripsi singkat';

  /// Seller's reference price field.
  static const originalPrice = 'Harga asli (Rp)';

  /// Surplus price field.
  static const surplusPrice = 'Harga surplus (Rp)';

  /// Initial package count field.
  static const quantity = 'Jumlah paket';

  /// Pickup start field.
  static const pickupStart = 'Pickup mulai';

  /// Pickup deadline field.
  static const pickupDeadline = 'Batas pickup';

  /// Seller's surplus reason field.
  static const surplusReason = 'Alasan surplus dari penjual';

  /// Seller-provided food condition field.
  static const condition = 'Kondisi menurut penjual';

  /// Optional seller storage statement field.
  static const storage = 'Informasi penyimpanan (opsional)';

  /// Optional seller allergen statement field.
  static const allergens = 'Informasi alergen (opsional)';

  /// Required text field validation.
  static const fieldRequired = 'Isi kolom ini.';

  /// Invalid number field validation.
  static const invalidNumber = 'Masukkan angka yang valid.';

  /// Invalid price relationship validation.
  static const invalidPrice = 'Harga surplus tidak boleh melebihi harga asli.';

  /// Pickup window validation.
  static const invalidTime = 'Periksa waktu pickup dan batasnya.';

  /// Existing illustrative image disclosure.
  static const photoNotice = 'Foto ilustrasi dari aset contoh aplikasi.';

  /// Opens the listing preview.
  static const preview = 'Lihat pratinjau';

  /// Returns to the form from preview.
  static const edit = 'Ubah';

  /// Saves without publishing.
  static const saveDraft = 'Simpan draft';

  /// Publishes in local demo state.
  static const publish = 'Publikasikan contoh';

  /// Busy action label.
  static const saving = 'Menyimpan…';

  /// Merchant listing detail title.
  static const manageTitle = 'Kelola listing';

  /// Opens quantity adjustment.
  static const updateQuantity = 'Ubah jumlah paket';

  /// Closes a listing in local state.
  static const closeListing = 'Tutup listing contoh';

  /// Closing confirmation title.
  static const closeQuestion = 'Tutup listing ini?';

  /// Closing consequence and active-reservation boundary.
  static const closeExplanation =
      'Listing tidak lagi muncul di Discover. Reservasi aktif harus '
      'diselesaikan lebih dulu.';

  /// Dismisses an action dialog.
  static const keep = 'Kembali';

  /// Total stock label.
  static const totalQuantity = 'Jumlah total';

  /// Remaining stock label.
  static const availableQuantity = 'Tersedia';

  /// Active reservation quantity label.
  static const reservedQuantity = 'Sedang dipesan';

  /// Completed pickup quantity label.
  static const completedQuantity = 'Paket selesai';

  /// Recoverable local mutation error.
  static const actionError = 'Perubahan belum bisa disimpan. Coba lagi.';

  /// Missing merchant listing state.
  static const missingListing = 'Listing bisnis contoh tidak ditemukan.';

  /// Merchant reservation destination title.
  static const reservationsTitle = 'Reservasi bisnis';

  /// Merchant reservation detail title.
  static const reservationTitle = 'Detail reservasi bisnis';

  /// Marks a reservation ready.
  static const markReady = 'Tandai siap diambil';

  /// Manual local pickup code field.
  static const pickupCode = 'Masukkan kode pickup contoh';

  /// Verifies a ready pickup locally.
  static const verifyPickup = 'Verifikasi pickup contoh';

  /// Explains the code's limited meaning.
  static const codeNotice =
      'Kode ini hanya untuk simulasi lokal; bukan verifikasi aman.';

  /// Missing merchant reservation state.
  static const missingReservation = 'Reservasi bisnis contoh tidak ditemukan.';

  /// Operational summary title.
  static const impactTitle = 'Ringkasan operasional';

  /// Explains that the displayed facts are local calculations.
  static const impactNotice =
      'Angka berikut dihitung dari state contoh di perangkat ini. '
      'Pembayaran dan dampak lingkungan tidak diukur.';

  /// Fictional profile title.
  static const profileTitle = 'Bisnis contoh';

  /// Fictional identity disclosure.
  static const profileNotice =
      'Identitas ini adalah data fiktif. Mode Bisnis tidak memverifikasi '
      'kepemilikan akun.';

  /// Category label used by the short listing form.
  static String categoryLabel(ListingCategory value) => switch (value) {
    ListingCategory.bakery => 'Roti & pastry',
    ListingCategory.meal => 'Nasi & lauk',
  };

  /// Existing local illustrative asset for the selected category.
  static String imageAsset(ListingCategory value) => switch (value) {
    ListingCategory.bakery => 'assets/food/pastry-box.png',
    ListingCategory.meal => 'assets/food/rice-meal.png',
  };

  /// Listing state conveyed in text as well as any visual treatment.
  static String listingStatus(ListingStatus value) => switch (value) {
    ListingStatus.draft => 'Draft',
    ListingStatus.active => 'Aktif',
    ListingStatus.soldOut => 'Habis',
    ListingStatus.expired => 'Lewat batas pickup',
    ListingStatus.cancelled => 'Ditutup',
  };

  /// Plain-language local listing failure.
  static String failure(ListingFailure value) => switch (value) {
    ListingFailure.invalidDraft => 'Periksa detail listing dan waktu pickup.',
    ListingFailure.notFound => missingListing,
    ListingFailure.invalidTransition => 'Status listing sudah berubah.',
    ListingFailure.heldQuantity =>
      'Jumlah tidak boleh kurang dari paket yang telah dipesan, '
          'dan listing dengan reservasi aktif belum bisa ditutup.',
  };
}
