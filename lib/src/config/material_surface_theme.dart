import 'package:flutter/material.dart';

/// -----------------------------------------------------------------------
/// MATERIAL SURFACE THEME - controls the background color used by every
/// Material dialog/sheet (confirm dialog, action sheet, multi-select,
/// date/time pickers), and the card color used by the individual rows
/// inside action sheets and multi-select lists.
///
/// No surfaceTintColor anywhere - it's forced to `Colors.transparent` on
/// every Material widget so no extra tint ever gets painted on top of
/// your colors, in any kit.
///
/// Leave everything null (the default) and you get a plain, dependable
/// look: white background / light-grey cards in light mode, black
/// background / faint-white cards in dark mode.
///
/// Want your own brand colors instead? Override any field:
///   AdaptiveUiKitConfig.materialSurface = AdaptiveUiKitConfig.materialSurface.copyWith(
///     backgroundColorLight: Colors.white,
///     backgroundColorDark: const Color(0xFF121212),
///     cardColorLight: Colors.grey.shade100,
///     cardColorDark: Colors.grey.shade900,
///   );
/// -----------------------------------------------------------------------
class MaterialSurfaceTheme {
  final Color? backgroundColorLight;
  final Color? backgroundColorDark;
  final Color? cardColorLight;
  final Color? cardColorDark;
  final Color? surfaceTintColorLight;
  final Color? surfaceTintColorDark;

  const MaterialSurfaceTheme({
    this.backgroundColorLight,
    this.backgroundColorDark,
    this.cardColorLight,
    this.cardColorDark,
    this.surfaceTintColorLight,
    this.surfaceTintColorDark,
  });

  MaterialSurfaceTheme copyWith({
    Color? backgroundColorLight,
    Color? backgroundColorDark,
    Color? cardColorLight,
    Color? cardColorDark,
    Color? surfaceTintColorLight,
    Color? surfaceTintColorDark,
  }) {
    return MaterialSurfaceTheme(
      backgroundColorLight: backgroundColorLight ?? this.backgroundColorLight,
      backgroundColorDark: backgroundColorDark ?? this.backgroundColorDark,
      cardColorLight: cardColorLight ?? this.cardColorLight,
      cardColorDark: cardColorDark ?? this.cardColorDark,
      surfaceTintColorLight:
          surfaceTintColorLight ?? this.surfaceTintColorLight,
      surfaceTintColorDark: surfaceTintColorDark ?? this.surfaceTintColorDark,
    );
  }

  /// Resolved background for the given [brightness].
  /// Defaults: white (light) / black (dark).
  Color background(Brightness brightness) {
    return brightness == Brightness.dark
        ? (backgroundColorDark ?? Colors.black)
        : (backgroundColorLight ?? Colors.white);
  }

  /// Resolved row/card color (action sheet items, multi-select items) for
  /// the given [brightness]. Defaults: light-grey on light backgrounds,
  /// faint white on dark backgrounds - always distinguishable from
  /// [background] regardless of theme.
  Color card(Brightness brightness) {
    return brightness == Brightness.dark
        ? (cardColorDark ?? Colors.white.withValues(alpha: 0.08))
        : (cardColorLight ?? Colors.black.withValues(alpha: 0.05));
  }

  /// Resolved surface tint for the given [brightness]. Defaults to
  /// [Colors.transparent] so [background] stays pure white (light) /
  /// pure black (dark) unless the user explicitly supplies their own
  /// [surfaceTintColorLight] / [surfaceTintColorDark].
  Color surfaceTint(ColorScheme scheme, Brightness brightness) {
    return brightness == Brightness.dark
        ? (surfaceTintColorDark ?? Colors.transparent)
        : (surfaceTintColorLight ?? Colors.transparent);
  }
}
