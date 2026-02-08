import 'package:Meshro3y/core/theme/app_colors.dart';
import 'package:Meshro3y/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Complete style guide and design system utilities for the Equipment Manager app
///
/// This file provides comprehensive documentation and utilities for using the
/// centralized styling system throughout the application.
///
/// USAGE EXAMPLES:
///
/// 1. TEXT STYLES
///    -----------
///    // Headings
///    Text('Title', style: AppTextStyles.h1())
///    Text('Subtitle', style: AppTextStyles.h3(color: Colors.blue))
///
///    // Body text
///    Text('Description', style: AppTextStyles.bodyMedium())
///
///    // Specialized styles
///    Text('\$1,234.56', style: AppTextStyles.currency(color: Colors.green))
///    Text('45%', style: AppTextStyles.percent())
///
/// 2. COLORS (Light Theme)
///    --------------------
///    backgroundColor: AppColors.lightBackground
///    textColor: AppColors.lightTextPrimary
///    accentColor: AppColors.lightPrimary
///    successColor: AppColors.lightSuccess
///
/// 3. COLORS (Dark Theme)
///    -------------------
///    backgroundColor: AppColors.darkBackground
///    textColor: AppColors.darkTextPrimary
///    accentColor: AppColors.darkPrimary
///
/// 4. COLORS (Smart Selection)
///    -------------------------
///    final brightness = Theme.of(context).brightness;
///    final primary = AppColors.getPrimary(brightness);
///    final text = AppColors.getTextPrimary(brightness);
///
/// 5. GRADIENTS
///    ----------
///    gradient: LinearGradient(
///      colors: AppColors.lightGradientBlue,
///      begin: Alignment.topLeft,
///      end: Alignment.bottomRight,
///    )
///
/// 6. CUSTOM WIDGETS
///    ---------------
///    // Gradient Card
///    GradientCard(
///      gradientColors: AppColors.lightGradientBlue,
///      padding: EdgeInsets.all(16),
///      child: Text('Content'),
///    )
///
///    // Stat Card
///    StatCard(
///      value: 1234,
///      label: 'Total Machines',
///      icon: Icons.build,
///      animateCounter: true,
///    )
///
///    // Custom App Bar
///    CustomAppBar(
///      title: 'App Title',
///      gradientColors: AppColors.lightGradientBlue,
///    )
///
/// 7. SPACING CONSTANTS
///    ------------------
///    padding: const EdgeInsets.all(16),
///    spacing: const SizedBox(height: 12),
///
/// CONSISTENT DESIGN PRINCIPLES
/// ============================
///
/// TYPOGRAPHY
/// -----------
/// • Cairo font for all text (Arabic & English support)
/// • Use predefined styles only (h1-h6, bodyLarge, bodyMedium, etc.)
/// • Never hardcode font sizes or weights
/// • Support RTL automatically through Flutter
///
/// COLOR PALETTE
/// ---------------
/// Light Theme:
///   • Primary: #2196F3 (Blue)
///   • Secondary: #00BCD4 (Cyan)
///   • Success: #4CAF50 (Green)
///   • Error: #F44336 (Red)
///   • Warning: #FFC107 (Amber)
///
/// Dark Theme: Automatically adjusted brightness equivalents
///
/// SPACING
/// ----------
/// • Use multiples of 4: 4, 8, 12, 16, 24, 32, 48, etc.
/// • Standard padding: 16
/// • Standard gap between widgets: 12
/// • Card padding: 16
///
/// ELEVATION & SHADOWS
/// ----------------------
/// • Cards: elevation 2
/// • FAB: elevation 4
/// • App Bar: elevation 0 (use gradient for depth)
/// • Bottom Sheet: elevation 8
///
/// BORDER RADIUS
/// ---------------
/// • Standard: 12
/// • Small elements: 8
/// • Large containers: 16
/// • Bottom sheets: 24 (top only)
/// • Buttons: 12
/// • Pills/Chips: 20+
///
/// INTERACTIVE ELEMENTS
/// ----------------------
/// • All buttons should have rounded corners
/// • Input fields should have clear focus states
/// • Use color feedback for disabled states
/// • Ensure sufficient tap targets (min 48x48)
/// • Add elevation on hover/focus
///
/// ANIMATION & TRANSITIONS
/// -------------------------
/// • Fade in duration: 300ms
/// • Scale animation: 200ms
/// • Counter animation: 1500ms
/// • Slide animation: 400ms
/// • Use MaterialPageRoute for screen transitions
///
/// ACCESSIBILITY
/// ----------------
/// • Maintain sufficient contrast ratios
/// • Use semantic color meanings (red=error, green=success)
/// • Support RTL text direction
/// • Use descriptive icon labels
/// • Ensure touch targets are 48x48 minimum
/// • Test with accessibility tools

