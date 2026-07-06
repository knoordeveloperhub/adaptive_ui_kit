import 'package:flutter/material.dart';

import '../config/adaptive_ui_kit_config.dart';
import '../glass/glass_navigation_bar.dart';
import '../material/material_navigation_bar.dart';
import '../widgets/adaptive_nav_item.dart';

/// A platform-adaptive bottom navigation bar that uses a glass-style tab bar
/// on Apple platforms and a Material 3 navigation bar elsewhere.
class AdaptiveNavigationBar extends StatelessWidget {
  /// Creates an adaptive navigation bar.
  const AdaptiveNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.showLabels = true,
    required this.items,
    this.backgroundColor,
    this.uiKit,
  });

  /// The index of the currently selected item.
  final int currentIndex;

  /// Called when an item is tapped.
  final ValueChanged<int>? onTap;

  /// Whether labels should be shown for navigation items.
  ///
  /// When set to false, labels are hidden for every item, including on
  /// Apple platforms.
  final bool showLabels;

  /// The items displayed in the navigation bar.
  final List<AdaptiveNavItem> items;

  /// Optional solid background color for the glass navigation bar.
  final Color? backgroundColor;

  /// Optional override for the resolved UI kit.
  final AdaptiveUiKit? uiKit;

  @override
  Widget build(BuildContext context) {
    return switch (resolveUiKit(context, uiKit)) {
      AdaptiveUiKit.glass => GlassNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          showLabels: showLabels,
          items: items,
        ),
      AdaptiveUiKit.material => MaterialNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          showLabels: showLabels,
          items: items,
        ),
    };
  }
}
