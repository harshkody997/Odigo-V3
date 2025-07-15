import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/robot_data_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/int_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/dashboard/web/helper/uptime/common_dashboard_semi_circle_progress.dart';
import 'package:odigov3/ui/dashboard/web/helper/uptime/common_dashboard_uptime_percentage_container.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/show_common_date_picker.dart';

class CommonDashboardUptimeWidget extends ConsumerWidget {
  const CommonDashboardUptimeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardWatch = ref.watch(dashboardController);
    bool isZero =
        (dashboardWatch.dashboardUptimeState.success?.data?.destinationUpTime?.percentage ?? 0.0) == 0.0 &&
            (dashboardWatch.dashboardUptimeState.success?.data?.emergency?.percentage ?? 0.0) == 0.0 &&
            (dashboardWatch.dashboardUptimeState.success?.data?.charging?.percentage ?? 0.0) == 0.0;

    return SizedBox(
      height: context.height * 0.53,
      child: CommonDashboardContainer(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CommonText(
                title: LocaleKeys.keyUptimeReportPerDay.localized,
                style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
              ),
            ),
            SizedBox(height: context.height * 0.01),
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    /// robot selection widget
                    CommonSearchableDropdown(
                      fieldWidth: context.width * 0.13,
                      fieldHeight: context.height * 0.04,
                      hintText: LocaleKeys.keySelectRobot.localized,
                      hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                      fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
                      onSelected: (value) {
                        dashboardWatch.updateUptimeSelectedRobot(context, ref, value);
                      },
                      textEditingController: dashboardWatch.uptimeRobotSearchCtr,
                      items: dashboardWatch.uptimeRobotList,
                      title: (RobotDataListDto? item) {
                        return item?.hostName ?? '';
                      },
                      showLoader: true,
                      onSearch: (value) async {
                        await dashboardWatch.robotDataListApi(
                          context,
                          ref,
                          robotDataList: dashboardWatch.uptimeRobotList,
                          searchKeyword: dashboardWatch.uptimeRobotSearchCtr.text,
                        );
                      },
                      onScrollListener: () {
                        dashboardWatch.robotDataListApi(
                          context,
                          ref,
                          robotDataList: dashboardWatch.uptimeRobotList,
                          isForPagination: true,
                          searchKeyword: dashboardWatch.uptimeRobotSearchCtr.text,
                        );
                      },
                    ),
                    /// date filter
                    Visibility(
                      visible: dashboardWatch.selectedUptimeRobot != null,
                      child: CommonDateInputFormField(
                        placeholder: LocaleKeys.keySelectDate.localized,
                        initialDate: dashboardWatch.uptimeSelectedDate,
                        lastDate: DateTime.now().subtract(Duration(days: 1)),
                        isForRange: false,
                        onSelected: (selectedDate) {
                          dashboardWatch.updateUptimeSelectedDate(selectedDate ?? DateTime.now().subtract(Duration(days: 1)), context, ref);
                        },
                      ).paddingOnly(left: context.width * 0.005),
                    ),
                    /// reset
                    Visibility(
                      visible: dashboardWatch.selectedUptimeRobot != null,
                      child: InkWell(
                        onTap: (){
                          dashboardWatch.resetUptimeFilter(context, ref);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.clrF4F5F7,
                            border: Border.all(color: AppColors.clrDEDEDE),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: context.width * 0.005, vertical: context.height * 0.007),
                          child: CommonSVG(strIcon: Assets.svgs.svgReload.path, height: context.height * 0.02),
                        ),
                      ).paddingOnly(left: context.width * 0.005),
                    ),
                  ],
                ),
              ),
            ),
            dashboardWatch.dashboardUptimeState.isLoading
              ? Expanded(child: CommonAnimLoader())
              : ((dashboardWatch.dashboardUptimeState.success?.data == null) || isZero)
                ? Expanded(child: CommonEmptyStateWidget())
                : Column(
                  children: [
                    SizedBox(
                      height: context.height * 0.25,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SemiCircleProgress(radius: context.height * 0.19, strokeWidth: context.height * 0.04, percentage: (dashboardWatch.dashboardUptimeState.success?.data?.destinationUpTime?.percentage ?? 0.0)/100, fillColor: AppColors.clr55BF61),
                          SemiCircleProgress(radius: context.height * 0.14, strokeWidth: context.height * 0.04, percentage: (dashboardWatch.dashboardUptimeState.success?.data?.emergency?.percentage ?? 0.0)/100, fillColor: AppColors.clrFF8484),
                          SemiCircleProgress(radius: context.height * 0.09, strokeWidth: context.height * 0.04, percentage: (dashboardWatch.dashboardUptimeState.success?.data?.charging?.percentage ?? 0.0)/100, fillColor: AppColors.clrFFC559),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CommonText(
                                title: '${((dashboardWatch.dashboardUptimeState.success?.data?.destinationUpTime?.totalTime ?? 0) / 3600000).formatTo2Decimals()} ${LocaleKeys.keyHr.localized}',
                                style: TextStyles.bold.copyWith(fontSize: 20, color: AppColors.clr080808),
                              ),
                              if (dashboardWatch.uptimeFilterDate != null)
                                CommonText(
                                  title: DateFormat('MMM dd, yyyy').format(dashboardWatch.uptimeFilterDate!),
                                  style: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.black),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.height * 0.02),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonDashboardUptimePercentageContainer(text: '${(dashboardWatch.dashboardUptimeState.success?.data?.destinationUpTime?.percentage ?? 0.0).toStringAsFixed(2)}%', subText: LocaleKeys.keyUptime.localized, color: AppColors.clr55BF61),
                          SizedBox(width: context.width * 0.01),
                          CommonDashboardUptimePercentageContainer(text: '${(dashboardWatch.dashboardUptimeState.success?.data?.emergency?.percentage ?? 0.0).toStringAsFixed(2)}%', subText: LocaleKeys.keyEmergency.localized, color: AppColors.clrFF8484),
                          SizedBox(width: context.width * 0.01),
                          CommonDashboardUptimePercentageContainer(text: '${(dashboardWatch.dashboardUptimeState.success?.data?.charging?.percentage ?? 0.0).toStringAsFixed(2)}%', subText: LocaleKeys.keyCharging.localized, color: AppColors.clrFFC559),
                        ],
                      ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
