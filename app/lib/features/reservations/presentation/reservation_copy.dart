import 'package:pangankita/features/reservations/domain/reservation.dart';

/// Bahasa Indonesia copy for the local reservation prototype.
abstract final class ReservationCopy {
  /// Explains the scope of every reservation action.
  static const demoNotice =
      'Simulasi lokal di perangkat ini. Penjual tidak menerima pesanan nyata.';

  /// Confirmation page title.
  static const confirmationTitle = 'Konfirmasi reservasi';

  /// Main confirmation action.
  static const confirm = 'Konfirmasi reservasi contoh';

  /// Selected quantity heading.
  static const quantity = 'Jumlah paket';

  /// Reduces the selected quantity.
  static const decreaseQuantity = 'Kurangi jumlah paket';

  /// Increases the selected quantity.
  static const increaseQuantity = 'Tambah jumlah paket';

  /// Describes the maximum quantity in the current listing snapshot.
  static String maximumQuantity(int count) => 'Maksimal $count paket';

  /// Progress label while creating local state.
  static const saving = 'Menyimpan…';

  /// Merchant and pickup place heading.
  static const pickupPlace = 'Lokasi pickup';

  /// Pickup time heading.
  static const pickupWindow = 'Waktu pickup';

  /// Absolute deadline prefix.
  static const pickupBefore = 'Pickup sebelum';

  /// Reservation quantity and seller summary.
  static String packageSummary(int quantity, String merchant) =>
      '$quantity paket · $merchant';

  /// Payment explanation.
  static const payment =
      'Bayar saat pickup dengan metode yang diterima penjual. '
      'Belum ada pembayaran yang diproses.';

  /// Demo cancellation rule, not a production merchant policy.
  static const cancellationRule =
      'Dalam demo ini, reservasi dapat dibatalkan '
      'saat masih berstatus Dipesan.';

  /// Amount payable to the merchant.
  static const amountDue = 'Total bayar saat pickup';

  /// Reservations tab heading.
  static const reservationsTitle = 'Reservasi';

  /// Empty list explanation.
  static const empty = 'Belum ada reservasi contoh.';

  /// Empty list action.
  static const browse = 'Lihat makanan';

  /// Active list heading.
  static const active = 'Aktif';

  /// History list heading.
  static const history = 'Riwayat';

  /// Reservation detail title.
  static const detailTitle = 'Detail pickup';

  /// Missing local reservation.
  static const missing = 'Reservasi contoh ini tidak ditemukan.';

  /// Recoverable loading error.
  static const loadError = 'Reservasi belum bisa dimuat.';

  /// Recoverable creation error without exposing an exception.
  static const createError = 'Reservasi contoh belum bisa dibuat. Coba lagi.';

  /// Recoverable transition error without exposing an exception.
  static const actionError = 'Status belum bisa diperbarui. Coba lagi.';

  /// Retry action.
  static const retry = 'Coba lagi';

  /// Pickup code heading.
  static const pickupCode = 'Kode pickup contoh';

  /// Explains the code's limited meaning.
  static const codeNotice =
      'Kode demo lokal; bukan token aman dan tidak dipindai penjual.';

  /// Pickup instruction without claiming merchant confirmation.
  static const instruction =
      'Tunjukkan kode contoh saat mencoba alur pickup. '
      'Pembayaran dilakukan langsung kepada penjual pada alur nyata.';

  /// Demo-only state controls heading.
  static const demoControls = 'Kontrol simulasi lokal';

  /// Simulates a merchant readiness event without business UI.
  static const simulateReady = 'Simulasikan penjual siap';

  /// Simulates pickup verification without a real merchant action.
  static const simulateComplete = 'Simulasikan pickup selesai';

  /// Consumer cancellation action.
  static const cancel = 'Batalkan reservasi contoh';

  /// Cancellation confirmation heading.
  static const cancelQuestion = 'Batalkan reservasi contoh?';

  /// Cancellation confirmation detail.
  static const cancelExplanation =
      'Jumlah paket akan kembali tersedia di demo lokal.';

  /// Dismisses a confirmation dialog.
  static const keep = 'Kembali';

  /// Human-readable status, never conveyed by color alone.
  static String status(ReservationStatus value) => switch (value) {
    ReservationStatus.reserved => 'Dipesan',
    ReservationStatus.readyForPickup => 'Siap diambil',
    ReservationStatus.completed => 'Selesai',
    ReservationStatus.cancelled => 'Dibatalkan',
    ReservationStatus.expired => 'Lewat batas pickup',
  };

  /// Plain-language response to a rejected local action.
  static String failure(ReservationFailure value) => switch (value) {
    ReservationFailure.unavailable =>
      'Paket tidak tersedia lagi. Kembali dan periksa listing.',
    ReservationFailure.notFound => 'Reservasi contoh tidak ditemukan.',
    ReservationFailure.invalidTransition =>
      'Status reservasi sudah berubah. Muat ulang dan coba lagi.',
    ReservationFailure.invalidCode => 'Kode pickup contoh tidak cocok.',
  };
}
