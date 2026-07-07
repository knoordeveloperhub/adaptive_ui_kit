import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../config/ui_kit_labels.dart';
import '../widgets/multi_select_option.dart';
import '../layout/responsive_layout.dart';

final _pillShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(999),
);

/// Android Material 3 style multi-select sheet
class MaterialMultiSelectSheet {
  static Future<List<String>?> show({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    TextStyle? titleStyle,
    required List<MultiSelectOption> options,
    List<String> initiallySelected = const [],
    UiKitLabels labels = UiKitLabels.defaultLabels,
  }) {
    final selected = {...initiallySelected};
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final surface = AdaptiveUiKitConfig.materialSurface;
    const sheetShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    );

    return showModalBottomSheet<List<String>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: sheetShape,
      builder: (ctx) => Material(
        color: surface.background(theme.brightness),
        surfaceTintColor: surface.surfaceTint(scheme, theme.brightness),
        shape: sheetShape,
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return SafeArea(
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            titleWidget ??
                                (title != null
                                    ? Text(
                                        title,
                                        style: titleStyle ??
                                            Theme.of(ctx).textTheme.titleMedium,
                                      )
                                    : const SizedBox.shrink()),
                            TextButton(
                              style: TextButton.styleFrom(shape: _pillShape),
                              onPressed: () =>
                                  Navigator.of(ctx).pop(selected.toList()),
                              child: Text(labels.done),
                            ),
                          ],
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: ResponsiveLayout.bottomSheetBodyMaxHeight(
                            ctx,
                            chromeHeight: 70,
                          ),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: options.length,
                          itemBuilder: (_, index) {
                            final option = options[index];
                            final isSelected = selected.contains(option.id);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Material(
                                color: scheme.surfaceContainerHigh,
                                shape: _pillShape,
                                child: CheckboxListTile(
                                  shape: _pillShape,
                                  value: isSelected,
                                  title: option.child ??
                                      Text(
                                        option.label,
                                        softWrap: true,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: option.labelStyle,
                                      ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  onChanged: (_) {
                                    setState(() {
                                      if (isSelected) {
                                        selected.remove(option.id);
                                      } else {
                                        selected.add(option.id);
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
