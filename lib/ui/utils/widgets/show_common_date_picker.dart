import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:table_calendar/table_calendar.dart';

class CommonDateInputFormField extends ConsumerStatefulWidget {
  final double? fieldWidth;
  final double? fieldHeight;
  final DateTime? initialDate;
  final String? placeholder;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final TextEditingController? dateController;
  final bool? isForFilter;
  final void Function(DateTime?) onSelected;
  final void Function(List<DateTime?>?)? onRangeSelected;
  final bool? isForRange;
  final List<DateTime?>? initialRange;
  final String? Function(String?)? validator;

  const CommonDateInputFormField({Key? key, this.fieldHeight, this.fieldWidth, this.initialDate, this.lastDate, required this.onSelected,this.placeholder, this.firstDate, this.dateController, this.isForFilter, this.onRangeSelected,this.isForRange,this.initialRange,this.validator}) : super(key: key);

  @override
  ConsumerState<CommonDateInputFormField> createState() => _CommonInputFormFieldState();
}

class _CommonInputFormFieldState extends ConsumerState<CommonDateInputFormField> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showOverlay();
      },
      child: SizedBox(
        width: widget.fieldWidth ,
        height: widget.fieldHeight,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: widget.isForFilter ?? false
              ? CommonInputFormField(
            hintText: widget.placeholder??LocaleKeys.keyDDMMYYYY.localized,
            isEnable: false,
            prefixWidget: CommonSVG(
              strIcon: Assets.svgs.svgCalendar.keyName,
              height: 10,
              width: 10,
              boxFit: BoxFit.scaleDown,
            ),
            fontSize: 13,
            hintTextStyle: TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 13),
            textEditingController: widget.dateController ?? TextEditingController(),
            textInputAction: TextInputAction.done,
            validator: widget.validator,
          )
              : Container(
            decoration: selectedDate != null
                ? BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.clr4793EB, AppColors.clr2367EC]),
              borderRadius: BorderRadius.circular(16),
            )
                : BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.clrF4F5F7,
              border: Border.all(color: AppColors.clrDEDEDE),
            ),
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.005, vertical: context.height * 0.007),
            child: Row(
              children: [
                CommonText(
                  title: selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate!) : widget.placeholder??LocaleKeys.keyDDMMYYYY.localized,
                  style: TextStyles.regular.copyWith(fontSize: 10, color: selectedDate != null ? AppColors.white : AppColors.clr828282),
                  maxLines: 3,
                ),
                SizedBox(width: context.width * 0.005),
                CommonSVG(
                  strIcon: Assets.svgs.svgCalendar.path,
                  height: context.height * 0.02,
                  colorFilter: ColorFilter.mode(selectedDate != null ? AppColors.white : AppColors.clr828282, BlendMode.srcATop),
                ).paddingOnly(left: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // DateTime? selectedDate;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final FocusNode focusNode = FocusNode();
  DateTime? selectedDate;

  @override
  void initState() {
    selectedDate = widget.initialDate;
    focusNode.addListener(_handleFocus);
    super.initState();
  }

  void _handleFocus() {
    if (focusNode.hasFocus) {
      _showOverlay();
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(_handleFocus);
    super.dispose();
  }

  ScrollController scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    _removeOverlay();
    super.didChangeDependencies();
  }

  void _showOverlay() {
    _removeOverlay();
    if (!mounted) return;
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        ref.read(dateTextFieldController).setInitialValues(isForRange: widget.isForRange,initialRange: widget.initialRange,initialDate: widget.initialDate);
        return Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _removeOverlay();
                FocusScope.of(context).unfocus(); // optional
              },
              child: Container(
                color: Colors.transparent, // Full screen transparent area
              ),
            ),
            Positioned(
              width: context.width * 0.15,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: true,
                offset: Offset((size.width - context.width * 0.15), (widget.fieldHeight ?? size.height) + 10),
                child: Consumer(
                  builder: (context, ref, child) {
                    final calendarWatch = ref.watch(dateTextFieldController);
                    return Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      borderOnForeground: true,
                      color: AppColors.white,
                      child: Container(
                        margin: EdgeInsets.only(bottom: context.height * 0.01),
                        width: context.width * 0.2,
                        child: Column(
                          children: [
                            /// Range selection
                            (widget.isForRange??true)?TableCalendar(
                              focusedDay: calendarWatch.rangeStart != null ? calendarWatch.rangeStart ?? DateTime.now() : selectedDate ?? DateTime.now(),
                              firstDay: widget.firstDate ?? AppConstants.appDefaultDate,
                              lastDay: widget.lastDate ?? DateTime.now(),
                              rangeStartDay: calendarWatch.rangeStart,
                              rangeEndDay: calendarWatch.rangeEnd,
                              rangeSelectionMode: calendarWatch.rangeSelectionMode,
                              onRangeSelected: (start, middle, end) {
                                calendarWatch.updateRangeEndDate(end);
                                calendarWatch.updateRangeStartDate(start);
                                // if (start != null && end != null) {
                                //   // setState(() {
                                //   //   rangeStart = start;
                                //   //   rangeEnd = end;
                                //   //   rangeSelectionMode = RangeSelectionMode.toggledOn;
                                //   //   selectedDate = null;
                                //   // });
                                //   calendarWatch.updateRangeEndDate(end);
                                //   calendarWatch.updateRangeStartDate(start);
                                //   print('Range selected: $start → $end');
                                // } else {
                                //   // Temporarily hold the start date, wait for second selection
                                //   // setState(() {
                                //   //   rangeStart = start;
                                //   //   rangeEnd = null;
                                //   //   rangeSelectionMode = RangeSelectionMode.toggledOn;
                                //   // });
                                //   //calendarWatch.updateRangeEndDate(end);
                                //   calendarWatch.updateRangeStartDate(start);
                                //   print('Waiting for range end date...');
                                // }
                              },
                              rowHeight: context.height * 0.045,
                              daysOfWeekHeight: context.height * 0.04,
                              headerStyle: HeaderStyle(
                                titleTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                headerPadding: EdgeInsets.symmetric(vertical: context.height * 0.009),
                                leftChevronPadding: EdgeInsets.zero,
                                rightChevronPadding: EdgeInsets.zero,
                                titleCentered: true,
                              ),
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle: TextStyles.medium.copyWith(fontSize: 12),
                                weekendStyle: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.primary),
                              ),
                              availableCalendarFormats: const {CalendarFormat.month: 'month'},
                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(shape: BoxShape.rectangle,color:AppColors.transparent),
                                todayTextStyle: TextStyles.medium.copyWith(fontSize: 12, color:AppColors.primary),
                                defaultTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                rangeStartTextStyle: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.white),
                                rangeEndTextStyle: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.white),
                                withinRangeTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                weekNumberTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                selectedTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                holidayTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                weekendTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                disabledTextStyle: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.black.withValues(alpha: 0.5)),
                                outsideTextStyle: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.black.withValues(alpha: 0.5)),
                                rangeHighlightColor: AppColors.primary.withValues(alpha: 0.3),
                                defaultDecoration: const BoxDecoration(shape: BoxShape.rectangle),
                                rangeStartDecoration: BoxDecoration(shape: BoxShape.rectangle, color: AppColors.primary),
                                rangeEndDecoration: BoxDecoration(shape: BoxShape.rectangle, color: AppColors.primary),
                              ),

                            ):
                            /// Single selection
                            TableCalendar(
                              focusedDay: calendarWatch.rangeStart != null ? calendarWatch.rangeStart ?? DateTime.now() : selectedDate ?? DateTime.now(),
                              currentDay: calendarWatch.rangeStart != null ? calendarWatch.rangeStart ?? DateTime.now() : selectedDate ?? DateTime.now(),
                              firstDay: widget.firstDate ?? AppConstants.appDefaultDate,
                              lastDay: widget.lastDate ?? DateTime.now(),
                              rowHeight: context.height * 0.045,
                              daysOfWeekHeight: context.height * 0.04,
                              headerStyle: HeaderStyle(
                                titleTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                headerPadding: EdgeInsets.symmetric(vertical: context.height * 0.01),
                                leftChevronPadding: EdgeInsets.zero,
                                rightChevronPadding: EdgeInsets.zero,
                                titleCentered: true,
                              ),
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle: TextStyles.medium.copyWith(fontSize: 12),
                                weekendStyle: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.primary),
                              ),
                              availableCalendarFormats: const {CalendarFormat.month: 'month'},
                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(shape: BoxShape.rectangle, color: selectedDate != null || calendarWatch.rangeStart != null?AppColors.primary:AppColors.transparent),
                                todayTextStyle: TextStyles.medium.copyWith(fontSize: 12, color:selectedDate != null || calendarWatch.rangeStart != null?AppColors.white:AppColors.primary),
                                defaultTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                rangeStartTextStyle: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.white),
                                rangeEndTextStyle: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.white),
                                withinRangeTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                weekNumberTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                selectedTextStyle: TextStyles.medium.copyWith(fontSize: 12,color:AppColors.black),
                                selectedDecoration: BoxDecoration(shape: BoxShape.rectangle, color: AppColors.primary),
                                holidayTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                weekendTextStyle: TextStyles.medium.copyWith(fontSize: 12),
                                disabledTextStyle: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.black.withValues(alpha: 0.5)),
                                outsideTextStyle: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.black.withValues(alpha: 0.5)),
                                rangeHighlightColor: AppColors.primary.withValues(alpha: 0.3),
                                defaultDecoration: const BoxDecoration(shape: BoxShape.rectangle),
                                rangeStartDecoration: BoxDecoration(shape: BoxShape.rectangle, color: AppColors.primary),
                                rangeEndDecoration: BoxDecoration(shape: BoxShape.rectangle, color: AppColors.primary),
                              ),
                              onDaySelected: (day, focusedDay) {
                                selectedDate = day;
                                calendarWatch.updateRangeStartDate(day);
                                ref.read(dateTextFieldController).notifyListeners();
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CommonButton(
                                width: context.width * 0.05,
                                height: context.height * 0.04,
                                borderRadius: BorderRadius.circular(5),
                                buttonTextStyle: TextStyles.medium.copyWith(color: AppColors.white, fontSize: 10),
                                backgroundColor: AppColors.primary,
                                buttonText:LocaleKeys.keyDone.localized,
                                onTap: () {
                                  widget.onSelected(calendarWatch.rangeStart);
                                  if(widget.isForRange??false){
                                    widget.onRangeSelected!([calendarWatch.rangeStart, calendarWatch.rangeEnd]);
                                  }
                                  _removeOverlay();
                                },
                              ).paddingOnly(right: context.width * 0.005),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );},
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

