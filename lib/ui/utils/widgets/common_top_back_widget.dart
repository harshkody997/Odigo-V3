import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonBackTopWidget extends StatelessWidget {
  final String title;
  final Function() onTap;

  const CommonBackTopWidget({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: CommonSVG(
            isRotate: true,
            strIcon: Assets.svgs.svgLeftArrow.keyName,
            height: context.height * 0.025,
            width: context.height * 0.025,
          ).paddingOnly(right: context.width*0.02),
        ),
        CommonText(
          title: title,
          style: TextStyles.regular.copyWith(
            color: AppColors.black,
            fontSize: 20,
          ),
        )
      ],
    );
  }



}
