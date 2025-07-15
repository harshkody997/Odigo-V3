import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/auth/otp_verification_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class OtpCounterForm extends ConsumerWidget {
  String? email;
   OtpCounterForm({super.key,this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpVerificationWatch = ref.watch(otpVerificationController);

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonText(
          title: '${LocaleKeys.keyOTPExpireMsg.localized} ${otpVerificationWatch.getCounterSeconds()}',
          style: TextStyles.regular.copyWith(fontSize: 16,color: AppColors.grayB0A9A9),
          maxLines: 2,
        ),
        SizedBox(height: context.height * 0.024),
        Visibility(
          visible: otpVerificationWatch.counterSeconds==0,
          child: RichText(
            text: TextSpan(
              text: LocaleKeys.keyCodeMsg.localized,
              style: TextStyles.regular.copyWith(
                fontSize: 16,
                color: AppColors.black,
                // decoration: TextDecoration.underline,
                // decorationColor: AppColors.black,
              ),
              children: [
                TextSpan(
                  text: LocaleKeys.keyResendTheCode.localized,
                  style: TextStyles.medium.copyWith(
                    fontSize: 16,
                    color: AppColors.black,
                    decoration: TextDecoration.underline,
                    // decoration: TextDecoration.underline,
                    // decorationColor: AppColors.primary2,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (otpVerificationWatch.counterSeconds == 0) {
                        otpVerificationWatch.counter?.cancel();
                        otpVerificationWatch.startCounter();
                        otpVerificationWatch.otpController.clear();
                        _resendOtpApiCall(context,ref);
                      }



                      // ref.read(navigationStackController).pop();
                    },
                ),
              ],
            ),
          ),
        ),

      ],
    );

  }

  /// resend Otp Api Call
  void _resendOtpApiCall(BuildContext context, WidgetRef ref) {
    final otpVerificationWatch = ref.watch(otpVerificationController);
    otpVerificationWatch.resendOtpApi(context, email??'').then((value) {
      if (otpVerificationWatch.counterSeconds == 0) {
        otpVerificationWatch.startCounter();
      }
      otpVerificationWatch.otpController.clear();

    },);
  }






}

