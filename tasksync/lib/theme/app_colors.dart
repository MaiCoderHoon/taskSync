import 'package:flutter/material.dart';

class AppColors {
  // Text colors
  static const Color textLight = Color(0xFFF0E8DF);
  static const Color textDark = Color(0xFF1A1410);
  static const Color textMuted = Color(0x99F0E8DF);
  static const Color textMutedDark = Color(0x991A1410);
  static const Color textMid = Color(0xFFC0B8B0);

  // Accents & Button
  static const Color accentGreen = Color(0xFF8CC88C);
  static const Color accentGreenBg = Color(0x1A8CC88C);
  static const Color callBtnBorder = Color(0x338CC88C);

  // Cards
  static const Color cardGlass = Color(0x0AFFFFFF);
  static const Color cardGlassBorder = Color(0x1AFFFFFF);
  static const Color cardDark = Color(0xFF231B14);
  static const Color cardDarkBorder = Color(0xFF2D241C);
  static const Color cardGoal = Color(0xFF231B14);

  // Gradient background
  static const Color bgGradientStart = Color(0xFF1A1410);
  static const Color bgGradientMid = Color(0xFF231B14);
  static const Color bgGradientEnd = Color(0xFF1A1410);

  // Priorities
  static const Color priorityHigh = Color(0xFFE57373);
  static const Color priorityMedium = Color(0xFFFFB74D);
  static const Color priorityLow = Color(0xFF81C784);

  // Avatar & Pills
  static const Color avatarRing = Color(0xFFC9A98A);
  static const Color pillBg = Color(0x0A000000);
  static const Color pillBorder = Color(0x1A000000);
  static const Color tabActiveBg = Color(0xFF2D241C);

  static Color avatarFor(String name) {
    const colors = [
      Color(0xFFC9906A),
      Color(0xFF8FAADC),
      Color(0xFF8CC88C),
      Color(0xFFD4A373),
    ];
    int sum = name.runes.fold(0, (a, b) => a + b);
    return colors[sum % colors.length];
  }
}
