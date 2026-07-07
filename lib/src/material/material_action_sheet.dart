import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../widgets/action_sheet_item.dart';
import '../layout/responsive_layout.dart';

final _pillShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(999),
);

/// Android Material 3 style action sheet
class MaterialActionSheet {
  static Future<void> show({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    TextStyle? titleStyle,
    required List<ActionSheetItem> items,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final surface = AdaptiveUiKitConfig.materialSurface;
    const sheetShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    );

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: sheetShape,
      isScrollControlled: true,
      builder: (ctx) => Material(
        color: surface.background(theme.brightness),
        surfaceTintColor: surface.surfaceTint(scheme, theme.brightness),
        shape: sheetShape,
        child: SafeArea(
          top: false,
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveLayout.sheetMaxWidth(ctx),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 4),
                    decoration: BoxDecoration(
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  if (titleWidget != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: titleWidget,
                      ),
                    )
                  else if (title != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style:
                              titleStyle ?? Theme.of(ctx).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: ResponsiveLayout.bottomSheetBodyMaxHeight(
                          ctx,
                          chromeHeight: title != null ? 80 : 40,
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
                                    color: scheme.surfaceContainerHigh,
                                    shape: _pillShape,
                                    child: InkWell(
                                      customBorder: _pillShape,
                                      onTap: () {
                                        Navigator.of(ctx).pop();
                                        item.onTap();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
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
                                                  color: item.isDestructive
                                                      ? scheme.error
                                                      : scheme.onSurface,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  item.label,
                                                  softWrap: true,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: item.labelStyle ??
                                                      TextStyle(
                                                        color: item
                                                                .isDestructive
                                                            ? scheme.error
                                                            : scheme.onSurface,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
