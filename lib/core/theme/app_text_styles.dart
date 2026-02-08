import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Comprehensive text styling system with Cairo font for Arabic support
/// All styles support RTL text direction and optional customization
class AppTextStyles {
  // Base Cairo font styles - uses font family name to avoid runtime downloads
  static TextStyle _cairoBase() {
    return TextStyle(
      fontFamily: GoogleFonts.cairo().fontFamily,
    );
  }

  // ============= HEADING STYLES =============

  /// H1 - Large heading (32sp, bold)
  /// Used for: Primary page titles, main section headers
  static TextStyle h1({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 32,
      fontWeight: weight ?? FontWeight.bold,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  /// H2 - Secondary heading (28sp, bold)
  /// Used for: Subsection titles, major content headers
  static TextStyle h2({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 28,
      fontWeight: weight ?? FontWeight.bold,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  /// H3 - Tertiary heading (24sp, bold)
  /// Used for: Section headers, card titles
  static TextStyle h3({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 24,
      fontWeight: weight ?? FontWeight.bold,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  /// H4 - Quaternary heading (20sp, semibold)
  /// Used for: Subsection titles, card subtitles
  static TextStyle h4({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 20,
      fontWeight: weight ?? FontWeight.w600,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  /// H5 - Quinary heading (18sp, semibold)
  /// Used for: Minor titles, form labels
  static TextStyle h5({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 20,
      fontWeight: weight ?? FontWeight.w600,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  /// H6 - Senary heading (16sp, semibold)
  /// Used for: Widget titles, item labels
  static TextStyle h6({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 16,
      fontWeight: weight ?? FontWeight.w600,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  // ============= BODY STYLES =============

  /// Body Large (16sp, regular)
  /// Used for: Main content paragraphs, body text
  static TextStyle bodyLarge({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 16,
      fontWeight: weight ?? FontWeight.w400,
      color: color,
      decoration: decoration,
      height: height ?? 1.5,
    );
  }

  /// Body Medium (14sp, regular)
  /// Used for: Secondary content, descriptions
  static TextStyle bodyMedium({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 14,
      fontWeight: weight ?? FontWeight.w400,
      color: color,
      decoration: decoration,
      height: height ?? 1.4,
    );
  }

  /// Body Small (12sp, regular)
  /// Used for: Supporting text, helper text
  static TextStyle bodySmall({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 12,
      fontWeight: weight ?? FontWeight.w400,
      color: color,
      decoration: decoration,
      height: height ?? 1.3,
    );
  }

  // ============= CAPTION & LABEL STYLES =============

  /// Caption Large (13sp, regular)
  /// Used for: Figure captions, timestamps
  static TextStyle captionLarge({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 13,
      fontWeight: weight ?? FontWeight.w500,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  /// Caption Medium (12sp, regular)
  /// Used for: Small captions, hints
  static TextStyle captionMedium({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 12,
      fontWeight: weight ?? FontWeight.w400,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  /// Caption Small (11sp, regular)
  /// Used for: Minimal text, micro captions
  static TextStyle captionSmall({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 11,
      fontWeight: weight ?? FontWeight.w400,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  /// Label Large (14sp, medium weight)
  /// Used for: Button text, tags, badges
  static TextStyle labelLarge({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 14,
      fontWeight: weight ?? FontWeight.w500,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  /// Label Medium (12sp, medium weight)
  /// Used for: Small labels, toggle labels
  static TextStyle labelMedium({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 12,
      fontWeight: weight ?? FontWeight.w500,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  /// Label Small (11sp, medium weight)
  /// Used for: Minimal labels, chip text
  static TextStyle labelSmall({
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) {
    return _cairoBase().copyWith(
      fontSize: 11,
      fontWeight: weight ?? FontWeight.w500,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  // ============= SPECIALIZED STYLES =============

  /// Hero text for large impact statements
  static TextStyle hero({
    Color? color,
    FontWeight? weight,
    double? fontSize,
  }) {
    return _cairoBase().copyWith(
      fontSize: fontSize ?? 40,
      fontWeight: weight ?? FontWeight.bold,
      color: color,
    );
  }

  /// Bold variant of any size
  static TextStyle bold(TextStyle style, {Color? color}) {
    return style.copyWith(
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  /// Semi-bold variant of any size
  static TextStyle semibold(TextStyle style, {Color? color}) {
    return style.copyWith(
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  /// Light variant of any size
  static TextStyle light(TextStyle style, {Color? color}) {
    return style.copyWith(
      fontWeight: FontWeight.w300,
      color: color,
    );
  }

  /// Italic variant of any size
  static TextStyle italic(TextStyle style, {Color? color}) {
    return style.copyWith(
      fontStyle: FontStyle.italic,
      color: color,
    );
  }

  /// Strike-through text
  static TextStyle strikethrough(TextStyle style, {Color? color}) {
    return style.copyWith(
      decoration: TextDecoration.lineThrough,
      color: color,
    );
  }

  /// Underlined text
  static TextStyle underline(TextStyle style, {Color? color}) {
    return style.copyWith(
      decoration: TextDecoration.underline,
      color: color,
    );
  }

  // ============= THEME-AWARE STYLES (Light/Dark) =============

  /// Get themed body text
  static TextStyle getBodyText(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return bodyLarge(
      color: color ??
          (isDark ? AppColors.lightTextPrimary : AppColors.lightTextPrimary),
    );
  }

  /// Get themed heading
  static TextStyle getHeading(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return h2(
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    );
  }

  /// Get themed caption
  static TextStyle getCaption(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return captionMedium(
      color: color ??
          (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
    );
  }

  // ============= NUMERIC & MONETARY STYLES =============

  /// Style for displaying large numbers (prices, totals)
  static TextStyle numeric({
    Color? color,
    double fontSize = 24,
    FontWeight weight = FontWeight.bold,
  }) {
    return _cairoBase().copyWith(
      fontSize: fontSize,
      fontWeight: weight,
      color: color,
      letterSpacing: 0.5,
    );
  }

  /// Style for currency display
  static TextStyle currency({
    Color? color,
    double fontSize = 20,
  }) {
    return _cairoBase().copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  /// Style for percentage display
  static TextStyle percent({
    Color? color,
    double fontSize = 18,
  }) {
    return _cairoBase().copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }
}
