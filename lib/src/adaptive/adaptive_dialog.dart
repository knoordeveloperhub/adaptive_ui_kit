import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../glass/glass_dialog.dart';
import '../material/material_dialog.dart';

/// Adaptive confirm dialog - routes to Glass or Material based on platform/config
class AdaptiveDialog {
  static Future<bool?> showConfirm({
    required BuildContext context,
    String? title,
    String? message,
    Widget? titleWidget,
    Widget? messageWidget,
    String? secondaryMessage,
    Widget? secondaryMessageWidget,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    TextStyle? secondaryMessageStyle,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    AdaptiveUiKit? uiKit,
  }) {
    switch (resolveUiKit(context, uiKit)) {
      case AdaptiveUiKit.glass:
        return LiquidGlassDialog.showConfirm(
          context: context,
          title: title,
          message: message,
          titleWidget: titleWidget,
          messageWidget: messageWidget,
          secondaryMessage: secondaryMessage,
          secondaryMessageWidget: secondaryMessageWidget,
          titleStyle: titleStyle,
          messageStyle: messageStyle,
          secondaryMessageStyle: secondaryMessageStyle,
          confirmText: confirmText,
          cancelText: cancelText,
          isDestructive: isDestructive,
        );
      case AdaptiveUiKit.material:
        return MaterialConfirmDialog.showConfirm(
          context: context,
          title: title,
          message: message,
          titleWidget: titleWidget,
          messageWidget: messageWidget,
          secondaryMessage: secondaryMessage,
          secondaryMessageWidget: secondaryMessageWidget,
          titleStyle: titleStyle,
          messageStyle: messageStyle,
          secondaryMessageStyle: secondaryMessageStyle,
          confirmText: confirmText,
          cancelText: cancelText,
          isDestructive: isDestructive,
        );
    }
  }
}
