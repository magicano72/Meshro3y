import 'package:Meshro3y/core/theme/app_colors.dart';
import 'package:Meshro3y/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Enhanced section header with divider and optional action button
class SectionHeader extends StatelessWidget {
  /// Section title
  final String title;

  /// Leading icon
  final IconData? icon;

  /// Action text (e.g., "See All")
  final String? actionText;

  /// Action callback
  final VoidCallback? onAction;

  /// Whether to show bottom divider
  final bool showDivider;

  /// Padding
  final EdgeInsets padding;

  /// Text style
  final TextStyle? textStyle;

  /// Custom icon widget
  final Widget? customIcon;

  const SectionHeader({
    Key? key,
    required this.title,
    this.icon,
    this.actionText,
    this.onAction,
    this.showDivider = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.textStyle,
    this.customIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.light
        ? AppColors.lightTextPrimary
        : AppColors.darkTextPrimary;
    final secondaryColor = brightness == Brightness.light
        ? AppColors.lightTextSecondary
        : AppColors.darkTextSecondary;
    final dividerColor = brightness == Brightness.light
        ? AppColors.lightDivider
        : AppColors.darkDivider;
    final primaryColor = brightness == Brightness.light
        ? AppColors.lightPrimary
        : AppColors.darkPrimary;

    return Column(
      children: [
        Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title with optional icon
              Expanded(
                child: Row(
                  children: [
                    if (icon != null && customIcon == null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          icon,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                    if (customIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: customIcon,
                      ),
                    Expanded(
                      child: Text(
                        title,
                        style: textStyle ?? AppTextStyles.h5(color: textColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Action button
              if (actionText != null)
                TextButton(
                  onPressed: onAction,
                  child: Text(
                    actionText!,
                    style: AppTextStyles.labelMedium(color: primaryColor),
                  ),
                ),
            ],
          ),
        ),

        // Divider
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
          ),
      ],
    );
  }
}

/// Loading shimmer placeholder
class ShimmerLoader extends StatefulWidget {
  /// Number of shimmer items to display
  final int itemCount;

  /// Height of each shimmer item
  final double itemHeight;

  /// Whether items are in a list or grid
  final bool isGridLayout;

  /// Grid columns (for grid layout)
  final int gridColumns;

  /// Spacing between items
  final double spacing;

  /// Border radius for shimmer items
  final BorderRadius? borderRadius;

  /// Padding around the shimmer
  final EdgeInsets padding;

  const ShimmerLoader({
    Key? key,
    this.itemCount = 5,
    this.itemHeight = 100,
    this.isGridLayout = false,
    this.gridColumns = 2,
    this.spacing = 12,
    this.borderRadius,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final baseColor =
        brightness == Brightness.light ? AppColors.gray200 : AppColors.gray700;
    final highlightColor =
        brightness == Brightness.light ? AppColors.gray100 : AppColors.gray800;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: widget.padding,
        child: widget.isGridLayout
            ? _buildGridShimmer(baseColor, highlightColor)
            : _buildListShimmer(baseColor, highlightColor),
      ),
    );
  }

  Widget _buildListShimmer(Color baseColor, Color highlightColor) {
    return Column(
      children: List.generate(
        widget.itemCount,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: widget.spacing),
          child: _ShimmerItem(
            controller: _controller,
            baseColor: baseColor,
            highlightColor: highlightColor,
            height: widget.itemHeight,
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }

  Widget _buildGridShimmer(Color baseColor, Color highlightColor) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.gridColumns,
        crossAxisSpacing: widget.spacing,
        mainAxisSpacing: widget.spacing,
        childAspectRatio: 1,
      ),
      itemCount: widget.itemCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => _ShimmerItem(
        controller: _controller,
        baseColor: baseColor,
        highlightColor: highlightColor,
        height: double.infinity,
        borderRadius: widget.borderRadius,
      ),
    );
  }
}

class _ShimmerItem extends StatelessWidget {
  final AnimationController controller;
  final Color baseColor;
  final Color highlightColor;
  final double height;
  final BorderRadius? borderRadius;

  const _ShimmerItem({
    required this.controller,
    required this.baseColor,
    required this.highlightColor,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (controller.value - 0.3).clamp(0, 1),
                controller.value.clamp(0, 1),
                (controller.value + 0.3).clamp(0, 1),
              ],
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Enhanced empty state widget
class EmptyStateWidget extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Title text
  final String title;

  /// Description text
  final String? description;

  /// Icon size
  final double iconSize;

  /// Action button text
  final String? actionText;

  /// Action button callback
  final VoidCallback? onAction;

  /// Icon color
  final Color? iconColor;

  /// Show animation
  final bool withAnimation;

  /// Padding
  final EdgeInsets padding;

  /// Custom child widget instead of icon
  final Widget? customChild;

  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.description,
    this.iconSize = 80,
    this.actionText,
    this.onAction,
    this.iconColor,
    this.withAnimation = true,
    this.padding = const EdgeInsets.all(24),
    this.customChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final actualIconColor = iconColor ??
        (brightness == Brightness.light
            ? AppColors.lightTextTertiary
            : AppColors.darkTextTertiary);
    final textColor = brightness == Brightness.light
        ? AppColors.lightTextPrimary
        : AppColors.darkTextPrimary;
    final secondaryColor = brightness == Brightness.light
        ? AppColors.lightTextSecondary
        : AppColors.darkTextSecondary;
    final primaryColor = brightness == Brightness.light
        ? AppColors.lightPrimary
        : AppColors.darkPrimary;

    Widget iconWidget = customChild ??
        Icon(
          icon,
          size: iconSize,
          color: actualIconColor,
        );

    if (withAnimation) {
      iconWidget = ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(
          CurvedAnimation(
            parent: _FadeInController(),
            curve: Curves.easeOutBack,
          ),
        ),
        child: iconWidget,
      );
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(height: 16),
              Text(
                title,
                style: AppTextStyles.h5(color: textColor),
                textAlign: TextAlign.center,
              ),
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(
                  description!,
                  style: AppTextStyles.bodyMedium(color: secondaryColor),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionText != null && onAction != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionText!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FadeInController extends AnimationController {
  _FadeInController()
      : super(
          vsync: const _FadeInTickerProvider(),
          duration: const Duration(milliseconds: 600),
        ) {
    forward();
  }
}

class _FadeInTickerProvider extends TickerProvider {
  const _FadeInTickerProvider();

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

/// Animated progress indicator
class AnimatedProgressIndicator extends StatelessWidget {
  /// Progress value (0-1)
  final double value;

  /// Height of the progress bar
  final double height;

  /// Colors for different progress ranges
  final List<Color>? colors;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Show percentage text
  final bool showPercentage;

  /// Animation duration
  final Duration animationDuration;

  /// Padding
  final EdgeInsets padding;

  const AnimatedProgressIndicator({
    Key? key,
    required this.value,
    this.height = 8,
    this.colors,
    this.borderRadius,
    this.showPercentage = true,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  }) : super(key: key);

  Color _getColorByProgress(double progress) {
    if (colors != null && colors!.length > 0) {
      if (progress < 0.33) return colors!.first;
      if (progress < 0.66) {
        return colors!.length > 1 ? colors![1] : colors!.first;
      }
      return colors!.length > 2 ? colors![2] : colors!.last;
    }
    if (progress < 0.33) return AppColors.lightWarning;
    if (progress < 0.66) return Colors.orange;
    return AppColors.lightSuccess;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.light
        ? AppColors.lightSurfaceVariant
        : AppColors.darkSurfaceVariant;

    return Padding(
      padding: padding,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              minHeight: height,
              backgroundColor: bgColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getColorByProgress(value),
              ),
            ),
          ),
          if (showPercentage)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${(value * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.labelSmall(),
              ),
            ),
        ],
      ),
    );
  }
}
