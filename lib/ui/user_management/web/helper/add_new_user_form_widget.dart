import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/users_management/add_new_user_controller.dart';
import 'package:odigov3/framework/controller/users_management/user_management_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AddNewUserFormWidget extends ConsumerWidget {
  final BuildContext mainContext;
  final String? userUuid;

  const AddNewUserFormWidget({super.key, this.userUuid, required this.mainContext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addNewUserWatch = ref.watch(addNewUserController);
    return Form(
      key: addNewUserWatch.addNewUserFormKey,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(title: LocaleKeys.keyAddNewUser.localized, fontWeight: TextStyles.fwSemiBold),
              SizedBox(height: 25),
              Column(
                children: [
                  /// User Name & Contact NumberField
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: CommonInputFormField(
                          textEditingController: addNewUserWatch.nameController,
                          hintText: LocaleKeys.keyUserName.localized,
                          validator: (value) {
                            return validateText(value, LocaleKeys.keyUserNameShouldBeRequired.localized);
                          },
                          textInputType: TextInputType.name,
                          onFieldSubmitted: (value) {
                            addNewUserWatch.contactNumberFocusNode.requestFocus();
                          },
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z/ ]')),
                            SingleSpaceInputFormatter(),
                            LengthLimitingTextInputFormatter(255),
                          ],
                          maxLength: maxNameLength,
                        ),
                      ),
                      SizedBox(width: 25),
                      Flexible(
                        child: CommonInputFormField(
                          focusNode: addNewUserWatch.contactNumberFocusNode,
                          textEditingController: addNewUserWatch.contactNumberController,
                          hintText: LocaleKeys.keyContactNumber.localized,
                          textInputType: TextInputType.number,
                          onFieldSubmitted: (value) {
                            addNewUserWatch.emailFocusNode.requestFocus();
                          },
                          validator: (value) {
                            return validateMobile(value);
                          },
                          textInputFormatter: [
                            LengthLimitingTextInputFormatter(maxMobileLength),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLength: maxMobileLength,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),

                  /// Email ID & Role Type Field
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: CommonInputFormField(
                          focusNode: addNewUserWatch.emailFocusNode,
                          textEditingController: addNewUserWatch.emailController,
                          hintText: LocaleKeys.keyEmailID.localized,
                          textInputType: TextInputType.emailAddress,
                          onFieldSubmitted: (value) {
                            addNewUserWatch.createPasswordFocusNode.requestFocus();
                          },
                          validator: (value) {
                            return validateEmail(value);
                          },
                          textInputFormatter: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny any spaces
                            LowerCaseTextFormatter(),
                          ],
                          maxLength: maxEmailLength,
                        ),
                      ),

                      SizedBox(width: 25),

                      /// Role Type Dropdown
                      Flexible(
                        child: CommonSearchableDropdown<String>(
                          isEnable: (userUuid == null),
                          selectedItem: (userUuid == null) ? null : addNewUserWatch.selectedAssignType?.name,
                          textEditingController: addNewUserWatch.assignTypeController,
                          hintText: LocaleKeys.keyRoleType.localized,
                          onSelected: (roleType) {
                            addNewUserWatch.assignTypeValue(roleType);
                          },
                          items: addNewUserWatch.assignTypeList.map((e) => e.name ?? '').toList(),
                          validator: (value) =>
                              validateTextIgnoreLength(value, LocaleKeys.keyRoleTypeRequiredValidation.localized),
                          title: (value) {
                            return (value);
                          },
                        ),
                      ),
                    ],
                  ),
                  Visibility(visible: (userUuid == null), child: SizedBox(height: 20)),

                  Visibility(
                    visible: (userUuid == null),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Create Password Field
                        Flexible(
                          child: CommonInputFormField(
                            focusNode: addNewUserWatch.createPasswordFocusNode,
                            obscureText: !addNewUserWatch.isShowNewPassword,
                            textEditingController: addNewUserWatch.createPasswordController,
                            hintText: LocaleKeys.keyCreatePassword.localized,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              addNewUserWatch.confirmPasswordFocusNode.requestFocus();
                            },
                            validator: (value) {
                              return validatePassword(value);
                            },
                            onChanged: (value) {
                              addNewUserWatch.checkIfPasswordValid();
                            },
                            suffixWidget: InkWell(
                              onTap: () {
                                addNewUserWatch.changeNewPasswordVisibility();
                              },
                              child: CommonSVG(
                                strIcon: addNewUserWatch.isShowNewPassword
                                    ? Assets.svgs.svgHidePasswordSvg.keyName
                                    : Assets.svgs.svgShowPasswordSvg.keyName,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 25),

                        /// Confirm Password Field
                        Flexible(
                          child: CommonInputFormField(
                            obscureText: !addNewUserWatch.isShowConfirmPassword,
                            textEditingController: addNewUserWatch.confirmPasswordController,
                            hintText: LocaleKeys.keyConfirmPassword.localized,
                            textInputAction: TextInputAction.done,
                            focusNode: addNewUserWatch.confirmPasswordFocusNode,
                            onFieldSubmitted: (value) async {
                              if (addNewUserWatch.addNewUserFormKey.currentState!.validate()) {
                                if (userUuid != null) {
                                  await updateUserApiCall(context, ref);
                                } else {
                                  await addNewUserApiCall(context, ref);
                                }
                              }
                            },
                            validator: (value) {
                              return validateConfirmPassword(addNewUserWatch.createPasswordController.text, value);
                            },
                            onChanged: (value) {
                              addNewUserWatch.checkIfPasswordValid();
                            },
                            suffixWidget: InkWell(
                              onTap: () {
                                addNewUserWatch.changeConfirmPasswordVisibility();
                              },
                              child: CommonSVG(
                                strIcon: addNewUserWatch.isShowConfirmPassword
                                    ? Assets.svgs.svgHidePasswordSvg.keyName
                                    : Assets.svgs.svgShowPasswordSvg.keyName,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// TODO: Validations As Per V2
              /*Row(
                  children: [
                    Visibility(
                      visible:
                      addNewUserWatch.createPasswordController.text.isNotEmpty &&
                          !((addNewUserWatch.createPasswordController.text.length >= 8 &&
                              addNewUserWatch.createPasswordController.text.length <= 16) &&
                              RegExp(r'[a-z]').hasMatch(addNewUserWatch.createPasswordController.text) &&
                              RegExp(r'[A-Z]').hasMatch(addNewUserWatch.createPasswordController.text) &&
                              RegExp(r'[0-9]').hasMatch(addNewUserWatch.createPasswordController.text) &&
                              RegExp(
                                r'[!@#$%^&*(),.?":{}|<>\-]',
                              ).hasMatch(addNewUserWatch.createPasswordController.text)),
                      child: passwordValidation(addNewUserWatch.createPasswordController),
                    ),

                    Spacer(),

                    Visibility(
                      visible:
                      addNewUserWatch.confirmPasswordController.text.isNotEmpty &&
                          !(addNewUserWatch.createPasswordController.text ==
                              addNewUserWatch.confirmPasswordController.text),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CommonSVG(
                            strIcon:
                            (addNewUserWatch.confirmPasswordController.text ==
                                addNewUserWatch.createPasswordController.text &&
                                addNewUserWatch.confirmPasswordController.text.isNotEmpty)
                                ? Assets.svgs.svgGreenRightArrow.keyName
                                : Assets.svgs.svgGreyDot.keyName,
                            height: 12,
                            width: 12,
                            boxFit: BoxFit.scaleDown,
                          ).paddingOnly(right: 5),
                          CommonText(
                            title: LocaleKeys.keyConfirmPasswordMatch.localized,
                            style: TextStyles.regular.copyWith(
                              fontSize: 14,
                              color:
                              addNewUserWatch.confirmPasswordController.text ==
                                  addNewUserWatch.createPasswordController.text
                                  ? AppColors.black
                                  : AppColors.clr8D8D8D,
                            ),
                          ),
                        ],
                      ).paddingOnly(bottom: 6, top: 6),
                    ),
                  ]
                ),*/
              SizedBox(height: 30),

              /// Bottom Buttons
              Row(
                children: [
                  /// Save Button
                  CommonButton(
                    height: 50,
                    width: 150,
                    buttonText: LocaleKeys.keySave.localized,
                    isLoading:
                        addNewUserWatch.addNewUserApiState.isLoading ||
                        addNewUserWatch.updateUserApiState.isLoading,
                    onTap: () async {
                      if (addNewUserWatch.addNewUserFormKey.currentState!.validate()) {
                        if (userUuid != null) {
                          await updateUserApiCall(context, ref);
                        } else {
                          await addNewUserApiCall(context, ref);
                        }
                      }
                    },
                    buttonTextStyle: TextStyles.regular.copyWith(fontSize: 14, color: AppColors.white),
                  ),
                  SizedBox(width: 20),

                  /// Back Button
                  CommonButton(
                    height: 50,
                    width: 150,
                    buttonText: LocaleKeys.keyBack.localized,
                    borderColor: AppColors.clr9E9E9E,
                    backgroundColor: AppColors.transparent,
                    buttonTextColor: AppColors.clr787575,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ).alignAtBottomLeft(),
            ],
          ).paddingSymmetric(horizontal: 25, vertical: 25),
        ),
      ),
    );
  }

  /// Add New User Api Call
  Future<void> addNewUserApiCall(BuildContext context, WidgetRef ref) async {
    final addNewUserWatch = ref.watch(addNewUserController);
    await addNewUserWatch.addNewUserApi(mainContext);
    if (addNewUserWatch.addNewUserApiState.success?.status == ApiEndPoints.apiStatus_200) {
      addNewUserWatch.disposeController(isNotify: true);
      ref.read(navigationStackController).pop();
      getUsersListApiCall(context, ref);
    }
  }

  /// Update User Api Call
  Future<void> updateUserApiCall(BuildContext context, WidgetRef ref) async {
    final addNewUserWatch = ref.watch(addNewUserController);
    await addNewUserWatch.updateUserApi(mainContext, userUuid ?? '');
    if (addNewUserWatch.updateUserApiState.success?.status == ApiEndPoints.apiStatus_200) {
      ref.watch(navigationStackController).pop();
      getUsersListApiCall(context, ref, isForPagination: false);
    }
  }

  /// Get users List Api Call
  Future<void> getUsersListApiCall(BuildContext context, WidgetRef ref, {bool isForPagination = true}) async {
    final userManagementWatch = ref.watch(userManagementController);
    if (!isForPagination) {
      userManagementWatch.isHasMorePage = false;
    }
    await userManagementWatch.getUserListApi(context);
  }

  Widget passwordValidation(TextEditingController passwordController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Length
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonSVG(
              strIcon: passwordController.text.length >= 8 && passwordController.text.length <= 16
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
                color: passwordController.text.length >= 8 && passwordController.text.length <= 16
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
                color: RegExp(r'[a-z]').hasMatch(passwordController.text) ? AppColors.black : AppColors.clr8D8D8D,
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
                color: RegExp(r'[A-Z]').hasMatch(passwordController.text) ? AppColors.black : AppColors.clr8D8D8D,
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
                color: RegExp(r'[0-9]').hasMatch(passwordController.text) ? AppColors.black : AppColors.clr8D8D8D,
              ),
            ),
          ],
        ).paddingOnly(bottom: 6),

        /// Must contain at least one special character (e.g. !@#...-)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonSVG(
              strIcon: RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(passwordController.text)
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
                color: RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(passwordController.text)
                    ? AppColors.black
                    : AppColors.clr8D8D8D,
              ),
            ),
          ],
        ).paddingOnly(bottom: 6),
      ],
    );
  }
}
