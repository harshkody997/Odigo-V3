import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardInteractionBarGraph extends ConsumerStatefulWidget {
  const CommonDashboardInteractionBarGraph({super.key});

  @override
  ConsumerState<CommonDashboardInteractionBarGraph> createState() => _CommonDashboardInteractionBarGraphState();
}

class _CommonDashboardInteractionBarGraphState extends ConsumerState<CommonDashboardInteractionBarGraph> with TickerProviderStateMixin {
  List<AnimationController> barGraphAnimationControllerList = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final dashboard = ref.read(dashboardController);

      final dataLength = dashboard.interactionsAverageMonthGraphDataList.length;

      barGraphAnimationControllerList = List.generate(
        dataLength,
            (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 150)),
      );

      await Future.delayed(const Duration(milliseconds: 200));
    });
  }


  @override
  Widget build(BuildContext context) {
    final dashboardWatch = ref.watch(dashboardController);
    final graphDataList = dashboardWatch.interactionsAverageMonthGraphDataList;
    final isAllZeroOrNull = graphDataList.every((e) => (e.count ?? 0.0) == 0.0);
    return Container(
      height: context.height * 0.33,
      width: context.width,
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.005, vertical: context.height * 0.01),
      child: dashboardWatch.interactionsTotalState.isLoading || dashboardWatch.interactionsAverageState.isLoading
          ? CommonAnimLoader()
          : graphDataList.isEmpty || isAllZeroOrNull
          ? Center(child: CommonEmptyStateWidget())
          : Builder(
              builder: (context) {
                return BarChart(
                  BarChartData(
                    maxY: dashboardWatch.maxInteractionsValue + 1,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: ((dashboardWatch.maxInteractionsValue + 20.0) / 4).roundToDouble(),
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
                            final index = value.toInt();
                            final labels = dashboardWatch.xTitlesInteractionRequests;
                            return CommonText(
                              maxLines: 2,
                              title: (index >= 0 && index < labels.length) ? getLocalizedMonth(labels[index]) : '',
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
                          interval: ((dashboardWatch.maxInteractionsValue + 20.0) / 4).roundToDouble(),                          getTitlesWidget: (value, meta) {
                            return CommonText(
                              title: value.toStringAsFixed(0),
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
                            rod.toY.abs().toStringAsFixed(4),
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
                    barGroups: getDataStatic(),
                  ),
                );
              },
            ),
    );
  }

  List<BarChartGroupData> getDataStatic() {
    final dashboard = ref.watch(dashboardController);
    final graphDataList = dashboard.interactionsAverageMonthGraphDataList;

    return List.generate(graphDataList.length, (index) {
      final data = graphDataList[index];

      return BarChartGroupData(
        x: index,
        barsSpace: 4,
        groupVertically: false,
        barRods: [
          BarChartRodData(
            toY:  (data.count ?? 0.0),
            width: context.width * 0.027,
            borderRadius: BorderRadius.circular(3),
            // rodStackItems: [],
            gradient:
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blueAccent,
                Colors.white.withAlpha(0),
              ],
            ),
          ),
        ],
      );
    });
  }
}
