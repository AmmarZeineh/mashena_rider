import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mashena_rider/core/common/extensions/pinput_theme_x.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';

final class AppTheme {
  const AppTheme._();

  static ThemeData light(Locale locale) {
    final fontFamily = _fontFamily(locale);

    final cs = ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
      surface: AppColors.lightScaffold,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      fontFamily: fontFamily,

      scaffoldBackgroundColor: cs.surface,

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        elevation: 0,
        foregroundColor: cs.onSurface,
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),

      extensions: [_pinputTheme(cs, fontFamily, isDark: false)],
    );
  }

  static ThemeData dark(Locale locale) {
    final fontFamily = _fontFamily(locale);

    final cs = ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.dark,
      surface: AppColors.darkScaffold,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: cs.surface,

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        elevation: 0,
        foregroundColor: cs.onSurface,
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),

      extensions: [_pinputTheme(cs, fontFamily, isDark: true)],
    );
  }

  static String? _fontFamily(Locale locale) {
    final isArabic = locale.languageCode == 'ar';
    return isArabic
        ? GoogleFonts.cairo().fontFamily
        : GoogleFonts.poppins().fontFamily;
  }

  static PinputTheme _pinputTheme(
    ColorScheme cs,
    String? fontFamily, {
    required bool isDark,
  }) {
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;

    final fieldFill = isDark ? cs.surface : Colors.white;

    return PinputTheme(
      width: 60,
      height: 60,
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
        fontFamily: fontFamily,
      ),
      defaultDecoration: BoxDecoration(
        color: fieldFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      focusedDecoration: BoxDecoration(
        color: fieldFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor, width: 2),
      ),
      submittedDecoration: BoxDecoration(
        color: fieldFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor, width: 1.5),
      ),
      errorDecoration: BoxDecoration(
        color: fieldFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.error, width: 1.5),
      ),
    );
  }
}
