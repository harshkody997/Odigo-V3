import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

///Common  Information Tile
class DetailsRowWidget extends StatelessWidget {
  const DetailsRowWidget({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ///Label
        CommonText(
          title: label,
          style: TextStyles.regular.copyWith(
            color: AppColors.black,
            fontSize: 12,
          ),
        ),

        ///Label
        CommonText(
          title: value,
          style: TextStyles.medium.copyWith(
            color: AppColors.black,
            fontSize: 12,
          ),
        ),
      ],
    ).paddingSymmetric(
      horizontal: context.width * 0.014,
      vertical: context.height * 0.016,
    );
  }
}
