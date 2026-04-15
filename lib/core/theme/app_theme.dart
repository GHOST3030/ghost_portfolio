import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_style.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    return AppStyle.isStartup ? _startupTheme : _classicTheme;
  }

  static ThemeData get _startupTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        background: AppColors.bg,
        surface: AppColors.bgSurface,
        primary: AppColors.accent,
        onPrimary: AppColors.bg,
        onBackground: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.syneTextTheme(
        ThemeData.dark().textTheme.copyWith(
              displayLarge: GoogleFonts.syne(
                fontSize: 72,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.0,
              ),
              displayMedium: GoogleFonts.syne(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              headlineLarge: GoogleFonts.syne(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              headlineMedium: GoogleFonts.syne(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              bodyLarge: GoogleFonts.dmSans(
                fontSize: 17,
                color: AppColors.textSecondary,
                height: 1.7,
              ),
              bodyMedium: GoogleFonts.dmSans(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              labelLarge: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                color: AppColors.accent,
                letterSpacing: 0.1,
              ),
            ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyle.cardRadius),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border),
    );
  }

  static ThemeData get _classicTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.classicBg,
      colorScheme: const ColorScheme.light(
        background: AppColors.classicBg,
        surface: AppColors.classicSurface,
        primary: AppColors.classicAccent,
        onPrimary: Colors.white,
        onBackground: AppColors.classicText,
        onSurface: AppColors.classicText,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme.copyWith(
              displayLarge: GoogleFonts.inter(
                fontSize: 56,
                fontWeight: FontWeight.w800,
                color: AppColors.classicText,
              ),
              displayMedium: GoogleFonts.inter(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.classicText,
              ),
              headlineLarge: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.classicText,
              ),
              headlineMedium: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.classicText,
              ),
              bodyLarge: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.classicTextSecondary,
                height: 1.7,
              ),
              bodyMedium: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.classicTextSecondary,
                height: 1.6,
              ),
              labelLarge: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.classicAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.classicCard,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyle.cardRadius),
          side: const BorderSide(color: AppColors.classicBorder),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.classicBorder),
    );
  }
}
