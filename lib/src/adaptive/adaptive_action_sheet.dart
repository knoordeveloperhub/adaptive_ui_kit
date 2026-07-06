import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../widgets/action_sheet_item.dart';
import '../glass/glass_action_sheet.dart';
import '../material/material_action_sheet.dart';

/// Adaptive action sheet - routes to Glass or Material based on platform/config
class AdaptiveActionSheet {
  static Future<void> show({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    TextStyle? titleStyle,
    required List<ActionSheetItem> items,
    AdaptiveUiKit? uiKit,
  }) {
    switch (resolveUiKit(context, uiKit)) {
      case AdaptiveUiKit.glass:
        return LiquidGlassActionSheet.show(
          context: context,
          title: title,
          titleWidget: titleWidget,
          titleStyle: titleStyle,
          items: items,
        );
      case AdaptiveUiKit.material:
        return MaterialActionSheet.show(
          context: context,
          title: title,
          titleWidget: titleWidget,
          titleStyle: titleStyle,
          items: items,
        );
    }
  }
}
