import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/line_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardAvgTimeStoreBarGraph extends ConsumerStatefulWidget {
  final List<LineGraphData> barGraphData;

  const CommonDashboardAvgTimeStoreBarGraph({super.key, required this.barGraphData});

  @override
  ConsumerState<CommonDashboardAvgTimeStoreBarGraph> createState() => _CommonDashboardAvgTimeStoreBarGraphState();
}

class _CommonDashboardAvgTimeStoreBarGraphState extends ConsumerState<CommonDashboardAvgTimeStoreBarGraph> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    final dashboardWatch = ref.watch(dashboardController);
    return Container(
      height: context.height * 0.33,
      width: context.width,
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.005, vertical: context.height * 0.01),
      child: dashboardWatch.adsCountState.isLoading
          ? CommonAnimLoader()
          : dashboardWatch.adsCountMonthGraphDataList.isEmpty
          ? Center(child: CommonEmptyStateWidget())
          : Builder(
              builder: (context) {
                return BarChart(
                  BarChartData(
                    maxY: widget.barGraphData.map((e) => double.parse(e.total?.grandTotal ?? '0')).reduce((a, b) => a > b ? a : b) + 10,
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
                            final index = value.toInt();
                            final month = DateFormat('MMM').format(DateFormat('MM-yyyy').parse(widget.barGraphData[index].date ?? '01-1950'));
                            return CommonText(
                              maxLines: 2,
                              title: month,
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
                          interval: (widget.barGraphData.map((e) => double.tryParse(e.total?.grandTotal ?? '') ?? 0).reduce((a, b) => a > b ? a : b) / 4),
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
                      widget.barGraphData.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: double.parse(widget.barGraphData[index].total?.grandTotal ?? '0'),
                            width: context.width * 0.03,
                            borderRadius: BorderRadius.circular(3),
                            // rodStackItems: [],
                            gradient:
                            // LinearGradient(
                            //   begin: Alignment.centerLeft,
                            //   end: Alignment.centerRight,
                            //   colors: [
                            //     Colors.white.withValues(alpha: 0.0),
                            //     AppColors.black838383
                            //   ],
                            // ),
                            LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.blueAccent, // or Colors.blueAccent
                                Colors.white.withOpacity(0.0), // lighter transparent shade or Colors.white.withOpacity(0.0)
                              ],
                            ),
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
