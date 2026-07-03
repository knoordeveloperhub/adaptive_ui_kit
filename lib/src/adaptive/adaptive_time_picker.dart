import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../config/ui_kit_labels.dart';
import '../glass/glass_time_picker.dart';
import '../material/material_time_picker.dart';

/// Adaptive time picker - routes to Glass or Material based on platform/config
class AdaptiveTimePicker {
  static Future<TimeOfDay?> show({
    required BuildContext context,
    TimeOfDay? initialTime,
    UiKitLabels labels = UiKitLabels.defaultLabels,
    AdaptiveUiKit? uiKit,
  }) {
    switch (resolveUiKit(context, uiKit)) {
      case AdaptiveUiKit.glass:
        return LiquidGlassTimePicker.show(
          context: context,
          initialTime: initialTime,
          labels: labels,
        );
      case AdaptiveUiKit.material:
        return MaterialTimeSheet.show(
          context: context,
          initialTime: initialTime,
        );
    }
  }
}
