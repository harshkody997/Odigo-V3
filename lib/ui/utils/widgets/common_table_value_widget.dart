import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonTableValueWidget extends StatelessWidget {
  final String valueText;
  final TextAlign? textAlign;
  const CommonTableValueWidget({super.key, required this.valueText, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return CommonText(
      title: valueText,
      style: TextStyles.regular.copyWith(
        fontSize: 13,
        color: AppColors.black,
      ),
      textAlign: textAlign??(Session.isRTL ? TextAlign.right : TextAlign.left),
      maxLines: 3,
    );
  }
}
