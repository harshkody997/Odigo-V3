import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/controller/purchase/add_purchase_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class WeekAmountGraph extends ConsumerWidget {
  const WeekAmountGraph({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addPurchaseWatch = ref.watch(addPurchaseController);
    final clientDetailsWatch = ref.watch(clientDetailsController);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: context.height * 0.1, horizontal: context.width* 0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(context.width * 0.2, context.width * 0.2),
                painter: DonutPainter(
                  sections: [
                    DonutSection(
                      color1: AppColors.clr185A96,
                      color2: AppColors.clr2997FC,
                      value: addPurchaseWatch.finalPurchaseAmount.toDouble(),
                    ),
                    DonutSection(
                      color1: AppColors.clrFFD8D8,
                      color2: AppColors.clrFFC9C9,
                      value: addPurchaseWatch.discountAmount,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  CommonText(
                    title: LocaleKeys.keyTotalValue.localized,
                    style: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.black),
                  ),
                  SizedBox(height: 4),
                  CommonText(
                    title: '${clientDetailsWatch.clientDetailsState.success?.data?.countryCurrency ?? AppConstants.currency} ${(addPurchaseWatch.totalAmount).toInt()}',
                    style: TextStyles.bold.copyWith(
                      fontSize: 22,
                      color: AppColors.black,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          _commonRow(
            ref,
            color: AppColors.clr2997FC,
            label: LocaleKeys.keyPurchaseAmount.localized,
            value: addPurchaseWatch.finalPurchaseAmount.toString(),
          ),
          SizedBox(height: 8),
          _commonRow(
            ref,
            color: AppColors.clrFFD8D8,
            label: LocaleKeys.keyDiscountAmount.localized,
            value: addPurchaseWatch.discountAmount.toString(),
          ),
          SizedBox(height: 8),
          _commonRow(
            ref,
            color: AppColors.white,
            label: LocaleKeys.keyWeeklyAmount.localized,
            value: addPurchaseWatch.weeklyAmount.toString(),
          ),
        ],
      ),
    );
  }

  Widget _commonRow(WidgetRef ref, {
    required Color color,
    required String label,
    required String value,
  }) {
    final clientDetailsWatch = ref.watch(clientDetailsController);
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 14)),
        Spacer(),
        Text('${clientDetailsWatch.clientDetailsState.success?.data?.countryCurrency ?? AppConstants.currency} ${value}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class DonutSection {
  final Color color1;
  final Color color2;
  final double value;

  DonutSection({required this.color1, required this.color2, required this.value});
}

class DonutPainter extends CustomPainter {
  final List<DonutSection> sections;

  DonutPainter({required this.sections});

  @override
  void paint(Canvas canvas, Size size) {
    final total = sections.fold(0.0, (sum, item) => sum + item.value);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = size.width * 0.07;

    // If both values are 0 — draw full grey donut
    if (total == 0) {
      final paint = Paint()
        ..color = Colors.grey.shade300
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        0,
        2 * pi,
        false,
        paint,
      );
      return;
    }

    var startAngle = -pi / 2;

    for (var section in sections) {
      if (section.value == 0) continue;

      final sweepAngle = (section.value / total) * 2 * pi;

      final gradient = SweepGradient(
        startAngle: 0,
        endAngle: sweepAngle,
        tileMode: TileMode.clamp,
        colors: [
          section.color1,
          section.color2,
          section.color1,
        ],
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: radius),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}