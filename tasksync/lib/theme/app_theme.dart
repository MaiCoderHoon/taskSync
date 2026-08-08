import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// ─── TASKSYNC APP THEME ───────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bgGradientEnd,
    colorScheme: const ColorScheme.light(
      primary: AppColors.textDark,
      surface: AppColors.bgGradientStart,
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
