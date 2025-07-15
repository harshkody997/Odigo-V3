import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonEmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? strIcon;
  const CommonEmptyStateWidget({super.key,this.title,this.strIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        CommonSVG(
          strIcon: strIcon?? Assets.svgs.svgCmsEmptyState.keyName,
        ).paddingOnly(bottom: 15),
        CommonText(
          title: title??LocaleKeys.keyNoDataFound.localized,
          style: TextStyles.medium.copyWith(
            color: AppColors.black,
            fontSize: 14,
          ),
        ),
      ]
    );
  }
}
