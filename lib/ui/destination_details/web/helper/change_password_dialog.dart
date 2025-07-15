import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
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

class ChangeDestinationPasswordDialog extends ConsumerStatefulWidget {
  const ChangeDestinationPasswordDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangeDestinationPasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangeDestinationPasswordDialog>{



  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final destinationDetailsWatch = ref.read(destinationDetailsController);
      destinationDetailsWatch.clearFormData();
    });
    super.initState();
  }
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final destinationDetailsWatch = ref.watch(destinationDetailsController);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            ///Back Icon
            InkWell(
              onTap: () {
                destinationDetailsWatch.clearFormData();
                Navigator.pop(context);
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgLeftArrow.keyName,
                height: context.height * 0.020,
                width: context.height * 0.020,
              ),
            ),
            SizedBox(width: context.width * 0.01),

            ///Change Email title
            CommonText(
              title: LocaleKeys.keyChangePassword.localized,
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
          title: LocaleKeys.keyChangePasswordTitle.localized,
          style: TextStyles.regular.copyWith(color: AppColors.black),
        ),
        const Spacer(),

        ///Form
        Form(
          key: destinationDetailsWatch.changePasswordKey,
          child: Column(
            children: [
              CommonInputFormField(
                obscureText: !destinationDetailsWatch.isShowNewPassword,
                textEditingController: destinationDetailsWatch.newPasswordController,
                maxLength: 16,
                hintText: LocaleKeys.keyNewPassword.localized,
                textInputAction: TextInputAction.next,
                focusNode: destinationDetailsWatch.newPasswordFocus,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(regExpBlocEmoji),
                  FilteringTextInputFormatter.deny(RegExp('[ ]')),
                ],
                validator: (password) {
                  return validateNewPassword(password);
                },
                onChanged: (password) {
                },
                suffixWidget: InkWell(
                  onTap: () {
                    destinationDetailsWatch.changePasswordVisibility();
                  },
                  child: CommonSVG(
                    height: context.width * 0.024,
                    width: context.width * 0.024,
                    strIcon: destinationDetailsWatch.isShowNewPassword
                        ? Assets.svgs.svgHidePasswordSvg_.keyName
                        : Assets.svgs.svgShowPasswordSvg_.keyName,
                  ),
                ),
              ),
              SizedBox(height: context.height * 0.025),

              CommonInputFormField(
                obscureText: !destinationDetailsWatch.isShowConfirmPassword,
                textEditingController: destinationDetailsWatch.confirmPasswordController,
                maxLength: 16,
                hintText: LocaleKeys.keyConfirmPassword.localized,
                textInputAction: TextInputAction.next,
                focusNode: destinationDetailsWatch.confirmPasswordFocus,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(regExpBlocEmoji),
                  FilteringTextInputFormatter.deny(RegExp('[ ]')),
                ],
                validator: (password) {
                  return validateConfirmPassword(
                      password, destinationDetailsWatch.newPasswordController.text);
                },
                onChanged: (password) {
                },
                suffixWidget: InkWell(
                  onTap: () {
                    destinationDetailsWatch.changeConfirmPasswordVisibility();
                  },
                  child: CommonSVG(
                    height: context.width * 0.024,
                    width: context.width * 0.024,
                    strIcon: destinationDetailsWatch.isShowConfirmPassword
                        ? Assets.svgs.svgHidePasswordSvg_.keyName
                        : Assets.svgs.svgShowPasswordSvg_.keyName,
                  ),
                ),
              ),


            ],
          ),
        ),
        const Spacer(),

        ///Change Password
        CommonButton(
          onTap: () async {
            if(destinationDetailsWatch.changePasswordKey.currentState?.validate() ?? false) {
              await destinationDetailsWatch.updateDestinationPasscodeApi(context, destinationDetailsWatch.currentDestinationUuid ?? '',).then((value) {
                if(value.success?.status == ApiEndPoints.apiStatus_200){
                  Navigator.pop(destinationDetailsWatch.changePasswordKey.currentContext!);
                }
              },);
            }
          },
          isLoading: destinationDetailsWatch.updateDestinationPasscodeApiState.isLoading,
          width: context.width,
          height: context.height * 0.080,
          buttonText: LocaleKeys.keyChangePassword.localized,
          // isButtonEnabled: profileWatch.isEmailFieldsValid,
        ),
      ],
    ).paddingSymmetric(
      horizontal: context.height * 0.050,
      vertical: context.height * 0.030,
    );
  }
}