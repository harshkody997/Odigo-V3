import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class EditFloorNameDialog extends StatelessWidget {
  final String uuid;

  const EditFloorNameDialog({super.key, required this.uuid});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final destinationDetailsWatch = ref.watch(destinationDetailsController);
        return Form(
          key: destinationDetailsWatch.editFloorNameFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// title
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CommonSVG(strIcon: Assets.svgs.svgBackButtonWithoutBg.keyName).paddingOnly(right: 10),
                  ),
                  CommonText(
                    title: LocaleKeys.keyEditFloorName.localized,
                    style: TextStyles.bold.copyWith(fontSize: 20),
                  ),
                ],
              ).paddingOnly(bottom: context.height * 0.025),

              /// form field
              CommonInputFormField(
                textEditingController: destinationDetailsWatch.floorNameController,
                hintText: LocaleKeys.keyFloorName.localized,
                fieldTextStyle: TextStyles.regular.copyWith(fontSize: 14, color: AppColors.black272727),
                maxLength: maxLength50,
                placeholderText: LocaleKeys.keyFloorName.localized,
                validator: (value) {
                  return validateTextIgnoreLength(value, LocaleKeys.keyFloorNameShouldBeRequired.localized);
                },
              ).paddingOnly(bottom: context.height * 0.025),

              /// save button
              CommonButton(
                buttonText: LocaleKeys.keySave.localized,
                borderRadius: BorderRadius.circular(6),
                // isLoading: destinationDetailsWatch.updateDefaultAdsNameApiState.isLoading || destinationDetailsWatch.updateClientAdsNameApiState.isLoading,
                // isShowLoader: destinationDetailsWatch.updateDefaultAdsNameApiState.isLoading || destinationDetailsWatch.updateClientAdsNameApiState.isLoading,
                onTap: () async {
                  final bool? result = destinationDetailsWatch.editFloorNameFormKey.currentState?.validate();
                  if (result == true) {

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.03),
        );
      },
    );
  }
}
