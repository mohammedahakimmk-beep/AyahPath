import 'package:flutter/material.dart';

/// Central palette for AyahPath.
/// Calm, warm, Quranic-inspired colors with restrained accents.
/// Avoids flashy gradients and keeps the interface peaceful.
class AppColors {
  AppColors._();

  // Light palette
  static const Color cream = Color(0xFFFBF7EE);
  static const Color sand = Color(0xFFF2EBDB);
  static const Color deepTeal = Color(0xFF1F5F57);
  static const Color teal = Color(0xFF2E7D6B);
  static const Color tealSoft = Color(0xFFBFDED5);
  static const Color gold = Color(0xFFB08D3E);
  static const Color goldSoft = Color(0xFFE8D9B8);
  static const Color ink = Color(0xFF24302D);
  static const Color inkSoft = Color(0xFF5C6B67);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB04A3A);

  // Dark palette
  static const Color night = Color(0xFF0E1A18);
  static const Color nightSurface = Color(0xFF162622);
  static const Color nightSurfaceHi = Color(0xFF1E3530);
  static const Color mint = Color(0xFF7FC9B6);
  static const Color mintSoft = Color(0xFF33564E);
  static const Color goldDark = Color(0xFFC9A55F);
  static const Color creamDark = Color(0xFFE5E9E4);
  static const Color textDark = Color(0xFFECE7DA);
  static const Color textDarkSoft = Color(0xFFA8B5B0);
}

/// Skill accent colors used on progress rings & bars.
class SkillColors {
  SkillColors._();
  static const Color reading = Color(0xFF2E7D6B);
  static const Color tajweed = Color(0xFFB08D3E);
  static const Color memorization = Color(0xFF5B6BB0);
  static const Color revision = Color(0xFF8A5BB0);
  static const Color comprehension = Color(0xFFB05B6B);
}
