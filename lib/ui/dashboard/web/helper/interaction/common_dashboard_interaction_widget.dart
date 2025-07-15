import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/category_data_list_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/store_data_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_dropdown.dart';
import 'package:odigov3/ui/dashboard/web/helper/interaction/common_dashboard_interaction_bar_graph.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_switch_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardInteractionGraphWidget extends ConsumerWidget {
  const CommonDashboardInteractionGraphWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardWatch = ref.watch(dashboardController);
    return SizedBox(
      height: context.height * 0.47,
      child: CommonDashboardContainer(
        child: Column(
          children: [
            Row(
              children: [
                CommonText(
                  title: LocaleKeys.keyInteractions.localized,
                  style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
                ),
                Spacer(),
                SizedBox(width: context.width * 0.005),
                ///Total Average Switch
                Row(
                  children: [
                    CommonText(
                      title: LocaleKeys.keyTotal.localized,
                      style: TextStyles.medium.copyWith(
                        color: AppColors.black.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                    CommonCupertinoSwitch(
                      switchValue: dashboardWatch.interactionInitialType,
                      onChanged: (value) async {
                        dashboardWatch.selectedInteractionMonth = null;
                        dashboardWatch.updateInteractionsGraphValues();
                        dashboardWatch.interactionApiCall(context);
                      },
                    ).paddingSymmetric(horizontal: 5),
                    CommonText(
                      title: LocaleKeys.keyAverage.localized,
                      style: TextStyles.medium.copyWith(
                        color: AppColors.black.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                    // SizedBox(width: context.width * 0.03),
                  ],
                ),
                SizedBox(width: context.width * 0.01),
                /// category selection widget
                CommonSearchableDropdown(
                  fieldWidth: context.width * 0.13,
                  fieldHeight: context.height * 0.04,
                  hintText: LocaleKeys.keySelectCategory.localized,
                  hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                  fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
                  onSelected: (value) {
                    dashboardWatch.updateInteractionSelectedCategory(context, ref, value);
                  },
                  textEditingController: dashboardWatch.interactionCategorySearchCtr,
                  items: dashboardWatch.interactionCategoryList,
                  title: (CategoryDataListDto? item) {
                    return item?.name ?? '';
                  },
                  showLoader: true,
                  onSearch: (value) async {
                    await dashboardWatch.categoryDataListApi(
                      context,
                      ref,
                      categoryList: dashboardWatch.interactionCategoryList,
                      searchKeyword: dashboardWatch.interactionCategorySearchCtr.text,
                    );
                  },
                  onScrollListener: () {
                    dashboardWatch.categoryDataListApi(
                      context,
                      ref,
                      categoryList: dashboardWatch.interactionCategoryList,
                      isForPagination: true,
                      searchKeyword: dashboardWatch.interactionCategorySearchCtr.text,
                    );
                  },
                ),
                /// Store selection widget
                Visibility(
                  visible: dashboardWatch.selectedInteractionCategory != null,
                  child: CommonSearchableDropdown(
                    fieldWidth: context.width * 0.13,
                    fieldHeight: context.height * 0.04,
                    hintText: LocaleKeys.keySelectStore.localized,
                    hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                    fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
                    onSelected: (value) {
                      dashboardWatch.updateInteractionSelectedStore(context, ref, value);
                    },
                    textEditingController: dashboardWatch.interactionStoreSearchCtr,
                    items: dashboardWatch.interactionStoreList,
                    title: (StoreDataListDto? item) {
                      return item?.name ?? '';
                    },
                    showLoader: true,
                    onSearch: (value) async {
                      await dashboardWatch.storeDataListApi(
                        context,
                        ref,
                        storeDataList: dashboardWatch.interactionStoreList,
                        searchKeyword: dashboardWatch.interactionStoreSearchCtr.text,
                        categoryUuid: dashboardWatch.selectedInteractionCategory?.uuid,
                      );
                    },
                    onScrollListener: () {
                      dashboardWatch.storeDataListApi(
                        context,
                        ref,
                        storeDataList: dashboardWatch.interactionStoreList,
                        isForPagination: true,
                        searchKeyword: dashboardWatch.interactionStoreSearchCtr.text,
                        categoryUuid: dashboardWatch.selectedInteractionCategory?.uuid,
                      );
                    },
                  ).paddingOnly(left: context.width * 0.005),
                ),
                ///Month Dropdown
                Visibility(
                  visible:  !dashboardWatch.interactionInitialType,
                  child: CommonDashboardDropdown(
                    itemHeight: 0.04,
                    width: context.width * 0.05,
                    placeholder: dashboardWatch.selectedInteractionMonth ?? LocaleKeys.keyMonth.localized,
                    items: monthDynamicList.map((e) => e.showTitle).toList(),
                    onChanged: (value) async {
                      final selectedMonth = monthDynamicList.firstWhere(
                            (element) => element.showTitle == value,
                        orElse: () => monthDynamicList.first,
                      );

                      dashboardWatch.updateInteractionMonthYear(selectedMonth.value??'');
                      dashboardWatch.interactionApiCall(context);
                    },
                    value: dashboardWatch.selectedInteractionMonth,
                  ).paddingOnly(left: context.width * 0.005),
                ),
                SizedBox(width: context.width * 0.005),
                ///Year Dropdown
                CommonDashboardDropdown(
                  itemHeight: 0.04,
                  width: context.width * 0.05,
                  placeholder: dashboardWatch.selectedYearInteractionsIndex ?? LocaleKeys.keyYear.localized,
                  value: dashboardWatch.selectedYearInteractionsIndex,
                  items: dashboardWatch.yearsDynamicList,
                  onChanged: (value) async {
                    dashboardWatch.updateYearInteractionsIndex(context, value);
                    dashboardWatch.interactionApiCall(context);
                  },
                ),

                ///Reset Button
                Visibility(
                  visible: dashboardWatch.selectedYearInteractionsIndex != DateTime.now().year.toString() || dashboardWatch.selectedInteractionMonth != null || dashboardWatch.selectedInteractionCategory != null,
                  child: InkWell(
                    onTap: (){
                      dashboardWatch.disposeInteractionValue();
                      dashboardWatch.interactionApiCall(context);
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
            CommonDashboardInteractionBarGraph(),
          ],
        ),
      ),
    );
  }
}
