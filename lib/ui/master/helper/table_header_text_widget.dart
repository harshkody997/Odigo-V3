import 'package:flutter/cupertino.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class TableHeaderTextWidget extends StatelessWidget {
  final text;
  const TableHeaderTextWidget({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return CommonText(
      title: text,
      fontSize: 12,
      clrFont: AppColors.grey8D8C8C,
    );
  }
}
