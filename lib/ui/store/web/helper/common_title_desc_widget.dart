import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

Widget commonTitleAndDesc(BuildContext context, {required String title,required String subtitle, double? titleFont, double? subtitleFont, TextStyle? style}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CommonText(title: title,style: TextStyles.regular.copyWith(fontSize: titleFont ?? 14, color: AppColors.grey8F8F8F),maxLines: 4,).paddingOnly(bottom: context.height * 0.010),
      CommonText(title: subtitle,style: style??TextStyles.regular.copyWith(fontSize: subtitleFont ?? 16),maxLines: 4,)
    ],
  ).paddingOnly(right: context.width * 0.01);
}
