import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

String getInitials(String text) {
  String initials = '';
  for (int i = 0; i < text.length; i++) {
    if (i == 0 || text[i - 1] == ' ' && initials.length < 3) {
      initials += text[i];
    }
  }
  return initials;
}

class CommonInitialTextWidget extends StatelessWidget  {
  final String text;
  final double? fontSize;
  final Color? containerColor;
  final TextStyle? textStyle;
  final double? height;
  final double? width;

  const CommonInitialTextWidget({
    super.key,
    required this.text,
    this.fontSize,
    this.containerColor,
    this.height,
    this.width,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    String name = getInitials(text);
    return Container(
      height: 95,
      width: 95,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: containerColor??AppColors.black,
      ),
      child: Center(
        child: CommonText(
          title: name.toUpperCase(),
          style: textStyle ?? TextStyles.medium.copyWith(
              fontSize: fontSize??24,
              color: AppColors.white
          ),
        ),
      ),
    );
  }
}