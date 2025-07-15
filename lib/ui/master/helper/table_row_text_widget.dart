import 'package:flutter/cupertino.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class TableRowTextWidget extends StatelessWidget {
  final text;
  const TableRowTextWidget({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return CommonText(
      title: text,
      fontSize: 12,
      clrFont: AppColors.black,
    );
  }
}
