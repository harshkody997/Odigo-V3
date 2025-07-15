import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';


Future<void> weekCountDateFilterPickerDialog(
  BuildContext context, {
  List<DateTime?> value = const [],
  DateTime? firstDate,
  DateTime? lastDate,
  required void Function(List<DateTime?> dateList) onSelect,
}) async {
  if(value.length == 1){
    value.add(value.first);
  }
  else if ((value.first == null) && (value.last != null)) {
    value.first = value.last;
  } else if ((value.first != null) && (value.last != null)) {
    if (value.last!.isBefore(value.first!)) {
      DateTime? temp = value.first;
      value.first = value.last;
      value.last = temp;
    }
  }

  CalendarDatePicker2WithActionButtonsConfig config = CalendarDatePicker2WithActionButtonsConfig(
    dayTextStyle: TextStyles.regular,
    calendarType: CalendarDatePicker2Type.range,
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
  );

  final dialogHeight = config.dayMaxWidth != null
      ? context.height * 0.6
      : max(context.height * 0.6, 410);

  await showDialog<List<DateTime?>>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 370,
          height: dialogHeight.toDouble(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomCalendarDatePicker2WithActionButtons(
                value: value,
                config: config.copyWith(
                  openedFromDialog: true,
                  scrollViewConstraints: config.scrollViewConstraints ??
                      (config.calendarViewMode == CalendarDatePicker2Mode.scroll
                          ? BoxConstraints(
                          maxHeight: dialogHeight.toDouble() - 24 * 2)
                          : null),
                ),
                onOkTapped: (List<DateTime?> values){
                  onSelect.call(values);
                },
              ),
            ],
          ),
        ),
      );
    },
    barrierColor: Colors.black54,
  );
}

/// Display CalendarDatePicker with action buttons
class CustomCalendarDatePicker2WithActionButtons extends StatefulWidget {
  CustomCalendarDatePicker2WithActionButtons({
    required this.value,
    required this.config,
    this.onValueChanged,
    this.onDisplayedMonthChanged,
    this.onCancelTapped,
    this.onOkTapped,
    Key? key,
  }) : super(key: key) {
    if (config.calendarViewMode == CalendarDatePicker2Mode.scroll) {
      assert(
      config.scrollViewConstraints?.maxHeight != null,
      'scrollViewConstraint with maxHeight must be provided when used withCalendarDatePicker2WithActionButtons under scroll mode',
      );
    }
  }

  /// The selected [DateTime]s that the picker should display.
  final List<DateTime?> value;

  /// Called when the user taps 'OK' button
  final ValueChanged<List<DateTime?>>? onValueChanged;

  /// Called when the user navigates to a new month/year in the picker under non-scroll mode
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// The calendar configurations including action buttons
  final CalendarDatePicker2WithActionButtonsConfig config;

  /// The callback when cancel button is tapped
  final Function? onCancelTapped;

  /// The callback when ok button is tapped
  final Function(List<DateTime?> dateList)? onOkTapped;

  @override
  State<CustomCalendarDatePicker2WithActionButtons> createState() =>
      _CalendarDatePicker2WithActionButtonsState();
}

class _CalendarDatePicker2WithActionButtonsState
    extends State<CustomCalendarDatePicker2WithActionButtons> {
  List<DateTime?> _values = [];
  List<DateTime?> _editCache = [];

  @override
  void initState() {
    _values = widget.value;
    _editCache = widget.value;
    showError = false;
    super.initState();
  }

  @override
  void didUpdateWidget(
      covariant CustomCalendarDatePicker2WithActionButtons oldWidget) {
    var isValueSame = oldWidget.value.length == widget.value.length;

    if (isValueSame) {
      for (var i = 0; i < oldWidget.value.length; i++) {
        var isSame = (oldWidget.value[i] == null && widget.value[i] == null) ||
            DateUtils.isSameDay(oldWidget.value[i], widget.value[i]);
        if (!isSame) {
          isValueSame = false;
          break;
        }
      }
    }

    if (!isValueSame) {
      _values = widget.value;
      _editCache = widget.value;
    }

    super.didUpdateWidget(oldWidget);
  }

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
    MaterialLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediaQuery.removePadding(
          context: context,
          child: CalendarDatePicker2(
            value: [..._editCache],
            config: widget.config,
            onValueChanged: (values) => _editCache = values,
            onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
          ),
        ),
        // SizedBox(height: context.height * 0.01),
        Visibility(
          visible: !(_values.first?.day  == _values.last?.subtract(const Duration(days: 6)).day),
          child: CommonText(
            title: LocaleKeys.keyTheDateRangeMustBeExactly7days.localized,
            style: TextStyles.regular.copyWith(
              color: AppColors.red,
              fontSize: 14,
            ),
            maxLines: 3,
          ).paddingSymmetric(horizontal: context.width * 0.02),
        ),
        SizedBox(height: context.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildCancelButton(Theme.of(context).colorScheme, localizations),
            if ((widget.config.gapBetweenCalendarAndButtons ?? 0) > 0)
              SizedBox(width: widget.config.gapBetweenCalendarAndButtons),
            _buildOkButton(Theme.of(context).colorScheme, localizations),
          ],
        ),
      ],
    );
  }

  Widget _buildCancelButton(
      ColorScheme colorScheme, MaterialLocalizations localizations) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => setState(() {
        _editCache = _values;
        widget.onCancelTapped?.call();
        if ((widget.config.openedFromDialog ?? false) &&
            (widget.config.closeDialogOnCancelTapped ?? true)) {
          Navigator.pop(context);
        }
      }),
      child: Container(
        padding: widget.config.buttonPadding ??
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: widget.config.cancelButton ??
            Text(
              localizations.cancelButtonLabel.toUpperCase(),
              style: widget.config.cancelButtonTextStyle ??
                  TextStyle(
                    color: widget.config.selectedDayHighlightColor ??
                        colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
            ),
      ),
    );
  }

  Widget _buildOkButton(
      ColorScheme colorScheme, MaterialLocalizations localizations) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => setState(() {
        _values = _editCache;
        widget.onValueChanged?.call(_values);
        if(_values.first?.day == _values.last?.subtract(const Duration(days: 6)).day) {
          widget.onOkTapped?.call(_values);
          if ((widget.config.openedFromDialog ?? false) &&
              (widget.config.closeDialogOnOkTapped ?? true)) {
            Navigator.pop(context, _values);
          }
        }
      }),
      child: Container(
        padding: widget.config.buttonPadding ??
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: widget.config.okButton ??
            Text(
              localizations.okButtonLabel.toUpperCase(),
              style: widget.config.okButtonTextStyle ??
                  TextStyle(
                    color: widget.config.selectedDayHighlightColor ??
                        colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
            ),
      ),
    );
  }
}

