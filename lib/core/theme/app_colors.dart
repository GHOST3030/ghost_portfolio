import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color bg = Color(0xFF0A0A10);
  static const Color bgSurface = Color(0xFF111118);
  static const Color bgCard = Color(0xFF16161F);
  static const Color bgCardHover = Color(0xFF1E1E2A);

  static const Color accent = Color(0xFF00FF87);
  static const Color accentDim = Color(0xFF00CC6A);
  static const Color accentGlow = Color(0x3300FF87);

  static const Color textPrimary = Color(0xFFF0F0F5);
  static const Color textSecondary = Color(0xFF8888A0);
  static const Color textMuted = Color(0xFF444455);

  static const Color border = Color(0xFF1E1E2A);
  static const Color borderAccent = Color(0xFF00FF8730);

  static const Color classicBg = Color(0xFFFAFAFA);
  static const Color classicSurface = Color(0xFFFFFFFF);
  static const Color classicCard = Color(0xFFFFFFFF);
  static const Color classicAccent = Color(0xFF0066FF);
  static const Color classicText = Color(0xFF1A1A2E);
  static const Color classicTextSecondary = Color(0xFF555577);
  static const Color classicBorder = Color(0xFFE0E0EE);

  static LinearGradient get accentGradient => const LinearGradient(
        colors: [Color(0xFF00FF87), Color(0xFF00E5FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get heroGradient => const LinearGradient(
        colors: [Color(0xFF0A0A10), Color(0xFF0D0D18)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
}
