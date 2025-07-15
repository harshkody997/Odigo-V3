import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/dummy_data.dart';
import 'package:odigov3/framework/repository/dashboard/model/line_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/avg_time/common_dashboard_avg_time_store_bar_graph.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_dropdown.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardReachedStoreWidget extends ConsumerWidget {
  const CommonDashboardReachedStoreWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardWatch = ref.watch(dashboardController);
    return SizedBox(
      // height: context.height * 0.43,
      child: CommonDashboardContainer(
        child: Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  CommonText(
                    title: LocaleKeys.keyAvgTimeToReachStore.localized,
                    style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
                  ),
                  Spacer(),
                  SizedBox(width: context.width * 0.005),
                  CommonDashboardDropdown(
                    placeholder: dashboardWatch.selectedStore ?? LocaleKeys.keySelectStore.localized,
                    value: dashboardWatch.selectedStore,
                    items: dashboardWatch.storeList,
                    onChanged: (store) {
                      dashboardWatch.updateSelectedStore(store);
                    },
                    itemHeight: 0.04,
                    width: context.width * 0.06,
                  ),
                  SizedBox(width: context.width * 0.005),
                  CommonDashboardDropdown(
                    value: dashboardWatch.overviewMonth,
                    itemHeight: 0.04,
                    width: context.width * 0.05,
                    placeholder: dashboardWatch.overviewMonth ?? LocaleKeys.keyMonth.localized,
                    items: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
                    onChanged: (value) {
                      dashboardWatch.updateOverviewMonth(value);
                    },
                  ),
                  SizedBox(width: context.width * 0.005),
                  CommonDashboardDropdown(
                    itemHeight: 0.04,
                    width: context.width * 0.04,
                    value: dashboardWatch.overviewYear ,
                    placeholder: dashboardWatch.overviewYear ?? LocaleKeys.keyYear.localized,
                    items: ['2025', '2024', '2023'],
                    onChanged: (value) {
                      dashboardWatch.updateOverviewYear(value);
                    },
                  ),
                ],
              ),
              SizedBox(height: context.height * 0.02),
              CommonDashboardAvgTimeStoreBarGraph(barGraphData: List.generate(dummyGraphData.length, (index) => LineGraphData.fromJson(dummyGraphData[index] ?? ''))),
            ],
          ),
        ),
      ),
    );
  }
}
