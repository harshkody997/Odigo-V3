import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/destination_user_management/add_edit_destination_user_controller.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class AddEditDestinationUserFormWidgetWeb extends ConsumerWidget {
  final String? userId;
  const AddEditDestinationUserFormWidgetWeb({super.key, this.userId});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final addEditUserWatch = ref.watch(addEditDestinationUserController);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            title: userId != null?LocaleKeys.keyEditUser.localized: LocaleKeys.keyAddNewUser.localized,
            style: TextStyles.semiBold.copyWith(
              fontSize: 14,
            ),
          ).paddingOnly(bottom: 20),

          /// Name and Contact fields
          Session.getEntityType() == RoleType.DESTINATION.name?
          CommonInputFormField(
            textEditingController: addEditUserWatch.nameCtr,
            focusNode: addEditUserWatch.nameFocus,
            hintText: LocaleKeys.keyUserName.localized,
            onFieldSubmitted: (value){
              addEditUserWatch.emailFocus.requestFocus();
            },
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textInputFormatter: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z/ ]')),
              SingleSpaceInputFormatter()
            ],
            validator: (value){
              return validateText(value, LocaleKeys.keyPleaseEnterName.localized);
            },
            maxLength: AppConstants.maxNameLength,
          ).paddingOnly(bottom: 25):Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 17,
                child: CommonInputFormField(
                  textEditingController: addEditUserWatch.nameCtr,
                  focusNode: addEditUserWatch.nameFocus,
                  hintText: LocaleKeys.keyUserName.localized,
                  onFieldSubmitted: (value){
                    addEditUserWatch.contactFocus.requestFocus();
                  },
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z/ ]')),
                    SingleSpaceInputFormatter()
                  ],
                  validator: (value){
                    return validateText(value, LocaleKeys.keyPleaseEnterName.localized);
                  },
                  maxLength: AppConstants.maxNameLength,
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 17,
                child: CommonInputFormField(
                  textEditingController: addEditUserWatch.contactCtr,
                  focusNode: addEditUserWatch.contactFocus,
                  hintText: LocaleKeys.keyContactNumber.localized,
                  onFieldSubmitted: (value){
                    addEditUserWatch.emailFocus.requestFocus();
                  },
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value){
                    return validateMobile(value);
                  },
                  maxLength: AppConstants.maxMobileLength,
                ),
              ),
            ],
          ).paddingOnly(bottom: 25),

          /// Email,Destination and Contact fields
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 17,
                child: CommonInputFormField(
                  textEditingController: addEditUserWatch.emailCtr,
                  focusNode: addEditUserWatch.emailFocus,
                  hintText: LocaleKeys.keyEmailAddress.localized,
                  textInputFormatter: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  onFieldSubmitted: (value) async {
                    /// If destination user
                    if( Session.getEntityType() == RoleType.DESTINATION.name){
                      addEditUserWatch.contactFocus.requestFocus();
                    }else{
                      /// If admin and admin use.
                      if(userId != null){
                        /// If edit then direct call api on email field submit
                        if(addEditUserWatch.formKey.currentState?.validate()??false){
                          await addEditUserWatch.addUpdateDestinationUserApi(userId: userId).then((_){
                            if(addEditUserWatch.addUpdateUserState.success?.status == ApiEndPoints.apiStatus_200){
                              /// Success toast
                              showToast(context: context,isSuccess:true,message: '${LocaleKeys.keyUser.localized} ${userId !=null?LocaleKeys.keyUpdatedSuccessMsg.localized:LocaleKeys.keyCreatedSuccessMsg.localized}');
                              /// List api call
                              ref.read(destinationUserController).destinationUserListApi(false);
                              /// Pop
                              ref.read(navigationStackController).pop();
                            }
                          });
                        }
                      }else{
                        addEditUserWatch.destinationFocus.requestFocus();
                      }
                    }

                  },
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value){
                    return validateEmail(value);
                  },
                  maxLength: AppConstants.maxEmailLength,
                ),
              ),
              const Spacer(),

              /// If Destination login then show contact field instead of destination selection
              Session.getEntityType() == RoleType.DESTINATION.name?Expanded(
                flex: 17,
                child: CommonInputFormField(
                  textEditingController: addEditUserWatch.contactCtr,
                  focusNode: addEditUserWatch.contactFocus,
                  hintText: LocaleKeys.keyContactNumber.localized,
                  onFieldSubmitted: (value) async{
                    /// If edit then direct call api on contact field submit
                    if(userId != null){
                      if(addEditUserWatch.formKey.currentState?.validate()??false){
                        await addEditUserWatch.addUpdateDestinationUserApi(userId: userId).then((_){
                          if(addEditUserWatch.addUpdateUserState.success?.status == ApiEndPoints.apiStatus_200){
                            /// Success toast
                            showToast(context: context,isSuccess:true,message: '${LocaleKeys.keyUser.localized} ${userId !=null?LocaleKeys.keyUpdatedSuccessMsg.localized:LocaleKeys.keyCreatedSuccessMsg.localized}');
                            /// List api call
                            ref.read(destinationUserController).destinationUserListApi(false);
                            /// Pop
                            ref.read(navigationStackController).pop();
                          }
                        });
                      }
                    }else{
                      addEditUserWatch.newPasswordFocus.requestFocus();
                    }
                  },
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value){
                    return validateMobile(value);
                  },
                  maxLength: AppConstants.maxMobileLength,
                ),
              ):Expanded(
                flex: 17,
                child:CommonSearchableDropdown<DestinationData>(
                  isEnable: userId== null,
                  textEditingController: addEditUserWatch.selectDestinationCtr,
                  hintText: LocaleKeys.keyDestination.localized,
                  passedFocus: addEditUserWatch.destinationFocus,
                  onSelected: (destination) {
                    addEditUserWatch.updateSelectedDestination(destination);
                  },
                  items: ref.watch(destinationController).destinationList,
                  validator: (value) => validateText(value, LocaleKeys.keyDestinationRequired.localized),
                  title: (value) {
                    return value.name ?? '';
                  },
                  onFieldSubmitted: (val){
                    addEditUserWatch.newPasswordFocus.requestFocus();
                  },
                  onScrollListener: () {
                    if (!ref.watch(destinationController).destinationListState.isLoadMore && ref.watch(destinationController).destinationListState.success?.hasNextPage == true) {
                      ref.watch(destinationController).getDestinationListApi(context,isReset: false,pagination: true,activeRecords: true).then((value) {
                        if(ref.read(destinationController).destinationListState.success?.status == ApiEndPoints.apiStatus_200){
                          ref.read(searchController).notifyListeners();
                        }
                      });
                    }
                  },
                ),
              ),
            ],
          ).paddingOnly(bottom: 25),

          /// Password and confirm password fields
          userId == null?Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 17,
                child: CommonInputFormField(
                  obscureText: !addEditUserWatch.isShowNewPassword,
                  textEditingController: addEditUserWatch.newPasswordCtr,
                  maxLength: AppConstants.maxPasswordLength,
                  hintText: LocaleKeys.keyNewPassword.localized,
                  textInputAction: TextInputAction.next,
                  focusNode: addEditUserWatch.newPasswordFocus,
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
                      addEditUserWatch.changePasswordVisibility();
                    },
                    child: CommonSVG(
                      height: context.width * 0.024,
                      width: context.width * 0.024,
                      strIcon: (!addEditUserWatch.isShowNewPassword)
                          ? Assets.svgs.svgShowPasswordSvg_.keyName
                          : Assets.svgs.svgHidePasswordSvg_.keyName,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 17,
                child: CommonInputFormField(
                  obscureText: !addEditUserWatch.isShowConfirmPassword,
                  textEditingController: addEditUserWatch.confirmPasswordCtr,
                  maxLength: AppConstants.maxPasswordLength,
                  hintText: LocaleKeys.keyConfirmPassword.localized,
                  textInputAction: TextInputAction.next,
                  focusNode: addEditUserWatch.confirmPasswordFocus,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(regExpBlocEmoji),
                    FilteringTextInputFormatter.deny(RegExp('[ ]')),
                  ],
                  validator: (password) {
                    return validateConfirmPassword(password, addEditUserWatch.newPasswordCtr.text);
                  },
                  onChanged: (password) {
                  },
                  suffixWidget: InkWell(
                    onTap: () {
                      addEditUserWatch.changeConfirmPasswordVisibility();
                    },
                    child: CommonSVG(
                      height: context.width * 0.024,
                      width: context.width * 0.024,
                      strIcon:(!addEditUserWatch.isShowConfirmPassword)
                          ? Assets.svgs.svgShowPasswordSvg_.keyName
                          : Assets.svgs.svgHidePasswordSvg_.keyName,
                    ),
                  ),
                  onFieldSubmitted: (val) async{
                    if(addEditUserWatch.formKey.currentState?.validate()??false){
                      await addEditUserWatch.addUpdateDestinationUserApi(userId: userId).then((_){
                        if(addEditUserWatch.addUpdateUserState.success?.status == ApiEndPoints.apiStatus_200){
                          /// Success toast
                          showToast(context: context,isSuccess:true,message: '${LocaleKeys.keyUser.localized} ${userId !=null?LocaleKeys.keyUpdatedSuccessMsg.localized:LocaleKeys.keyCreatedSuccessMsg.localized}');
                          /// List api call
                          ref.read(destinationUserController).destinationUserListApi(false);
                          /// Pop
                          ref.read(navigationStackController).pop();
                        }
                      });
                    }
                  },
                ),
              ),
            ],
          ).paddingOnly(bottom: 25): const  Offstage(),

        ],
      ).paddingAll(20),
    ).paddingOnly(bottom: 20);
  }
}
