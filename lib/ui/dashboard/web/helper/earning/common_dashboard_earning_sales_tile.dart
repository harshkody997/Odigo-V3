import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardEarningSalesTile extends StatelessWidget {
  final String title;
  final Color color;
  final String amount;
  final String sales;

  const CommonDashboardEarningSalesTile({super.key, required this.title, required this.color, required this.amount, required this.sales});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: context.width * 0.002,
              height: context.height * 0.015,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: color),
            ),
            SizedBox(width: context.width * 0.002),
            CommonText(
              title: title,
              style: TextStyles.medium.copyWith(color: AppColors.clr878787, fontSize: 13),
            ),
          ],
        ),
        CommonText(
          title: '\$$amount',
          style: TextStyles.semiBold.copyWith(color: AppColors.clr080808, fontSize: 25),
        ),
        Row(
          children: [
            CommonText(
              title: sales,
              style: TextStyles.semiBold.copyWith(color: AppColors.clr878787, fontSize: 13),
            ),
            SizedBox(width: context.width * 0.002),
            CommonText(
              title: LocaleKeys.keyTotalSales.localized.toLowerCase(),
              style: TextStyles.medium.copyWith(color: AppColors.clr878787, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}
