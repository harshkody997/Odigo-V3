

import 'package:odigov3/framework/utils/session.dart';

import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class TableHeaderTextWidget extends StatelessWidget{
  final String text;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  const TableHeaderTextWidget({super.key, required this.text,this.textAlign,this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      color: Colors.transparent,
      child: CommonText(
        title: text,
        textAlign: textAlign ?? (/*Session.isRTL ? TextAlign.right : */ TextAlign.left),
        // textAlign: textAlign ?? TextAlign.left,
        maxLines: 2,
        style:textStyle?? TextStyles.regular.copyWith(fontSize: 12, color: AppColors.grey8D8C8C),
      ),
    );
  }
}
