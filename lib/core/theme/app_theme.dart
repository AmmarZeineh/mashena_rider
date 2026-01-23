import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';

final class AppTheme {
  const AppTheme._();

  static ThemeData light(Locale locale) {
    final isArabic = locale.languageCode == 'ar';

    final fontFamily = isArabic
        ? GoogleFonts.cairo().fontFamily
        : GoogleFonts.poppins().fontFamily;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
      background: const Color(0xFFF9FAFB), // خلفية عامة للتطبيق
      surface: Colors.white, // cards / dialogs / sheets
    );

    return ThemeData(
      useMaterial3: true,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
      ),
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: fontFamily,

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }

  static ThemeData dark(Locale locale) {
    final isArabic = locale.languageCode == 'ar';

    final fontFamily = isArabic
        ? GoogleFonts.cairo().fontFamily
        : GoogleFonts.poppins().fontFamily;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.dark,
      background: const Color(0xFF0F1115), // خلفية داكنة ناعمة
      surface: const Color(0xFF1A1D23),
    );

    return ThemeData(
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
      ),
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: fontFamily,

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }
}
