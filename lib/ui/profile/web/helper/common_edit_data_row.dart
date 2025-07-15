import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

///Common Edit Information Row Tile
class CommonEditDataRow extends StatelessWidget {
  const CommonEditDataRow({
    super.key,
    required this.label,
    required this.value,
    required this.buttonText,
    required this.onButtonTap,
  });

  final String label;
  final String value;
  final String buttonText;
  final void Function()? onButtonTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ///label Text
        CommonText(
          title: label,
          style: TextStyles.regular.copyWith(
            fontSize: 16,
            color: AppColors.clr7C7474,
          ),
        ),
        Row(
          children: [
            ///Value text
            CommonText(
              title: value,
              style: TextStyles.regular.copyWith(
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
            SizedBox(width: context.width * 0.015),

            ///edit button
            InkWell(
              onTap: onButtonTap,
              child: Container(
                height: context.height * 0.06,
                decoration: BoxDecoration(
                  color: AppColors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: AppColors.greyD0D5DD),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText(
                      title: buttonText,
                      style: TextStyles.medium.copyWith(
                        fontSize: 14,
                        color: AppColors.black,
                      ),
                    )
                  ],
                ).paddingSymmetric(horizontal: 15),
              ),
            ),

          ],
        ),
      ],
    ).paddingSymmetric(vertical: context.height * 0.025);
  }
}
