import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/adaptive_ui_kit_config.dart';
import '../layout/responsive_layout.dart';
import '../uitils/glass_colors.dart';
import '../widgets/liquid_glass_panel.dart';

/// iOS-style month-grid calendar (like the native Calendar app / EventKit
/// date picker) - replaces the spinning CupertinoDatePicker wheel for pure
/// date selection. Tapping a day updates [onChanged] live, same contract
/// as the wheel had.
class _GlassMonthGridCalendar extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final ValueChanged<DateTime> onChanged;

  const _GlassMonthGridCalendar({
    required this.initialDate,
    required this.onChanged,
    this.minimumDate,
    this.maximumDate,
  });

  @override
  State<_GlassMonthGridCalendar> createState() =>
      _GlassMonthGridCalendarState();
}

class _GlassMonthGridCalendarState extends State<_GlassMonthGridCalendar> {
  late DateTime _visibleMonth;
  late DateTime _selected;
  bool _showMonthYearPicker = false;

  static const _weekdayLabels = [
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
  ];
  static const _monthLabels = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate;
    _visibleMonth = DateTime(_selected.year, _selected.month, 1);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isDisabled(DateTime day) {
    if (widget.minimumDate != null) {
      final min = widget.minimumDate!;
      if (day.isBefore(DateTime(min.year, min.month, min.day))) return true;
    }
    if (widget.maximumDate != null) {
      final max = widget.maximumDate!;
      if (day.isAfter(DateTime(max.year, max.month, max.day))) return true;
    }
    return false;
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + delta,
        1,
      );
    });
  }

  void _selectDay(DateTime day) {
    if (_isDisabled(day)) return;
    setState(() {
      _selected = DateTime(
        day.year,
        day.month,
        day.day,
        _selected.hour,
        _selected.minute,
      );
    });
    widget.onChanged(_selected);
  }

  @override
  Widget build(BuildContext context) {
    final tint = AdaptiveUiKitConfig.glass.tintColor;
    final firstWeekday =
        DateTime(_visibleMonth.year, _visibleMonth.month, 1).weekday % 7;
    final daysInMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    ).day;

    const cellSize = 40.0;
    const rowGap = 6.0;
    const maxRows = 6;
    const gridHeight = maxRows * cellSize + (maxRows - 1) * rowGap;

    Widget dayCell(int d) {
      final day = DateTime(_visibleMonth.year, _visibleMonth.month, d);
      final isSelected = _isSameDay(day, _selected);
      final isToday = _isSameDay(day, DateTime.now());
      final disabled = _isDisabled(day);

      return GestureDetector(
        onTap: disabled ? null : () => _selectDay(day),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: cellSize,
            height: cellSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? tint : Colors.transparent,
            ),
            child: Text(
              '$d',
              style: TextStyle(
                fontSize: 19,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: disabled
                    ? GlassColors.textMuted(context).withValues(alpha: 0.4)
                    : isSelected
                        ? Colors.white
                        : isToday
                            ? tint
                            : GlassColors.text(context),
              ),
            ),
          ),
        ),
      );
    }

    final flatCells = <Widget>[
      for (var i = 0; i < firstWeekday; i++) const SizedBox.shrink(),
      for (var d = 1; d <= daysInMonth; d++) dayCell(d),
    ];
    final remainder = flatCells.length % 7;
    if (remainder != 0) {
      flatCells.addAll(List.filled(7 - remainder, const SizedBox.shrink()));
    }

    final weekRows = <Widget>[
      for (var r = 0; r < flatCells.length ~/ 7; r++)
        Expanded(
          child: Row(
            children: [
              for (var c = 0; c < 7; c++) Expanded(child: flatCells[r * 7 + c]),
            ],
          ),
        ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(
                  () => _showMonthYearPicker = !_showMonthYearPicker,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_monthLabels[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _showMonthYearPicker
                            ? tint
                            : GlassColors.text(context),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: AnimatedRotation(
                        turns: _showMonthYearPicker ? 0.25 : 0,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        child: Icon(
                          CupertinoIcons.chevron_forward,
                          size: 18,
                          color: tint,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (!_showMonthYearPicker) ...[
                _GlassCalendarNavArrow(
                  icon: CupertinoIcons.chevron_left,
                  onTap: () => _changeMonth(-1),
                ),
                const SizedBox(width: 10),
                _GlassCalendarNavArrow(
                  icon: CupertinoIcons.chevron_right,
                  onTap: () => _changeMonth(1),
                ),
              ],
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _showMonthYearPicker
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: SizedBox(
                      height: 232,
                      child: _GlassMonthYearWheel(
                        month: _visibleMonth.month,
                        year: _visibleMonth.year,
                        minimumDate: widget.minimumDate,
                        maximumDate: widget.maximumDate,
                        onChanged: (month, year) {
                          setState(() {
                            _visibleMonth = DateTime(year, month, 1);
                          });
                        },
                      ),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 14),
                      Row(
                        children: _weekdayLabels
                            .map(
                              (w) => Expanded(
                                child: Center(
                                  child: Text(
                                    w,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.4,
                                      color: GlassColors.textMuted(context),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: gridHeight,
                        child: Column(children: weekRows),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// Two-column month/year scroll-wheel
class _GlassMonthYearWheel extends StatefulWidget {
  final int month;
  final int year;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final void Function(int month, int year) onChanged;

  const _GlassMonthYearWheel({
    required this.month,
    required this.year,
    required this.onChanged,
    this.minimumDate,
    this.maximumDate,
  });

  @override
  State<_GlassMonthYearWheel> createState() => _GlassMonthYearWheelState();
}

class _GlassMonthYearWheelState extends State<_GlassMonthYearWheel> {
  static const _monthLabels = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const double _itemExtent = 40;
  static const int _yearSpan = 60;

  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _yearCtrl;
  late int _month;
  late int _year;
  late int _firstYear;
  late int _yearCount;

  @override
  void initState() {
    super.initState();
    _month = widget.month;
    _year = widget.year;

    final anchor = widget.year;
    _firstYear = (widget.minimumDate?.year ?? anchor - _yearSpan);
    final lastYear = (widget.maximumDate?.year ?? anchor + _yearSpan);
    _yearCount = (lastYear - _firstYear + 1).clamp(1, 1000);

    _monthCtrl = FixedExtentScrollController(initialItem: _month - 1);
    _yearCtrl = FixedExtentScrollController(
      initialItem: (_year - _firstYear).clamp(0, _yearCount - 1),
    );
  }

  @override
  void dispose() {
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
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
      diameterRatio: 1.8,
      perspective: 0.004,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onSelected,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (cntxt, index) {
          return Center(
            child: Text(
              labelBuilder(index),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: GlassColors.text(cntxt),
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
          children: [
            Expanded(
              flex: 3,
              child: _wheel(
                controller: _monthCtrl,
                itemCount: 12,
                labelBuilder: (i) => _monthLabels[i],
                onSelected: (i) {
                  _month = i + 1;
                  widget.onChanged(_month, _year);
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: _wheel(
                controller: _yearCtrl,
                itemCount: _yearCount,
                labelBuilder: (i) => '${_firstYear + i}',
                onSelected: (i) {
                  _year = _firstYear + i;
                  widget.onChanged(_month, _year);
                },
              ),
            ),
          ],
        ),
        IgnorePointer(
          child: Container(
            height: _itemExtent,
            margin: const EdgeInsets.symmetric(horizontal: 8),
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

class _GlassCalendarNavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassCalendarNavArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 24, color: GlassColors.text(context)),
      ),
    );
  }
}

/// iOS 26 style date/time picker sheet
class LiquidGlassDateTimeSheet {
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
    DateTime? minimumDate,
    DateTime? maximumDate,
    ValueChanged<DateTime>? onChanged,
  }) {
    DateTime selected = initialDate ?? DateTime.now();

    return showDialog<DateTime>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.20),
      builder: (dialogCtx) {
        final isLandscape = ResponsiveLayout.isLandscape(dialogCtx);
        final media = MediaQuery.of(dialogCtx);
        final safeHeight = media.size.height - media.padding.vertical;

        Widget body;
        if (mode == CupertinoDatePickerMode.date) {
          final calendar = _GlassMonthGridCalendar(
            initialDate: selected,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            onChanged: (val) {
              selected = val;
              onChanged?.call(val);
            },
          );
          body = isLandscape
              ? SizedBox(
                  width: ResponsiveLayout.sheetMaxWidth(dialogCtx),
                  height: (safeHeight - 55).clamp(120.0, safeHeight),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: ResponsiveLayout.sheetMaxWidth(dialogCtx) - 8,
                      child: calendar,
                    ),
                  ),
                )
              : calendar;
        } else {
          final isDark = Theme.of(dialogCtx).brightness == Brightness.dark;
          body = SizedBox(
            height: ResponsiveLayout.wheelPickerHeight(dialogCtx),
            child: CupertinoTheme(
              data: CupertinoThemeData(
                brightness: isDark ? Brightness.dark : Brightness.light,
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                    fontSize: 20,
                    color: GlassColors.text(context),
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                mode: mode,
                initialDateTime: selected,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                onDateTimeChanged: (val) {
                  selected = val;
                  onChanged?.call(val);
                },
              ),
            ),
          );
        }

        final panel = ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveLayout.sheetMaxWidth(dialogCtx),
          ),
          child: LiquidGlassPanel(
            radius: AdaptiveUiKitConfig.glass.sheetRadius,
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
            child: body,
          ),
        );

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.of(dialogCtx).pop(selected);
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(dialogCtx).pop(selected),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isLandscape ? 16 : 12,
                      vertical: 24,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 48,
                      ),
                      child: Center(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {},
                          child: panel,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
