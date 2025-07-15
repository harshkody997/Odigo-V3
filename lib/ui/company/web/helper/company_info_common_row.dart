import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

///Common Edit Information Row Tile
class CompanyInfoCommonRow extends StatelessWidget {
  const CompanyInfoCommonRow({
    super.key,
    required this.label,
    required this.value
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///label Text
        CommonText(
          title: label,
          style: TextStyles.regular.copyWith(
            color: AppColors.clr7C7474,
          ),
        ),
        Spacer(flex: 2,),

        ///value text
        Flexible(
          flex: 5,
          child: CommonText(
            title: value,
            maxLines: 4,
            textAlign: TextAlign.end,
            style: TextStyles.regular.copyWith(
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    ).paddingOnly(bottom: context.height * 0.03);
  }
}
