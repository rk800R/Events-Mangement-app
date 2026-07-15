import 'package:flutter/material.dart';

/// Theme extension carrying app-specific semantic colors that don't
/// fit into the standard Material 3 [ColorScheme].
///
/// Access via: `context.appColors`
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.categoryWork,
    required this.categoryPersonal,
    required this.categoryHealth,
    required this.categoryEducation,
    required this.categorySocial,
    required this.categoryTravel,
    required this.categoryFinance,
    required this.categoryOther,
    required this.priorityHigh,
    required this.priorityMedium,
    required this.priorityLow,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  // Semantic status
  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color infoContainer;
  final Color onInfoContainer;

  // Event categories
  final Color categoryWork;
  final Color categoryPersonal;
  final Color categoryHealth;
  final Color categoryEducation;
  final Color categorySocial;
  final Color categoryTravel;
  final Color categoryFinance;
  final Color categoryOther;

  // Priority
  final Color priorityHigh;
  final Color priorityMedium;
  final Color priorityLow;

  // Utility
  final Color shimmerBase;
  final Color shimmerHighlight;

  static const light = AppColorsExtension(
    success: Color(0xFF2E7D32),
    successContainer: Color(0xFFC8E6C9),
    onSuccessContainer: Color(0xFF1B5E20),
    warning: Color(0xFFF57C00),
    warningContainer: Color(0xFFFFE0B2),
    onWarningContainer: Color(0xFFE65100),
    info: Color(0xFF1976D2),
    infoContainer: Color(0xFFBBDEFB),
    onInfoContainer: Color(0xFF0D47A1),
    categoryWork: Color(0xFF6C63FF),
    categoryPersonal: Color(0xFF4CAF50),
    categoryHealth: Color(0xFFFF6B6B),
    categoryEducation: Color(0xFF2196F3),
    categorySocial: Color(0xFFFF9800),
    categoryTravel: Color(0xFF009688),
    categoryFinance: Color(0xFF9C27B0),
    categoryOther: Color(0xFF9E9E9E),
    priorityHigh: Color(0xFFE53935),
    priorityMedium: Color(0xFFFF9800),
    priorityLow: Color(0xFF4CAF50),
    shimmerBase: Color(0xFFE0E0E0),
    shimmerHighlight: Color(0xFFF5F5F5),
  );

  static const dark = AppColorsExtension(
    success: Color(0xFF81C784),
    successContainer: Color(0xFF1B5E20),
    onSuccessContainer: Color(0xFFC8E6C9),
    warning: Color(0xFFFFB74D),
    warningContainer: Color(0xFFE65100),
    onWarningContainer: Color(0xFFFFE0B2),
    info: Color(0xFF64B5F6),
    infoContainer: Color(0xFF0D47A1),
    onInfoContainer: Color(0xFFBBDEFB),
    categoryWork: Color(0xFF9D97FF),
    categoryPersonal: Color(0xFF81C784),
    categoryHealth: Color(0xFFFF8A80),
    categoryEducation: Color(0xFF64B5F6),
    categorySocial: Color(0xFFFFB74D),
    categoryTravel: Color(0xFF4DB6AC),
    categoryFinance: Color(0xFFBA68C8),
    categoryOther: Color(0xFFBDBDBD),
    priorityHigh: Color(0xFFEF5350),
    priorityMedium: Color(0xFFFFB74D),
    priorityLow: Color(0xFF66BB6A),
    shimmerBase: Color(0xFF2A2A33),
    shimmerHighlight: Color(0xFF3A3A44),
  );

  /// Returns the color for a category [name] (case-insensitive).
  Color categoryColor(String? name) {
    switch (name?.toLowerCase()) {
      case 'work':
        return categoryWork;
      case 'personal':
        return categoryPersonal;
      case 'health':
        return categoryHealth;
      case 'education':
        return categoryEducation;
      case 'social':
        return categorySocial;
      case 'travel':
        return categoryTravel;
      case 'finance':
        return categoryFinance;
      default:
        return categoryOther;
    }
  }

  @override
  AppColorsExtension copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? categoryWork,
    Color? categoryPersonal,
    Color? categoryHealth,
    Color? categoryEducation,
    Color? categorySocial,
    Color? categoryTravel,
    Color? categoryFinance,
    Color? categoryOther,
    Color? priorityHigh,
    Color? priorityMedium,
    Color? priorityLow,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return AppColorsExtension(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      categoryWork: categoryWork ?? this.categoryWork,
      categoryPersonal: categoryPersonal ?? this.categoryPersonal,
      categoryHealth: categoryHealth ?? this.categoryHealth,
      categoryEducation: categoryEducation ?? this.categoryEducation,
      categorySocial: categorySocial ?? this.categorySocial,
      categoryTravel: categoryTravel ?? this.categoryTravel,
      categoryFinance: categoryFinance ?? this.categoryFinance,
      categoryOther: categoryOther ?? this.categoryOther,
      priorityHigh: priorityHigh ?? this.priorityHigh,
      priorityMedium: priorityMedium ?? this.priorityMedium,
      priorityLow: priorityLow ?? this.priorityLow,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other == null) return this;
    return AppColorsExtension(
      success: Color.lerp(success, other.success, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      categoryWork: Color.lerp(categoryWork, other.categoryWork, t)!,
      categoryPersonal:
          Color.lerp(categoryPersonal, other.categoryPersonal, t)!,
      categoryHealth: Color.lerp(categoryHealth, other.categoryHealth, t)!,
      categoryEducation:
          Color.lerp(categoryEducation, other.categoryEducation, t)!,
      categorySocial: Color.lerp(categorySocial, other.categorySocial, t)!,
      categoryTravel: Color.lerp(categoryTravel, other.categoryTravel, t)!,
      categoryFinance: Color.lerp(categoryFinance, other.categoryFinance, t)!,
      categoryOther: Color.lerp(categoryOther, other.categoryOther, t)!,
      priorityHigh: Color.lerp(priorityHigh, other.priorityHigh, t)!,
      priorityMedium: Color.lerp(priorityMedium, other.priorityMedium, t)!,
      priorityLow: Color.lerp(priorityLow, other.priorityLow, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight:
          Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}
