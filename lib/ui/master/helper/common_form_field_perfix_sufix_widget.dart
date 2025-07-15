import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonFormFieldPrefixSuffixWidget extends StatelessWidget {
  final bool isRTL;
  final String languageName;
  const CommonFormFieldPrefixSuffixWidget({super.key, this.isRTL = false, required this.languageName});

  @override
  Widget build(BuildContext context) {
    double padding = context.width * 0.01;
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          border: isRTL ? Border(
            right: BorderSide(
              color:  AppColors.clrE7EAEE ,
            ),
          ):Border(
            left: BorderSide(
              color:  AppColors.clrE7EAEE ,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: CommonText(
          title: languageName,
          clrFont: AppColors.clr8B8B8B,
          fontSize: 14,
        ).paddingOnly(left: padding),
      ),
    );
  }
}
