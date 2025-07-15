import 'package:collection/collection.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/utils/anim/custom_animation_controller.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AdsCountBarGraph extends ConsumerStatefulWidget {

  const AdsCountBarGraph({Key? key}) : super(key: key);

  @override
  ConsumerState<AdsCountBarGraph> createState() => _AdsCountBarGraphState();
}

class _AdsCountBarGraphState extends ConsumerState<AdsCountBarGraph> with TickerProviderStateMixin {
  List<AnimationController> barGraphAnimationControllerList = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final customAnimationWatch = ref.watch(customAnimationController);
      final dashBoardWatch = ref.watch(dashboardController);

      barGraphAnimationControllerList = List.generate(
        dashBoardWatch.adsCountMonthGraphDataList.length,
            (index) => AnimationController(vsync: this, duration: const Duration(milliseconds: 150)),
      );      customAnimationWatch.notifyListeners();
      await Future.delayed(const Duration(milliseconds: 200));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardWatch = ref.watch(dashboardController);
    final graphDataList = dashboardWatch.adsCountMonthGraphDataList;

    final isAllZeroOrNull = graphDataList.every((value) => (value) == 0.0);

    return Container(
      height: context.height * 0.33,
      width: context.width,
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.005, vertical: context.height * 0.01),
      child: dashboardWatch.adsCountState.isLoading
          ? CommonAnimLoader()
          : graphDataList.isEmpty || isAllZeroOrNull
          ? Center(child: CommonEmptyStateWidget())
          : Builder(
        builder: (context) {
          return BarChart(
            BarChartData(
              maxY: dashboardWatch.adsCountState.isLoading
                  ? 16000
                  : graphDataList.map((e) => e).toList().max + 100,
              gridData: FlGridData(
                show: true,
                horizontalInterval: dashboardWatch.adsCountState.isLoading
                    ? 100
                    : ((graphDataList.map((e) => e).toList().max + 100) / 4).roundToDouble(),
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.clrE7EAEE,
                    strokeWidth: context.height * 0.001,
                    dashArray: [4, 4],
                  );
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
                        title: getLocalizedMonth(dashboardWatch.xTitlesAdsCountRequests[value.toInt()]),
                        textAlign: TextAlign.center,
                        style: TextStyles.regular.copyWith(
                          fontSize: 12,
                          color: AppColors.black.withValues(alpha: 0.4),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: context.width * 0.03,
                    interval: dashboardWatch.adsCountState.isLoading
                        ? 100
                        : ((graphDataList.map((e) => e).toList().max + 100) / 4).roundToDouble(),
                    getTitlesWidget: (value, meta) {
                      return CommonText(
                        title: '${value.abs().toStringAsFixed(0)} ',
                        textAlign: TextAlign.left,
                        style: TextStyles.regular.copyWith(
                          fontSize: 12,
                          color: AppColors.black.withValues(alpha: 0.4),
                        ),
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
                  tooltipPadding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.01,
                    vertical: context.height * 0.005,
                  ),
                  tooltipBorderRadius: BorderRadius.circular(5),
                  maxContentWidth: context.width * 0.2,
                  tooltipBorder: BorderSide(color: AppColors.black.withValues(alpha: 0.2)),
                  getTooltipColor: (touchedSpot) => AppColors.white,
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
              barGroups: getDataStatic(),
            ),
          );
        },
      ),
    );
  }


  List<BarChartGroupData> getDataStatic() {
    final dashboard = ref.watch(dashboardController);
    final graphDataList = dashboard.adsCountMonthGraphDataList;

    return List.generate(graphDataList.length, (index) {
      final data = graphDataList[index];
      final animationValue = index < barGraphAnimationControllerList.length
          ? barGraphAnimationControllerList[index].value
          : 1.0;

      return BarChartGroupData(
        x: index,
        barsSpace: 4,
        groupVertically: false,
        barRods: [
          BarChartRodData(
            toY: data * animationValue,
            width: context.width * 0.027,
            borderRadius: BorderRadius.circular(3),
            gradient: LinearGradient(
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
