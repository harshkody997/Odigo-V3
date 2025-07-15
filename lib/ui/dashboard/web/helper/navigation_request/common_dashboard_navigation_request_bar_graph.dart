import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardNavigationRequestBarGraph extends ConsumerStatefulWidget {
  const CommonDashboardNavigationRequestBarGraph({Key? key}) : super(key: key);

  @override
  ConsumerState<CommonDashboardNavigationRequestBarGraph> createState() => _CommonDashboardNavigationRequestBarGraphState();
}

class _CommonDashboardNavigationRequestBarGraphState extends ConsumerState<CommonDashboardNavigationRequestBarGraph> with TickerProviderStateMixin {
  void animationListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dashboardWatch = ref.watch(dashboardController);
    bool isZero = dashboardWatch.monthGraphDataListNavigationRequest.isEmpty || dashboardWatch.monthGraphDataListNavigationRequest.every((e) => (e.total ?? 0.0) == 0.0);

    return Container(
      height: context.height * 0.33,
      width: context.width,
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.005, vertical: context.height * 0.01),
      child: dashboardWatch.totalNavigationRequestState.isLoading || dashboardWatch.averageNavigationRequestState.isLoading
          ? CommonAnimLoader()
          : isZero
          ? Center(child: CommonEmptyStateWidget())
          : Builder(
        builder: (context) {
          return BarChart(
            BarChartData(
              maxY: dashboardWatch.maxValue + 1,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: AppColors.clrE7EAEE, strokeWidth: context.height * 0.001, dashArray: [4, 4]);
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: context.width * 0.02,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return CommonText(
                        maxLines: 2,
                        title: getLocalizedMonth(dashboardWatch.xTitlesNavigationRequests[value.toInt()]),
                        textAlign: TextAlign.center,
                        style: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.black.withValues(alpha: 0.4)),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: context.width * 0.03,
                    interval: ((dashboardWatch.maxValue + 20.0)/4).round().toDouble(),
                    getTitlesWidget: (value, meta) {
                      return CommonText(
                        title: value.toString().currencyFormShort,
                        textAlign: TextAlign.left,
                        style: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.black.withValues(alpha: 0.4)),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  fitInsideHorizontally: true,
                  tooltipPadding: EdgeInsets.symmetric(horizontal: context.width * 0.01, vertical: context.height * 0.005),
                  tooltipBorderRadius: BorderRadius.circular(5),
                  maxContentWidth: context.width * 0.2,
                  tooltipBorder: BorderSide(color: AppColors.black.withValues(alpha: 0.2)),
                  getTooltipColor: (touchedSpot) {
                    return AppColors.white;
                  },
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      (rod.toY).abs().toString().split('.').first,
                      TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                  tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                ),
                enabled: true,
              ),
              barGroups: List.generate(
                dashboardWatch.monthGraphDataListNavigationRequest.length,
                    (index) => BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: dashboardWatch.monthGraphDataListNavigationRequest.map((e) => e.total).toList()[index]?? 0.0,
                      width: context.width * 0.03,
                      borderRadius: BorderRadius.circular(3),
                      rodStackItems: [
                        BarChartRodStackItem(0, dashboardWatch.monthGraphDataListNavigationRequest.map((e) => e.failure).toList()[index] ?? 0.0, AppColors.clr55BF61),     // failed
                        BarChartRodStackItem( dashboardWatch.monthGraphDataListNavigationRequest.map((e) => e.failure).toList()[index] ?? 0.0, dashboardWatch.monthGraphDataListNavigationRequest.map((e) => e.total).toList()[index]?? 0.0, AppColors.red), // success
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

