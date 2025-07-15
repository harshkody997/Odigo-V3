import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/repository/dashboard/model/line_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonSalesLineChart extends ConsumerStatefulWidget {
  final List<LineGraphData> lineGraphData;

  const CommonSalesLineChart({super.key, required this.lineGraphData});

  @override
  ConsumerState<CommonSalesLineChart> createState() => _CommonSalesLineChartState();
}

class _CommonSalesLineChartState extends ConsumerState<CommonSalesLineChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.33,
      width: context.width,
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.005, vertical: context.height * 0.01),
      child: widget.lineGraphData.isEmpty || (widget.lineGraphData.map((e) => double.tryParse(e.total?.grandTotal ?? '') ?? 0).reduce((a, b) => a > b ? a : b)) == 0
          ? /*Empty State here*/ Offstage()
          : Builder(
              builder: (context) {
                return LineChart(
                  LineChartData(
                    minY: 0,
                    lineTouchData: LineTouchData(
                      enabled: true,

                      touchTooltipData: LineTouchTooltipData(
                        // fitInsideVertically: true,
                        fitInsideHorizontally: true,
                        tooltipPadding: EdgeInsets.symmetric(horizontal: context.width * 0.01, vertical: context.height * 0.005),
                        tooltipBorderRadius: BorderRadius.circular(5),
                        maxContentWidth: context.width * 0.2,
                        tooltipBorder: BorderSide(color: AppColors.black.withValues(alpha: 0.2)),
                        getTooltipColor: (touchedSpot) {
                          return AppColors.white;
                        },
                        getTooltipItems: (touchedSpots) {
                          return List.generate(touchedSpots.length, (index) {
                            try {
                              final subrange = widget.lineGraphData[touchedSpots[index].spotIndex].total;
                              if (subrange == null) return null;
                              final date = DateFormat('MM-yyyy').parse('${widget.lineGraphData[touchedSpots[index].spotIndex].date}');
                              String subrangeLabel = DateFormat('MMMM yyyy').format(date);
                              return LineTooltipItem(
                                '$subrangeLabel\n\n',
                                TextStyles.semiBold.copyWith(color: AppColors.black, fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: 'Sub Total            ',
                                    style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: '${subrange.subtotal?.currencyForm ?? '0'}\n',
                                    style: TextStyles.semiBold.copyWith(color: AppColors.black, fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: 'Round Total       ',
                                    style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: '${subrange.roundtotal?.currencyForm ?? '0'}\n',
                                    style: TextStyles.semiBold.copyWith(color: AppColors.black, fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: 'Grand Total       ',
                                    style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: subrange.grandTotal?.currencyForm ?? '0',
                                    style: TextStyles.semiBold.copyWith(color: AppColors.black, fontSize: 14),
                                  ),
                                ],
                                textAlign: TextAlign.justify,
                              );
                            } catch (e) {
                              return null;
                            }
                          });
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        barWidth: 2,
                        curveSmoothness: 0.3,
                        dotData: const FlDotData(show: false),
                        color: AppColors.clr2997FC,
                        spots: List.generate(widget.lineGraphData.length, (i) {
                          return FlSpot(i.toDouble(), (double.tryParse(widget.lineGraphData[i].total?.grandTotal ?? '') ?? 0));
                        }),
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [AppColors.clr2997FC.withValues(alpha: 0.01), AppColors.clr2997FC.withValues(alpha: 0.24)],
                          ),
                        ),
                      ),
                    ],
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
                            final month = DateFormat('MMM').format(DateFormat('MM-yyyy').parse(widget.lineGraphData[index].date ?? '01-1950'));
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
                          interval: (widget.lineGraphData.map((e) => double.tryParse(e.total?.grandTotal ?? '') ?? 0).reduce((a, b) => a > b ? a : b) / 4),
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
                  ),
                );
              },
            ),
    );
  }
}
