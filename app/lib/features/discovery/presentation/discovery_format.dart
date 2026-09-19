/// Formats whole rupiah values without a money arithmetic dependency.
String formatRupiah(int amount) {
  final grouped = amount.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return 'Rp $grouped';
}

/// Formats the illustrative distance from the selected area.
String formatDistance(int meters) {
  const metersPerKilometer = 1000;
  if (meters < metersPerKilometer) return '$meters m';
  final kilometers = (meters / metersPerKilometer)
      .toStringAsFixed(1)
      .replaceAll('.', ',');
  return '$kilometers km';
}

/// Always includes an absolute local date and time for pickup.
String formatPickupTime(DateTime time) {
  final day = time.day.toString().padLeft(2, '0');
  final month = time.month.toString().padLeft(2, '0');
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$day/$month $hour.$minute';
}
