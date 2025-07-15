import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

///This is includes range and single both date picker
///This is dialog widget, This will use in onTap Function of any widget.
/// here onSelect function will give List<DateTime?>
/// in single you will get selectedDate only in list and
/// in range date you will get start date and end date in list.

/// for range date picker use like this.
/// must use isRangePicker: true,
/// use selectedStartDate, selectedEndDate
/// Note: do not use selected date in range date picker

Future<void> commonRangeDatePickerDialog(
  BuildContext context, {
  required bool isRangePicker,
  DateTime? selectedDate,
  DateTime? selectedStartDate,
  DateTime? selectedEndDate,
  DateTime? firstDate,
  DateTime? lastDate,
  required void Function(List<DateTime?> dateList) onSelect,
}) async {
  if ((selectedStartDate == null) && (selectedEndDate != null)) {
    selectedStartDate = selectedEndDate;
  } else if ((selectedStartDate != null) && (selectedEndDate != null)) {
    if (selectedEndDate.isBefore(selectedStartDate)) {
      DateTime? temp = selectedStartDate;
      selectedStartDate = selectedEndDate;
      selectedEndDate = temp;
    }
  }
  final values = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: TextStyles.regular,
      calendarType: isRangePicker
          ? CalendarDatePicker2Type.range
          : CalendarDatePicker2Type.single,
      weekdayLabelTextStyle: TextStyles.medium,
      controlsTextStyle: TextStyles.medium,
      selectedDayHighlightColor: AppColors.clr2367EC,
      selectedDayTextStyle: TextStyles.medium.copyWith(color: AppColors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = TextStyles.regular.copyWith(color: AppColors.red);
        }
        return textStyle;
      },
      firstDate: firstDate,
      lastDate: lastDate,
    ),
    dialogSize: Size(context.width * 0.3, 370),
    borderRadius: BorderRadius.circular(15),
    value: isRangePicker
        ? [selectedStartDate, selectedEndDate]
        : [selectedDate],
    dialogBackgroundColor: Colors.white,
  );
  if (values != null) {
    if (isRangePicker) {
      if (values.length == 1) {
        values.add(values.first);
      }
    }
    onSelect.call(values);
  } else {
    showLog('Selected values are null!!!!');
  }
}
