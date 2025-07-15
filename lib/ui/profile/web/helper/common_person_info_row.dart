import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

///Common Personal Information Tile
class CommonPersonalInfoRow extends StatelessWidget {
  const CommonPersonalInfoRow({
    super.key,
    required this.svgAsset,
    required this.label,
    required this.value,
  });

  final String svgAsset;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.clrF4F7FE,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blueBACFFF),
      ),
      child:
          Row(
            children: [
              ///Assets
              CommonSVG(
                strIcon: svgAsset,
                width: context.width * 0.03,
                height: context.width * 0.03,
              ),
              SizedBox(width: context.width * 0.01),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Label
                    CommonText(
                      title: label,
                      style: TextStyles.medium.copyWith(
                        color: AppColors.gray667085,
                        fontSize: 12,
                      ),
                    ),

                    ///value
                    CommonText(
                      title: value,
                      style: TextStyles.regular.copyWith(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ).paddingSymmetric(
            horizontal: context.width * 0.01,
            vertical: context.height * 0.018,
          ),
    );
  }
}
