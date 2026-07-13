import 'package:flutter/material.dart';

import '../../adaptive_ui_kit.dart';

/// Material 3 bottom navigation bar for Android/Web/Windows/Linux.
///
/// Follows the official M3 spec (m3.material.io/components/navigation-bar):
/// - No drop shadow (M2 used elevation to imply "floating on top of
///   content"; M3 drops the shadow and just uses a taller bar instead).
/// - Selection is communicated primarily through the ICON, not the label:
///   the active destination swaps to a filled icon variant and gets a
///   pill-shaped "active indicator" that scales in behind it. The label
///   stays visually quiet (same weight for selected/unselected) so it
///   doesn't compete with the icon as the selection cue.
/// - The indicator is a `StadiumBorder` shape local to each item (it scales
///   in/out in place), matching how Flutter's own `NavigationBar` /
///   `NavigationIndicator` behave - it does not slide across the bar.
class MaterialNavigationBar extends StatelessWidget {
  /// Creates a material navigation bar.
  const MaterialNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.showLabels = true,
    required this.items,
  });

  /// The index of the currently selected item.
  final int currentIndex;

  /// Called when an item is tapped.
  final ValueChanged<int>? onTap;

  /// Whether labels should be shown for navigation items.
  final bool showLabels;

  /// The items displayed in the navigation bar.
  final List<AdaptiveNavItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasVisibleLabels = items.any((item) => item.showLabel ?? showLabels);

    return Material(
      // M3: no drop shadow - the bar sits flush with the surface below it
      // rather than implying it floats above the page content.
      color: theme.navigationBarTheme.backgroundColor ??
          colorScheme.surfaceContainer,
      elevation: 0,
      child: SafeArea(
        top: false,
        child: SizedBox(
          // M3 spec height: 80dp with labels visible, slightly shorter
          // icon-only variant.
          height: hasVisibleLabels ? 80 : 64,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              final showItemLabel = item.showLabel ?? showLabels;

              return Expanded(
                child: _MaterialNavItem(
                  item: item,
                  selected: isSelected,
                  showLabel: showItemLabel,
                  colorScheme: colorScheme,
                  onTap: () => onTap?.call(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _MaterialNavItem extends StatelessWidget {
  const _MaterialNavItem({
    required this.item,
    required this.selected,
    required this.showLabel,
    required this.colorScheme,
    required this.onTap,
  });

  final AdaptiveNavItem item;
  final bool selected;
  final bool showLabel;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  static const double _iconSize = 28;
  static const double _noLabelIconSize = 35;
  static const Duration _duration = Duration(milliseconds: 300);
  static const Curve _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Selection cue #1: the icon itself. `activeIcon`/`activeIconBuilder`
    // let the caller supply a filled variant (e.g. Icons.home vs
    // Icons.home_outlined) - exactly the "filled icon = active" pattern the
    // M3 spec calls for.
    final icon = selected ? (item.activeIcon ?? item.icon) : item.icon;
    final builder = selected
        ? (item.activeIconBuilder ?? item.iconBuilder)
        : item.iconBuilder;
    final iconColor = selected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurfaceVariant;

    final iconSize = showLabel ? _iconSize : _noLabelIconSize;

    final Widget iconWidget = builder != null
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: builder(context, iconColor, iconSize),
          )
        : Icon(icon, size: iconSize, color: iconColor);

    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selection cue #2: a pill-shaped active indicator that
              // scales in behind the icon in place (native NavigationBar
              // behaviour) - it never slides across the bar.
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: selected ? 1 : 0),
                duration: _duration,
                curve: _curve,
                builder: (context, t, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: t,
                        child: Transform.scale(
                          scaleX: 0.6 + (0.4 * t),
                          child: Container(
                            width: showLabel ? 64 : 72,
                            height: showLabel ? 32 : 36,
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      child!,
                    ],
                  );
                },
                child: iconWidget,
              ),
              // Label stays visually quiet - same weight whether selected
              // or not, so the icon (not the text) reads as the selection
              // signal. Only the colour follows the icon's active colour
              // so the two stay in sync.
              if (showLabel && item.label != null) ...[
                const SizedBox(height: 4),
                Text(
                  item.label!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: selected
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
