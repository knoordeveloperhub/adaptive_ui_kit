import 'package:flutter/material.dart';
import '../widgets/action_sheet_item.dart';
import '../layout/responsive_layout.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../uitils/glass_colors.dart';
import '../widgets/liquid_glass_panel.dart';

/// iOS 26 style action sheet
class LiquidGlassActionSheet {
  static Future<void> show({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    TextStyle? titleStyle,
    required List<ActionSheetItem> items,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.20),
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        top: false,
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveLayout.sheetMaxWidth(ctx),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: LiquidGlassPanel(
                radius: AdaptiveUiKitConfig.glass.sheetRadius,
                topOnly: false,
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    if (titleWidget != null) ...[
                      Align(
                          alignment: Alignment.centerLeft, child: titleWidget),
                      const SizedBox(height: 8),
                    ] else if (title != null) ...[
                      Text(
                        title,
                        style: titleStyle ??
                            TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GlassColors.textMuted(ctx),
                            ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: ResponsiveLayout.bottomSheetBodyMaxHeight(
                          ctx,
                          chromeHeight: title != null ? 90 : 50,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: items
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(999),
                                      onTap: () {
                                        Navigator.of(ctx).pop();
                                        item.onTap();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 13,
                                        ),
                                        decoration: BoxDecoration(
                                          color: GlassColors.rowFill(ctx),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (item.child != null) ...[
                                              item.child!,
                                            ] else ...[
                                              Align(
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  item.icon,
                                                  size: 19,
                                                  color: item.isDestructive
                                                      ? AdaptiveUiKitConfig
                                                          .glass
                                                          .destructiveColor
                                                      : GlassColors.text(ctx),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  item.label,
                                                  softWrap: true,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: item.labelStyle ??
                                                      TextStyle(
                                                        fontSize: 15,
                                                        color: item
                                                                .isDestructive
                                                            ? AdaptiveUiKitConfig
                                                                .glass
                                                                .destructiveColor
                                                            : GlassColors.text(
                                                                ctx),
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
