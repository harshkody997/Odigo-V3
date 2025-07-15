import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_list_controller.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/client/model/response/client_list_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/dummy_data.dart';
import 'package:odigov3/framework/repository/dashboard/model/line_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/ads_count/ads_count_bar_graph.dart';
import 'package:odigov3/ui/dashboard/web/helper/avg_time/common_dashboard_avg_time_store_bar_graph.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_dropdown.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_tab_bar.dart';
import 'package:odigov3/ui/dashboard/web/helper/sales/common_sales_line_chart_data.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_switch_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AdsCountWidget extends ConsumerWidget {
  const AdsCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardWatch = ref.watch(dashboardController);
    final clientListWatch = ref.watch(clientListController);
    return SizedBox(
      height: context.height * 0.45,
      child: CommonDashboardContainer(
        child: Column(
          children: [
            Row(
              children: [
                CommonText(
                  title: LocaleKeys.keyAdsCount.localized,
                  style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
                ),
                Spacer(),
                SizedBox(width: context.width * 0.01),
                ///Total Average Switch
                Row(
                  children: [
                    CommonText(
                      title: LocaleKeys.keyTotal.localized,
                      style: TextStyles.medium.copyWith(
                        color: AppColors.black.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    CommonCupertinoSwitch(
                      switchValue: dashboardWatch.adsCountInitialType,
                      onChanged: (value) async {
                        dashboardWatch.selectedAdsCountMonth = null;
                        showLog('dashboardWatch.adsCountInitialType ${dashboardWatch.adsCountInitialType}');
                        showLog(value.toString());
                        dashboardWatch.adsCountInteractionsGraphValues();
                        if (value) {
                          await dashboardWatch.adsCountApi(context);
                        } else {
                          await dashboardWatch.adsCountApi(context);
                        }
                      },
                    ).paddingSymmetric(horizontal: 5),
                    CommonText(
                      title: LocaleKeys.keyAverage.localized,
                      style: TextStyles.medium.copyWith(
                        color: AppColors.black.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    // SizedBox(width: context.width * 0.03),
                  ],
                ),
                SizedBox(width: context.width * 0.01),

                ///Client DropDown
                CommonSearchableDropdown(
                  fieldWidth: context.width * 0.13,
                  fieldHeight: context.height * 0.04,
                  hintText: LocaleKeys.keySelectClients.localized,
                  hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                  fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
                  onSelected: (value) async {
                    dashboardWatch.updateSelectedClient(value);
                    await dashboardWatch.adsCountApi(context);
                  },
                  textEditingController: clientListWatch.searchController,
                  items: clientListWatch.clientList,
                  title: (ClientData? item) {
                    return item?.name ?? '';
                  },
                  showLoader: clientListWatch.clientListState.isLoading,
                  onSearch: (value) async {
                    await clientListWatch.getClientApi(context);
                  },
                  onScrollListener: () async {
                    await clientListWatch.getClientApi(context, pagination: true);
                  },
                ),
                SizedBox(width: context.width * 0.01),

                ///Month Dropdown
                Visibility(
                  visible: !dashboardWatch.adsCountInitialType,
                  child: CommonDashboardDropdown(
                    itemHeight: 0.04,
                    width: context.width * 0.05,
                    value: dashboardWatch.selectedAdsCountMonth,
                    placeholder: dashboardWatch.selectedAdsCountMonth ?? LocaleKeys.keyMonth.localized,
                    items: monthDynamicList.map((e) => e.showTitle).toList(),
                    onChanged: (value) async {
                      final selectedMonth = monthDynamicList.firstWhere(
                            (element) => element.showTitle == value,
                        orElse: () => monthDynamicList.first,
                      );

                      dashboardWatch.updateAdsCountMonthYear(selectedMonth.value ?? '');
                      await dashboardWatch.adsCountApi(context);
                    },
                  ),
                ).paddingOnly(right: context.width * 0.005),
                ///Year Dropdown
                CommonDashboardDropdown(
                  itemHeight: 0.04,
                  width: context.width * 0.05,
                  value: dashboardWatch.selectedYearAdsCount,
                  placeholder: dashboardWatch.selectedYearAdsCount ?? LocaleKeys.keyYear.localized,
                  items: dashboardWatch.yearsDynamicList,
                  onChanged: (value) {
                    dashboardWatch.updateYearAdsCountIndex(context, value);
                    dashboardWatch.adsCountApi(context);
                  },
                ),

                ///Reset Button
                Visibility(
                  visible: dashboardWatch.selectedClient != null || dashboardWatch.selectedAdsCountMonth != null || dashboardWatch.selectedYearAdsCount != DateTime.now().year.toString(),
                  child: InkWell(
                    onTap: (){
                      dashboardWatch.disposeAdsCountGraphData();
                      clientListWatch.searchController.clear();
                      dashboardWatch.adsCountApi(context);
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

            ///Graph
            AdsCountBarGraph(),
          ],
        ),
      ),
    );
  }
}
