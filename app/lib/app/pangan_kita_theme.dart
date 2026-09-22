import 'package:flutter/material.dart';

/// Material mapping of the PanganKita design foundations.
abstract final class PanganKitaTheme {
  /// The light prototype theme.
  // Geist Sans and Satoshi can be added here after licensed assets are present.
  static final light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: PanganKitaColors.surfaceWarm,
    colorScheme: const ColorScheme.light(
      primary: PanganKitaColors.brandPrimary,
      secondary: PanganKitaColors.brandAccent,
      surface: PanganKitaColors.surfaceWarm,
      onSurface: PanganKitaColors.textPrimary,
      error: PanganKitaColors.danger,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 36,
        height: 44 / 36,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: TextStyle(
        fontSize: 28,
        height: 34 / 28,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        height: 24 / 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 24 / 16),
      bodyMedium: TextStyle(fontSize: 14, height: 20 / 14),
      bodySmall: TextStyle(fontSize: 12, height: 16 / 12),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: PanganKitaColors.surfaceWarm,
      foregroundColor: PanganKitaColors.textPrimary,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(PanganKitaRadii.control),
        ),
        borderSide: BorderSide(color: PanganKitaColors.borderNeutral),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? PanganKitaColors.brandPrimary
              : PanganKitaColors.textPrimary,
          fill: states.contains(WidgetState.selected) ? 1 : 0,
          weight: states.contains(WidgetState.selected) ? 600 : 400,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          color: states.contains(WidgetState.selected)
              ? PanganKitaColors.brandPrimary
              : PanganKitaColors.textPrimary,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: PanganKitaColors.brandPrimary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(PanganKitaRadii.control),
          ),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        foregroundColor: PanganKitaColors.brandPrimary,
        side: const BorderSide(color: PanganKitaColors.brandPrimary),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(PanganKitaRadii.control),
          ),
        ),
      ),
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: PanganKitaColors.borderNeutral),
        borderRadius: BorderRadius.all(Radius.circular(PanganKitaRadii.card)),
      ),
    ),
  );
}

/// Brand and semantic colors used by the prototype.
abstract final class PanganKitaColors {
  /// Main brand green.
  static const brandPrimary = Color(0xFF1B6B3A);

  /// Strong green for pressed states.
  static const brandPrimaryStrong = Color(0xFF0D4D2B);

  /// Controlled urgency accent.
  static const brandAccent = Color(0xFFF5921B);

  /// Warm page background.
  static const surfaceWarm = Color(0xFFFAF6F0);

  /// Slightly darker warm surface used for contextual panels.
  static const surfaceContainerLow = Color(0xFFF7F3ED);

  /// Primary text color.
  static const textPrimary = Color(0xFF2D2D2D);

  /// Subtle border color.
  static const borderNeutral = Color(0xFFE8E4DF);

  /// Soft badge behind calculated savings.
  static const savingsSurface = Color(0xFFE8F5E9);

  /// Soft badge behind local stock remaining.
  static const urgencySurface = Color(0xFFFFEBD5);

  /// Error and destructive action color.
  static const danger = Color(0xFFD32F2F);
}

/// Common layout measurements.
abstract final class PanganKitaSpacing {
  /// Extra-small spacing for compact badges.
  static const xs = 4.0;

  /// Small spacing.
  static const sm = 8.0;

  /// Default page gutter.
  static const md = 16.0;

  /// Large spacing.
  static const lg = 24.0;
}

/// Common surface radii.
abstract final class PanganKitaRadii {
  /// Button and input radius.
  static const control = 12.0;

  /// Card radius.
  static const card = 16.0;
}
