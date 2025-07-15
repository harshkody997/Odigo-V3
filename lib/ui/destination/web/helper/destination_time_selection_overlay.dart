import 'package:odigov3/ui/utils/theme/theme.dart';

class CommonTimePickerOverlayWidget extends StatefulWidget {
  final Widget child;
  final DateTime initialTime;
  final Function(DateTime) onTimeSelected;

  const CommonTimePickerOverlayWidget({super.key, required this.child, required this.initialTime, required this.onTimeSelected});

  @override
  State<CommonTimePickerOverlayWidget> createState() => _CommonTimePickerOverlayWidgetState();
}

class _CommonTimePickerOverlayWidgetState extends State<CommonTimePickerOverlayWidget> {
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: () {
          _showOverlay();
        },
        child: widget.child,
      ),
    );
  }

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _showOverlay() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.initialTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.grayEAECF0),
              ),
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
                if (states.isEmpty) return AppColors.clr080808;
                return states.first == WidgetState.selected ? AppColors.white : AppColors.clr080808;
              }),
              hourMinuteTextStyle: TextStyles.medium.copyWith(color: AppColors.white, fontSize: 36),
              hourMinuteColor: WidgetStateColor.resolveWith((states) {
                if (states.isEmpty) return AppColors.clrF4F7FE;
                return states.first == WidgetState.selected ? AppColors.clr2997FC : AppColors.clrF4F7FE;
              }),
              dialTextStyle: TextStyles.regular.copyWith(color: AppColors.clr080808),
              hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              dialHandColor: AppColors.clr2997FC,
              dialBackgroundColor: AppColors.clrF4F7FE,
              entryModeIconColor: AppColors.black,
              dayPeriodColor: WidgetStateColor.resolveWith((states) {
                if (states.isEmpty) return AppColors.clrF4F7FE;
                return states.first == WidgetState.selected ? AppColors.clr2997FC : AppColors.clrF4F7FE;
              }),
              dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
                if (states.isEmpty) return AppColors.clr080808;
                return states.first == WidgetState.selected ? AppColors.white : AppColors.clr080808;
              }),
              timeSelectorSeparatorColor: WidgetStateColor.resolveWith((states) {
                return AppColors.black;
              }),
              confirmButtonStyle: ButtonStyle(foregroundColor: WidgetStateColor.resolveWith((states) => AppColors.clr080808)),
              cancelButtonStyle: ButtonStyle(foregroundColor: WidgetStateColor.resolveWith((states) => AppColors.clr080808)),
              dayPeriodTextStyle: TextStyles.semiBold.copyWith(color: AppColors.white),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      widget.onTimeSelected(selectedDateTime);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void didChangeDependencies() {
    _removeOverlay();
    super.didChangeDependencies();
  }
}
