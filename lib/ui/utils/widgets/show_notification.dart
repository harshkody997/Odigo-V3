import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class ShowNotification extends StatelessWidget {
  final String? notificationTitle;
  final String? notificationBody;
  final Function() onCloseTap;
  const ShowNotification({super.key, this.notificationTitle, this.notificationBody, required this.onCloseTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(10),
          ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CommonSVG(
              strIcon: Assets.svgs.svgForegroundNotificationIcon.keyName,
            height: 30,
            width: 30,
          ).paddingOnly(right: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  title: notificationTitle??'',
                  style: TextStyles.medium.copyWith(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ).paddingOnly(bottom: 5 ),
                CommonText(
                  title: notificationBody??'',
                  style: TextStyles.regular.copyWith(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                  maxLines: 10,
                )
              ],
            ).paddingOnly(right: 20),
          ),
          InkWell(
            onTap: onCloseTap,
            child:  CommonSVG(
              height: 30,
              width: 30,
              strIcon: Assets.svgs.svgCrossRounded.keyName,
            ),
          ),
        ],
      ),
    );
  }
}
