import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonUserDetailsRowWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const CommonUserDetailsRowWidget({super.key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(title: title ?? '', clrFont: AppColors.clr7C7474, fontSize: 16).paddingOnly(right: context.width * 0.05),
        Flexible(child: CommonText(title: subTitle ?? '', fontSize: 16, maxLines: 3,)),
      ],
    );
  }
}
