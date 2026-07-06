import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../layout/responsive_layout.dart';

final _pillShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(999),
);

/// Android Material 3 style confirm dialog
class MaterialConfirmDialog {
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
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final surface = AdaptiveUiKitConfig.materialSurface;

    return showDialog<bool>(
      context: context,
      builder: (dialogCtx) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveLayout.dialogMaxWidth(dialogCtx),
            ),
            child: AlertDialog(
              backgroundColor: surface.background(theme.brightness),
              surfaceTintColor: surface.surfaceTint(scheme, theme.brightness),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              title: titleWidget ??
                  (title != null ? Text(title, style: titleStyle) : null),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (messageWidget != null)
                    messageWidget
                  else if (message != null)
                    Text(message, style: messageStyle)
                  else
                    const SizedBox.shrink(),
                  if (secondaryMessage != null ||
                      secondaryMessageWidget != null) ...[
                    const SizedBox(height: 8),
                    secondaryMessageWidget ??
                        Text(secondaryMessage ?? '',
                            style: secondaryMessageStyle),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(shape: _pillShape),
                  onPressed: () => Navigator.of(dialogCtx).pop(false),
                  child: Text(cancelText),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    shape: _pillShape,
                    backgroundColor: isDestructive ? scheme.error : null,
                  ),
                  onPressed: () => Navigator.of(dialogCtx).pop(true),
                  child: Text(confirmText),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
