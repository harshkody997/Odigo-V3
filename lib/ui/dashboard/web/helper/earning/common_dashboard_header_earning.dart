import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_dropdown.dart';
import 'package:odigov3/ui/dashboard/web/helper/earning/common_dashboard_earning_sales_tile.dart';
import 'package:odigov3/ui/dashboard/web/helper/overview/common_dashboard_header_tile.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_tab_bar.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardHeaderEarning extends ConsumerWidget {
  const CommonDashboardHeaderEarning({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardWatch = ref.watch(dashboardController);

    return SizedBox(
      height: context.height * 0.65,
      child: CommonDashboardContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonSVG(strIcon: Assets.svgs.svgCash.path),
                SizedBox(width: context.width * 0.001),
                CommonText(title: LocaleKeys.keyEarning.localized, style: TextStyles.semiBold),
                SizedBox(width: context.width * 0.001),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: CommonDashboardTabBar(
                      tabList: dashboardWatch.earningTabList,
                      selectedTab: dashboardWatch.selectedEarningTab,
                      onTabSelect: (tab) {
                        dashboardWatch.updateSelectedEarningTab(tab);
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.height * 0.05),
            Align(
              alignment: Alignment.center,
              child: CommonText(
                title: LocaleKeys.keyTotalEarning.localized,
                style: TextStyles.medium.copyWith(color: AppColors.clr878787, fontSize: 12),
              ),
            ),
            SizedBox(height: context.height * 0.01),
            Align(
              alignment: Alignment.center,
              child: CommonText(
                title: '\$12400',
                style: TextStyles.semiBold.copyWith(color: AppColors.clr2997FC, fontSize: 32),
              ),
            ),
            Spacer(),
            Align(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: context.height * 0.2,
                    width: context.height * 0.2,
                    child: CircularProgressIndicator(color: AppColors.clr2997FC, value: 0.7, backgroundColor: AppColors.dividerColor, strokeCap: StrokeCap.round, strokeWidth: 20),
                  ),
                  SizedBox(
                    height: context.height * 0.12,
                    width: context.height * 0.12,
                    child: CircularProgressIndicator(color: AppColors.clrBFE0FF, value: 0.6, backgroundColor: AppColors.dividerColor, strokeCap: StrokeCap.round, strokeWidth: 20),
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CommonDashboardEarningSalesTile(title: LocaleKeys.keyVendor.localized, color: AppColors.clr2997FC, amount: '52,010', sales: '3200'),
                CommonDashboardEarningSalesTile(title: LocaleKeys.keyAgency.localized, color: AppColors.clrBFE0FF, amount: '68,000', sales: '1200'),
              ],
            ),
            Spacer(),
            Align(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText(
                      title: LocaleKeys.keyGreatResultsWith.localized,
                      style: TextStyles.medium.copyWith(color: AppColors.clr878787, fontSize: 13),
                    ),
                    SizedBox(width: context.width * 0.002),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.clrE8FFF4,
                        border: Border.all(color: AppColors.clr8FE7BE),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: context.width * 0.001, vertical: context.width * 0.001),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_upward, color: AppColors.clr8FE7BE, size: 12),
                          SizedBox(width: context.width * 0.001),
                          CommonText(
                            title: '12%',
                            style: TextStyles.medium.copyWith(color: AppColors.clr8FE7BE, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: context.width * 0.002),
                    CommonText(
                      title: LocaleKeys.keyFromLastMonth.localized,
                      style: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.clrA3AED0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
