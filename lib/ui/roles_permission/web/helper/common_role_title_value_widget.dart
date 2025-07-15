import 'package:flutter/material.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonRoleTitleValueWidget extends StatelessWidget {
  final String title;
  final String value;
  const CommonRoleTitleValueWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonText(title: '$title: ',clrFont: AppColors.clr7C7474,fontSize: 14,),
        CommonText(title: value,clrFont: AppColors.black,fontSize: 14,),
      ],
    );
  }
}