class StyleGuide {
  // Prevent instantiation
  StyleGuide._();

  /// Standard padding values
  static const double paddingXSmall = 4;
  static const double paddingSmall = 8;
  static const double paddingMedium = 12;
  static const double paddingLarge = 16;
  static const double paddingXLarge = 24;
  static const double paddingXXLarge = 32;
  static const double paddingHuge = 48;

  /// Standard spacing for gaps between widgets
  static const double spacingSmall = 8;
  static const double spacingMedium = 12;
  static const double spacingLarge = 16;
  static const double spacingXLarge = 24;

  /// Border radius values
  static const double radiusSmall = 8;
  static const double radiusStandard = 12;
  static const double radiusMedium = 16;
  static const double radiusLarge = 20;
  static const double radiusXLarge = 24;
  static const double radiusRound = 100;

  /// Elevation values
  static const double elevationNone = 0;
  static const double elevationLow = 2;
  static const double elevationMedium = 4;
  static const double elevationHigh = 8;
  static const double elevationVeryHigh = 12;

  /// Animation durations
  static const Duration durationQuick = Duration(milliseconds: 150);
  static const Duration durationFast = Duration(milliseconds: 300);
  static const Duration durationNormal = Duration(milliseconds: 500);
  static const Duration durationSlow = Duration(milliseconds: 800);
  static const Duration durationVerySlow = Duration(milliseconds: 1500);

  /// Minimum tap target size (Material Design)
  static const double minTapTarget = 48;

  /// Icon sizes
  static const double iconSizeSmall = 16;
  static const double iconSizeMedium = 24;
  static const double iconSizeLarge = 32;
  static const double iconSizeXLarge = 48;

  /// Common EdgeInsets
  static const EdgeInsets paddingAll = EdgeInsets.all(paddingLarge);
  static const EdgeInsets paddingSymmetricH = EdgeInsets.symmetric(
    horizontal: paddingLarge,
  );
  static const EdgeInsets paddingSymmetricV = EdgeInsets.symmetric(
    vertical: paddingLarge,
  );
  static const EdgeInsets paddingCardContent = EdgeInsets.all(paddingLarge);

  /// Common BorderRadius
  static const BorderRadius radiusCard = BorderRadius.all(
    Radius.circular(radiusStandard),
  );
  static const BorderRadius radiusButton = BorderRadius.all(
    Radius.circular(radiusStandard),
  );
  static const BorderRadius radiusInput = BorderRadius.all(
    Radius.circular(radiusStandard),
  );
  static const BorderRadius radiusBottomSheet = BorderRadius.only(
    topLeft: Radius.circular(radiusXLarge),
    topRight: Radius.circular(radiusXLarge),
  );

