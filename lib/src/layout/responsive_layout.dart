import 'package:flutter/material.dart';

/// -----------------------------------------------------------------------
/// RESPONSIVE LAYOUT HELPERS
///
/// Centralizes every breakpoint / sizing decision so dialogs, sheets and
/// pickers behave well on phones (portrait + landscape) as well as wider
/// surfaces (tablet / desktop / resized desktop windows) instead of
/// stretching edge-to-edge or clipping in landscape.
/// -----------------------------------------------------------------------
class ResponsiveLayout {
  /// Tablet/desktop breakpoint - matches Material's medium breakpoint.
  static bool isWide(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= 600;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Dialogs (confirm dialog) should never stretch full width - capped on
  /// EVERY device, not just tablets/desktop. A landscape phone has a
  /// shortestSide < 600 (so it isn't "wide") but its actual width can
  /// still be 700-900px, so the cap must apply unconditionally; on a
  /// narrow portrait phone the cap is simply larger than the screen and
  /// has no effect.
  static double dialogMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 440 ? 440 : width;
  }

  /// Same reasoning as [dialogMaxWidth], for bottom sheets (action sheet
  /// / pickers / multi-select).
  static double sheetMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 480 ? 480 : width;
  }

  /// Max height a bottom sheet's SCROLLABLE body (the list / wheel) may
  /// use, after reserving [chromeHeight] for whatever is drawn above it
  /// in the same sheet (drag handle, title row, Done button, etc). This
  /// is what actually prevents landscape overflow: capping just the
  /// overall sheet without reserving room for its own header still lets
  /// the header + list together exceed the available height.
  static double bottomSheetBodyMaxHeight(
    BuildContext context, {
    double chromeHeight = 56,
  }) {
    final media = MediaQuery.of(context);
    // Leave room for the status bar / notch / gesture nav / keyboard.
    final safeHeight =
        media.size.height - media.padding.vertical - media.viewInsets.bottom;
    final fraction = isLandscape(context) ? 0.92 : 0.6;
    final available = (safeHeight * fraction) - chromeHeight;
    return available.clamp(120.0, safeHeight - chromeHeight);
  }

  /// Height for the fixed-height wheel pickers (date/time). Shrinks in
  /// landscape (short screens) instead of overflowing, and never grows
  /// past [max] on very tall desktop windows.
  static double wheelPickerHeight(
    BuildContext context, {
    double base = 232,
    double max = 260,
  }) {
    final media = MediaQuery.of(context);
    final safeHeight =
        media.size.height - media.padding.vertical - media.viewInsets.bottom;
    if (isLandscape(context)) {
      final landscapeHeight = safeHeight * 0.55;
      return landscapeHeight.clamp(140.0, base);
    }
    return base.clamp(150.0, max);
  }
}
