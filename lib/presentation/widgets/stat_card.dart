import 'package:Meshro3y/core/theme/app_colors.dart';
import 'package:Meshro3y/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Reusable statistics card widget
/// Displays statistics with optional icon, title, value, and animated counter
class StatCard extends StatefulWidget {
  /// Main value/number to display
  final dynamic value;

  /// Label/title for the statistic
  final String label;

  /// Optional leading icon
  final IconData? icon;

  /// Icon color
  final Color? iconColor;

  /// Background color for the card
  final Color? backgroundColor;

  /// Gradient colors (overrides backgroundColor)
  final List<Color>? gradientColors;

  /// Text color for value
  final Color? valueColor;

  /// Text color for label
  final Color? labelColor;

  /// Icon size
  final double iconSize;

  /// Whether to animate the value counter
  final bool animateCounter;

  /// Duration of counter animation
  final Duration counterAnimationDuration;

  /// Subtitle/additional text
  final String? subtitle;

  /// Trailing widget (e.g., percentage badge)
  final Widget? trailing;

  /// Padding inside the card
  final EdgeInsets padding;

  /// Border radius
  final BorderRadius? borderRadius;

  /// OnTap callback
  final VoidCallback? onTap;

  /// Card elevation
  final double elevation;

  /// Size variant of the card
  final _StatCardSize size;

  /// Whether to show a percentage indicator
  final bool showPercentage;

  /// Percentage value (if showPercentage is true)
  final double? percentageValue;

  /// Percentage color
  final Color? percentageColor;

  const StatCard({
    Key? key,
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.gradientColors,
    this.valueColor,
    this.labelColor,
    this.iconSize = 32,
    this.animateCounter = false,
    this.counterAnimationDuration = const Duration(milliseconds: 1500),
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
    this.onTap,
    this.elevation = 2,
    this.size = _StatCardSize.medium,
    this.showPercentage = false,
    this.percentageValue,
    this.percentageColor,
  }) : super(key: key);

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> with TickerProviderStateMixin {
  late AnimationController _counterController;

  @override
  void initState() {
    super.initState();
    if (widget.animateCounter) {
      _counterController = AnimationController(
        duration: widget.counterAnimationDuration,
        vsync: this,
      )..forward();
    }
  }

  @override
  void dispose() {
    _counterController.dispose();
    super.dispose();
  }

  String _formatValue(dynamic value) {
    if (value is int || value is double) {
      if (value >= 1000000) {
        return '${(value / 1000000).toStringAsFixed(1)}M';
      } else if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(1)}K';
      }
      return value.toString();
    }
    return value.toString();
  }

  Widget _buildCounter() {
    if (!widget.animateCounter || widget.value is! num) {
      return Text(
        _formatValue(widget.value),
        style: AppTextStyles.numeric(color: widget.valueColor),
      );
    }

    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _counterController, curve: Curves.easeOutBack),
      ),
      child: Text(
        _formatValue(widget.value),
        style: AppTextStyles.numeric(color: widget.valueColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final defaultBgColor = brightness == Brightness.light
        ? AppColors.lightSurface
        : AppColors.darkSurface;

    final actualBgColor = widget.backgroundColor ?? defaultBgColor;
    final actualIconColor = widget.iconColor ??
        (brightness == Brightness.light
            ? AppColors.lightPrimary
            : AppColors.darkPrimary);
    final actualValueColor = widget.valueColor ??
        (brightness == Brightness.light
            ? AppColors.lightTextPrimary
            : AppColors.darkTextPrimary);
    final actualLabelColor = widget.labelColor ??
        (brightness == Brightness.light
            ? AppColors.lightTextSecondary
            : AppColors.darkTextSecondary);
    final actualBorderRadius = widget.borderRadius ?? BorderRadius.circular(12);

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(borderRadius: actualBorderRadius),
        color: widget.gradientColors == null ? actualBgColor : null,
        child: Container(
          decoration: widget.gradientColors != null
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.gradientColors!,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: actualBorderRadius,
                )
              : null,
          padding: widget.padding,
          child: _buildContent(
            actualIconColor,
            actualValueColor,
            actualLabelColor,
            context,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color iconColor, Color valueColor, Color labelColor,
      BuildContext context) {
    final sizeConfig = _getSizeConfig(widget.size);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with icon and trailing widget
        if (widget.icon != null || widget.trailing != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (widget.icon != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.icon,
                    size: widget.iconSize,
                    color: iconColor,
                  ),
                )
              else
                const SizedBox.shrink(),
              if (widget.trailing != null)
                Flexible(
                  child: widget.trailing!,
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        SizedBox(height: sizeConfig['spacing'] as double),

        // Value
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: _buildCounter(),
        ),
        SizedBox(height: sizeConfig['labelSpacing'] as double),

        // Label
        Text(
          widget.label,
          style: AppTextStyles.bodyMedium(color: labelColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // Subtitle (optional)
        if (widget.subtitle != null) ...[
          SizedBox(height: 4),
          Text(
            widget.subtitle!,
            style: AppTextStyles.captionSmall(color: labelColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        // Percentage indicator (optional)
        if (widget.showPercentage && widget.percentageValue != null) ...[
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (widget.percentageValue! / 100).clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: iconColor.withAlpha(51),
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.percentageColor ??
                    (Theme.of(context).brightness == Brightness.light
                        ? AppColors.lightSuccess
                        : AppColors.darkSuccess),
              ),
            ),
          ),
          SizedBox(height: 6),
          Text(
            '${widget.percentageValue?.toStringAsFixed(1)}%',
            style: AppTextStyles.labelSmall(color: labelColor),
          ),
        ],
      ],
    );
  }

  Map<String, dynamic> _getSizeConfig(_StatCardSize size) {
    switch (size) {
      case _StatCardSize.small:
        return {
          'spacing': 8.0,
          'labelSpacing': 4.0,
          'fontSize': 14.0,
        };
      case _StatCardSize.medium:
        return {
          'spacing': 12.0,
          'labelSpacing': 6.0,
          'fontSize': 18.0,
        };
      case _StatCardSize.large:
        return {
          'spacing': 16.0,
          'labelSpacing': 8.0,
          'fontSize': 24.0,
        };
    }
  }
}

enum _StatCardSize { small, medium, large }
