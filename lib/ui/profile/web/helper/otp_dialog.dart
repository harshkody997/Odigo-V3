
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/profile/profile_controller.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/routing/delegate.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ChangeEmailOrPhoneVerifyOtpDialog extends ConsumerWidget {
  final bool isEmail;
  ChangeEmailOrPhoneVerifyOtpDialog({super.key, required this.isEmail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileWatch = ref.watch(profileController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ///Crossed Icon
            InkWell(
              onTap: () {
                profileWatch.counter?.cancel();
                profileWatch.changeEmailOrMobileOtpController.clear();
                Navigator.pop(context);
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgLeftArrow.keyName,
                height: context.height * 0.020,
                width: context.height * 0.020,
              ),
            ),
            SizedBox(width: context.width * 0.01,),
            ///Otp title
            CommonText(
              title: LocaleKeys.keyVerifyYourCode.localized,
              style: TextStyles.bold.copyWith(
                fontSize: 24,
                color: AppColors.black,
              ),
            ),
          ],
        ),


        SizedBox(height: context.height * 0.01,),

        ///We have sent a code to your Email Id or Mobile Number
        RichText(
          text: TextSpan(
            text:
                '${LocaleKeys.keyWeHaveSentYourCode.localized}  ${isEmail == true ? LocaleKeys.keyEmailId.localized : LocaleKeys.keyMobileNumber.localized} ',
            style: TextStyles.regular.copyWith(
              color: AppColors.black,
            ),
            children: [
              TextSpan(
                text: isEmail == true
                    ? profileWatch.newEmailController.text
                    : profileWatch.newMobileController.text,
                style: TextStyles.semiBold.copyWith(
                  color: AppColors.black,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.black,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: context.height * 0.030),

        /// OTP Text Field
        Form(
          key: profileWatch.emailVerifyOtpKey,
          child: PinCodeTextField(
            appContext: context,
            autoDisposeControllers: false,
            cursorColor: AppColors.black171717,
            length: 6,
            hintCharacter: '-',
            hintStyle: TextStyles.regular.copyWith(
          color: AppColors.clrB0A9A9,
          ),
            onSubmitted: (value) async {
              if(profileWatch.emailVerifyOtpKey.currentState?.validate() ?? false){
                ///Update email api
                await updateEmailApi(context, ref);
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) {
              return validateOtp(value);
            },
            controller: profileWatch.changeEmailOrMobileOtpController,
            keyboardType: TextInputType.number,
            onChanged: (code) {
              profileWatch.checkIfOtpValid();
            },
            textStyle: TextStyles.regular.copyWith(color: AppColors.black),
            onCompleted: (String? code) {},
            pinTheme: PinTheme(
              borderRadius: BorderRadius.circular(10),
              shape: PinCodeFieldShape.box,
              fieldWidth: context.height * 0.1,
              fieldHeight: context.height * 0.1,
              activeColor: AppColors.whiteEAEAEA,
              inactiveColor: AppColors.whiteEAEAEA,
              selectedColor: AppColors.whiteEAEAEA,
              fieldOuterPadding: EdgeInsets.zero,
              activeBorderWidth: 1,
              selectedBorderWidth: 1,
              inactiveBorderWidth: 1,
            ),
          ),
        ),
        SizedBox(height: context.height * 0.020),
        ///Submit OTP Button
        CommonButton(
          onTap: () async {

            if(profileWatch.emailVerifyOtpKey.currentState?.validate() ?? false){
              ///Update email api
              await updateEmailApi(context, ref);
            }

          },
            isLoading: profileWatch.updateEmailState.isLoading,
          height: context.height * 0.080,
          buttonText: LocaleKeys.keySubmit.localized,
          // isButtonEnabled: profileWatch.isEmailVerifyOtpValid,
        ),
        SizedBox(height: context.height * 0.020),

        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Resend OTP Button
              InkWell(
                onTap: () async {
                  if (profileWatch.counterSeconds == 0) {
                    profileWatch.startCounter();
                    profileWatch.changeEmailOrMobileOtpController.clear();

                    ///Send OTP Api
                    await profileWatch.sendOtpApi(
                      context,
                      email: profileWatch.newEmailController.text,
                    );
                  }

                },
                child: CommonText(
                  title:
                      '${(profileWatch.counterSeconds == 0) ? LocaleKeys.keyResendCode.localized : 'OTP Expire in '} ${(profileWatch.counterSeconds == 0) ? '' : profileWatch.getCounterSeconds()}',
                  style: TextStyles.regular.copyWith(
                    color: (profileWatch.counterSeconds == 0)
                        ? AppColors.black
                        : AppColors.clr33333380,
                    decorationColor: (profileWatch.counterSeconds == 0)
                        ? AppColors.black
                        : AppColors.clr33333380,
                  ),
                ),
              ),

            ],
          ),
        ),

      ],
    ).paddingSymmetric(vertical: context.height * 0.05, horizontal: context.height * 0.06);
  }

  ///Update Email Api
  updateEmailApi(BuildContext context, WidgetRef ref) async {
    final profileWatch = ref.watch(profileController);

    ///Update Email Api
    await profileWatch
        .updateEmailApi(
          context: context,
          isEmail: true,
          email: profileWatch.newEmailController.text,
          otp: profileWatch.changeEmailOrMobileOtpController.text,
          password: profileWatch.emailPasswordController.text,
        )
        .then((value) {
          if (profileWatch.updateEmailState.success?.status == ApiEndPoints.apiStatus_200) {
            {
              Navigator.pop(profileWatch.changeEmailDialogKey.currentContext!);
              Navigator.pop(profileWatch.sendOtpDialogKey.currentContext!);

              showSuccessDialogue(
                  width: context.width * 0.4,
                  height: context.height * 0.65,
                  context:context,
                  dismissble: false,
                  animation: Assets.anim.animSucess.keyName,
                  successMessage: isEmail ? LocaleKeys.keyEmailChangedSuccessfully.localized : LocaleKeys.keyMobileChangedSuccessfully.localized,
                  successDescription: isEmail ? LocaleKeys.keyYourEmailAddressHasBeenUpdated.localized : LocaleKeys.keyYourMobileNumberHasBeenUpdated.localized,
                  buttonText: LocaleKeys.keyBack.localized,
                  onTap: () async {
                    Navigator.pop(globalNavigatorKey.currentContext!);
                    await profileWatch.getProfileDetail(context, ref);

                  }
              );

            }
          }
        });
  }
}
