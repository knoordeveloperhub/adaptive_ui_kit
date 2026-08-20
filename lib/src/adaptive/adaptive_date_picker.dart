import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../glass/glass_date_picker.dart';
import '../material/material_date_picker.dart';

/// Adaptive date picker - routes to Glass or Material based on platform/config
class AdaptiveDateTimePicker {
  /// Shows a platform-adaptive date range picker.
  static Future<DateTimeRange?> showDateRange({
    required BuildContext context,
    DateTimeRange? initialDateRange,
    DateTime? minimumDate,
    DateTime? maximumDate,
    ValueChanged<DateTimeRange>? onChanged,
    String? helpText,
    String? cancelText,
    String? confirmText,
    Widget Function(BuildContext, Widget?)? builder,
    AdaptiveUiKit? uiKit,
  }) {
    switch (resolveUiKit(context, uiKit)) {
      case AdaptiveUiKit.glass:
        return LiquidGlassDateRangeSheet.show(
          context: context,
          initialDateRange: initialDateRange,
          minimumDate: minimumDate,
          maximumDate: maximumDate,
          onChanged: onChanged,
          cancelText: cancelText,
          confirmText: confirmText,
        );
      case AdaptiveUiKit.material:
        return MaterialDateRangeSheet.show(
          context: context,
          initialDateRange: initialDateRange,
          minimumDate: minimumDate,
          maximumDate: maximumDate,
          helpText: helpText,
          cancelText: cancelText,
          confirmText: confirmText,
          builder: builder,
        );
    }
  }

  /// `mode` only applies to the iOS glass sheet; Android always shows
  /// its native calendar dialog for dates. `onChanged` fires live on
  /// iOS as the wheel scrolls (Android's native picker has no live
  /// callback - it only resolves once OK is tapped, per Material spec).
  static Future<DateTime?> showDate({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    ValueChanged<DateTime>? onChanged,
    String? helpText,
    String? cancelText,
    String? confirmText,
    String? fieldLabelText,
    String? fieldHintText,
    Widget Function(BuildContext, Widget?)? builder,
    AdaptiveUiKit? uiKit,
  }) {
    switch (resolveUiKit(context, uiKit)) {
      case AdaptiveUiKit.glass:
        return LiquidGlassDateTimeSheet.show(
          context: context,
          initialDate: initialDate,
          mode: CupertinoDatePickerMode.date,
          minimumDate: minimumDate,
          maximumDate: maximumDate,
          onChanged: onChanged,
        );
      case AdaptiveUiKit.material:
        return MaterialDateSheet.show(
          context: context,
          initialDate: initialDate,
          minimumDate: minimumDate,
          maximumDate: maximumDate,
          helpText: helpText,
          cancelText: cancelText,
          confirmText: confirmText,
          fieldLabelText: fieldLabelText,
          fieldHintText: fieldHintText,
          builder: builder,
        );
    }
  }
}
