import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class DeviceDetailsCommonTileWidgetWeb extends StatelessWidget {
  final String title;
  final String value;
  const DeviceDetailsCommonTileWidgetWeb({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: CommonText(
            title: title,
            style: TextStyles.regular.copyWith(
              fontSize: 15,
              color:  AppColors.clr7C7474,
            ),
          ),
        ),
        const Spacer(flex: 1,),
        Expanded(
          flex: 3,
          child:CommonText(
            title: value,
            style: TextStyles.regular.copyWith(
              fontSize: 15,
              color:  AppColors.black,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
