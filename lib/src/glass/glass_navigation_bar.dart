import 'dart:ui';

import 'package:flutter/material.dart';

import '../../adaptive_ui_kit.dart';

/// Glass-style bottom navigation bar for Apple platforms (iOS 26+).
/// Renders as a floating pill with drag-to-select animation, mirroring the
/// iPhone Phone app design.
class GlassNavigationBar extends StatefulWidget {
  /// Creates a glass navigation bar.
  const GlassNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.showLabels = true,
    required this.items,
    this.backgroundColor,
  });

  /// The index of the currently selected item.
  final int currentIndex;

  /// Called when an item is tapped.
  final ValueChanged<int>? onTap;

  /// Whether labels should be shown for navigation items.
  final bool showLabels;

  /// The items displayed in the navigation bar.
  final List<AdaptiveNavItem> items;

  /// Optional solid background color for the navigation bar.
  ///
  /// When null, the bar keeps the default translucent glass look.
  final Color? backgroundColor;

  @override
  State<GlassNavigationBar> createState() => _GlassNavigationBarState();
}

class _GlassNavigationBarState extends State<GlassNavigationBar> {
  static const double _capsuleMargin = 4;
  static const double _barHorizontalPadding = 12;
  static const double _barBottomMargin = 12;

  /// Finger x-position within the bar while dragging, null otherwise.
  double? _dragX;

  int _indexAt(double x, double barWidth) {
    final itemWidth = barWidth / widget.items.length;
    return (x ~/ itemWidth).clamp(0, widget.items.length - 1);
  }

