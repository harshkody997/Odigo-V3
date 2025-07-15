import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/profile/profile_controller.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class ChangePasswordDialog extends ConsumerWidget {
  const ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileWatch = ref.watch(profileController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
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

            ///Change Password title
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

        CommonText(
          title: LocaleKeys.keyChangePasswordTitle.localized,
          style: TextStyles.regular.copyWith(color: AppColors.black),
        ),
        Spacer(),

        Form(
          key: profileWatch.changePasswordKey,
          child: Column(
            children: [
              ///Current Password Field
              CommonInputFormField(
                obscureText: !profileWatch.isShowCurrentPassword,
                textEditingController: profileWatch.oldPasswordController,
                hintText: LocaleKeys.keyCurrentPassword.localized,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  profileWatch.newPasswordFocus.requestFocus();
                },
                onChanged: (value) {
                  profileWatch.checkIfPasswordValid();
                },
                suffixWidget: InkWell(
                  onTap: () {
                    profileWatch.changeCurrentPasswordVisibility();
                  },
                  child: CommonSVG(
                    strIcon: profileWatch.isShowCurrentPassword
                        ? Assets.svgs.svgHidePasswordSvg.keyName
                        : Assets.svgs.svgShowPasswordSvg.keyName,
                  ),
                ),
                validator: (password) {
                  return validateCurrentPassword(password);
                },
              ).paddingSymmetric(vertical: context.height * 0.015),

              ///New Password Field
              CommonInputFormField(
                obscureText: !profileWatch.isShowNewPassword,
                textEditingController: profileWatch.newPasswordController,
                hintText: LocaleKeys.keyNewPassword.localized,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  profileWatch.confirmPasswordFocus.requestFocus();
                },
                focusNode: profileWatch.newPasswordFocus,
                onChanged: (value) {
                  profileWatch.checkIfPasswordValid();
                },
                validator: (password) {
                  return validateChangePassword(password);
                },
                suffixWidget: InkWell(
                  onTap: () {
                    profileWatch.changeNewPasswordVisibility();
                  },
                  child: CommonSVG(
                    strIcon: profileWatch.isShowNewPassword
                        ? Assets.svgs.svgHidePasswordSvg.keyName
                        : Assets.svgs.svgShowPasswordSvg.keyName,
                  ),
                ),
              ).paddingSymmetric(vertical: context.height * 0.015),

              ///Re Enter Password Field
              CommonInputFormField(
                obscureText: !profileWatch.isShowConfirmPassword,
                textEditingController:
                    profileWatch.confirmNewPasswordController,
                hintText: LocaleKeys.keyConfirmPassword.localized,
                textInputAction: TextInputAction.done,
                focusNode: profileWatch.confirmPasswordFocus,
                validator: (password) {
                  if (password != null &&
                      password.length > 7 &&
                      password != profileWatch.newPasswordController.text) {
                    return LocaleKeys
                        .keyConfirmPasswordMustAsPassword.localized;
                  } else {
                    return validateConfirmPassword(
                        password, profileWatch.newPasswordController.text);
                  }
                },
                onFieldSubmitted: (value) async {
                  ///Change Password Api
                  if ((profileWatch.changePasswordKey.currentState?.validate() ?? false) && context.mounted) {
                    await changePasswordApi(context,ref);
                  }
                  },
                onChanged: (value) {
                  profileWatch.checkIfPasswordValid();
                },
                suffixWidget: InkWell(
                  onTap: () {
                    profileWatch.changeConfirmPasswordVisibility();
                  },
                  child: CommonSVG(
                    strIcon: profileWatch.isShowConfirmPassword
                        ? Assets.svgs.svgHidePasswordSvg.keyName
                        : Assets.svgs.svgShowPasswordSvg.keyName,
                  ),
                ),
              ).paddingSymmetric(vertical: context.height * 0.015),

            ],
          ),
        ),
        Spacer(),

        ///Save Button
        CommonButton(
          onTap: () async {
            ///Change Password Api
            if ((profileWatch.changePasswordKey.currentState?.validate() ?? false) && context.mounted ) {
              await changePasswordApi(context,ref);
            }
          },
          isLoading: profileWatch.changePasswordState.isLoading,
          height: context.height * 0.080,
          buttonText: LocaleKeys.keySave.localized,
        ),
      ],
    ).paddingSymmetric(
      horizontal: context.width * 0.03,
      vertical: context.height * 0.03,
    );
  }


  /// Password Validation Widget
  Widget passwordValidation(TextEditingController passwordController) {
    return Column(
      children: [
        ///Length
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonSVG(
              strIcon:
                  passwordController.text.length >= 8 &&
                      passwordController.text.length <= 16
                  ? Assets.svgs.svgGreenRightArrow.keyName
                  : Assets.svgs.svgGreyDot.keyName,
              height: 12,
              width: 12,
              boxFit: BoxFit.scaleDown,
            ).paddingOnly(right: 5),
            CommonText(
              title: LocaleKeys.keyMustHaveLength.localized,
              style: TextStyles.regular.copyWith(
                fontSize: 14,
                color:
                    passwordController.text.length >= 8 &&
                        passwordController.text.length <= 16
                    ? AppColors.black
                    : AppColors.clr8D8D8D,
              ),
            ),
          ],
        ).paddingOnly(bottom: 6, top: 6),

        ///Lower case
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonSVG(
              strIcon: RegExp(r'[a-z]').hasMatch(passwordController.text)
                  ? Assets.svgs.svgGreenRightArrow.keyName
                  : Assets.svgs.svgGreyDot.keyName,
              height: 12,
              width: 12,
              boxFit: BoxFit.scaleDown,
            ).paddingOnly(right: 5),
            CommonText(
              title: LocaleKeys.keyContainLower.localized,
              style: TextStyles.regular.copyWith(
                fontSize: 14,
                color: RegExp(r'[a-z]').hasMatch(passwordController.text)
                    ? AppColors.black
                    : AppColors.clr8D8D8D,
              ),
            ),
          ],
        ).paddingOnly(bottom: 6),

        ///Upper Case
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonSVG(
              strIcon: RegExp(r'[A-Z]').hasMatch(passwordController.text)
                  ? Assets.svgs.svgGreenRightArrow.keyName
                  : Assets.svgs.svgGreyDot.keyName,
              height: 12,
              width: 12,
              boxFit: BoxFit.scaleDown,
            ).paddingOnly(right: 5),
            CommonText(
              title: LocaleKeys.keyContainUpper.localized,
              style: TextStyles.regular.copyWith(
                fontSize: 14,
                color: RegExp(r'[A-Z]').hasMatch(passwordController.text)
                    ? AppColors.black
                    : AppColors.clr8D8D8D,
              ),
            ),
          ],
        ).paddingOnly(bottom: 6),

        ///Numeric
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonSVG(
              strIcon: RegExp(r'[0-9]').hasMatch(passwordController.text)
                  ? Assets.svgs.svgGreenRightArrow.keyName
                  : Assets.svgs.svgGreyDot.keyName,
              height: 12,
              width: 12,
              boxFit: BoxFit.scaleDown,
            ).paddingOnly(right: 5),
            CommonText(
              title: LocaleKeys.keyContainNumeric.localized,
              style: TextStyles.regular.copyWith(
                fontSize: 14,
                color: RegExp(r'[0-9]').hasMatch(passwordController.text)
                    ? AppColors.black
                    : AppColors.clr8D8D8D,
              ),
            ),
          ],
        ).paddingOnly(bottom: 6),

        /// Must contain at least one special character (e.g. !@#...-)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonSVG(
              strIcon:
                  RegExp(
                    r'[!@#$%^&*(),.?":{}|<>\-]',
                  ).hasMatch(passwordController.text)
                  ? Assets.svgs.svgGreenRightArrow.keyName
                  : Assets.svgs.svgGreyDot.keyName,
              height: 12,
              width: 12,
              boxFit: BoxFit.scaleDown,
            ).paddingOnly(right: 5),
            CommonText(
              title: LocaleKeys.keyContainSpecialCharacter.localized,
              style: TextStyles.regular.copyWith(
                fontSize: 14,
                color:
                    RegExp(
                      r'[!@#$%^&*(),.?":{}|<>\-]',
                    ).hasMatch(passwordController.text)
                    ? AppColors.black
                    : AppColors.clr8D8D8D,
              ),
            ),
          ],
        ).paddingOnly(bottom: 6),
      ],
    );
  }

  ///Change password Api
  changePasswordApi(BuildContext context,WidgetRef ref) async{
    final profileWatch = ref.watch(profileController);
    ///Change password Api
    await profileWatch.changePassword(context);
    if(profileWatch.changePasswordState.success?.status==ApiEndPoints.apiStatus_200 && context.mounted){
      if(context.mounted){
        Navigator.pop(profileWatch.changePasswordKey.currentContext!);

      }
    }
  }
}
