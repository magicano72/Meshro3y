import 'package:Meshro3y/core/theme/app_colors.dart';
import 'package:Meshro3y/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Reusable custom app bar with gradient background
/// Provides flexible branding, navigation, and action options
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title
  final String title;

  /// Leading widget (typically back button)
  final Widget? leading;

  /// List of action widgets
  final List<Widget>? actions;

  /// Gradient colors for the app bar
  final List<Color>? gradientColors;

  /// Solid background color (used if no gradient)
  final Color? backgroundColor;

  /// Text color for title
  final Color? titleColor;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom title widget (overrides title string)
  final Widget? titleWidget;

  /// App bar elevation
  final double elevation;

  /// Border radius for bottom corners
  final BorderRadius? borderRadius;

  /// Padding for title and actions
  final EdgeInsets contentPadding;

  /// Height of the app bar
  final double appBarHeight;

  /// Leading button color
  final Color? leadingColor;

  /// Whether to show a bottom divider
  final bool showDivider;

  /// Divider color
  final Color? dividerColor;

  /// Prefix widget (left aligned before title)
  final Widget? prefixWidget;

  /// Suffix widget (right aligned after title)
  final Widget? suffixWidget;

  /// Leading icon size
  final double leadingIconSize;

  /// Title text style
  final TextStyle? titleTextStyle;

  /// OnPop callback when back is pressed
  final VoidCallback? onBack;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.actions,
    this.gradientColors,
    this.backgroundColor,
    this.titleColor,
    this.centerTitle = true,
    this.titleWidget,
    this.elevation = 0,
    this.borderRadius,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.appBarHeight = 64,
    this.leadingColor,
    this.showDivider = false,
    this.dividerColor,
    this.prefixWidget,
    this.suffixWidget,
    this.leadingIconSize = 24,
    this.titleTextStyle,
    this.onBack,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    final actualBgColor = backgroundColor ??
        (brightness == Brightness.light
            ? AppColors.lightSurface
            : AppColors.darkSurface);

    final actualTitleColor = titleColor ??
        (brightness == Brightness.light
            ? AppColors.lightTextPrimary
            : AppColors.darkTextPrimary);

    final actualLeadingColor = leadingColor ??
        (brightness == Brightness.light
            ? AppColors.lightTextPrimary
            : AppColors.darkTextPrimary);

    final actualBorderRadius = borderRadius ??
        const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        );

    final defaultTitleStyle = titleTextStyle ??
        AppTextStyles.h4(
          color: actualTitleColor,
        );

    return Container(
      decoration: BoxDecoration(
        gradient: gradientColors != null
            ? LinearGradient(
                colors: gradientColors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: gradientColors == null ? actualBgColor : null,
        borderRadius: actualBorderRadius,
        boxShadow: [
          if (elevation > 0)
            BoxShadow(
              color: Colors.black.withAlpha((elevation * 10).toInt()),
              blurRadius: elevation,
              offset: Offset(0, elevation / 2),
            ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main AppBar Content
          Container(
            height: appBarHeight,
            padding: contentPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Leading and Prefix
                Expanded(
                  flex: centerTitle ? 1 : 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Leading Widget
                      if (leading != null)
                        _buildLeadingButton(context, actualLeadingColor)
                      else
                        _buildDefaultLeadingButton(context, actualLeadingColor),

                      if (prefixWidget != null) ...[
                        const SizedBox(width: 8),
                        prefixWidget!,
                      ],
                    ],
                  ),
                ),

                // Title
                if (!centerTitle || titleWidget != null)
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: titleWidget ??
                          Text(
                            title,
                            style: defaultTitleStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: Directionality.of(context),
                          ),
                    ),
                  )
                else
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        title,
                        style: defaultTitleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: Directionality.of(context),
                      ),
                    ),
                  ),

                // Actions and Suffix
                Expanded(
                  flex: centerTitle ? 1 : 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (suffixWidget != null) ...[
                        Flexible(
                          child: suffixWidget!,
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (actions != null && actions!.isNotEmpty)
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: actions!
                                .map((action) => Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: action,
                                    ))
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Divider
          if (showDivider)
            Divider(
              height: 1,
              thickness: 1,
              color: dividerColor ??
                  (brightness == Brightness.light
                      ? AppColors.lightDivider
                      : AppColors.darkDivider),
            ),
        ],
      ),
    );
  }

  Widget _buildLeadingButton(BuildContext context, Color color) {
    return GestureDetector(
      onTap: onBack ?? () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: leading,
      ),
    );
  }

  Widget _buildDefaultLeadingButton(BuildContext context, Color color) {
    return GestureDetector(
      onTap: onBack ?? () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          _getLeadingIcon(context),
          size: leadingIconSize,
          color: color,
        ),
      ),
    );
  }

  IconData _getLeadingIcon(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return isRtl ? Icons.arrow_forward : Icons.arrow_back;
  }
}

/// AppBar with search functionality
class SearchableAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Hint text for search field
  final String searchHint;

  /// Leading widget
  final Widget? leading;

  /// List of action widgets
  final List<Widget>? actions;

  /// Gradient colors
  final List<Color>? gradientColors;

  /// Background color
  final Color? backgroundColor;

  /// Search callback
  final Function(String)? onSearch;

  /// Search text changed callback
  final Function(String)? onSearchChanged;

  /// Whether search is active
  final bool isSearching;

  /// On search close callback
  final VoidCallback? onSearchClose;

  /// Height of the app bar
  final double appBarHeight;

  const SearchableAppBar({
    Key? key,
    required this.searchHint,
    this.leading,
    this.actions,
    this.gradientColors,
    this.backgroundColor,
    this.onSearch,
    this.onSearchChanged,
    this.isSearching = false,
    this.onSearchClose,
    this.appBarHeight = 64,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  State<SearchableAppBar> createState() => _SearchableAppBarState();
}

class _SearchableAppBarState extends State<SearchableAppBar> {
  late TextEditingController _searchController;
  late FocusNode _searchFocus;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocus = FocusNode();
    _isSearching = widget.isSearching;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        widget.onSearchClose?.call();
      } else {
        _searchFocus.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final actualBgColor = widget.backgroundColor ??
        (brightness == Brightness.light
            ? AppColors.lightSurface
            : AppColors.darkSurface);

    if (_isSearching) {
      return Container(
        height: widget.appBarHeight,
        decoration: BoxDecoration(
          gradient: widget.gradientColors != null
              ? LinearGradient(
                  colors: widget.gradientColors!,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: widget.gradientColors == null ? actualBgColor : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _toggleSearch,
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocus,
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                onChanged: widget.onSearchChanged,
                onSubmitted: widget.onSearch as void Function(String)?,
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  widget.onSearchChanged?.call('');
                },
              ),
          ],
        ),
      );
    }

    return CustomAppBar(
      title: 'Search',
      leading: widget.leading,
      actions: [
        ...(widget.actions ?? []),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _toggleSearch,
        ),
      ],
      backgroundColor: widget.backgroundColor,
      gradientColors: widget.gradientColors,
      appBarHeight: widget.appBarHeight,
    );
  }
}
