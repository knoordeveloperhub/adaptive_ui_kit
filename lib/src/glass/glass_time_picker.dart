import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../config/ui_kit_labels.dart';
import '../layout/responsive_layout.dart';
import '../uitils/glass_colors.dart';
import '../widgets/liquid_glass_panel.dart';

/// Custom scroll-wheel time picker (hour / minute / AM-PM) with a glass
/// "selection band" fixed in the middle
class LiquidGlassTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onChanged;
  final UiKitLabels labels;

  const LiquidGlassTimePicker({
    super.key,
    required this.initialTime,
    required this.onChanged,
    this.labels = UiKitLabels.defaultLabels,
  });

  static Future<TimeOfDay?> show({
    required BuildContext context,
    TimeOfDay? initialTime,
    UiKitLabels labels = UiKitLabels.defaultLabels,
  }) {
    TimeOfDay selected = initialTime ?? TimeOfDay.now();

    return showDialog<TimeOfDay>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.20),
      builder: (dialogCtx) {
        final isLandscape = ResponsiveLayout.isLandscape(dialogCtx);

        final panel = ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveLayout.sheetMaxWidth(dialogCtx),
          ),
          child: LiquidGlassPanel(
            radius: AdaptiveUiKitConfig.glass.sheetRadius,
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
            child: SizedBox(
              height: ResponsiveLayout.wheelPickerHeight(dialogCtx, base: 220),
              child: LiquidGlassTimePicker(
                key: const ValueKey('liquid_glass_time_picker'),
                initialTime: selected,
                labels: labels,
                onChanged: (val) => selected = val,
              ),
            ),
          ),
        );

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(dialogCtx).pop(selected),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (layoutCtx, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLandscape ? 70 : 12,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 48,
                    ),
                    child: PopScope(
                      canPop: false,
                      onPopInvokedWithResult: (didPop, result) {
                        if (didPop) return;
                        Navigator.of(dialogCtx).pop(selected);
                      },
                      child: Center(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {},
                          child: panel,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  State<LiquidGlassTimePicker> createState() => _LiquidGlassTimePickerState();
}

class _LiquidGlassTimePickerState extends State<LiquidGlassTimePicker> {
  late FixedExtentScrollController _hourCtrl;
  late FixedExtentScrollController _minuteCtrl;
  late FixedExtentScrollController _periodCtrl;

  late int _hour12;
  late int _minute;
  late int _periodIndex; // 0 = AM, 1 = PM

  static const double _itemExtent = 38;

  @override
  void initState() {
    super.initState();
    final h24 = widget.initialTime.hour;
    _hour12 = h24 % 12 == 0 ? 12 : h24 % 12;
    _minute = widget.initialTime.minute;
    _periodIndex = h24 >= 12 ? 1 : 0;

    _hourCtrl = FixedExtentScrollController(initialItem: _hour12 - 1);
    _minuteCtrl = FixedExtentScrollController(initialItem: _minute);
    _periodCtrl = FixedExtentScrollController(initialItem: _periodIndex);
  }

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    _periodCtrl.dispose();
    super.dispose();
  }

  void _emitChange() {
    var h24 = _hour12 % 12;
    if (_periodIndex == 1) h24 += 12;
    widget.onChanged(TimeOfDay(hour: h24, minute: _minute));
  }

  Widget _wheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int index) labelBuilder,
    required ValueChanged<int> onSelected,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: _itemExtent,
      diameterRatio: 1.6,
      perspective: 0.004,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onSelected,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          return Center(
            child: Text(
              labelBuilder(index),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: GlassColors.text(context),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: AdaptiveUiKitConfig.glass.timePickerHourMinuteColumnWidth,
              child: _wheel(
                controller: _hourCtrl,
                itemCount: 12,
                labelBuilder: (i) => '${i + 1}',
                onSelected: (i) {
                  _hour12 = i + 1;
                  _emitChange();
                },
              ),
            ),
            SizedBox(width: AdaptiveUiKitConfig.glass.timePickerColumnGap),
            SizedBox(
              width: AdaptiveUiKitConfig.glass.timePickerHourMinuteColumnWidth,
              child: _wheel(
                controller: _minuteCtrl,
                itemCount: 60,
                labelBuilder: (i) => i.toString().padLeft(2, '0'),
                onSelected: (i) {
                  _minute = i;
                  _emitChange();
                },
              ),
            ),
            SizedBox(width: AdaptiveUiKitConfig.glass.timePickerColumnGap * 2),
            SizedBox(
              width: AdaptiveUiKitConfig.glass.timePickerPeriodColumnWidth,
              child: _wheel(
                controller: _periodCtrl,
                itemCount: 2,
                labelBuilder: (i) =>
                    i == 0 ? widget.labels.am : widget.labels.pm,
                onSelected: (i) {
                  _periodIndex = i;
                  _emitChange();
                },
              ),
            ),
          ],
        ),
        IgnorePointer(
          child: Container(
            height: _itemExtent,
            width:
                AdaptiveUiKitConfig.glass.timePickerHourMinuteColumnWidth * 2 +
                    AdaptiveUiKitConfig.glass.timePickerPeriodColumnWidth +
                    AdaptiveUiKitConfig.glass.timePickerColumnGap * 3 +
                    24,
            decoration: BoxDecoration(
              color: GlassColors.rowFill(context),
              borderRadius: BorderRadius.circular(999),
              border:
                  Border.all(color: GlassColors.highlight(context), width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}
