import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/dummy_data.dart';
import 'package:odigov3/framework/repository/dashboard/model/line_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_dropdown.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_tab_bar.dart';
import 'package:odigov3/ui/dashboard/web/helper/sales/common_sales_line_chart_data.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardSalesWidget extends ConsumerWidget {
  const CommonDashboardSalesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardWatch = ref.watch(dashboardController);
    return SizedBox(
      height: context.height * 0.45,
      child: CommonDashboardContainer(
        child: Column(
          children: [
            Row(
              children: [
                CommonText(
                  title: LocaleKeys.keyTotalSales.localized,
                  style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
                ),
                SizedBox(width: context.width * 0.01),
                Expanded(
                  child: CommonDashboardTabBar(
                    tabList: dashboardWatch.salesTabList,
                    selectedTab: dashboardWatch.selectedSalesTab,
                    onTabSelect: (selectedTab) {
                      dashboardWatch.updateSelectedSalesTab(selectedTab);
                    },
                  ),
                ),
                SizedBox(width: context.width * 0.005),
                CommonDashboardDropdown(
                  itemHeight: 0.04,
                  width: context.width * 0.05,
                  value: dashboardWatch.overviewMonth,
                  placeholder: dashboardWatch.overviewMonth ?? LocaleKeys.keyMonth.localized,
                  items: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
                  onChanged: (value) {
                    dashboardWatch.updateOverviewMonth(value);
                  },
                ),
                SizedBox(width: context.width * 0.005),
                CommonDashboardDropdown(
                  itemHeight: 0.04,
                  value: dashboardWatch.overviewYear,
                  width: context.width * 0.04,
                  placeholder: dashboardWatch.overviewYear ?? LocaleKeys.keyYear.localized,
                  items: ['2025', '2024', '2023'],
                  onChanged: (value) {
                    dashboardWatch.updateOverviewYear(value);
                  },
                ),
              ],
            ),
            SizedBox(height: context.height * 0.02),
            CommonSalesLineChart(lineGraphData: List.generate(dummyGraphData.length, (index) => LineGraphData.fromJson(dummyGraphData[index] ?? ''))),
          ],
        ),
      ),
    );
  }
}
