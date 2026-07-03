import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';

/// Native M3 clock-face time picker
class MaterialTimeSheet {
  static Future<TimeOfDay?> show({
    required BuildContext context,
    TimeOfDay? initialTime,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (ctx, child) => _wrapWithMaterialSurfaceTheme(ctx, child),
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
