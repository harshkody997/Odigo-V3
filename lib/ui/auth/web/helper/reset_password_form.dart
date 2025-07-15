import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/auth/reset_password_controller.dart';
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
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';


class ResetPasswordForm extends ConsumerWidget {
  String? email;
  String? otp;
   ResetPasswordForm({super.key,this.email,this.otp});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resetPasswordWatch = ref.watch(resetPasswordController);
    GlobalKey<FormState> globalKey = GlobalKey();

    return
      Form(
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
                  title: LocaleKeys.keyCreateNewPassword.localized,
                  style: TextStyles.bold.copyWith(fontSize: 24),
                ).paddingOnly(left: 12),
              ],
            ),
            SizedBox(height: context.height * 0.022),
            CommonText(
              title: LocaleKeys.keyCreateNewPasswordMSG.localized,
              style: TextStyles.regular.copyWith(fontSize: 16),
              maxLines: 2,
            ),

            SizedBox(height: context.height * 0.034),
            CommonInputFormField(
              textEditingController: resetPasswordWatch.newPasswordController,
              borderRadius: BorderRadius.circular(11),
              backgroundColor: AppColors.white,
              focusNode: resetPasswordWatch.newPasswordFocus,
              onFieldSubmitted: (value) {
               resetPasswordWatch.confirmPasswordFocus.requestFocus();
              },
              hintTextStyle: TextStyles.regular.copyWith(
                fontSize: 14,
                color: AppColors.grey8D8C8C,
              ),

              textInputAction: TextInputAction.next,
              fieldTextStyle: TextStyles.regular.copyWith(
                fontSize: 14,
                color: AppColors.black272727,
              ),
              hintText: LocaleKeys.keyNewPassword.localized,
              validator: (password) {
                return validateNewPassword(password);
              },
            ),
            SizedBox(height: context.height * 0.032),
            CommonInputFormField(
              textEditingController: resetPasswordWatch.confirmPasswordController,
              focusNode: resetPasswordWatch.confirmPasswordFocus,
              borderRadius: BorderRadius.circular(11),
              backgroundColor: AppColors.white,
              onFieldSubmitted: (value) {
                bool isValid = globalKey.currentState?.validate() ?? false;
                if (isValid) {
                  resetPasswordApi(context,ref,email,otp);
                }
              },
              hintTextStyle: TextStyles.regular.copyWith(
                fontSize: 14,
                color: AppColors.grey8D8C8C,
              ),

              textInputAction: TextInputAction.next,
              fieldTextStyle: TextStyles.regular.copyWith(
                fontSize: 14,
                color: AppColors.black272727,
              ),
              hintText: LocaleKeys.keyConfirmPassword.localized,
              validator: (password) {
                if (password != null &&
                    password.length > 7 &&
                    password != resetPasswordWatch.newPasswordController.text) {
                  return LocaleKeys
                      .keyConfirmPasswordMustAsPassword.localized;
                } else {
                  return validateConfirmPassword(
                      password, resetPasswordWatch.newPasswordController.text);
                }
              },
            ),
            SizedBox(height: context.height * 0.036),

            CommonButton(
              height: context.height * 0.077,
              borderRadius: BorderRadius.circular(9),
              isLoading: resetPasswordWatch.resetPasswordState.isLoading,
              buttonTextStyle: TextStyles.regular.copyWith(
                fontSize: 16,
                color: AppColors.white,
              ),
              buttonText: LocaleKeys.keyChangePassword.localized,
              onTap: () {
                bool isValid = globalKey.currentState?.validate() ?? false;
                if (isValid) {

                  resetPasswordApi(context,ref,email,otp);



                }
              },
            ),
          ],
        ),
      );
  }



  void resetPasswordApi(BuildContext context, WidgetRef ref,String? email, String? otp) {
    final resetPasswordWatch = ref.watch(resetPasswordController);
    resetPasswordWatch.resetPasswordApi(context,email,otp).then(
          (value) {
        if (resetPasswordWatch.resetPasswordState.success?.status ==
            ApiEndPoints.apiStatus_200) {
          showSuccessDialogue(
              width: context.width * 0.4,
              height: context.height * 0.55,
              context:context,
              dismissble: true,
              animation: Assets.anim.animSucess.keyName,
              successMessage:
              LocaleKeys.keyPasswordChangedSuccessfully.localized,
              successDescription:
              LocaleKeys.keyLoginYourAcc.localized,
              buttonText: LocaleKeys.keyBackToLogin.localized,
              onTap: (){
                ref.read(navigationStackController).pushAndRemoveAll(NavigationStackItem.login());

              }
          );
        }
      },
    );
  }




}

