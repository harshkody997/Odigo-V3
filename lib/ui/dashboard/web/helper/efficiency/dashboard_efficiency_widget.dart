import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/store_data_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/dashboard/web/helper/efficiency/common_dashboard_efficiency_circle_progress.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class DashboardEfficiencyWidget extends ConsumerWidget {
  const DashboardEfficiencyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final dashboardWatch = ref.watch(dashboardController);
     final double efficiency = dashboardWatch.navigationEfficiencyState.success?.data ?? 0;


     return SizedBox(
      height: context.height * 0.48,
      child: CommonDashboardContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(title: LocaleKeys.keyEfficiencyOfGuideShopperToStore.localized, style: TextStyles.semiBold),
            SizedBox(height: context.height * 0.02),
            Row(
              children: [

                /// store filter
                CommonSearchableDropdown(
                  fieldWidth: context.width * 0.13,
                  fieldHeight: context.height * 0.04,
                  hintText: LocaleKeys.keySelectStore.localized,
                  hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                  fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
                  onSelected: (value) {
                    dashboardWatch.updateEfficiencySelectedStore(context, ref, value);
                  },
                  textEditingController: dashboardWatch.efficiencyStoreSearchCtr,
                  items: dashboardWatch.efficiencyStoreList,
                  title: (StoreDataListDto? item) {
                    return item?.name ?? '';
                  },
                  showLoader: true,
                  onSearch: (value) async {
                    await dashboardWatch.storeDataListApi(
                      context,
                      ref,
                      storeDataList: dashboardWatch.efficiencyStoreList,
                      searchKeyword: dashboardWatch.efficiencyStoreSearchCtr.text,
                    );
                  },
                  onScrollListener: () {
                    dashboardWatch.storeDataListApi(
                      context,
                      ref,
                      storeDataList: dashboardWatch.efficiencyStoreList,
                      isForPagination: true,
                      searchKeyword: dashboardWatch.efficiencyStoreSearchCtr.text,
                    );
                  },
                ),
                SizedBox(width: context.width * 0.005),
                /// reset
                Visibility(
                  visible: dashboardWatch.selectedEfficiencyStore!=null,
                  child: InkWell(
                    onTap: (){
                          dashboardWatch.resetEfficiency();
                          dashboardWatch.navigationEfficiencyApi(context);
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
            SizedBox(height: context.height * 0.06),
        Expanded(
              child: Center(
                child:
                dashboardWatch.navigationEfficiencyState.isLoading?  CommonAnimLoader()  :dashboardWatch.navigationEfficiencyState.success?.data ==null || dashboardWatch.navigationEfficiencyState.success?.data ==0  ?  CommonEmptyStateWidget():Stack(
                  alignment: Alignment.center,
                  children: [
                    CommonDashboardEfficiencyCircleProgress(radius: context.height * 0.14, strokeWidth: context.height * 0.04, percentage:efficiency/100, fillColor: efficiency < 50? AppColors.redFF4C4C.withValues(alpha: 0.9):efficiency < 75?  AppColors.green4CAF50.withValues(alpha: 0.9): AppColors.yellowFFC107.withValues(alpha: 0.9),),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonText(
                          title: '${(dashboardWatch.navigationEfficiencyState.success?.data??0).toStringAsFixed(0)}%',
                          style: TextStyles.bold.copyWith(fontSize: 26, color: AppColors.clr080808),
                        ),
                        CommonText(
                          title:  efficiency < 50
                              ? LocaleKeys.keyNeedImprovement.localized
                              : efficiency < 75
                              ? LocaleKeys.keyGood.localized
                              :LocaleKeys.keyExcellent.localized,
                          style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.clr080808),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );  }
}
