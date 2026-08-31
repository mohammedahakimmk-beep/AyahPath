import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Builds calm, Quran-centered light and dark themes.
class AppTheme {
  AppTheme._();

  static ThemeData light() => _base(Brightness.light, isDark: false);

  static ThemeData dark() => _base(Brightness.dark, isDark: true);

  static ThemeData _base(Brightness brightness, {required bool isDark}) {
    final scheme = isDark
        ? const ColorScheme.dark(
            primary: AppColors.mint,
            onPrimary: AppColors.night,
            secondary: AppColors.goldDark,
            surface: AppColors.nightSurface,
            onSurface: AppColors.textDark,
            error: AppColors.error,
          )
        : const ColorScheme.light(
            primary: AppColors.teal,
            onPrimary: Colors.white,
            secondary: AppColors.gold,
            surface: AppColors.surfaceLight,
            onSurface: AppColors.ink,
            error: AppColors.error,
          );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? AppColors.night : AppColors.cream,
    );

    final cardColor = isDark ? AppColors.nightSurfaceHi : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textDark : AppColors.ink;

    return base.copyWith(
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.night : AppColors.cream,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'AmiriQuran',
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.night : AppColors.cream,
        indicatorColor: isDark ? AppColors.mintSoft : AppColors.tealSoft,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDarkSoft : AppColors.inkSoft,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: isDark ? AppColors.nightSurfaceHi : AppColors.surfaceLight,
          foregroundColor: textColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: BorderSide(color: isDark ? AppColors.mintSoft : AppColors.tealSoft, width: 1.5),
          foregroundColor: isDark ? AppColors.mint : AppColors.teal,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.nightSurfaceHi : AppColors.sand,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.teal, width: 1.5),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06),
      ),
      textTheme: base.textTheme
          .apply(
            bodyColor: textColor,
            displayColor: textColor,
          )
          .copyWith(
            titleLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: textColor,
              letterSpacing: -0.3,
            ),
            titleMedium: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
            bodyMedium: TextStyle(
              fontSize: 15,
              height: 1.45,
              color: isDark ? AppColors.textDark : AppColors.ink,
            ),
            bodySmall: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: isDark ? AppColors.textDarkSoft : AppColors.inkSoft,
            ),
          ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.nightSurfaceHi : AppColors.ink,
      ),
    );
  }
}
