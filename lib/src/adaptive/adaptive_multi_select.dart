import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../config/ui_kit_labels.dart';
import '../widgets/multi_select_option.dart';
import '../glass/glass_multi_select.dart';
import '../material/material_multi_select.dart';

/// Adaptive multi-select - routes to Glass or Material based on platform/config
class AdaptiveMultiSelect {
  static Future<List<String>?> show({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    TextStyle? titleStyle,
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
          titleWidget: titleWidget,
          titleStyle: titleStyle,
          options: options,
          initiallySelected: initiallySelected,
          labels: labels,
        );
      case AdaptiveUiKit.material:
        return MaterialMultiSelectSheet.show(
          context: context,
          title: title,
          titleWidget: titleWidget,
          titleStyle: titleStyle,
          options: options,
          initiallySelected: initiallySelected,
          labels: labels,
        );
    }
  }
}