final dateTextFieldController = ChangeNotifierProvider((ref) => DateTextFieldController());

class DateTextFieldController extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  /// Set Initial values
  void setInitialValues({bool? isForRange,List<DateTime?>? initialRange,DateTime? initialDate,bool? isNotify }){
    rangeStart = null;
    rangeEnd = null;
    rangeSelectionMode =isForRange??false ?RangeSelectionMode.toggledOn:RangeSelectionMode.toggledOff;
    if(isForRange??false){
      rangeStart= initialRange?.first;
      rangeEnd = initialRange?.last;
    }else{
      rangeStart= initialDate??initialRange?.first;
    }
    if(isNotify??false){
      notifyListeners();
    }
  }

  /// Range dates
  DateTime? rangeStart;
  DateTime? rangeEnd;

  /// Range selection mode
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOff;

  /// Update range start date
  updateRangeStartDate(value) {
    rangeStart = value;
    notifyListeners();
  }

  /// Update range end date
  updateRangeEndDate(value) {
    rangeEnd = value;
    notifyListeners();
  }
}

/// Usage
/*
if Date selection field from filter and only one date selection
CommonDateInputFormField(
  dateController: walletWatch.dateController,
  initialRange: [walletWatch.tempSelectedStartDate],
  isForRange: false,
  placeholder: LocaleKeys.keyEndDate.localized,
  isForFilter: true,
  onSelected: (value){
    walletWatch.changeDateValue(value);
  },
),
if Date selection field from filter and range selection
CommonDateInputFormField(
  dateController: walletWatch.dateController,
  initialRange: [walletWatch.tempSelectedStartDate,walletWatch.tempSelectedEndDate],
  isForRange: true,
  onRangeSelected: (List<DateTime?>? value ) {
    walletWatch.changeDateValue(value);
  },
  isForFilter: true,
  onSelected: (value){},
),


* */