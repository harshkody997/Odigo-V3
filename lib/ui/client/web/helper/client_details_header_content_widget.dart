import 'package:flutter/material.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class ClientDetailsHeaderContentWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color? subTitleColor;
  final bool isExpandedSubTitle;
  final bool isUseWrap;

  ClientDetailsHeaderContentWidget(this.title, this.subTitle, {super.key, this.subTitleColor,this.isExpandedSubTitle = false,this.isUseWrap = false});

  @override
  Widget build(BuildContext context) {
    return isUseWrap ? Wrap(
      children: [
        CommonText(
          title: '${title} : ',
          style: TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 16),
        ),
        CommonText(
          title: subTitle,
          maxLines: 10,
          style: TextStyles.regular.copyWith(color: subTitleColor ?? AppColors.primary, fontSize: 16),
        ),
      ],
    ) : Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonText(
          title: '${title} : ',
          style: TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 16),
        ),
        isExpandedSubTitle ?
        Expanded(
          child: CommonText(
            title: subTitle,
            maxLines: 10,
            style: TextStyles.regular.copyWith(color: subTitleColor ?? AppColors.primary, fontSize: 16),
          ),
        ) :    
        CommonText(
          title: subTitle,
          maxLines: 10,
          style: TextStyles.regular.copyWith(color: subTitleColor ?? AppColors.primary, fontSize: 16),
        ),
      ],
    );
  }
}
