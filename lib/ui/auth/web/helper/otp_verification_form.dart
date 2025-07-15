import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/auth/forgot_password_controller.dart';
import 'package:odigov3/framework/controller/auth/otp_verification_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/auth/web/helper/otp_counter_form.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class OtpVerificationForm extends ConsumerWidget {
  String? email;
   OtpVerificationForm({super.key,this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    GlobalKey<FormState> globalKey = GlobalKey();

    return  Form(
      key: globalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              InkWell(
                onTap: ()
                {
                  ref.read(navigationStackController).pop();
                },
                child: CommonSVG(
                  strIcon: Assets.svgs.svgBackArrow.path,
                  height: 11,
                  width: 11,
                ),
              ),

              CommonText(
                title: LocaleKeys.keyVerifyYourCode.localized,
                style: TextStyles.bold.copyWith(fontSize: 24),
              ).paddingOnly(left: 12),
            ],
          ),
          SizedBox(height: context.height * 0.022),
          CommonText(
            title: LocaleKeys.keyVerifyMsg.localized,
            style: TextStyles.regular.copyWith(fontSize: 16),
            maxLines: 2,
          ),
          SizedBox(height: context.height * 0.024),

          Consumer(
            builder: (context,ref,child) {
              final otpVerificationWatch = ref.watch(otpVerificationController);
              return
              Column(children: [
                PinCodeTextField(
                appContext: context,
                autoDisposeControllers: false,
                hintCharacter: '-',
                autoFocus: true,
                hintStyle:  TextStyles.regular.copyWith(
                  color: AppColors.grayB0A9A9,
                  fontSize: 12,
                ),
                cursorColor: AppColors.black,
                length: AppConstants.otpLength,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                validator: (value) {
                  return validateOtp(value);
                },

                textInputAction: TextInputAction.done,
                controller: otpVerificationWatch.otpController,
                keyboardType: TextInputType.number,
                onChanged: (code) {

                },
                textStyle: TextStyles.regular.copyWith(
                  color: AppColors.black272727,
                  fontSize: 14,
                ),
                onSubmitted: (value) {

                  bool isValid = globalKey.currentState?.validate() ?? false;
                  if (isValid) {
                    otpVerificationApi(context,ref,email??'');
                    return;
                  }
                },
                onCompleted: (String? code) {
                  otpVerificationWatch.checkIfAllFieldsValid();
                },
                pinTheme: PinTheme(
                  borderRadius: BorderRadius.circular(9),
                  shape: PinCodeFieldShape.box,
                  activeColor: AppColors.whiteEAEAEA,
                  inactiveColor: AppColors.whiteEAEAEA,
                  selectedColor: AppColors.whiteEAEAEA,
                  activeFillColor: AppColors.whiteEAEAEA,
                  inactiveFillColor: AppColors.whiteEAEAEA,
                  fieldHeight: 58,
                  fieldWidth: 58,
                  selectedBorderWidth: 1,
                  inactiveBorderWidth: 1,
                ),
              ),
                SizedBox(height: context.height * 0.024),
                CommonButton(
                  height: context.height * 0.077,
                  borderRadius: BorderRadius.circular(9),
                  isLoading: otpVerificationWatch.otpVerifyState.isLoading,
                  buttonTextStyle: TextStyles.regular.copyWith(
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                  buttonText: LocaleKeys.keySubmit.localized,
                  onTap: () {

                    bool isValid = globalKey.currentState?.validate() ?? false;
                    if (isValid) {
                      otpVerificationApi(context,ref,email??'');

                      return;
                    }
                  },
                ),
              ],);

            }
          ),

          SizedBox(height: context.height * 0.024),
          OtpCounterForm(email: email,)
        ],
      ),
    );




  }


  otpVerificationApi(BuildContext context, WidgetRef ref,String email) async {
    final otpVerificationWatch = ref.watch(otpVerificationController);
    final forgotWatch = ref.watch(forgotPasswordController);
    await otpVerificationWatch.otpVerifyApi(context,forgotWatch.emailController.text).then((value) async {
      if (otpVerificationWatch.otpVerifyState.success?.status == ApiEndPoints.apiStatus_200) {

        ref.read(navigationStackController).pushRemove(NavigationStackItem.resetPassword(email: email,otp: otpVerificationWatch.otpController.text));

      }
    },
    );
  }



}

