import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';

/// Native M3 calendar date picker
class MaterialDateSheet {
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    String? helpText,
    String? cancelText,
    String? confirmText,
    String? fieldLabelText,
    String? fieldHintText,
    Widget Function(BuildContext, Widget?)? builder,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: minimumDate ?? DateTime(1990),
      lastDate: maximumDate ?? DateTime(2100),
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      fieldLabelText: fieldLabelText,
      fieldHintText: fieldHintText,
      builder:
          builder ?? (ctx, child) => _wrapWithMaterialSurfaceTheme(ctx, child),
    );
  }
}

/// Applies [AdaptiveUiKitConfig.materialSurface]'s background + surfaceTint
Widget _wrapWithMaterialSurfaceTheme(BuildContext ctx, Widget? child) {
  final theme = Theme.of(ctx);
  final surface = AdaptiveUiKitConfig.materialSurface;
  final resolvedBackground = surface.background(theme.brightness);
  final resolvedTint = surface.surfaceTint(theme.colorScheme, theme.brightness);

  return Theme(
    data: theme.copyWith(
      dialogTheme: theme.dialogTheme.copyWith(
        backgroundColor: resolvedBackground,
        surfaceTintColor: resolvedTint,
      ),
      timePickerTheme: theme.timePickerTheme.copyWith(
        backgroundColor: resolvedBackground,
        dialBackgroundColor: resolvedBackground,
      ),
      datePickerTheme: theme.datePickerTheme.copyWith(
        backgroundColor: resolvedBackground,
        surfaceTintColor: resolvedTint,
      ),
    ),
    child: child!,
  );
}
