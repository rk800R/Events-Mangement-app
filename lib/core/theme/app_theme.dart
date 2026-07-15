import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_typography.dart';
import 'theme_extensions.dart';

class AppTheme {
  AppTheme._();

  // ════════════════════════════════════════════════════════════════
  //  Light Theme
  // ════════════════════════════════════════════════════════════════
  static ThemeData get lightTheme {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.light,
    );

    final colorScheme = base.copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE5E1FF),
      onPrimaryContainer: const Color(0xFF1A1147),
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFFFDAD5),
      onSecondaryContainer: const Color(0xFF410002),
      tertiary: const Color(0xFF009688),
      onTertiary: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightText,
      surfaceContainerHighest: const Color(0xFFE8E8F0),
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: AppColors.lightBorder,
      outlineVariant: AppColors.lightDivider,
      shadow: const Color(0xFF000000),
      scrim: const Color(0xFF000000),
      inverseSurface: const Color(0xFF2D2D3F),
      onInverseSurface: const Color(0xFFF3F3F8),
      inversePrimary: AppColors.primaryLight,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410E0B),
    );

    return _buildTheme(
      colorScheme: colorScheme,
      brightness: Brightness.light,
      extensions: const [AppColorsExtension.light],
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  Dark Theme
  // ════════════════════════════════════════════════════════════════
  static ThemeData get darkTheme {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.dark,
    );

    final colorScheme = base.copyWith(
      primary: AppColors.primaryLight,
      onPrimary: const Color(0xFF2A1E70),
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: const Color(0xFFE5E1FF),
      secondary: AppColors.accent,
      onSecondary: const Color(0xFF5F0B07),
      secondaryContainer: const Color(0xFF8A1A12),
      onSecondaryContainer: const Color(0xFFFFDAD5),
      tertiary: const Color(0xFF4DB6AC),
      onTertiary: const Color(0xFF003734),
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkText,
      surfaceContainerHighest: const Color(0xFF33333F),
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkDivider,
      shadow: const Color(0xFF000000),
      scrim: const Color(0xFF000000),
      inverseSurface: const Color(0xFFF3F3F8),
      onInverseSurface: const Color(0xFF2D2D3F),
      inversePrimary: AppColors.primary,
      error: const Color(0xFFEF5350),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
    );

    return _buildTheme(
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      extensions: const [AppColorsExtension.dark],
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  Theme Builder
  // ════════════════════════════════════════════════════════════════
  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Brightness brightness,
    required List<ThemeExtension<dynamic>> extensions,
  }) {
    final isLight = brightness == Brightness.light;
    final textTheme = AppTypography.textThemeFor(brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isLight ? AppColors.lightBackground : AppColors.darkBackground,
      canvasColor: colorScheme.surface,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: textTheme,
      extensions: extensions,

      // ─── AppBar ──────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        toolbarHeight: AppDimens.appBarHeight,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: AppColors.lightBackground,
                systemNavigationBarIconBrightness: Brightness.dark,
              )
            : SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: AppColors.darkBackground,
                systemNavigationBarIconBrightness: Brightness.light,
              ),
      ),

      // ─── Card ────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: isLight ? 0.5 : 0,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          side: BorderSide(
            color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
            width: AppDimens.borderThin,
          ),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // ─── FAB ─────────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: AppDimens.elevation3,
        focusElevation: AppDimens.elevation4,
        hoverElevation: AppDimens.elevation4,
        highlightElevation: AppDimens.elevation6,
        disabledElevation: AppDimens.elevation0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        ),
        extendedPadding:
            const EdgeInsets.symmetric(horizontal: AppDimens.space20),
      ),

      // ─── Elevated Button ─────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor:
              colorScheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor:
              colorScheme.onSurface.withValues(alpha: 0.38),
          elevation: AppDimens.elevation0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space24,
            vertical: AppDimens.space14,
          ),
          minimumSize:
              const Size(AppDimens.touchTarget, AppDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ─── Filled Button ───────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor:
              colorScheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor:
              colorScheme.onSurface.withValues(alpha: 0.38),
          elevation: AppDimens.elevation0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space24,
            vertical: AppDimens.space14,
          ),
          minimumSize:
              const Size(AppDimens.touchTarget, AppDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ─── Text Button ─────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space16,
            vertical: AppDimens.space10,
          ),
          minimumSize:
              const Size(AppDimens.touchTarget, AppDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ─── Outlined Button ─────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          disabledForegroundColor:
              colorScheme.onSurface.withValues(alpha: 0.38),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space24,
            vertical: AppDimens.space14,
          ),
          minimumSize:
              const Size(AppDimens.touchTarget, AppDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
          side: BorderSide(
            color: colorScheme.outline,
            width: AppDimens.borderRegular,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ─── Icon Button ─────────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          disabledForegroundColor:
              colorScheme.onSurface.withValues(alpha: 0.38),
          iconSize: AppDimens.iconLg,
          minimumSize: const Size(AppDimens.touchTarget, AppDimens.touchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          ),
        ),
      ),

      // ─── Input Decoration ────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? const Color(0xFFF2F2F7)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        helperStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.error,
        ),
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space16,
          vertical: AppDimens.space14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: AppDimens.borderRegular,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
            width: AppDimens.borderRegular,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppDimens.borderThick,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppDimens.borderRegular,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppDimens.borderThick,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: AppDimens.borderRegular,
          ),
        ),
      ),

      // ─── Divider ─────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: isLight ? AppColors.lightDivider : AppColors.darkDivider,
        thickness: AppDimens.borderRegular,
        space: AppDimens.space1,
      ),

      // ─── Chip ────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        labelStyle:
            textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
        secondaryLabelStyle: textTheme.labelLarge
            ?.copyWith(color: colorScheme.onPrimaryContainer),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: AppDimens.borderThin,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space8,
          vertical: AppDimens.space4,
        ),
        checkmarkColor: colorScheme.onPrimaryContainer,
      ),

      // ─── ListTile ────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space16,
          vertical: AppDimens.space4,
        ),
        horizontalTitleGap: AppDimens.space12,
        minVerticalPadding: AppDimens.space8,
        minLeadingWidth: AppDimens.iconLg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle:
            textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
      ),

      // ─── Dialog ──────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppDimens.elevation0,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
        actionsPadding: const EdgeInsets.fromLTRB(
          AppDimens.space16,
          AppDimens.space8,
          AppDimens.space16,
          AppDimens.space16,
        ),
      ),

      // ─── Bottom Sheet ────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: colorScheme.surface,
        modalBarrierColor: colorScheme.scrim.withValues(alpha: 0.5),
        modalElevation: AppDimens.elevation0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radius2Xl),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        dragHandleSize: const Size(36, 4),
      ),

      // ─── SnackBar ───────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            isLight ? const Color(0xFF2D2D3F) : const Color(0xFFE8E8F0),
        contentTextStyle: isLight
            ? textTheme.bodyMedium?.copyWith(color: Colors.white)
            : textTheme.bodyMedium?.copyWith(color: const Color(0xFF1A1A2E)),
        actionTextColor: isLight ? AppColors.primaryLight : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        elevation: AppDimens.elevation4,
      ),

      // ─── Tab Bar ─────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle:
            textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
        dividerColor: colorScheme.outlineVariant,
        dividerHeight: AppDimens.borderRegular,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space16,
          vertical: AppDimens.space12,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppDimens.borderThick,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
      ),

      // ─── Switch ──────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.surfaceContainerHighest;
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.12);
          }
          return Colors.transparent;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary.withValues(alpha: 0.12);
          }
          return null;
        }),
        splashRadius: AppDimens.iconLg,
      ),

      // ─── Checkbox ────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return Colors.transparent;
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.onSurfaceVariant;
        }),
        side: BorderSide(
          color: colorScheme.onSurfaceVariant,
          width: AppDimens.borderThick,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXs),
        ),
        visualDensity: VisualDensity.compact,
      ),

      // ─── Radio ───────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurfaceVariant;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary.withValues(alpha: 0.12);
          }
          return null;
        }),
        splashRadius: AppDimens.iconLg,
      ),

      // ─── Slider ──────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        valueIndicatorColor: colorScheme.primary,
        valueIndicatorTextStyle:
            textTheme.labelSmall?.copyWith(color: colorScheme.onPrimary),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 12,
          elevation: AppDimens.elevation2,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
        valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
      ),

      // ─── Progress Indicator ──────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        linearMinHeight: 4,
        circularTrackColor: colorScheme.surfaceContainerHighest,
        refreshBackgroundColor: colorScheme.surfaceContainerHighest,
      ),

      // ─── Bottom Navigation Bar (legacy) ──────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimens.elevation0,
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
        showUnselectedLabels: true,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
      ),

      // ─── Navigation Bar (M3) ─────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colorScheme.primaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium!
                .copyWith(color: colorScheme.onSurface);
          }
          return textTheme.labelMedium!
              .copyWith(color: colorScheme.onSurfaceVariant);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: colorScheme.onPrimaryContainer,
              size: AppDimens.iconLg,
            );
          }
          return IconThemeData(
            color: colorScheme.onSurfaceVariant,
            size: AppDimens.iconLg,
          );
        }),
        height: AppDimens.bottomNavHeight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: AppDimens.elevation0,
      ),

      // ─── Navigation Rail ─────────────────────────────────────────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(
          color: colorScheme.primary,
          size: AppDimens.iconLg,
        ),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: AppDimens.iconLg,
        ),
        selectedLabelTextStyle:
            textTheme.labelLarge?.copyWith(color: colorScheme.primary),
        unselectedLabelTextStyle:
            textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        indicatorColor: colorScheme.primaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        ),
        minWidth: 72,
        minExtendedWidth: 160,
        groupAlignment: 0,
      ),

      // ─── Navigation Drawer (M3) ──────────────────────────────────
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        elevation: AppDimens.elevation0,
        indicatorColor: colorScheme.primaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelLarge!
                .copyWith(color: colorScheme.onPrimaryContainer);
          }
          return textTheme.labelLarge!
              .copyWith(color: colorScheme.onSurfaceVariant);
        }),
        tileHeight: 56,
      ),

      // ─── Drawer (legacy) ─────────────────────────────────────────
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrimColor: colorScheme.scrim.withValues(alpha: 0.5),
        elevation: AppDimens.elevation0,
        width: 320,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(AppDimens.radius2Xl),
          ),
        ),
      ),

      // ─── Tooltip ─────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        textStyle:
            textTheme.labelSmall?.copyWith(color: colorScheme.onInverseSurface),
        waitDuration: const Duration(milliseconds: 500),
        showDuration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space12,
          vertical: AppDimens.space6,
        ),
        margin: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
      ),

      // ─── Popup Menu ──────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppDimens.elevation3,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        textStyle: textTheme.bodyMedium,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelLarge!.copyWith(color: colorScheme.onSurface),
        ),
        iconColor: colorScheme.onSurfaceVariant,
      ),

      // ─── Date Picker ─────────────────────────────────────────────
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppDimens.elevation0,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius2Xl),
        ),
        headerBackgroundColor: Colors.transparent,
        headerForegroundColor: colorScheme.onSurface,
        headerHeadlineStyle: textTheme.headlineSmall,
        headerHelpStyle: textTheme.labelMedium,
        weekdayStyle:
            textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
        dayStyle: textTheme.bodyMedium,
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.onSurface;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        dayOverlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary.withValues(alpha: 0.12);
          }
          return null;
        }),
        todayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.primary;
        }),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        todayBorder: BorderSide(
          color: colorScheme.primary,
          width: AppDimens.borderThick,
        ),
        yearStyle: textTheme.titleMedium,
        yearForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.onSurface;
        }),
        yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(colorScheme.primary),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(colorScheme.primary),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        ),
      ),

      // ─── Time Picker ─────────────────────────────────────────────
      timePickerTheme: TimePickerThemeData(
        backgroundColor: colorScheme.surface,
        elevation: AppDimens.elevation0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius2Xl),
        ),
        hourMinuteColor: colorScheme.surfaceContainerHighest,
        hourMinuteTextColor: colorScheme.onSurfaceVariant,
        dayPeriodColor: colorScheme.surfaceContainerHighest,
        dayPeriodTextColor: colorScheme.onSurfaceVariant,
        dialHandColor: colorScheme.primary,
        dialBackgroundColor: colorScheme.surfaceContainerHighest,
        dialTextColor: colorScheme.onSurfaceVariant,
        entryModeIconColor: colorScheme.primary,
        helpTextStyle: textTheme.labelMedium
            ?.copyWith(color: colorScheme.onSurfaceVariant),
        hourMinuteTextStyle: AppTypography.displaySmall,
        dayPeriodTextStyle: textTheme.titleMedium,
      ),

      // ─── Expansion Tile ──────────────────────────────────────────
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        iconColor: colorScheme.onSurfaceVariant,
        collapsedIconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        collapsedTextColor: colorScheme.onSurface,
        tilePadding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
        childrenPadding: const EdgeInsets.only(
          left: AppDimens.space16,
          right: AppDimens.space16,
          bottom: AppDimens.space8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // ─── Scrollbar ───────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.onSurfaceVariant.withValues(alpha: 0.5);
          }
          return colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
        }),
        trackColor: const WidgetStatePropertyAll(Colors.transparent),
        trackBorderColor: const WidgetStatePropertyAll(Colors.transparent),
        radius: const Radius.circular(AppDimens.radiusFull),
        thickness: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) return 8;
          return 6;
        }),
        thumbVisibility: const WidgetStatePropertyAll(false),
        crossAxisMargin: 2,
        mainAxisMargin: 4,
        minThumbLength: 48,
      ),

      // ─── Search Bar ──────────────────────────────────────────────
      searchBarTheme: SearchBarThemeData(
        backgroundColor:
            WidgetStatePropertyAll(colorScheme.surfaceContainerHighest),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(AppDimens.elevation0),
        shadowColor: WidgetStatePropertyAll(
          colorScheme.shadow.withValues(alpha: 0.1),
        ),
        textStyle: WidgetStatePropertyAll(textTheme.bodyLarge),
        hintStyle: WidgetStatePropertyAll(
          textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: AppDimens.space16,
            vertical: AppDimens.space8,
          ),
        ),
      ),

      // ─── Badge ───────────────────────────────────────────────────
      badgeTheme: BadgeThemeData(
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
        textStyle: textTheme.labelSmall,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space6,
          vertical: AppDimens.space2,
        ),
        alignment: const AlignmentDirectional(0.6, -0.6),
        smallSize: 6,
        largeSize: 16,
      ),

      // ─── Text Selection ──────────────────────────────────────────
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withValues(alpha: 0.25),
        selectionHandleColor: colorScheme.primary,
      ),

      // ─── Page Transitions ────────────────────────────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