  /// Get theme-aware colors
  static Color getPrimaryColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AppColors.getPrimary(brightness);
  }

  static Color getTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AppColors.getTextPrimary(brightness);
  }

  static Color getSecondaryTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AppColors.getTextSecondary(brightness);
  }

  static Color getBackgroundColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AppColors.getBackground(brightness);
  }

  static Color getSurfaceColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AppColors.getSurface(brightness);
  }

  /// Create a shadow decoration
  static BoxDecoration shadowDecoration({
    Color color = Colors.black,
    double blurRadius = 8,
    Offset offset = const Offset(0, 2),
    double spreadRadius = 0,
  }) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: color.withAlpha(51),
          blurRadius: blurRadius,
          offset: offset,
          spreadRadius: spreadRadius,
        ),
      ],
    );
  }

  /// Create a standard card decoration
  static BoxDecoration cardDecoration(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.light
        ? AppColors.lightSurface
        : AppColors.darkSurface;

    return BoxDecoration(
      color: bgColor,
      borderRadius: radiusCard,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(26),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Create a gradient decoration
  static BoxDecoration gradientDecoration(
    List<Color> colors, {
    BorderRadius? borderRadius,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ),
      borderRadius: borderRadius ?? radiusCard,
    );
  }

  /// Create a themed app bar decoration
  static BoxDecoration appBarDecoration(
    BuildContext context, {
    List<Color>? gradientColors,
    BorderRadius? borderRadius,
  }) {
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.light
        ? AppColors.lightSurface
        : AppColors.darkSurface;

    return BoxDecoration(
      gradient: gradientColors != null
          ? LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      color: gradientColors == null ? bgColor : null,
      borderRadius: borderRadius,
    );
  }

  /// Create a divider
  static Widget divider(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final color = brightness == Brightness.light
        ? AppColors.lightDivider
        : AppColors.darkDivider;

    return Divider(
      color: color,
      thickness: 1,
    );
  }

  /// Create vertical spacing
  static Widget verticalSpacing(double height) {
    return SizedBox(height: height);
  }

  /// Create horizontal spacing
  static Widget horizontalSpacing(double width) {
    return SizedBox(width: width);
  }

  /// Enhanced card widget with standard styling
  static Widget styledCard({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(paddingLarge),
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    List<Color>? gradientColors,
    Color? backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          gradient: gradientColors != null
              ? LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: gradientColors == null
              ? backgroundColor ?? AppColors.lightSurface
              : null,
          borderRadius: borderRadius ?? radiusCard,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  /// Create a button-like container
  static Widget styledButton({
    required String label,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
    double borderRadius = radiusStandard,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: paddingLarge,
      vertical: paddingMedium,
    ),
  }) {
    return Material(
      color: backgroundColor ?? AppColors.lightPrimary,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding,
          child: Text(
            label,
            style: AppTextStyles.labelLarge(
              color: textColor ?? AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// Print style system info to console (for development)
  static void printStyleInfo() {
    debugPrint('=== Style Guide Info ===');
    debugPrint('Padding: $paddingLarge');
    debugPrint('Spacing: $spacingMedium');
    debugPrint('Border Radius: $radiusStandard');
    debugPrint('Min Tap Target: $minTapTarget');
  }
}

/// Extension methods for easier access to padding
extension PaddingExtension on num {
  /// Convert number to EdgeInsets.all
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());

  /// Convert number to vertical EdgeInsets
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());

  /// Convert number to horizontal EdgeInsets
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// Convert number to BorderRadius
  BorderRadius get borderRadius =>
      BorderRadius.all(Radius.circular(toDouble()));

  /// Convert number to circular BorderRadius
  BorderRadius get circularBorderRadius =>
      BorderRadius.all(Radius.circular(toDouble()));

  /// Convert number to SizedBox height
  SizedBox get heightBox => SizedBox(height: toDouble());

  /// Convert number to SizedBox width
  SizedBox get widthBox => SizedBox(width: toDouble());

  /// Convert number to Duration (milliseconds)
  Duration get duration => Duration(milliseconds: toInt());
}

/// Extension methods for convenient spacing
extension SpacingExtension on BuildContext {
  /// Get theme-aware primary color
  Color get primaryColor => StyleGuide.getPrimaryColor(this);

  /// Get theme-aware text color
  Color get textColor => StyleGuide.getTextColor(this);

  /// Get theme-aware secondary text color
  Color get secondaryTextColor => StyleGuide.getSecondaryTextColor(this);

  /// Get theme-aware background color
  Color get backgroundColor => StyleGuide.getBackgroundColor(this);

  /// Get theme-aware surface color
  Color get surfaceColor => StyleGuide.getSurfaceColor(this);

  /// Check if dark theme
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  /// Check if light theme
  bool get isLightTheme => Theme.of(this).brightness == Brightness.light;

  /// Check if RTL
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  /// Check if LTR
  bool get isLtr => Directionality.of(this) == TextDirection.ltr;
}
