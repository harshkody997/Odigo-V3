import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonTableHeaderWidget extends StatelessWidget {
  final String headerText;
  final TextAlign? textAlign;
  const CommonTableHeaderWidget({super.key, required this.headerText,this.textAlign});

  @override
  Widget build(BuildContext context) {
    return CommonText(
      title: headerText,
      style: TextStyles.medium.copyWith(
        fontSize: 12,
        color: AppColors.clr667085,
      ),
      textAlign: textAlign??(Session.isRTL ? TextAlign.right : TextAlign.left),
      maxLines: 3,
    );
  }
}

