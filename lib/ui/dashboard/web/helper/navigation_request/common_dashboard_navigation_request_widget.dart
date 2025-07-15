import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/store_data_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_dropdown.dart';
import 'package:odigov3/ui/dashboard/web/helper/navigation_request/common_dashboard_navigation_request_bar_graph.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_switch_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardNavigationRequestWidget extends ConsumerWidget {
  const CommonDashboardNavigationRequestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardWatch = ref.watch(dashboardController);
    return CommonDashboardContainer(
      child: Column(
        children: [
          Row(
            children: [
              /// title
              CommonText(
                title: LocaleKeys.keyNavigationRequest.localized,
                style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
              ),
              Spacer(),
              SizedBox(width: context.width * 0.005),
              /// total average switch
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
                    switchValue: dashboardWatch.navigationRequestType,
                    onChanged: (value) async {
                      dashboardWatch.selectedNavigationMonth = null;
                      dashboardWatch.updateNavigationRequestType(context);
                    },
                  ).paddingSymmetric(horizontal: context.width * 0.005),
                  CommonText(
                    title: LocaleKeys.keyAverage.localized,
                    style: TextStyles.medium.copyWith(
                      color: AppColors.black.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(width: context.width * 0.01),
              /// store filter
              CommonSearchableDropdown(
                fieldWidth: context.width * 0.13,
                fieldHeight: context.height * 0.04,
                hintText: LocaleKeys.keySelectStore.localized,
                hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
                onSelected: (value) {
                  dashboardWatch.updateNavigationRequestSelectedStore(context, ref, value);
                },
                textEditingController: dashboardWatch.navigationRequestStoreSearchCtr,
                items: dashboardWatch.navigationRequestStoreList,
                title: (StoreDataListDto? item) {
                  return item?.name ?? '';
                },
                showLoader: true,
                onSearch: (value) async {
                  await dashboardWatch.storeDataListApi(
                    context,
                    ref,
                    storeDataList: dashboardWatch.navigationRequestStoreList,
                    searchKeyword: dashboardWatch.navigationRequestStoreSearchCtr.text,
                  );
                },
                onScrollListener: () {
                  dashboardWatch.storeDataListApi(
                    context,
                    ref,
                    storeDataList: dashboardWatch.navigationRequestStoreList,
                    isForPagination: true,
                    searchKeyword: dashboardWatch.navigationRequestStoreSearchCtr.text,
                  );
                },
              ),
              /// month filter
              Visibility(
                visible: dashboardWatch.navigationRequestType == false,
                child: CommonDashboardDropdown(
                  itemHeight: 0.04,
                  width: context.width * 0.05,
                  value: dashboardWatch.selectedNavigationMonth,
                  placeholder: dashboardWatch.selectedNavigationMonth ?? LocaleKeys.keyMonth.localized,
                  items: monthDynamicList.map((e) => e.showTitle?.localized).whereType<String>().toList(),
                  onChanged: (value) {
                    dashboardWatch.updateNavigationRequestMonthYear(context, value);
                  },
                ).paddingOnly(left: context.width * 0.005),
              ),
              SizedBox(width: context.width * 0.005),
              /// year filter
              CommonDashboardDropdown(
                itemHeight: 0.04,
                width: context.width * 0.05,
                value: dashboardWatch.selectedNavigationRequestYear,
                placeholder: dashboardWatch.selectedNavigationRequestYear ?? LocaleKeys.keyYear.localized,
                items: dashboardWatch.yearsDynamicList,
                onChanged: (value) {
                  dashboardWatch.updateNavigationRequestYearIndex(context, value);
                },
              ),
              /// reset
              Visibility(
                visible: (dashboardWatch.selectedNavigationRequestStore != null) || (dashboardWatch.selectedNavigationMonth != null) || (dashboardWatch.selectedNavigationRequestYear != DateTime.now().year.toString()),
                child: InkWell(
                  onTap: (){
                    dashboardWatch.resetNavigationRequestFilter(context);
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
          /// graph widget
          CommonDashboardNavigationRequestBarGraph(),
        ],
      ),
    );
  }
}
