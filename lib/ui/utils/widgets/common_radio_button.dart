
import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonRadioButton<T> extends StatelessWidget {
  const CommonRadioButton({
    super.key,
    required this.groupValue,
    this.value,
    required this.onTap,
    this.title,
    this.borderRequired,
    this.textStyle,
  });

  final T? groupValue;
  final T? value;
  final String? title;
  final bool? borderRequired;
  final GestureTapCallback? onTap;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: borderRequired??true?BoxDecoration(
          border: Border.all(
            color: value!=null?
            value == groupValue
                ? AppColors.primary2
                : AppColors.clrE5E7EB
            :groupValue as bool?AppColors.primary2
            : AppColors.clrE5E7EB,
          ),
          borderRadius: BorderRadius.circular(8),
        ):null,
        child: Row(
          mainAxisAlignment: title?.isNotEmpty??false?MainAxisAlignment.spaceBetween:MainAxisAlignment.start,
          children: [
            CommonText(
              title: title??'',
              style: textStyle??TextStyles.regular.copyWith(
                fontSize: 14,
                color: AppColors.clr101828,
              ),
            ),
            CommonSVG(
              strIcon: value!=null?
              value == groupValue
                  ? Assets.svgs.svgRadioSelected.keyName
                  : Assets.svgs.svgRadioUnselected.keyName
                  :groupValue as bool?Assets.svgs.svgRadioSelected.keyName
                  : Assets.svgs.svgRadioUnselected.keyName,
            ),
          ],
        ).paddingSymmetric(
          horizontal: borderRequired??false? context.width * 0.010:0,
          vertical: borderRequired??false?context.height * 0.010:0,
        ),
      ),
    );
  }
}

/// ---- USAGE 1----///
/*  CommonRadioButton<CommonEnumTitleValueModel>(
    value: status,
    title: status.title,
    borderRequired: true,
    groupValue: deviceWatch.tempSelectedStatus,
    onTap: () {
          deviceWatch.changeTempSelectedStatus(status);
    },
)*/

/*  CommonRadioButton(
    title: status.title,
    borderRequired: true,
    groupValue: deviceWatch.tempSelectedStatus == list[index].status,
    onTap: () {
          deviceWatch.changeTempSelectedStatus(status);
    },
)*/