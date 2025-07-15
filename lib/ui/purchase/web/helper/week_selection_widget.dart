import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/add_purchase_controller.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_weeks_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class WeekSelectionWidget extends ConsumerStatefulWidget {
  const WeekSelectionWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<WeekSelectionWidget> createState() => _WeekSelectionWidgetState();
}

class _WeekSelectionWidgetState extends ConsumerState<WeekSelectionWidget> {

  @override
  Widget build(BuildContext context) {
    final addPurchaseWatch = ref.watch(addPurchaseController);
    return CommonInputFormField(
      textEditingController: TextEditingController(),
      isEnable: addPurchaseWatch.purchaseWeeksState.success?.data?.isNotEmpty ?? false,
      borderRadius: BorderRadius.circular(6),
      validator: (value) {
        if(addPurchaseWatch.selectedWeeks.isNotEmpty){
          return null;
        }else{
          return LocaleKeys.keyWeekIsRequired.localized;
        }
      },
      prefixWidget: InkWell(
        onTap: (){
          _showOverlay();
        },
        child: Row(
          children: [
            Expanded(
              child: addPurchaseWatch.selectedWeeks.isEmpty
                  ? CommonText(
                title: LocaleKeys.keySelectWeek.localized,
                style: TextStyles.medium.copyWith(color: AppColors.textFieldBorderColor, fontSize: 14),
              )
                  :
              SizedBox(
                height: context.height * 0.06,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  // shrinkWrap: true,
                  itemCount: addPurchaseWatch.selectedWeeks.length,
                  itemBuilder: (BuildContext context, int index) {
                    PurchaseWeeksData item = addPurchaseWatch.selectedWeeks[index];
                    ///Selected container
                    return Container(
                      height: context.height * 0.05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.clr2997FC.withValues(alpha: 0.15),
                      ),
                      child: Row(
                        children: [
                          ///Week Number and Start date and end date
                          CommonText(
                            title: '${LocaleKeys.keyWeek.localized} ${item.weekNumber??0} (${formatDateToDDMMYYYY(item.startDate)} - ${formatDateToDDMMYYYY(item.endDate)})',
                            style: TextStyles.medium.copyWith(color: AppColors.clr2997FC, fontSize: 14),
                          ),
                          SizedBox(width: context.width * 0.005),
                          ///Cross Button
                          InkWell(
                            onTap: () {
                              addPurchaseWatch.updateSelectedWeek(item, false);
                              addPurchaseWatch.calculateWeeklyPrice(addPurchaseWatch.purchaseType==PurchaseType.PREMIUM?addPurchaseWatch.selectedDestination?.premiumPrice??0:addPurchaseWatch.selectedDestination?.fillerPrice??0);
                            },
                            child:  Icon(
                              Icons.close,
                              size: context.height * 0.02,
                              color: AppColors.clr2997FC,
                            ).paddingAll(5),
                          ),
                        ],
                      ).paddingOnly(left: context.width * 0.01, right: context.width * 0.005),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: context.width * 0.01);
                  },
                ).paddingSymmetric(vertical: context.height * 0.005),
              ),
            ),
            SizedBox(width: context.width * 0.005),
            ///Dropdown arrow
            CommonSVG(
              strIcon: Assets.svgs.svgDropDown.keyName,
              height: context.height * 0.03,
              width: context.height * 0.03,
            ),
          ],
        ).paddingOnly(right: context.width * 0.006, left: context.width * 0.01),
      ),
    );
  }

  /// for overlay selection

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    if(_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _hideOverlay();
              FocusScope.of(context).unfocus();
            },
            child: Container(color: Colors.transparent),
          ),

          Positioned(
            left: offset.dx,
            top: offset.dy + size.height,
            width: size.width,
            child: Consumer(
              builder: (context, ref, child) {
                final addPurchaseWatch = ref.watch(addPurchaseController);
                List<PurchaseWeeksData> weekList = addPurchaseWatch.purchaseWeeksState.success?.data ?? [];

                return CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: true,
                  offset: Offset(0.0, size.height + 10),
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: AppColors.white,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: context.height * 0.3,
                          maxWidth: context.width * 0.2,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ///Select All Check box
                              CheckboxListTile(
                                title: CommonText(
                                  title: LocaleKeys.keySelectAll.localized,
                                  style: TextStyles.regular.copyWith(
                                    color: AppColors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                value: (weekList.every(addPurchaseWatch.selectedWeeks.contains)) && weekList.isNotEmpty,
                                onChanged: (checked) {
                                  addPurchaseWatch.addAllWeeks(checked);
                                  addPurchaseWatch.calculateWeeklyPrice(addPurchaseWatch.purchaseType==PurchaseType.PREMIUM?addPurchaseWatch.selectedDestination?.premiumPrice??0:addPurchaseWatch.selectedDestination?.fillerPrice??0);
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: AppColors.clr2997FC,
                                checkboxScaleFactor: 0.8,
                              ),
                              const Divider(color: AppColors.dividerColor),
                              ...weekList.map((item) {
                                return Column(
                                  children: [
                                    ///Individual Check Box
                                    CheckboxListTile(
                                      title: CommonText(
                                        title: '${LocaleKeys.keyWeek.localized} ${item.weekNumber??''} (${formatDateToDDMMYYYY(item.startDate)} - ${formatDateToDDMMYYYY(item.endDate)})',
                                        style: TextStyles.regular.copyWith(
                                          color: AppColors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                      value: addPurchaseWatch.selectedWeeks.contains(item),
                                      onChanged: (checked) {
                                        addPurchaseWatch.updateSelectedWeek(item, checked);
                                        addPurchaseWatch.calculateWeeklyPrice(addPurchaseWatch.purchaseType==PurchaseType.PREMIUM?addPurchaseWatch.selectedDestination?.premiumPrice??0:addPurchaseWatch.selectedDestination?.fillerPrice??0);
                                      },
                                      controlAffinity: ListTileControlAffinity.leading,
                                      activeColor: AppColors.clr2997FC,
                                      checkboxScaleFactor: 0.8,
                                    ),
                                    const Divider(color: AppColors.dividerColor),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
