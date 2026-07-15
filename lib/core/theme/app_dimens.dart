import 'package:flutter/material.dart';

/// Design tokens for spacing, radius, elevation, and timing.
///
/// Use these throughout the app for consistent visual rhythm.
class AppDimens {
  AppDimens._();

  // ─── Spacing (4-pt grid) ────────────────────────────────────────
  static const double space1 = 1;
  static const double space2 = 2;
  static const double space3 = 3;
  static const double space4 = 4;
  static const double space6 = 6;
  static const double space8 = 8;
  static const double space10 = 10;
  static const double space12 = 12;
  static const double space14 = 14;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space28 = 28;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space48 = 48;
  static const double space56 = 56;
  static const double space64 = 64;

  // ─── Radius ─────────────────────────────────────────────────────
  static const double radiusXs = 6;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radius2Xl = 28;
  static const double radiusFull = 999;

  // ─── Elevation ──────────────────────────────────────────────────
  static const double elevation0 = 0;
  static const double elevation1 = 1;
  static const double elevation2 = 2;
  static const double elevation3 = 3;
  static const double elevation4 = 4;
  static const double elevation6 = 6;
  static const double elevation8 = 8;

  // ─── Icon Sizes ─────────────────────────────────────────────────
  static const double iconXs = 14;
  static const double iconSm = 18;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;

  // ─── Touch Targets ──────────────────────────────────────────────
  static const double touchTarget = 48;

  // ─── Component Heights ──────────────────────────────────────────
  static const double buttonHeight = 52;
  static const double inputHeight = 56;
  static const double appBarHeight = 56;
  static const double fabSize = 56;
  static const double bottomNavHeight = 72;

  // ─── Border Width ───────────────────────────────────────────────
  static const double borderThin = 0.5;
  static const double borderRegular = 1;
  static const double borderThick = 2;

  // ─── Animation ──────────────────────────────────────────────────
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  static const Curve curveStandard = Curves.easeInOut;
  static const Curve curveDecelerate = Curves.decelerate;
}
