import 'package:Meshro3y/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Reusable card widget with gradient background
/// Provides a flexible, customizable card with optional gradient, shadow, and elevation
class GradientCard extends StatelessWidget {
  /// The child widget to display inside the card
  final Widget child;

  /// Gradient colors for the card background
  /// If null, uses solid color from [backgroundColor]
  final List<Color>? gradientColors;

  /// Solid background color when no gradient is provided
  final Color? backgroundColor;

  /// Gradient begin alignment
  final Alignment gradientBegin;

  /// Gradient end alignment
  final Alignment gradientEnd;

  /// Card elevation/shadow depth
  final double elevation;

  /// Padding inside the card
  final EdgeInsets padding;

  /// Border radius for the card
  final BorderRadius? borderRadius;

  /// OnTap callback
  final VoidCallback? onTap;

  /// Border side for the card
  final BorderSide? border;

  /// Shadow color
  final Color? shadowColor;

  /// Clip behavior
  final Clip clipBehavior;

  /// Margin around the card
  final EdgeInsets? margin;

  /// Whether to apply a semi-transparent overlay
  final bool enableOverlay;

  /// Overlay color opacity
  final double overlayOpacity;

  /// Whether to animate on tap
  final bool animateOnTap;

  /// Duration of tap animation
  final Duration tapAnimationDuration;

  const GradientCard({
    Key? key,
    required this.child,
    this.gradientColors,
    this.backgroundColor,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
    this.elevation = 2,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
    this.onTap,
    this.border,
    this.shadowColor,
    this.clipBehavior = Clip.antiAlias,
    this.margin,
    this.enableOverlay = false,
    this.overlayOpacity = 0.1,
    this.animateOnTap = false,
    this.tapAnimationDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final actualBgColor = backgroundColor ??
        (brightness == Brightness.light
            ? AppColors.lightSurface
            : AppColors.darkSurface);

    final actualBorderRadius = borderRadius ?? BorderRadius.circular(12);

    Widget cardChild = Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradientColors != null
            ? LinearGradient(
                begin: gradientBegin,
                end: gradientEnd,
                colors: gradientColors!,
              )
            : null,
        color: gradientColors == null ? actualBgColor : null,
        borderRadius: actualBorderRadius,
        border: border != null ? Border.fromBorderSide(border!) : null,
      ),
      child: child,
    );

    if (enableOverlay) {
      cardChild = Stack(
        children: [
          cardChild,
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: actualBorderRadius,
                color:
                    AppColors.black.withAlpha((overlayOpacity * 255).toInt()),
              ),
            ),
          ),
        ],
      );
    }

    if (animateOnTap && onTap != null) {
      cardChild = _AnimatedCardOnTap(
        onTap: onTap!,
        duration: tapAnimationDuration,
        child: cardChild,
      );
    }

    return Container(
      margin: margin,
      child: Material(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: actualBorderRadius,
          side: border ?? BorderSide.none,
        ),
        shadowColor: shadowColor ?? Colors.black.withAlpha(51),
        clipBehavior: clipBehavior,
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                child: cardChild,
              )
            : cardChild,
      ),
    );
  }
}

/// Animated card on tap helper widget
class _AnimatedCardOnTap extends StatefulWidget {
  final VoidCallback onTap;
  final Duration duration;
  final Widget child;

  const _AnimatedCardOnTap({
    required this.onTap,
    required this.duration,
    required this.child,
  });

  @override
  State<_AnimatedCardOnTap> createState() => _AnimatedCardOnTapState();
}

class _AnimatedCardOnTapState extends State<_AnimatedCardOnTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