  /// Builds a standard saturation matrix so the blurred backdrop stays
  /// vivid/colourful instead of turning into a washed-out grey smear -
  /// this is what makes real Liquid Glass content behind the bar still
  /// read as colourful even though it's heavily blurred.
  static List<double> _saturationMatrix(double s) {
    const rw = 0.213, gw = 0.715, bw = 0.072;
    return <double>[
      rw + (1 - rw) * s,
      gw - gw * s,
      bw - bw * s,
      0,
      0,
      rw - rw * s,
      gw + (1 - gw) * s,
      bw - bw * s,
      0,
      0,
      rw - rw * s,
      gw - gw * s,
      bw + (1 - bw) * s,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tint = AdaptiveUiKitConfig.glass.tintColor;
    final hasVisibleLabels =
        widget.items.any((item) => item.showLabel ?? widget.showLabels);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _barHorizontalPadding,
        0,
        _barHorizontalPadding,
        _barBottomMargin,
      ),
      // Ambient shadow lives on this outer, unclipped container - putting it
      // inside the ClipRRect below (as before) meant the shadow was clipped
      // away entirely except for a thin uneven sliver near the curved
      // corners, which showed up as a stray glow/bulge artifact.
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: widget.backgroundColor != null
              ? Container(
                  height: hasVisibleLabels ? 68 : 56,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.18)
                          : Colors.white.withValues(alpha: 0.65),
                      width: 0.75,
                    ),
                  ),
                  child: Stack(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final barWidth = constraints.maxWidth;
                          final itemWidth = barWidth / widget.items.length;
                          final dragging = _dragX != null;
                          final activeIndex = dragging
                              ? _indexAt(_dragX!, barWidth)
                              : widget.currentIndex;
                          final capsuleLeft = dragging
                              ? (_dragX! - itemWidth / 2)
                                  .clamp(0.0, barWidth - itemWidth)
                              : widget.currentIndex * itemWidth;

                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapUp: (details) => widget.onTap?.call(
                                _indexAt(details.localPosition.dx, barWidth)),
                            onHorizontalDragStart: (details) => setState(
                                () => _dragX = details.localPosition.dx),
                            onHorizontalDragUpdate: (details) => setState(() =>
                                _dragX = details.localPosition.dx
                                    .clamp(0.0, barWidth)),
                            onHorizontalDragEnd: (_) {
                              final index = _indexAt(_dragX!, barWidth);
                              setState(() => _dragX = null);
                              widget.onTap?.call(index);
                            },
                            onHorizontalDragCancel: () =>
                                setState(() => _dragX = null),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: dragging
                                      ? Duration.zero
                                      : const Duration(milliseconds: 420),
                                  curve: dragging
                                      ? Curves.linear
                                      : Curves.easeOutBack,
                                  left: capsuleLeft + _capsuleMargin,
                                  top: _capsuleMargin,
                                  bottom: _capsuleMargin,
                                  width: itemWidth - _capsuleMargin * 2,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.16)
                                          : Colors.white
                                              .withValues(alpha: 0.65),
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                            alpha: isDark ? 0.12 : 0.8),
                                        width: 0.75,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    for (var i = 0;
                                        i < widget.items.length;
                                        i++)
                                      Expanded(
                                        child: _GlassNavItem(
                                          item: widget.items[i],
                                          selected: i == activeIndex,
                                          tint: tint,
                                          showLabel:
                                              widget.items[i].showLabel ??
                                                  widget.showLabels,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              : BackdropFilter(
                  filter: ImageFilter.compose(
                    outer: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    inner: ColorFilter.matrix(_saturationMatrix(1.35)),
                  ),
                  child: Container(
                    height: hasVisibleLabels ? 68 : 56,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.22)
                          : Colors.white.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.18)
                            : Colors.white.withValues(alpha: 0.65),
                        width: 0.75,
                      ),
                    ),
                    child: Stack(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final barWidth = constraints.maxWidth;
                            final itemWidth = barWidth / widget.items.length;
                            final dragging = _dragX != null;
                            final activeIndex = dragging
                                ? _indexAt(_dragX!, barWidth)
                                : widget.currentIndex;
                            final capsuleLeft = dragging
                                ? (_dragX! - itemWidth / 2)
                                    .clamp(0.0, barWidth - itemWidth)
                                : widget.currentIndex * itemWidth;

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapUp: (details) => widget.onTap?.call(
                                  _indexAt(details.localPosition.dx, barWidth)),
                              onHorizontalDragStart: (details) => setState(
                                  () => _dragX = details.localPosition.dx),
                              onHorizontalDragUpdate: (details) => setState(
                                  () => _dragX = details.localPosition.dx
                                      .clamp(0.0, barWidth)),
                              onHorizontalDragEnd: (_) {
                                final index = _indexAt(_dragX!, barWidth);
                                setState(() => _dragX = null);
                                widget.onTap?.call(index);
                              },
                              onHorizontalDragCancel: () =>
                                  setState(() => _dragX = null),
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    duration: dragging
                                        ? Duration.zero
                                        : const Duration(milliseconds: 420),
                                    curve: dragging
                                        ? Curves.linear
                                        : Curves.easeOutBack,
                                    left: capsuleLeft + _capsuleMargin,
                                    top: _capsuleMargin,
                                    bottom: _capsuleMargin,
                                    width: itemWidth - _capsuleMargin * 2,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.white
                                                .withValues(alpha: 0.16)
                                            : Colors.white
                                                .withValues(alpha: 0.65),
                                        borderRadius: BorderRadius.circular(28),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                              alpha: isDark ? 0.12 : 0.8),
                                          width: 0.75,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      for (var i = 0;
                                          i < widget.items.length;
                                          i++)
                                        Expanded(
                                          child: _GlassNavItem(
                                            item: widget.items[i],
                                            selected: i == activeIndex,
                                            tint: tint,
                                            showLabel:
                                                widget.items[i].showLabel ??
                                                    widget.showLabels,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _GlassNavItem extends StatelessWidget {
  const _GlassNavItem({
    required this.item,
    required this.selected,
    required this.tint,
    required this.showLabel,
  });

  final AdaptiveNavItem item;
  final bool selected;
  final Color tint;
  final bool showLabel;

  // Apple HIG-ish sizing: unselected icons sit at a slightly smaller base
  // size, and the selected icon scales up with a spring bounce rather than
  // both rendering at a single fixed 24px with no distinction.
  static const double _baseIconSize = 22;
  static const double _selectedScale = 1.18;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Unselected icons stay near-solid black/white, matching the reference
    // - a heavily faded (~0.45) unselected icon combined with a very
    // transparent bar made the whole thing look washed out rather than
    // "glass with crisp icons floating on it".
    final iconColor = selected
        ? tint
        : (isDark
            ? Colors.white.withValues(alpha: 0.92)
            : Colors.black.withValues(alpha: 0.87));
    final textColor = selected
        ? tint
        : (isDark
            ? Colors.white.withValues(alpha: 0.92)
            : Colors.black.withValues(alpha: 0.87));
    final icon = selected ? (item.activeIcon ?? item.icon) : item.icon;
    final builder = selected
        ? (item.activeIconBuilder ?? item.iconBuilder)
        : item.iconBuilder;

    // Prefer the custom builder (SVG/Image/any widget) when provided;
    // otherwise fall back to the plain IconData rendering.
    final Widget iconWidget = builder != null
        ? SizedBox(
            width: _baseIconSize,
            height: _baseIconSize,
            child: builder(context, iconColor, _baseIconSize),
          )
        : Icon(icon, color: iconColor, size: _baseIconSize);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 1.0,
              end: selected ? _selectedScale : 1.0,
            ),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: iconWidget,
          ),
          if (showLabel && item.label != null) ...[
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                decoration: TextDecoration.none,
              ),
              child: Text(
                item.label!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
