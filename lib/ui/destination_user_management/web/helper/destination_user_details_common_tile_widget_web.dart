import 'package:flutter/material.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class DestinationUserDetailsCommonTileWidgetWeb extends StatelessWidget {
  final String title;
  final String value;
  const DestinationUserDetailsCommonTileWidgetWeb({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: CommonText(
            title: title,
            style: TextStyles.regular.copyWith(
              fontSize: 14,
              color:  AppColors.clr7C7474,
            ),
          ),
        ),
        const Spacer(flex: 1,),
        Expanded(
            flex: 3,
            child:Align(
              alignment: Alignment.centerRight,
              child: CommonText(
                title: value,
                style: TextStyles.regular.copyWith(
                  fontSize: 14,
                  color:  AppColors.black,
                ),
                maxLines: 5,
              ),
            )
        ),
      ],
    );
  }
}