import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Cache the Cairo font family name to avoid runtime downloads
  static final String? _cairoFontFamily = GoogleFonts.cairo().fontFamily;
  // ============= LIGHT THEME =============
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.lightPrimaryLight,
      onPrimaryContainer: AppColors.lightPrimaryDark,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.lightSecondaryLight,
      onSecondaryContainer: AppColors.lightSecondaryDark,
      tertiary: AppColors.lightWarning,
      tertiaryContainer: AppColors.lightWarning.withAlpha(51),
      error: AppColors.lightError,
      onError: AppColors.white,
      errorContainer: AppColors.lightError.withAlpha(26),
      onErrorContainer: AppColors.lightError,
      background: AppColors.lightBackground,
      onBackground: AppColors.lightTextPrimary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceVariant: AppColors.lightSurfaceVariant,
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: AppColors.lightBorder,
      outlineVariant: AppColors.lightDivider,
      scrim: AppColors.black,
      inverseSurface: AppColors.gray900,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.lightPrimaryLight,
    ),

    // Scaffold and General Background
    scaffoldBackgroundColor: AppColors.lightBackground,

    // App Bar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightTextPrimary,
      centerTitle: true,
      toolbarHeight: 64,
      titleTextStyle: AppTextStyles.h4(color: AppColors.lightTextPrimary),
      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
      surfaceTintColor: AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.lightSurface,
      shadowColor: AppColors.black.withAlpha(26),
      clipBehavior: Clip.antiAlias,
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle:
          AppTextStyles.labelMedium(color: AppColors.lightTextSecondary),
      hintStyle: AppTextStyles.bodyMedium(color: AppColors.lightTextTertiary),
      floatingLabelStyle:
          AppTextStyles.labelMedium(color: AppColors.lightPrimary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.lightPrimary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.lightError,
          width: 2,
        ),
      ),
      prefixIconColor: AppColors.lightTextSecondary,
      suffixIconColor: AppColors.lightTextSecondary,
      errorStyle: AppTextStyles.captionSmall(color: AppColors.lightError),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 4,
      highlightElevation: 8,
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      sizeConstraints: const BoxConstraints.tightFor(width: 56, height: 56),
      extendedSizeConstraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.white,
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.labelLarge(color: AppColors.white),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        side: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
        foregroundColor: AppColors.lightPrimary,
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.labelLarge(color: AppColors.lightPrimary),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.lightPrimary,
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: AppTextStyles.labelLarge(color: AppColors.lightPrimary),
      ),
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      tileColor: AppColors.lightSurface,
      selectedTileColor: AppColors.lightPrimaryLight.withAlpha(26),
      selectedColor: AppColors.lightPrimary,
      textColor: AppColors.lightTextPrimary,
      iconColor: AppColors.lightTextSecondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSurfaceVariant,
      selectedColor: AppColors.lightPrimary,
      disabledColor: AppColors.lightTextTertiary.withAlpha(76),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      labelStyle: AppTextStyles.labelMedium(color: AppColors.lightTextPrimary),
      secondaryLabelStyle:
          AppTextStyles.labelMedium(color: AppColors.lightTextPrimary),
      brightness: Brightness.light,
      side: const BorderSide(color: AppColors.lightBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightSurface,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: AppTextStyles.h4(color: AppColors.lightTextPrimary),
      contentTextStyle:
          AppTextStyles.bodyMedium(color: AppColors.lightTextSecondary),
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.lightSurface,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.lightDivider,
      thickness: 1,
      space: 16,
    ),

    // Snack Bar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.lightTextPrimary,
      contentTextStyle: AppTextStyles.bodyMedium(color: AppColors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.lightPrimary,
      unselectedLabelColor: AppColors.lightTextSecondary,
      labelStyle: AppTextStyles.labelMedium(color: AppColors.lightPrimary),
      unselectedLabelStyle:
          AppTextStyles.labelMedium(color: AppColors.lightTextSecondary),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: AppColors.lightPrimary,
          width: 3,
        ),
        insets: const EdgeInsets.symmetric(horizontal: 16),
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.lightTextPrimary,
      size: 24,
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1(color: AppColors.lightTextPrimary),
      displayMedium: AppTextStyles.h2(color: AppColors.lightTextPrimary),
      displaySmall: AppTextStyles.h3(color: AppColors.lightTextPrimary),
      headlineLarge: AppTextStyles.h4(color: AppColors.lightTextPrimary),
      headlineMedium: AppTextStyles.h5(color: AppColors.lightTextPrimary),
      headlineSmall: AppTextStyles.h6(color: AppColors.lightTextPrimary),
      titleLarge: AppTextStyles.bodyLarge(color: AppColors.lightTextPrimary),
      titleMedium: AppTextStyles.bodyMedium(color: AppColors.lightTextPrimary),
      titleSmall: AppTextStyles.bodySmall(color: AppColors.lightTextPrimary),
      bodyLarge: AppTextStyles.bodyLarge(color: AppColors.lightTextPrimary),
      bodyMedium: AppTextStyles.bodyMedium(color: AppColors.lightTextPrimary),
      bodySmall: AppTextStyles.bodySmall(color: AppColors.lightTextPrimary),
      labelLarge: AppTextStyles.labelLarge(color: AppColors.lightTextPrimary),
      labelMedium: AppTextStyles.labelMedium(color: AppColors.lightTextPrimary),
      labelSmall: AppTextStyles.labelSmall(color: AppColors.lightTextPrimary),
    ),

    // Font Family
    fontFamily: _cairoFontFamily,
  );

  // ============= DARK THEME =============
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkBackground,
      primaryContainer: AppColors.darkPrimaryDark,
      onPrimaryContainer: AppColors.darkPrimaryLight,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkBackground,
      secondaryContainer: AppColors.darkSecondaryDark,
      onSecondaryContainer: AppColors.darkSecondaryLight,
      tertiary: AppColors.darkWarning,
      tertiaryContainer: AppColors.darkWarning.withAlpha(51),
      error: AppColors.darkError,
      onError: AppColors.darkBackground,
      errorContainer: AppColors.darkError.withAlpha(26),
      onErrorContainer: AppColors.darkError,
      background: AppColors.darkBackground,
      onBackground: AppColors.darkTextPrimary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceVariant: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkDivider,
      scrim: AppColors.black,
      inverseSurface: AppColors.gray100,
      onInverseSurface: AppColors.gray900,
      inversePrimary: AppColors.darkPrimaryDark,
    ),

    // Scaffold and General Background
    scaffoldBackgroundColor: AppColors.darkBackground,

    // App Bar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      centerTitle: true,
      toolbarHeight: 64,
      titleTextStyle: AppTextStyles.h4(color: AppColors.darkTextPrimary),
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
      surfaceTintColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.darkSurface,
      shadowColor: AppColors.black.withAlpha(128),
      clipBehavior: Clip.antiAlias,
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: AppTextStyles.labelMedium(color: AppColors.darkTextSecondary),
      hintStyle: AppTextStyles.bodyMedium(color: AppColors.darkTextTertiary),
      floatingLabelStyle:
          AppTextStyles.labelMedium(color: AppColors.darkPrimary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.darkPrimary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.darkError,
          width: 2,
        ),
      ),
      prefixIconColor: AppColors.darkTextSecondary,
      suffixIconColor: AppColors.darkTextSecondary,
      errorStyle: AppTextStyles.captionSmall(color: AppColors.darkError),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 4,
      highlightElevation: 8,
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: AppColors.darkBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      sizeConstraints: const BoxConstraints.tightFor(width: 56, height: 56),
      extendedSizeConstraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkBackground,
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.labelLarge(color: AppColors.darkBackground),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        side: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
        foregroundColor: AppColors.darkPrimary,
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.labelLarge(color: AppColors.darkPrimary),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.darkPrimary,
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: AppTextStyles.labelLarge(color: AppColors.darkPrimary),
      ),
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      tileColor: AppColors.darkSurface,
      selectedTileColor: AppColors.darkPrimaryDark.withAlpha(51),
      selectedColor: AppColors.darkPrimary,
      textColor: AppColors.darkTextPrimary,
      iconColor: AppColors.darkTextSecondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurfaceVariant,
      selectedColor: AppColors.darkPrimary,
      disabledColor: AppColors.darkTextTertiary.withAlpha(76),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      labelStyle: AppTextStyles.labelMedium(color: AppColors.darkTextPrimary),
      secondaryLabelStyle:
          AppTextStyles.labelMedium(color: AppColors.darkTextPrimary),
      brightness: Brightness.dark,
      side: const BorderSide(color: AppColors.darkBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurface,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: AppTextStyles.h4(color: AppColors.darkTextPrimary),
      contentTextStyle:
          AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary),
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.darkSurface,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
      space: 16,
    ),

    // Snack Bar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkSurfaceVariant,
      contentTextStyle:
          AppTextStyles.bodyMedium(color: AppColors.darkTextPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.darkPrimary,
      unselectedLabelColor: AppColors.darkTextSecondary,
      labelStyle: AppTextStyles.labelMedium(color: AppColors.darkPrimary),
      unselectedLabelStyle:
          AppTextStyles.labelMedium(color: AppColors.darkTextSecondary),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: AppColors.darkPrimary,
          width: 3,
        ),
        insets: EdgeInsets.symmetric(horizontal: 16),
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.darkTextPrimary,
      size: 24,
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1(color: AppColors.darkTextPrimary),
      displayMedium: AppTextStyles.h2(color: AppColors.darkTextPrimary),
      displaySmall: AppTextStyles.h3(color: AppColors.darkTextPrimary),
      headlineLarge: AppTextStyles.h4(color: AppColors.darkTextPrimary),
      headlineMedium: AppTextStyles.h5(color: AppColors.darkTextPrimary),
      headlineSmall: AppTextStyles.h6(color: AppColors.darkTextPrimary),
      titleLarge: AppTextStyles.bodyLarge(color: AppColors.darkTextPrimary),
      titleMedium: AppTextStyles.bodyMedium(color: AppColors.darkTextPrimary),
      titleSmall: AppTextStyles.bodySmall(color: AppColors.darkTextPrimary),
      bodyLarge: AppTextStyles.bodyLarge(color: AppColors.darkTextPrimary),
      bodyMedium: AppTextStyles.bodyMedium(color: AppColors.darkTextPrimary),
      bodySmall: AppTextStyles.bodySmall(color: AppColors.darkTextPrimary),
      labelLarge: AppTextStyles.labelLarge(color: AppColors.darkTextPrimary),
      labelMedium: AppTextStyles.labelMedium(color: AppColors.darkTextPrimary),
      labelSmall: AppTextStyles.labelSmall(color: AppColors.darkTextPrimary),
    ),

    // Font Family
    fontFamily: _cairoFontFamily,
  );
}
