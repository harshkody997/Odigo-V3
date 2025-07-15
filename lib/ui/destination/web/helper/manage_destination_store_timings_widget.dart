import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/manage_destination_controller.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_timings_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/destination/web/helper/destination_time_selection_overlay.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_switch_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class ManageDestinationStoreTimingsWidget extends ConsumerWidget {
  const ManageDestinationStoreTimingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manageDestinationWatch = ref.watch(manageDestinationController);
    return SizedBox(
      // height: context.height * 0.6,
      child: CommonDashboardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              title: LocaleKeys.keyDestinationTimings.localized,
              style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
            ),
            SizedBox(height: context.height * 0.02),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    color: AppColors.clrF4F5F7,
                    border: Border.all(color: AppColors.grayEAECF0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(flex: 2,child: CommonText(title: LocaleKeys.keyDay.localized)),
                      Expanded(flex: 2,child: CommonText(title: LocaleKeys.keyStartTime.localized)),
                      Expanded(flex: 2,child: CommonText(title: LocaleKeys.keyEndTime.localized)),
                      Expanded(child: Offstage())
                    ],
                  ),
                ),
                Column(
                  children: List.generate(manageDestinationWatch.destinationTimingsList.length, (index) {
                    DestinationTimeValue model = manageDestinationWatch.destinationTimingsList[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: index == (manageDestinationWatch.destinationTimingsList.length - 1) ? BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)) : null,
                        color: AppColors.white,
                        border: Border.all(color: AppColors.grayEAECF0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CommonText(title: (model.dayOfWeek ?? '').toLowerCase().capitalizeFirstLetterOfSentence, textAlign: TextAlign.start),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: context.width * 0.06,
                                  child: CommonText(title: model.startHour == null ? LocaleKeys.keyStartTime.localized : formatHHMMAStringDateToDateTime(model.startHour) ?? '-', textAlign: TextAlign.start),
                                ),
                                SizedBox(width: context.width * 0.005),
                                CommonTimePickerOverlayWidget(
                                  initialTime: DateFormat('HH:mm:ss').tryParse(model.startHour ?? '') ?? DateTime.now(),
                                  onTimeSelected: (value) {
                                    if (manageDestinationWatch.isStartBeforeEnd(value, model.endHour) == true) {
                                      model.startHour = DateFormat('HH:mm:ss').format(value);
                                      manageDestinationWatch.updateApplyToAllDaysIndex(index);
                                      manageDestinationWatch.notifyListeners();
                                    } else {
                                      showToast(context: context,message: LocaleKeys.keySelectedStartTimeShouldBeBeforeEndTime.localized,isSuccess: false);
                                    }

                                  },
                                  child: CommonSVG(strIcon: Assets.svgs.svgEdit2.path),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: context.width * 0.06,
                                  child: CommonText(title: model.endHour == null ? LocaleKeys.keyEndTime.localized : formatHHMMAStringDateToDateTime(model.endHour) ?? '-', textAlign: TextAlign.start),
                                ),
                                SizedBox(width: context.width * 0.005),
                                CommonTimePickerOverlayWidget(
                                  initialTime: DateFormat('HH:mm:ss').tryParse(model.endHour ?? '') ?? DateTime.now(),
                                  onTimeSelected: (value) {
                                    if(manageDestinationWatch.isSelectedTimeValid(value, model.startHour) == true){
                                      model.endHour = DateFormat('HH:mm:ss').format(value);
                                      manageDestinationWatch.updateApplyToAllDaysIndex(index);
                                      manageDestinationWatch.notifyListeners();
                                    }else{
                                      showToast(context: context,message: LocaleKeys.keySelectedEndTimeShouldBeAfterStartTime.localized,isSuccess: false);
                                    }
                                  },
                                  child: CommonSVG(strIcon: Assets.svgs.svgEdit2.path),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Visibility(
                                visible: index == manageDestinationWatch.applyToAllDaysIndex && manageDestinationWatch.isApplyToAllDaysShow,
                                child: InkWell(
                                  onTap: () => manageDestinationWatch.setApplyToAllDaysTime(),
                                  child: CommonText(
                                      title: LocaleKeys.keyApplyToAllDays.localized,
                                      textAlign: TextAlign.end,
                                      style: TextStyles.medium.copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.clr2997FC,
                                          fontSize: 14,
                                          color: AppColors.clr2997FC,
                                      ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
