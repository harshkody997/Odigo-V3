import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/category_data_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_dropdown.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class DashboardMostRequestedStore extends ConsumerWidget {
  const DashboardMostRequestedStore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardWatch = ref.watch(dashboardController);
    return SizedBox(
      height: context.height * 0.48,
      child:
     CommonDashboardContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CommonText(title: LocaleKeys.keyMostRequestedStores.localized, style: TextStyles.semiBold),
                Spacer(),
                CommonSearchableDropdown(
                  fieldWidth: context.width * 0.13,
                  fieldHeight: context.height * 0.04,
                  hintText: LocaleKeys.keySelectCategory.localized,
                  hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                  fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
                  onSelected: (value)async  {
                    dashboardWatch.updateMostRequestedSelectedCategory(value);
                    await dashboardWatch.mostRequestedStoreApi(context);
                  },
                  textEditingController: dashboardWatch.mostRequestedCategorySearchCtr,
                  items: dashboardWatch.mostRequestedCategoryList,
                  title: (CategoryDataListDto? item) {
                    return item?.name ?? '';
                  },
                  showLoader: true,
                  onSearch: (value) async {
                    await dashboardWatch.categoryDataListApi(context, ref, categoryList: dashboardWatch.mostRequestedCategoryList, searchKeyword: dashboardWatch.mostRequestedCategorySearchCtr.text);
                  },
                  onScrollListener: () {
                    dashboardWatch.categoryDataListApi(context, ref, categoryList: dashboardWatch.mostRequestedCategoryList, searchKeyword: dashboardWatch.mostRequestedCategorySearchCtr.text, isForPagination: true);
                  },
                ),
                SizedBox(width: context.width * 0.005),

                Visibility(
                  visible: dashboardWatch.mostRequestedStoreMonth!=null,
                  child: CommonDashboardDropdown(
                    itemHeight: 0.04,
                    width: context.width * 0.08,
                    placeholder: dashboardWatch.dayOfMonth ?? LocaleKeys.keyDay.localized,
                    items: dashboardWatch.daysList,
                    value: dashboardWatch.dayOfMonth,
                    onChanged: (value)async  {
                      dashboardWatch.updateDay(value);
                      await dashboardWatch.mostRequestedStoreApi(context);
                    },
                  ),
                ),
                SizedBox(width: context.width * 0.005),
                /// month filter
                Visibility(
                  visible: dashboardWatch.mostRequestedStoreYear!=null,
                  child: CommonDashboardDropdown(
                    itemHeight: 0.04,
                    width: context.width * 0.08,
                    value: dashboardWatch.mostRequestedStoreMonth,
                    placeholder: dashboardWatch.mostRequestedStoreMonth ?? LocaleKeys.keyMonth.localized,
                    items: dashboardWatch.monthMap.keys.toList(),
                    onChanged: (value) async{
                      dashboardWatch.updateMostRequestedStoreMonth(value);
                      await dashboardWatch.mostRequestedStoreApi(context);
                    },
                  ),
                ),
                SizedBox(width: context.width * 0.005),
                /// year filter
                CommonDashboardDropdown(
                  itemHeight: 0.04,
                  width: context.width * 0.08,
                  value: dashboardWatch.mostRequestedStoreYear,
                  placeholder: dashboardWatch.mostRequestedStoreYear ?? LocaleKeys.keyYear.localized,
                  items: ['2025', '2024', '2023'],
                  onChanged: (value) async {
                    dashboardWatch.updateMostRequestedStoreYear(value);
                    await dashboardWatch.mostRequestedStoreApi(context);
                  },
                ),
                SizedBox(width: context.width * 0.005),
                /// reset
                Visibility(
                  visible: dashboardWatch.selectedMostRequestedStoreCategory!=null || dashboardWatch.mostRequestedStoreMonth!=null ||
                      dashboardWatch.mostRequestedStoreYear!=null || dashboardWatch.dayOfMonth!=null,
                  child: InkWell(
                    onTap: (){

                          dashboardWatch.resetMostRequestedStoreData();
                          dashboardWatch.mostRequestedStoreApi(context);


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
                  ),
                ),
              ],
            ),
            SizedBox(height: context.height * 0.02),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CommonText(
                    title: LocaleKeys.keySrNo.localized,
                    style: TextStyles.medium.copyWith(fontSize: 12,color: AppColors.clr828282),
                  ),
                ),
                SizedBox(
                  width: context.height * 0.036,
                ),
                Expanded(
                  child: CommonText(
                    title: LocaleKeys.keyAdCount.localized,
                    style: TextStyles.medium.copyWith(fontSize: 12,color: AppColors.clr828282),

                  ),
                ),
                SizedBox(
                  width: context.height * 0.036,
                ),
                Expanded(
                  flex: 4,
                  child: CommonText(
                    title: LocaleKeys.keyStoreName.localized,
                    style: TextStyles.medium.copyWith(fontSize: 12,color: AppColors.clr828282),

                  ),
                ),
              ],
            ),

            SizedBox(
              height: context.height * 0.02,
            ),
            Expanded(
              child:   dashboardWatch.mostRequestedStoreListState.isLoading? CommonAnimLoader() :
              (dashboardWatch.mostRequestedStoreListState.success?.data?.mostRequestedStores??[]).isEmpty ?
              Center(child: CommonEmptyStateWidget()):SingleChildScrollView(
                  child:
                  Column(
                    children: List.generate((dashboardWatch.mostRequestedStoreListState.success?.data?.mostRequestedStores??[]).length,
                          (index) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: 1.5,
                                      color: AppColors.whiteF9F9F9,
                                    ),
                                  ),
                                ),
                                child: CommonText(
                                  title: '${index + 1}',
                                  style: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.black),
                                ).paddingSymmetric(vertical: context.height * 0.015),
                              ),
                            ),
                            SizedBox(width: context.height * 0.036),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: 1.5,
                                      color: AppColors.whiteF9F9F9,
                                    ),
                                  ),
                                ),
                                child: CommonText(
                                  title: (dashboardWatch.mostRequestedStoreListState.success?.data?.mostRequestedStores??[])[index].requestCount.toString(),
                                  style: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.black),
                                ).paddingSymmetric(vertical: context.height * 0.015),
                              ),
                            ),
                            SizedBox(width: context.height * 0.036),
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: 1.5,
                                      color: AppColors.whiteF9F9F9,
                                    ),
                                  ),
                                ),
                                child: CommonText(
                                  title: (dashboardWatch.mostRequestedStoreListState.success?.data?.mostRequestedStores??[])[index].storeName??'',
                                  style: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.black),
                                ).paddingSymmetric(vertical: context.height * 0.015),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
