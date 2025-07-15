import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class PurchaseSuccessfulDialog extends ConsumerWidget {
  const PurchaseSuccessfulDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),

        ///Animation
        Lottie.asset(
          Assets.anim.animSucess.keyName,
          height: context.height * 0.25,
          width: context.width * 0.25,
          repeat: true,
        ),

        Spacer(),

        ///Title
        CommonText(
          title: LocaleKeys.keyPurchaseSuccessful.localized,
          style: TextStyles.semiBold.copyWith(
              fontSize: 22
          ),
        ),

        SizedBox(height: context.height*0.020),

        ///Description
        CommonText(
          title: LocaleKeys.keyYourAdHasBeenSuccessfullyPurchased.localized,
          style: TextStyles.regular.copyWith(
              fontSize: 16
          ),
        ),
        Spacer(),

       /* ///Button
        CommonButton(
          buttonText: LocaleKeys.keyBackToDashboard.localized,
          onTap: (){
            Navigator.pop(context);
          },
        )*/
      ],
    ).paddingAll(context.height*0.035);
  }


}
