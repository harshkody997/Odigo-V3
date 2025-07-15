import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/profile/profile_controller.dart';
import 'package:odigov3/framework/provider/network/network.dart';
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

class ChangeMobileDialog extends ConsumerStatefulWidget {
  const ChangeMobileDialog({super.key});

  @override
  ConsumerState<ChangeMobileDialog> createState() => _ChangeMobileDialogState();
}

class _ChangeMobileDialogState extends ConsumerState<ChangeMobileDialog> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final profileWatch = ref.watch(profileController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ///Change Mobile Title
        Row(
          children: [
            ///Back Icon
            InkWell(
              onTap: () {
                profileWatch.clearFormData();
                profileWatch.disposeKeys();
                Navigator.pop(context);
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgLeftArrow.keyName,
                height: context.height * 0.020,
                width: context.height * 0.020,
              ),
            ),
            SizedBox(width: context.width * 0.01),

            ///Change Mobile title
            CommonText(
              title: LocaleKeys.keyEditContact.localized,
              style: TextStyles.bold.copyWith(
                fontSize: 24,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: context.height * 0.01),
        ///email description
        CommonText(
          title: LocaleKeys.keyEditContactTitle.localized,
          maxLines: 2,
          style: TextStyles.regular.copyWith(color: AppColors.black),
        ),

        const Spacer(),

        ///Mobile Number Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: profileWatch.changeMobileKey,
              child: CommonInputFormField(
                textEditingController: profileWatch.newMobileController,
                hintText: LocaleKeys.keyNewMobile.localized,
                textInputAction: TextInputAction.next,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(regExpBlocEmoji),
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(maxMobileLength),
                ],
                onFieldSubmitted: (value) async {
                  if ((profileWatch.changeMobileKey.currentState?.validate() ?? false) && context.mounted) {
                    await changeContactNumberApi(context,ref);
                  }                    },
                onChanged: (value) {
                  profileWatch.validateNewMobile();
                },
                validator: (value) {
                  return validateMobile(value);
                },
              ),
            ),
          ],
        ),
        const Spacer(),

        ///Change Submit Button
        CommonButton(
          onTap: () async {

              if ((profileWatch.changeMobileKey.currentState?.validate() ?? false) && context.mounted) {
                await changeContactNumberApi(context,ref);
              }
          },
          height: context.height * 0.080,
          isLoading: profileWatch.changeContactNumberState.isLoading,
          buttonText: LocaleKeys.keySave.localized,
          // isButtonEnabled: profileWatch.isNewMobileValid,
        ),
      ],
    ).paddingSymmetric(
      horizontal: context.height * 0.050,
      vertical: context.height * 0.030,
    );
  }

  ///Change Name Api
  changeContactNumberApi(BuildContext context,WidgetRef ref) async{
    final profileWatch = ref.watch(profileController);
    ///Change Contact number Api
    await profileWatch.changeContactNumber(context);
    if(profileWatch.changeContactNumberState.success?.status==ApiEndPoints.apiStatus_200 && context.mounted){
      if(context.mounted){
        Navigator.pop(profileWatch.changeMobileKey.currentContext!);
        ///Success Dialog
        profileWatch.getProfileDetail(context, ref);
      }
    }
  }
}
