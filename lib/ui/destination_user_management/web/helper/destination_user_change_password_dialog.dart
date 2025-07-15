import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_details_controller.dart';
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
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class DestinationUserChangePasswordDialog extends ConsumerStatefulWidget {
  const DestinationUserChangePasswordDialog({super.key});

  @override
  ConsumerState<DestinationUserChangePasswordDialog> createState() => _DestinationUserChangePasswordDialogState();
}

class _DestinationUserChangePasswordDialogState extends ConsumerState<DestinationUserChangePasswordDialog> {

  @override
  void initState() {
    final destinationDetailsRead = ref.read(destinationUserDetailsController);
    destinationDetailsRead.clearFormData();
    super.initState();
  }
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final  destinationDetailsWatch= ref.watch(destinationUserDetailsController);

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
            ).paddingOnly(right: 10),

            ///Change Email title
            CommonText(
              title: LocaleKeys.keyChangePassword.localized,
              style: TextStyles.bold.copyWith(
                fontSize: 22,
                color: AppColors.black,
              ),
            ),
          ],
        ).paddingOnly(bottom: 10),

        ///Password description
        CommonText(
          title: LocaleKeys.keyChangePasswordTitleForDestinationUser.localized,
          style: TextStyles.regular.copyWith(color: AppColors.black),
          maxLines: 2,
        ),
        const Spacer(),

        ///Form
        Form(
          key: destinationDetailsWatch.formKey,
          child: Column(
            children: [

              /// New password
              CommonInputFormField(
                obscureText: !destinationDetailsWatch.isShowNewPassword,
                textEditingController: destinationDetailsWatch.newPasswordController,
                maxLength: AppConstants.maxPasswordLength,
                hintText: LocaleKeys.keyNewPassword.localized,
                textInputAction: TextInputAction.next,
                focusNode: destinationDetailsWatch.newPasswordFocus,
                onFieldSubmitted: (val){
                  destinationDetailsWatch.confirmPasswordFocus.requestFocus();
                },
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
                    strIcon: (!destinationDetailsWatch.isShowNewPassword)
                        ? Assets.svgs.svgShowPasswordSvg_.keyName
                        : Assets.svgs.svgHidePasswordSvg_.keyName,
                  ),
                ),
              ).paddingOnly(bottom: 20),

              /// Confirm password
              CommonInputFormField(
                obscureText: !destinationDetailsWatch.isShowConfirmPassword,
                textEditingController: destinationDetailsWatch.confirmPasswordController,
                maxLength: AppConstants.maxPasswordLength,
                hintText: LocaleKeys.keyConfirmPassword.localized,
                textInputAction: TextInputAction.next,
                focusNode: destinationDetailsWatch.confirmPasswordFocus,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(regExpBlocEmoji),
                  FilteringTextInputFormatter.deny(RegExp('[ ]')),
                ],
                validator: (password) {
                  return validateConfirmPassword(password, destinationDetailsWatch.newPasswordController.text);
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
                    strIcon: (!destinationDetailsWatch.isShowConfirmPassword)
                        ? Assets.svgs.svgShowPasswordSvg_.keyName
                        : Assets.svgs.svgHidePasswordSvg_.keyName,
                  ),
                ),
                onFieldSubmitted: (val) async{
                  if(destinationDetailsWatch.formKey.currentState?.validate() ?? false) {
                    /// Api call
                    await destinationDetailsWatch.updateDestinationUserPasswordApi().then((value) {
                      if(destinationDetailsWatch.updateUserPasswordState.success?.status == ApiEndPoints.apiStatus_200){
                        /// Success toast
                        showToast(context: context,isSuccess:true,message: LocaleKeys.keyChangedPasswordSuccessfully.localized);

                        /// Close dialog
                        Navigator.pop(destinationDetailsWatch.changePasswordDialogKey.currentContext!);
                      }
                    },);
                  }
                },
              ),
            ],
          ),
        ),
        const Spacer(),

        ///Change Password
        CommonButton(
          onTap: () async {
            if(destinationDetailsWatch.formKey.currentState?.validate() ?? false) {
              /// Api call
              await destinationDetailsWatch.updateDestinationUserPasswordApi().then((value) {
                if(destinationDetailsWatch.updateUserPasswordState.success?.status == ApiEndPoints.apiStatus_200){
                  /// Success toast
                  showToast(context: context,isSuccess:true,message: LocaleKeys.keyChangedPasswordSuccessfully.localized);
                  /// Close dialog
                  Navigator.pop(destinationDetailsWatch.changePasswordDialogKey.currentContext!);
                }
              },);
            }
          },
          isLoading: destinationDetailsWatch.updateUserPasswordState.isLoading,
          width: context.width,
          height: 48,
          buttonText: LocaleKeys.keyChangePassword.localized,
        ),
      ],
    ).paddingAll(20);
  }
}

