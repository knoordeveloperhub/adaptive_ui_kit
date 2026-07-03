import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../config/ui_kit_labels.dart';
import '../models/multi_select_option.dart';
import '../glass/glass_multi_select.dart';
import '../material/material_multi_select.dart';

/// Adaptive multi-select - routes to Glass or Material based on platform/config
class AdaptiveMultiSelect {
  static Future<List<String>?> show({
    required BuildContext context,
    required String title,
    required List<MultiSelectOption> options,
    List<String> initiallySelected = const [],
    UiKitLabels labels = UiKitLabels.defaultLabels,
    AdaptiveUiKit? uiKit,
  }) {
    switch (resolveUiKit(context, uiKit)) {
      case AdaptiveUiKit.glass:
        return LiquidGlassMultiSelect.show(
          context: context,
          title: title,
          options: options,
          initiallySelected: initiallySelected,
          labels: labels,
        );
      case AdaptiveUiKit.material:
        return MaterialMultiSelectSheet.show(
          context: context,
          title: title,
          options: options,
          initiallySelected: initiallySelected,
          labels: labels,
        );
    }
  }
}
