import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/category_data_list_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/store_data_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/dashboard/web/helper/weekend_weekday/common_dashboard_weekend_weekday_bar_graph.dart';
import 'package:odigov3/ui/dashboard/web/helper/weekend_weekday/week_count_date_filter.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardWeekendWeekdayWidget extends ConsumerWidget {
  const CommonDashboardWeekendWeekdayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardWatch = ref.watch(dashboardController);
    return CommonDashboardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              /// title
              CommonText(
                title: LocaleKeys.keyWeekdaysAndWeekend.localized,
                style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
              ),
              Spacer(),
              /// category selection widget
              CommonSearchableDropdown(
                fieldWidth: context.width * 0.13,
                fieldHeight: context.height * 0.04,
                hintText: LocaleKeys.keySelectCategory.localized,
                hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
                onSelected: (value) {
                  dashboardWatch.updateWeekInteractionCountSelectedCategory(context, ref, value);
                },
                textEditingController: dashboardWatch.weekInteractionCountCategorySearchCtr,
                items: dashboardWatch.weekInteractionCountCategoryList,
                title: (CategoryDataListDto? item) {
                  return item?.name ?? '';
                },
                showLoader: true,
                onSearch: (value) async {
                  await dashboardWatch.categoryDataListApi(
                    context,
                    ref,
                    categoryList: dashboardWatch.weekInteractionCountCategoryList,
                    searchKeyword: dashboardWatch.weekInteractionCountCategorySearchCtr.text,
                  );
                },
                onScrollListener: () {
                  dashboardWatch.categoryDataListApi(
                    context,
                    ref,
                    categoryList: dashboardWatch.weekInteractionCountCategoryList,
                    isForPagination: true,
                    searchKeyword: dashboardWatch.weekInteractionCountCategorySearchCtr.text,
                  );
                },
              ).paddingOnly(left: context.width * 0.005),
              /// Store selection widget
              Visibility(
                visible: dashboardWatch.selectedWeekInteractionCountCategory != null,
                child: CommonSearchableDropdown(
                  fieldWidth: context.width * 0.13,
                  fieldHeight: context.height * 0.04,
                  hintText: LocaleKeys.keySelectStore.localized,
                  hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                  fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
                  onSelected: (value) {
                    dashboardWatch.updateWeekInteractionCountSelectedStore(context, ref, value);
                  },
                  textEditingController: dashboardWatch.weekInteractionCountStoreSearchCtr,
                  items: dashboardWatch.weekInteractionCountStoreList,
                  title: (StoreDataListDto? item) {
                    return item?.name ?? '';
                  },
                  showLoader: true,
                  onSearch: (value) async {
                    await dashboardWatch.storeDataListApi(
                      context,
                      ref,
                      storeDataList: dashboardWatch.weekInteractionCountStoreList,
                      searchKeyword: dashboardWatch.weekInteractionCountStoreSearchCtr.text,
                      categoryUuid: dashboardWatch.selectedWeekInteractionCountCategory?.uuid,
                    );
                  },
                  onScrollListener: () {
                    dashboardWatch.storeDataListApi(
                      context,
                      ref,
                      storeDataList: dashboardWatch.weekInteractionCountStoreList,
                      isForPagination: true,
                      searchKeyword: dashboardWatch.weekInteractionCountStoreSearchCtr.text,
                      categoryUuid: dashboardWatch.selectedWeekInteractionCountCategory?.uuid,
                    );
                  },
                ).paddingOnly(left: context.width * 0.005),
              ),
              /// range date selection widget
              InkWell(
                onTap: () {
                  ///Range Date Picker
                  weekCountDateFilterPickerDialog(
                    context,
                    value: [dashboardWatch.startDateWeekdays, dashboardWatch.endDateWeekdays],
                    firstDate: DateTime(2000, 1, 1),
                    lastDate: DateTime.now(),
                    onSelect: (dateList) {
                      ///Change Selected Date Value
                      dashboardWatch.changeWeekInteractionCountDateValue(context, ref, dateList);
                    },
                  );
                },
                child: SizedBox(
                  height: context.height * 0.04,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.clr4793EB, AppColors.clr2367EC]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: context.width * 0.005, vertical: context.height * 0.007),
                    child: Row(
                      children: [
                        CommonText(
                          title: dashboardWatch.weekInteractionCountDateController.text,
                          style: TextStyles.regular.copyWith(fontSize: 10, color: AppColors.white),
                          maxLines: 5,
                        ),
                        SizedBox(width: context.width * 0.005),
                        CommonSVG(
                          strIcon: Assets.svgs.svgCalendar.path,
                          height: context.height * 0.02,
                          colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcATop),
                        ).paddingOnly(left: 3),
                      ],
                    ),
                  ),
                ),
              ).paddingOnly(left: context.width * 0.005),
              /// reset
              Visibility(
                visible: (dashboardWatch.selectedWeekInteractionCountCategory != null) || !isDateRangeThisWeek(dashboardWatch.startDateWeekdays, dashboardWatch.endDateWeekdays),
                child: InkWell(
                  onTap: (){
                    dashboardWatch.resetWeekInteractionCountFilter(context, ref);
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
          SizedBox(height: context.height * 0.02),
          CommonDashboardWeekendWeekdayBarGraph(),
        ],
      ),
    );
  }
}
