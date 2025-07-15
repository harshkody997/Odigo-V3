import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/auth/forgot_password_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
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
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';


class ForgotPasswordForm extends ConsumerWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalKey<FormState> globalKey = GlobalKey();

    final forgotPasswordWatch = ref.watch(forgotPasswordController);

    return SingleChildScrollView(
      child: Form(
        key: globalKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    ref.read(navigationStackController).pop();
                  },
                  child: CommonSVG(
                    strIcon: Assets.svgs.svgBackArrow.path,
                    height: 11,
                    width: 11,
                  ),
                ),
                CommonText(
                  title: LocaleKeys.keyForgetPassword.localized,
                  style: TextStyles.bold.copyWith(fontSize: 24),
                ).paddingOnly(left: 12),
              ],
            ),
            SizedBox(height: context.height * 0.015),
            CommonText(
              title: LocaleKeys.keyForgotPasswordMsg.localized,
              style: TextStyles.regular.copyWith(fontSize: 16),
              maxLines: 2,
            ),
            SizedBox(height: context.height * 0.034),
            CommonInputFormField(
              textEditingController: forgotPasswordWatch.emailController,
              borderRadius: BorderRadius.circular(11),
              onChanged: (val) {},
              backgroundColor: AppColors.white,
              onFieldSubmitted: (value) {
                bool isValid = globalKey.currentState?.validate() ?? false;
                if (isValid) {
                  _forgotPasswordApiCall(context, ref);
                }
              },
              textInputFormatter: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              textInputAction: TextInputAction.done,
              fieldTextStyle: TextStyles.regular.copyWith(
                fontSize: 14,
                color: AppColors.black272727,
              ),
              hintText: LocaleKeys.keyEmailid.localized,
              hintTextStyle: TextStyles.regular.copyWith(
                fontSize: 14,
                color: AppColors.grey8D8C8C,
              ),
              validator: (email) => validateEmail(email),
            ),
            SizedBox(height: context.height * 0.036),
            CommonButton(
              height: context.height * 0.077,
              borderRadius: BorderRadius.circular(9),
              buttonTextStyle: TextStyles.regular.copyWith(
                fontSize: 16,
                color: AppColors.white,
              ),
              buttonText: LocaleKeys.keyGetOtp.localized,
              isLoading: forgotPasswordWatch.forgotPasswordState.isLoading,
              onTap: () async {
                bool isValid = globalKey.currentState?.validate() ?? false;
                if (isValid) {
                  _forgotPasswordApiCall(context, ref);
                }
              },
              onValidateTap: () {
                globalKey.currentState?.validate();
              },
            ),
            SizedBox(height: context.height * 0.036),
            Row(
              children: [
                CommonText(
                  title: LocaleKeys.keyIRememberMyPassword.localized,
                  style: TextStyles.regular.copyWith(fontSize: 16),
                ),
                SizedBox(width: context.width * 0.005),
                InkWell(
                  onTap: () {
                    ref.read(navigationStackController).pop();
                  },
                  child: CommonText(
                    title: LocaleKeys.keyLogIN.localized,
                    style: TextStyles.bold.copyWith(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      color: AppColors.black333333,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }

  void _forgotPasswordApiCall(BuildContext context, WidgetRef ref) {
    final forgotPasswordWatch = ref.watch(forgotPasswordController);
    forgotPasswordWatch.forgotPasswordApi(context).then(
          (value) {
        if (forgotPasswordWatch.forgotPasswordState.success?.status ==
            ApiEndPoints.apiStatus_200) {
          ref.read(navigationStackController).push( NavigationStackItem.otpVerification(email: forgotPasswordWatch.emailController.text));
        }
      },
    );
  }





}

