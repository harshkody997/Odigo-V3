import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/profile/profile_controller.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/profile/web/helper/otp_dialog.dart';
import 'package:odigov3/ui/routing/delegate.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class ChangeEmailDialog extends ConsumerStatefulWidget {
  const ChangeEmailDialog({super.key});

  @override
  ConsumerState<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends ConsumerState<ChangeEmailDialog> {
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

            ///Change Email title
            CommonText(
              title: LocaleKeys.keyChangeEmail.localized,
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
          title: LocaleKeys.keyChangeEmailTitle.localized,
          style: TextStyles.regular.copyWith(color: AppColors.black),
        ),
        const Spacer(),

        ///Form
        Form(
          key: profileWatch.changeEmailKey,
          child: Column(
            children: [
              ///New Email Field
              CommonInputFormField(
                textEditingController: profileWatch.newEmailController,
                hintText: LocaleKeys.keyEnterNewEmailId.localized,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                   profileWatch.passwordFocus.requestFocus();
                },
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(regExpBlocEmoji),
                  FilteringTextInputFormatter.deny(
                    RegExp(r'\s'),
                  ), // Deny any spaces
                  LowerCaseTextFormatter(),
                ],
                maxLength: maxEmailLength,
                onChanged: (value) {
                  profileWatch.checkIfEmailValid();
                },
                validator: (value) {
                  return validateEmail(value);
                },
              ),

              SizedBox(height: context.height * 0.025),

              ///Current Password Field
              CommonInputFormField(
                obscureText: !profileWatch.isShowNewPassword,
                textEditingController: profileWatch.emailPasswordController,
                maxLength: 16,
                hintText: LocaleKeys.keyCurrentPassword.localized,
                textInputAction: TextInputAction.next,
                focusNode: profileWatch.passwordFocus,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(regExpBlocEmoji),
                  FilteringTextInputFormatter.deny(RegExp('[ ]')),
                ],
                onFieldSubmitted: (value) async {
                  if(profileWatch.changeEmailKey.currentState?.validate() ?? false) {

                    if (context.mounted) {
                      ///Send Otp
                      if(profileWatch.profileDetailState.success?.data?.email == profileWatch.newEmailController.text) {
                        showErrorDialogue(
                          context: globalNavigatorKey.currentContext!,
                          dismissble: true,
                          buttonText: LocaleKeys.keyOk.localized,
                          onTap: ()
                          {
                            Navigator.pop(globalNavigatorKey.currentContext!);
                          },
                          animation: Assets.anim.animErrorJson.keyName,
                          successMessage: LocaleKeys.keyNewMobileAndConfirmEmail.localized,
                        );
                      }else{
                        await sendOTPApi(context, ref);
                      }
                    }
                  }
                },
                validator: (password) {
                  return validateCurrentPassword(password);
                },
                onChanged: (password) {
                  profileWatch.checkIfEmailValid();
                },
                suffixWidget: InkWell(
                  onTap: () {
                    profileWatch.changePasswordVisibility();
                  },
                  child: CommonSVG(
                    height: context.width * 0.024,
                    width: context.width * 0.024,
                    strIcon: profileWatch.isShowNewPassword
                        ? Assets.svgs.svgHidePasswordSvg.keyName
                        : Assets.svgs.svgShowPasswordSvg.keyName,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),

        ///Change Email
        CommonButton(
          onTap: () async {
             if(profileWatch.changeEmailKey.currentState?.validate() ?? false) {

            if (context.mounted) {
              ///Send Otp
              if(profileWatch.profileDetailState.success?.data?.email == profileWatch.newEmailController.text) {
                //  showCommonErrorDialogNew(context: context, message: LocaleKeys.keyNewMobileAndConfirmEmail.localized);
                showErrorDialogue(
                  context: globalNavigatorKey.currentContext!,
                  dismissble: true,
                  buttonText: LocaleKeys.keyOk.localized,
                  onTap: ()
                  {
                    Navigator.pop(globalNavigatorKey.currentContext!);
                  },
                  animation: Assets.anim.animErrorJson.keyName,
                  successMessage: LocaleKeys.keyNewMobileAndConfirmEmail.localized,
                );
              }else{
                await sendOTPApi(context, ref);
              }
            }
            }

          },
          isLoading: profileWatch.checkPasswordState.isLoading || profileWatch.sendOtpState.isLoading ,
          width: context.width,
          height: context.height * 0.080,
          buttonText: LocaleKeys.keyGetOTP.localized,
          // isButtonEnabled: profileWatch.isEmailFieldsValid,
        ),
      ],
    ).paddingSymmetric(
      horizontal: context.height * 0.050,
      vertical: context.height * 0.030,
    );
  }

  ///Send Otp
  sendOTPApi(BuildContext context,WidgetRef ref) async{
    final profileWatch = ref.watch(profileController);

    ///Check Password Api
    await profileWatch.checkPassword(context, profileWatch.emailPasswordController.text);
    if (profileWatch.checkPasswordState.success?.status == ApiEndPoints.apiStatus_200 && context.mounted) {

      ///Send Otp Api
      await profileWatch.sendOtpApi(context,email: profileWatch.newEmailController.text);
      if(profileWatch.sendOtpState.success?.status==ApiEndPoints.apiStatus_200){
        profileWatch.startCounter();
        if (context.mounted) {
          profileWatch.changeEmailOrMobileOtpController.clear();
          ///show otp dialog
          showCommonWebDialog(
            context: context,
            keyBadge: profileWatch.sendOtpDialogKey,
            height: 0.57,
            width: 0.4,
            dialogBody: ChangeEmailOrPhoneVerifyOtpDialog(
              isEmail: true,
            ).paddingSymmetric(horizontal: 0.03, vertical: 0.03),
          );
        }
      }
    }
  }
}
