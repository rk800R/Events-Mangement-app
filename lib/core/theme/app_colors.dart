import 'package:flutter/material.dart';

/// Centralized color definitions.
///
/// Brand colors override the Material 3 seed-generated [ColorScheme]
/// to maintain custom identity while leveraging M3 tonal palettes
/// for all other surface, container, and variant roles.
class AppColors {
  AppColors._();

  /// Seed used to generate the full M3 tonal palette.
  static const Color seed = Color(0xFF6C63FF);

  // ─── Brand ──────────────────────────────────────────────────────
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42D4);
  static const Color accent = Color(0xFFFF6B6B);

  // ─── Semantic Status ────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF1976D2);

  // ─── Light Surface Palette ──────────────────────────────────────
  static const Color lightBackground = Color(0xFFFAFAFE);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF6C757D);
  static const Color lightBorder = Color(0xFFE4E4EC);
  static const Color lightDivider = Color(0xFFEFEFF4);

  // ─── Dark Surface Palette ───────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F0F14);
  static const Color darkSurface = Color(0xFF1B1B24);
  static const Color darkCard = Color(0xFF262631);
  static const Color darkText = Color(0xFFF3F3F8);
  static const Color darkTextSecondary = Color(0xFFA0A0B0);
  static const Color darkBorder = Color(0xFF36363F);
  static const Color darkDivider = Color(0xFF2A2A33);

  // ─── Event Categories (raw values — see ThemeExtension for themed access) ──
  static const Map<String, Color> categoryColors = {
    'work': Color(0xFF6C63FF),
    'personal': Color(0xFF4CAF50),
    'health': Color(0xFFFF6B6B),
    'education': Color(0xFF2196F3),
    'social': Color(0xFFFF9800),
    'travel': Color(0xFF009688),
    'finance': Color(0xFF9C27B0),
    'other': Color(0xFF9E9E9E),
  };

  // ─── Priority (raw values — see ThemeExtension for themed access) ──
  static const Color priorityHigh = Color(0xFFE53935);
  static const Color priorityMedium = Color(0xFFFF9800);
  static const Color priorityLow = Color(0xFF4CAF50);
}
