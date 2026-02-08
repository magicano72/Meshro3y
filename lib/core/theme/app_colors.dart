import 'package:flutter/material.dart';

/// Comprehensive color palette for Equipment Manager app
/// Supports both light and dark themes with semantic colors
class AppColors {
  // Light Theme - Primary Colors
  static const Color lightPrimary = Color(0xFF2196F3);
  static const Color lightPrimaryDark = Color(0xFF1976D2);
  static const Color lightPrimaryLight = Color(0xFF64B5F6);

  // Light Theme - Secondary Colors
  static const Color lightSecondary = Color(0xFF00BCD4);
  static const Color lightSecondaryDark = Color(0xFF0097A7);
  static const Color lightSecondaryLight = Color(0xFF4DD0E1);

  // Light Theme - Background & Surface
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF5F5F5);

  // Light Theme - Semantic Colors
  static const Color lightSuccess = Color(0xFF4CAF50);
  static const Color lightError = Color(0xFFF44336);
  static const Color lightWarning = Color(0xFFFFC107);
  static const Color lightInfo = Color(0xFF2196F3);

  // Light Theme - Text & Borders
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightTextTertiary = Color(0xFFBDBDBD);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightDivider = Color(0xFFEEEEEE);

  // Dark Theme - Primary Colors
  static const Color darkPrimary = Color(0xFF64B5F6);
  static const Color darkPrimaryDark = Color(0xFF42A5F5);
  static const Color darkPrimaryLight = Color(0xFF90CAF9);

  // Dark Theme - Secondary Colors
  static const Color darkSecondary = Color(0xFF4DD0E1);
  static const Color darkSecondaryDark = Color(0xFF26C6DA);
  static const Color darkSecondaryLight = Color(0xFF80DEEA);

  // Dark Theme - Background & Surface
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);

  // Dark Theme - Semantic Colors
  static const Color darkSuccess = Color(0xFF81C784);
  static const Color darkError = Color(0xFFEF5350);
  static const Color darkWarning = Color(0xFFFFD54F);
  static const Color darkInfo = Color(0xFF64B5F6);

  // Dark Theme - Text & Borders
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextTertiary = Color(0xFF808080);
  static const Color darkBorder = Color(0xFF404040);
  static const Color darkDivider = Color(0xFF333333);

  // Gradient Colors - Light Theme
  static const List<Color> lightGradientBlue = [
    Color(0xFF2196F3),
    Color(0xFF64B5F6),
  ];
  static const List<Color> lightGradientGreen = [
    Color(0xFF4CAF50),
    Color(0xFF81C784),
  ];
  static const List<Color> lightGradientOrange = [
    Color(0xFFFF6F00),
    Color(0xFFFFB74D),
  ];
  static const List<Color> lightGradientPurple = [
    Color(0xFF9C27B0),
    Color(0xFFCE93D8),
  ];

  // Gradient Colors - Dark Theme
  static const List<Color> darkGradientBlue = [
    Color(0xFF42A5F5),
    Color(0xFF90CAF9),
  ];
  static const List<Color> darkGradientGreen = [
    Color(0xFF66BB6A),
    Color(0xFFA5D6A7),
  ];
  static const List<Color> darkGradientOrange = [
    Color(0xFFFF8A3D),
    Color(0xFFFFCA3D),
  ];
  static const List<Color> darkGradientPurple = [
    Color(0xFFBA68C8),
    Color(0xFFE1BEE7),
  ];

  // Cost-based gradient colors (Light)
  static const List<Color> costGradientLowLight = [
    Color(0xFF4CAF50),
    Color(0xFF81C784),
  ];
  static const List<Color> costGradientMediumLight = [
    Color(0xFFFFC107),
    Color(0xFFFFD54F),
  ];
  static const List<Color> costGradientHighLight = [
    Color(0xFFF44336),
    Color(0xFFEF5350),
  ];

  // Cost-based gradient colors (Dark)
  static const List<Color> costGradientLowDark = [
    Color(0xFF66BB6A),
    Color(0xFFA5D6A7),
  ];
  static const List<Color> costGradientMediumDark = [
    Color(0xFFFFD54F),
    Color(0xFFFFE082),
  ];
  static const List<Color> costGradientHighDark = [
    Color(0xFFEF5350),
    Color(0xFFE57373),
  ];

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Neutral Grays
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Utility Colors
  static const Color overlay = Color(0x00000000);
  static const Color overlayDark = Color(0x1F000000);
  static const Color overlayLight = Color(0x0FFFFFFF);

  /// Get colors based on theme brightness
  static Color getPrimary(Brightness brightness) {
    return brightness == Brightness.light ? lightPrimary : darkPrimary;
  }

  static Color getTextPrimary(Brightness brightness) {
    return brightness == Brightness.light ? lightTextPrimary : darkTextPrimary;
  }

  static Color getTextSecondary(Brightness brightness) {
    return brightness == Brightness.light
        ? lightTextSecondary
        : darkTextSecondary;
  }

  static Color getBackground(Brightness brightness) {
    return brightness == Brightness.light ? lightBackground : darkBackground;
  }

  static Color getSurface(Brightness brightness) {
    return brightness == Brightness.light ? lightSurface : darkSurface;
  }

  static Color getBorder(Brightness brightness) {
    return brightness == Brightness.light ? lightBorder : darkBorder;
  }

  static Color getDivider(Brightness brightness) {
    return brightness == Brightness.light ? lightDivider : darkDivider;
  }

  /// Get variant gradient based on brightness
  static List<Color> getGradientPrimary(Brightness brightness) {
    return brightness == Brightness.light
        ? lightGradientBlue
        : darkGradientBlue;
  }

  static List<Color> getGradientSuccess(Brightness brightness) {
    return brightness == Brightness.light
        ? lightGradientGreen
        : darkGradientGreen;
  }

  static List<Color> getGradientWarning(Brightness brightness) {
    return brightness == Brightness.light
        ? lightGradientOrange
        : darkGradientOrange;
  }

  static List<Color> getGradientError(Brightness brightness) {
    return brightness == Brightness.light
        ? lightGradientPurple
        : darkGradientPurple;
  }

  /// Get cost-based gradient
  static List<Color> getCostGradient(double cost, Brightness brightness) {
    if (cost < 1000) {
      return brightness == Brightness.light
          ? costGradientLowLight
          : costGradientLowDark;
    } else if (cost < 5000) {
      return brightness == Brightness.light
          ? costGradientMediumLight
          : costGradientMediumDark;
    } else {
      return brightness == Brightness.light
          ? costGradientHighLight
          : costGradientHighDark;
    }
  }
}
