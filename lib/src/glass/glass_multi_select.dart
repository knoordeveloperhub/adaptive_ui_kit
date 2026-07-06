import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../config/ui_kit_labels.dart';
import '../widgets/multi_select_option.dart';
import '../layout/responsive_layout.dart';
import '../uitils/glass_colors.dart';
import '../widgets/liquid_glass_panel.dart';

/// iOS 26 style multi-select sheet
class LiquidGlassMultiSelect {
  static Future<List<String>?> show({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    TextStyle? titleStyle,
    required List<MultiSelectOption> options,
    List<String> initiallySelected = const [],
    UiKitLabels labels = UiKitLabels.defaultLabels,
  }) {
    return showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.20),
      builder: (ctx) => _LiquidGlassMultiSelectSheet(
        title: title,
        titleWidget: titleWidget,
        titleStyle: titleStyle,
        options: options,
        initiallySelected: initiallySelected,
        labels: labels,
      ),
    );
  }
}

class _LiquidGlassMultiSelectSheet extends StatefulWidget {
  final String? title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final List<MultiSelectOption> options;
  final List<String> initiallySelected;
  final UiKitLabels labels;

  const _LiquidGlassMultiSelectSheet({
    this.title,
    this.titleWidget,
    this.titleStyle,
    required this.options,
    required this.initiallySelected,
    required this.labels,
  });

  @override
  State<_LiquidGlassMultiSelectSheet> createState() =>
      _LiquidGlassMultiSelectSheetState();
}

class _LiquidGlassMultiSelectSheetState
    extends State<_LiquidGlassMultiSelectSheet> {
  late final Set<String> _selected = {...widget.initiallySelected};
  late final ScrollController _scrollController = ScrollController();
  bool _isScrollable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateScrollbarState(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollbarState() {
    if (!mounted || !_scrollController.hasClients) return;
    final needsScrollbar = _scrollController.position.maxScrollExtent > 0;
    if (needsScrollbar != _isScrollable) {
      setState(() => _isScrollable = needsScrollbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveLayout.sheetMaxWidth(context),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: LiquidGlassPanel(
              radius: AdaptiveUiKitConfig.glass.sheetRadius,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.titleWidget ??
                          (widget.title != null
                              ? Text(
                                  widget.title!,
                                  style: widget.titleStyle ??
                                      TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: GlassColors.text(context),
                                      ),
                                )
                              : const SizedBox.shrink()),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pop(_selected.toList()),
                        child: Text(
                          widget.labels.done,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AdaptiveUiKitConfig.glass.tintColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: ResponsiveLayout.bottomSheetBodyMaxHeight(
                        context,
                        chromeHeight: 90,
                      ),
                    ),
                    child: NotificationListener<ScrollMetricsNotification>(
                      onNotification: (notification) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => _updateScrollbarState(),
                        );
                        return false;
                      },
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: _isScrollable,
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                            right: _isScrollable ? 10 : 0,
                          ),
                          itemCount: widget.options.length,
                          itemBuilder: (_, index) {
                            final option = widget.options[index];
                            final isSelected = _selected.contains(option.id);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(999),
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        _selected.remove(option.id);
                                      } else {
                                        _selected.add(option.id);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 13,
                                    ),
                                    decoration: BoxDecoration(
                                      color: GlassColors.rowFill(context),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        option.child ??
                                            Text(
                                              option.label,
                                              style: option.labelStyle ??
                                                  TextStyle(
                                                    fontSize: 15,
                                                    color: GlassColors.text(
                                                        context),
                                                  ),
                                            ),
                                        if (isSelected)
                                          Icon(
                                            CupertinoIcons.check_mark,
                                            size: 18,
                                            color: AdaptiveUiKitConfig
                                                .glass.tintColor,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
