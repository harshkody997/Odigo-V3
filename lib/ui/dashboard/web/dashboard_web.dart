import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/destination_name_data_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/dashboard/web/helper/ads_count/ads_count_widget.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/efficiency/dashboard_efficiency_widget.dart';
import 'package:odigov3/ui/dashboard/web/helper/interaction/common_dashboard_interaction_widget.dart';
import 'package:odigov3/ui/dashboard/web/helper/most_requested_store/dashboard_most_requested_store.dart';
import 'package:odigov3/ui/dashboard/web/helper/navigation_request/common_dashboard_navigation_request_widget.dart';
import 'package:odigov3/ui/dashboard/web/helper/overview/common_dashboard_header_overview.dart' show CommonDashboardHeaderOverview;
import 'package:odigov3/ui/dashboard/web/helper/peak_usage/peak_usage_graph_widget.dart';
import 'package:odigov3/ui/dashboard/web/helper/uptime/common_dashboard_uptime_widget.dart';
import 'package:odigov3/ui/dashboard/web/helper/weekend_weekday/common_dashboard_weekend_weekday_widget.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class DashboardWeb extends ConsumerStatefulWidget {
  const DashboardWeb({super.key});

  @override
  ConsumerState createState() => _DashboardWebState();
}

class _DashboardWebState extends ConsumerState<DashboardWeb> {

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    final dashboardWatch = ref.watch(dashboardController);
    return BaseDrawerPageWidget(showSettings: true,
      body: _bodyWidget(),
      showProfile: true,
      showNotification: true,

     );
  }


  Widget _bodyWidget() {
    final dashboardWatch = ref.watch(dashboardController);
    return dashboardWatch.dashboardCountState.isLoading
        ? CommonAnimLoader()
        : ListView(
      children: [
        /// overview and earning graph
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 11, child: CommonDashboardHeaderOverview()),
            // SizedBox(width: context.width * 0.005),
            // Expanded(flex: 4, child: CommonDashboardHeaderEarning()),
          ],
        ),
        SizedBox(height: context.height * 0.03),
        /// destination selection dropdown
        if(!((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)))
          Row(
          children: [
            CommonText(
              title: LocaleKeys.keyDetailedAnalytics.localized,
              style: TextStyles.semiBold.copyWith(
                fontSize: 14
              ),
            ),
            SizedBox(width: context.width * 0.01),
            /// destination selection widget
            CommonSearchableDropdown<DestinationNameData>(
              fieldWidth: context.width * 0.17,
              fieldHeight: context.height * 0.05,
              hintText: LocaleKeys.keySelectDestination.localized,
              hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
              fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12),
              onSelected: (value) async{
                dashboardWatch.updateSelectedDestination(context, ref, value);
              },
              textEditingController: dashboardWatch.destinationSearchCtr,
              items: dashboardWatch.destinationList,
              title: (DestinationNameData? item) {
                return item?.name ?? '';
              },
              showLoader: true,
              onSearch: (value) async {
                await dashboardWatch.destinationDataListApi(context, ref);
              },
              onScrollListener: () {
                dashboardWatch.destinationDataListApi(context, ref, isForPagination: true);
              },
            ),
          ],
        ).paddingOnly(bottom: context.height * 0.02),
        /// uptime and peak usage graph
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2,child: CommonDashboardUptimeWidget()),
            SizedBox(width: context.width * 0.005),
            Expanded(flex: 3, child: PeakUsageGraphWidget()),
            // Expanded(flex: 2, child: CommonDashboardSalesWidget()),
          ],
        ),
        SizedBox(height: context.height * 0.02),
        /// most requested store and efficiency graph
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: DashboardMostRequestedStore()),
            SizedBox(width: context.width * 0.005),
            Expanded(flex: 1, child: DashboardEfficiencyWidget()),
          ],
        ),
        SizedBox(height: context.height * 0.02),
        /// weekend and weekdays graph
        CommonDashboardWeekendWeekdayWidget(),
        SizedBox(height: context.height * 0.02),
        /// ads count graph
        AdsCountWidget(),
        SizedBox(height: context.height * 0.02),
        /// interaction graph
        CommonDashboardInteractionGraphWidget(),
        SizedBox(height: context.height * 0.02),
        /// navigation request graph
        CommonDashboardNavigationRequestWidget(),
        SizedBox(height: context.height * 0.02),
      ],
    );
  }
}
