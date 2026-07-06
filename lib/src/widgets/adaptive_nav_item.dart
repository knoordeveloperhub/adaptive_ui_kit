import 'package:flutter/widgets.dart';

/// A single item rendered by [AdaptiveNavigationBar] / [GlassNavigationBar] /
/// [MaterialNavigationBar].
///
/// Provide EITHER [icon] (a plain [IconData], simplest case) OR
/// [iconBuilder] (full control - SVG via flutter_svg, an [Image], a Lottie
/// animation, or any custom widget). If both are given, [iconBuilder] wins.
///
/// NOTE: this is a best-effort reconstruction of the existing model based on
/// how it's used in glass_navigation_bar.dart / material_navigation_bar.dart
/// (icon, activeIcon, label, showLabel). If your real adaptive_nav_item.dart
/// has more fields, merge those in - only the two builder fields below are
/// new.
class AdaptiveNavItem {
  const AdaptiveNavItem({
    this.icon,
    this.activeIcon,
    this.iconBuilder,
    this.activeIconBuilder,
    this.label,
    this.showLabel,
  }) : assert(
          icon != null || iconBuilder != null,
          'Provide either icon or iconBuilder.',
        );

  /// Simple case: a Material/Cupertino icon glyph.
  final IconData? icon;

  /// Simple case: glyph shown when this item is selected. Falls back to
  /// [icon] when null.
  final IconData? activeIcon;

  /// Full control: build any widget for the unselected state - an
  /// SvgPicture, an Image, a custom painted widget, etc.
  ///
  /// The builder receives the resolved icon color and size so custom
  /// widgets can match the surrounding nav bar's styling. For SVG icons via
  /// flutter_svg, pass the color through as a [ColorFilter]:
  ///
  /// ```dart
  /// iconBuilder: (context, color, size) => SvgPicture.asset(
  ///   'assets/icons/home.svg',
  ///   width: size,
  ///   height: size,
  ///   colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  /// ),
  /// ```
  ///
  /// For a plain [Image] that should NOT be tinted (e.g. a full-color app
  /// icon or photo), just ignore the color argument:
  ///
  /// ```dart
  /// iconBuilder: (context, color, size) => Image.asset(
  ///   'assets/icons/home.png',
  ///   width: size,
  ///   height: size,
  /// ),
  /// ```
  final Widget Function(BuildContext context, Color color, double size)?
      iconBuilder;

  /// Full control: build the widget shown when this item is selected. Falls
  /// back to [iconBuilder] when null.
  final Widget Function(BuildContext context, Color color, double size)?
      activeIconBuilder;

  /// Label shown under the icon (if [showLabel] resolves true).
  final String? label;

  /// Per-item override for whether the label is shown. Null defers to the
  /// navigation bar's own `showLabels`.
  final bool? showLabel;
}
