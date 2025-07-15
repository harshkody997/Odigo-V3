import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/category_data_list_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/store_data_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/extension/time_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/dashboard/web/helper/peak_usage/peak_usage_bar_graph.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/show_common_date_picker.dart';

class PeakUsageGraphWidget extends ConsumerWidget {
  const PeakUsageGraphWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardWatch = ref.watch(dashboardController);
    return SizedBox(
      height: context.height * 0.53,
      child: CommonDashboardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// heading
            CommonText(
              title: LocaleKeys.keyPeakUsageTime.localized,
              style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
            ),
            SizedBox(height: context.height * 0.01),
            /// filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  /// category selection widget
                  CommonSearchableDropdown(
                    fieldWidth: context.width * 0.13,
                    fieldHeight: context.height * 0.04,
                    hintText: LocaleKeys.keySelectCategory.localized,
                    hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                    fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
                    onSelected: (value) {
                      dashboardWatch.updatePeakUsageSelectedCategory(context, ref, value);
                    },
                    textEditingController: dashboardWatch.peakUsageCategorySearchCtr,
                    items: dashboardWatch.peakUsageCategoryList,
                    title: (CategoryDataListDto? item) {
                      return item?.name ?? '';
                    },
                    showLoader: true,
                    onSearch: (value) async {
                      await dashboardWatch.categoryDataListApi(context, ref, categoryList: dashboardWatch.peakUsageCategoryList,searchKeyword: dashboardWatch.peakUsageCategorySearchCtr.text);
                    },
                    onScrollListener: () {
                      dashboardWatch.categoryDataListApi(context, ref, categoryList: dashboardWatch.peakUsageCategoryList, isForPagination: true, searchKeyword: dashboardWatch.peakUsageCategorySearchCtr.text);
                    },
                  ),
                  /// Store selection widget
                  Visibility(
                    visible: dashboardWatch.selectedPeakUsageCategory != null,
                    child: CommonSearchableDropdown(
                      fieldWidth: context.width * 0.13,
                      fieldHeight: context.height * 0.04,
                      hintText: LocaleKeys.keySelectStore.localized,
                      hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                      fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
                      onSelected: (value) {
                        dashboardWatch.updatePeakUsageSelectedStore(context, ref, value);
                      },
                      textEditingController: dashboardWatch.peakUsageStoreSearchCtr,
                      items: dashboardWatch.peakUsageStoreList,
                      title: (StoreDataListDto? item) {
                        return item?.name ?? '';
                      },
                      showLoader: true,
                      onSearch: (value) async {
                        await dashboardWatch.storeDataListApi(
                          context,
                          ref,
                          storeDataList: dashboardWatch.peakUsageStoreList,
                          searchKeyword: dashboardWatch.peakUsageStoreSearchCtr.text,
                          categoryUuid: dashboardWatch.selectedPeakUsageCategory?.uuid
                        );
                      },
                      onScrollListener: () {
                        dashboardWatch.storeDataListApi(
                          context,
                          ref,
                          storeDataList: dashboardWatch.peakUsageStoreList,
                          isForPagination: true,
                          searchKeyword: dashboardWatch.peakUsageStoreSearchCtr.text,
                          categoryUuid: dashboardWatch.selectedPeakUsageCategory?.uuid
                        );
                      },
                    ).paddingOnly(left: context.width * 0.005),
                  ),
                  SizedBox(width: context.width * 0.005),
                  /// date filter
                  CommonDateInputFormField(
                    placeholder: LocaleKeys.keySelectDate.localized,
                    initialDate: dashboardWatch.peakUsageSelectedDate,
                    isForRange: false,
                    lastDate: DateTime.now(),
                    onSelected: (selectedDate) {
                      dashboardWatch.updatePeakUsageSelectedDate(selectedDate ?? DateTime.now(), context, ref);
                    },
                  ),
                  /// reset
                  Visibility(
                    visible: (dashboardWatch.selectedPeakUsageCategory != null) || !dashboardWatch.peakUsageSelectedDate.isToday(),
                    child: InkWell(
                      onTap: (){
                        dashboardWatch.resetPeakUsageFilter(context, ref);
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
            Spacer(),
            SizedBox(height: context.height * 0.02),
            /// graph widget
            PeakUsageBarGraph(),
          ],
        ),
      ),
    );
  }
}
