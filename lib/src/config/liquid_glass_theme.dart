import 'package:flutter/material.dart';

// =======================================================================
// iOS 26 LIQUID GLASS THEME - every color/size/opacity/duration used by
// the glass kit lives here with a sensible default
// =======================================================================
class LiquidGlassTheme {
  // Brand colors
  final Color tintColor; // primary/prominent actions, selected checkmarks
  final Color destructiveColor; // destructive actions (delete/discard)
  final Color textColorLight; // text color in light mode
  final Color textColorDark; // text color in dark mode
  final Color textMutedColorLight;
  final Color textMutedColorDark;

  // Glass surface opacities (0-1)
  final double surfaceOpacityLight;
  final double surfaceOpacityDark;
  final double borderOpacityLight;
  final double borderOpacityDark;
  final double highlightOpacityLight;
  final double highlightOpacityDark;
  final double rowFillOpacityLight;
  final double rowFillOpacityDark;

  // Blur / lensing
  final double blurSigma;
  final double saturationBoost;

  // Shape
  final double dialogRadius;
  final double sheetRadius;
  final double borderWidth;
  final double highlightStreakHeight;

  // Time picker wheel layout (fixes the "too much horizontal gap" issue -
  // columns are sized to fit their content and centered as a group,
  // instead of stretching to fill the sheet width)
  final double timePickerHourMinuteColumnWidth;
  final double timePickerPeriodColumnWidth;
  final double timePickerColumnGap;

  // Motion
  final Duration entryAnimationDuration;

  // Shadow
  final Color shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;

  const LiquidGlassTheme({
    this.tintColor = const Color(0xFF2F6FED),
    this.destructiveColor = const Color(0xFFE0453A),
    this.textColorLight = const Color(0xFF1A1A1A),
    this.textColorDark = Colors.white,
    this.textMutedColorLight = const Color(0xFF6B6B6B),
    this.textMutedColorDark = Colors.white70,
    this.surfaceOpacityLight = 0.62,
    this.surfaceOpacityDark = 0.14,
    this.borderOpacityLight = 0.55,
    this.borderOpacityDark = 0.22,
    this.highlightOpacityLight = 0.95,
    this.highlightOpacityDark = 0.35,
    this.rowFillOpacityLight = 0.55,
    this.rowFillOpacityDark = 0.09,
    this.blurSigma = 30,
    this.saturationBoost = 1.3,
    this.dialogRadius = 32,
    this.sheetRadius = 34,
    this.borderWidth = 0.8,
    this.highlightStreakHeight = 1.4,
    this.timePickerHourMinuteColumnWidth = 56,
    this.timePickerPeriodColumnWidth = 48,
    this.timePickerColumnGap = 4,
    this.entryAnimationDuration = const Duration(milliseconds: 220),
    this.shadowColor = Colors.black,
    this.shadowBlur = 36,
    this.shadowOffset = const Offset(0, 14),
  });

  LiquidGlassTheme copyWith({
    Color? tintColor,
    Color? destructiveColor,
    Color? textColorLight,
    Color? textColorDark,
    Color? textMutedColorLight,
    Color? textMutedColorDark,
    double? surfaceOpacityLight,
    double? surfaceOpacityDark,
    double? borderOpacityLight,
    double? borderOpacityDark,
    double? highlightOpacityLight,
    double? highlightOpacityDark,
    double? rowFillOpacityLight,
    double? rowFillOpacityDark,
    double? blurSigma,
    double? saturationBoost,
    double? dialogRadius,
    double? sheetRadius,
    double? borderWidth,
    double? highlightStreakHeight,
    double? timePickerHourMinuteColumnWidth,
    double? timePickerPeriodColumnWidth,
    double? timePickerColumnGap,
    Duration? entryAnimationDuration,
    Color? shadowColor,
    double? shadowBlur,
    Offset? shadowOffset,
  }) {
    return LiquidGlassTheme(
      tintColor: tintColor ?? this.tintColor,
      destructiveColor: destructiveColor ?? this.destructiveColor,
      textColorLight: textColorLight ?? this.textColorLight,
      textColorDark: textColorDark ?? this.textColorDark,
      textMutedColorLight: textMutedColorLight ?? this.textMutedColorLight,
      textMutedColorDark: textMutedColorDark ?? this.textMutedColorDark,
      surfaceOpacityLight: surfaceOpacityLight ?? this.surfaceOpacityLight,
      surfaceOpacityDark: surfaceOpacityDark ?? this.surfaceOpacityDark,
      borderOpacityLight: borderOpacityLight ?? this.borderOpacityLight,
      borderOpacityDark: borderOpacityDark ?? this.borderOpacityDark,
      highlightOpacityLight:
          highlightOpacityLight ?? this.highlightOpacityLight,
      highlightOpacityDark: highlightOpacityDark ?? this.highlightOpacityDark,
      rowFillOpacityLight: rowFillOpacityLight ?? this.rowFillOpacityLight,
      rowFillOpacityDark: rowFillOpacityDark ?? this.rowFillOpacityDark,
      blurSigma: blurSigma ?? this.blurSigma,
      saturationBoost: saturationBoost ?? this.saturationBoost,
      dialogRadius: dialogRadius ?? this.dialogRadius,
      sheetRadius: sheetRadius ?? this.sheetRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      highlightStreakHeight:
          highlightStreakHeight ?? this.highlightStreakHeight,
      timePickerHourMinuteColumnWidth:
          timePickerHourMinuteColumnWidth ??
          this.timePickerHourMinuteColumnWidth,
      timePickerPeriodColumnWidth:
          timePickerPeriodColumnWidth ?? this.timePickerPeriodColumnWidth,
      timePickerColumnGap: timePickerColumnGap ?? this.timePickerColumnGap,
      entryAnimationDuration:
          entryAnimationDuration ?? this.entryAnimationDuration,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOffset: shadowOffset ?? this.shadowOffset,
    );
  }
}
