import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardHeaderTile extends StatelessWidget {
  final String title;
  final String? count;
  final String? active;
  final String? inActive;
  final String asset;

  const CommonDashboardHeaderTile({super.key, required this.title, required this.count, required this.active, required this.inActive, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CommonDashboardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      title: title.localized,
                      style: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.clr101010),
                    ),
                    CommonText(
                      title: count ?? '-',
                      style: TextStyles.semiBold.copyWith(fontSize: 22, color: AppColors.clr101010),
                    ),
                  ],
                ),
                Spacer(),
                CommonSVG(strIcon: asset),
              ],
            ),
            SizedBox(height: context.height * 0.02,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteF7F7FC,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: context.width * 0.01, vertical: context.height * 0.007),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          title: LocaleKeys.keyActive.localized,
                          style: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.clrA3AED0),
                        ),
                        CommonText(
                          title: active ?? '-',
                          style: TextStyles.semiBold.copyWith(color: AppColors.clr10B99A),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: context.width * 0.01,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.whiteF7F7FC,
                        borderRadius: BorderRadius.circular(6)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: context.width * 0.01, vertical: context.height * 0.007),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          title: LocaleKeys.keyInActive.localized,
                          style: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.clrA3AED0),
                        ),
                        CommonText(
                          title: inActive ?? '-',
                          style: TextStyles.semiBold.copyWith(color: AppColors.errorColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
