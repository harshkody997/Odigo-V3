import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonAddEditDialog extends StatelessWidget {
  final String title;
  final Widget dialogWidget;
  final String? buttonName;
  final GestureTapCallback? onButtonTap;
  const CommonAddEditDialog({super.key, required this.dialogWidget, required this.title, this.buttonName, this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      child: Container(
        width: context.width * 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  title: title,
                  fontSize: 20,
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: CommonSVG(
                    strIcon: Assets.svgs.svgCloseRoundedDialog.keyName,
                  ),
                )
              ],
            ),

            dialogWidget,

            CommonButton(
              width: context.width * 0.09,
              height: context.height * 0.06,
              fontSize: 12,
              buttonText: buttonName ?? "Save",
              backgroundColor: AppColors.blue009AF1,
              onTap: onButtonTap
            )

          ],
        ).paddingSymmetric(horizontal: context.width * 0.02,vertical: context.height * 0.03),
      ),
    );
  }
}
