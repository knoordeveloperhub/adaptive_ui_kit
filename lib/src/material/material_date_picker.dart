import 'package:flutter/material.dart';

/// Native M3 calendar date picker
class MaterialDateSheet {
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    String? helpText,
    String? cancelText,
    String? confirmText,
    String? fieldLabelText,
    String? fieldHintText,
    Widget Function(BuildContext, Widget?)? builder,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: minimumDate ?? DateTime(1990),
      lastDate: maximumDate ?? DateTime(2100),
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      fieldLabelText: fieldLabelText,
      fieldHintText: fieldHintText,
      builder: builder,
    );
  }
}

/// Native Material 3 date range picker.
class MaterialDateRangeSheet {
  static Future<DateTimeRange?> show({
    required BuildContext context,
    DateTimeRange? initialDateRange,
    DateTime? minimumDate,
    DateTime? maximumDate,
    String? helpText,
    String? cancelText,
    String? confirmText,
    Widget Function(BuildContext, Widget?)? builder,
    DateTime? currentDate,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    String? saveText,
    String? errorFormatText,
    String? errorInvalidText,
    String? errorInvalidRangeText,
    String? fieldStartHintText,
    String? fieldEndHintText,
    String? fieldStartLabelText,
    String? fieldEndLabelText,
    Locale? locale,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    TextDirection? textDirection,
    Offset? anchorPoint,
    TextInputType keyboardType = TextInputType.datetime,
    Icon? switchToInputEntryModeIcon,
    Icon? switchToCalendarEntryModeIcon,
    SelectableDayForRangePredicate? selectableDayPredicate,
    CalendarDelegate<DateTime> calendarDelegate =
        const GregorianCalendarDelegate(),
  }) {
    final firstDate = calendarDelegate.dateOnly(minimumDate ?? DateTime(1990));
    final lastDate = calendarDelegate.dateOnly(maximumDate ?? DateTime(2100));
    final current =
        calendarDelegate.dateOnly(currentDate ?? calendarDelegate.now());
    final dialog = DateRangePickerDialog(
      initialDateRange: initialDateRange == null
          ? null
          : calendarDelegate.datesOnly(initialDateRange),
      firstDate: firstDate,
      lastDate: lastDate,
      currentDate: current,
      initialEntryMode: initialEntryMode,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      saveText: saveText,
      errorFormatText: errorFormatText,
      errorInvalidText: errorInvalidText,
      errorInvalidRangeText: errorInvalidRangeText,
      fieldStartHintText: fieldStartHintText,
      fieldEndHintText: fieldEndHintText,
      fieldStartLabelText: fieldStartLabelText,
      fieldEndLabelText: fieldEndLabelText,
      keyboardType: keyboardType,
      switchToInputEntryModeIcon: switchToInputEntryModeIcon,
      switchToCalendarEntryModeIcon: switchToCalendarEntryModeIcon,
      selectableDayPredicate: selectableDayPredicate,
      calendarDelegate: calendarDelegate,
    );

    Widget routeDialog = dialog;
    if (textDirection != null) {
      routeDialog =
          Directionality(textDirection: textDirection, child: routeDialog);
    }
    if (locale != null) {
      routeDialog = Localizations.override(
        context: context,
        locale: locale,
        child: routeDialog,
      );
    }

    return Navigator.of(context, rootNavigator: useRootNavigator)
        .push<DateTimeRange?>(
      DialogRoute<DateTimeRange?>(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        settings: routeSettings,
        anchorPoint: anchorPoint,
        builder: (routeContext) {
          final built = builder == null
              ? routeDialog
              : builder(routeContext, routeDialog);
          return built;
        },
      ),
    );
  }
}
