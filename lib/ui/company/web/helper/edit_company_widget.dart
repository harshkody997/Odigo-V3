import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/company/company_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/company/web/helper/upload_company_image.dart';
import 'package:odigov3/ui/destination/web/helper/destination_time_selection_overlay.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';

class EditCompanyWidget extends ConsumerStatefulWidget {
  const EditCompanyWidget({super.key});

  @override
  ConsumerState<EditCompanyWidget> createState() => _EditCompanyWidgetState();
}

class _EditCompanyWidgetState extends ConsumerState<EditCompanyWidget> {
  ///Build
  @override
  Widget build(BuildContext context) {
    final editCompanyWatch = ref.watch(companyController);
    return  Form(
            key: editCompanyWatch.editCompanyFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///name dynamic field
                DynamicLangFormManager.instance.dynamicWidget(
                  editCompanyWatch.listForTextField,
                  DynamicFormEnum.COMPANY,
                  onFieldSubmitted: (value) {
                    editCompanyWatch.gstNoFocusNode.requestFocus();
                  },
                ),
                SizedBox(height: context.height * 0.025),

                ///state and city  field
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///State text field.
                    Flexible(
                      child: CommonInputFormField(
                        focusNode: editCompanyWatch.stateFocusNode,
                        textEditingController: editCompanyWatch.stateController,
                        hintText: LocaleKeys.keyState.localized,
                        textInputType: TextInputType.text,
                        validator: (value) {
                          return validateText(
                            value,
                            LocaleKeys.keyStateIsRequired.localized,
                          );
                        },
                        onFieldSubmitted: (value) {
                          editCompanyWatch.cityFocusNode.requestFocus();
                        },
                        maxLength: AppConstants.maxLength60,
                      ),
                    ),
                    SizedBox(width: 25),

                    ///City text field
                    Flexible(
                      child: CommonInputFormField(
                        focusNode: editCompanyWatch.cityFocusNode,
                        textEditingController:
                        editCompanyWatch.cityController,
                        hintText: LocaleKeys.keyCity.localized,
                        textInputType: TextInputType.text,
                        onFieldSubmitted: (value) {
                          editCompanyWatch.gstNoFocusNode.requestFocus();
                        },
                        validator: (value) {
                          return validateText(
                            value,
                            LocaleKeys.keyCityIsRequired.localized,
                          );
                        },
                        maxLength: AppConstants.maxLength60,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.height * 0.025),
                ///upload company image widget
                UploadCompanyImage(),
                SizedBox(height: context.height * 0.025),


                ///gst number and contact number field
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Gst no.
                    Flexible(
                      child: CommonInputFormField(
                        focusNode: editCompanyWatch.gstNoFocusNode,
                        textEditingController: editCompanyWatch.gstNoController,
                        hintText: LocaleKeys.keyGSTNo.localized,
                        textInputType: TextInputType.text,
                        validator: (value) {
                          return validateGSTNumber(
                            value,
                            LocaleKeys.keyGstNoRequired.localized,
                          );
                        },
                        onFieldSubmitted: (value) {
                          editCompanyWatch.mobileNumberFocusNode.requestFocus();
                        },
                        maxLength: 15,
                      ),
                    ),
                    SizedBox(width: 25),

                    ///contact number field
                    Flexible(
                      child: CommonInputFormField(
                        focusNode: editCompanyWatch.mobileNumberFocusNode,
                        textEditingController:
                            editCompanyWatch.mobileNumberController,
                        hintText: LocaleKeys.keyContactNo.localized,
                        textInputType: TextInputType.number,
                        onFieldSubmitted: (value) {
                          editCompanyWatch.emailFocusNode.requestFocus();
                        },
                        validator: (value) {
                          return validateMobile(value);
                        },
                        textInputFormatter: [
                          LengthLimitingTextInputFormatter(
                            AppConstants.maxMobileLength,
                          ),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: AppConstants.maxMobileLength,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.height * 0.025),

                /// Email ID Row & Customer email id
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///company email field
                    Flexible(
                      child: CommonInputFormField(
                        focusNode: editCompanyWatch.emailFocusNode,
                        textEditingController: editCompanyWatch.emailController,
                        hintText: LocaleKeys.keyEmailId.localized,
                        textInputType: TextInputType.emailAddress,
                        onFieldSubmitted: (value) {
                          editCompanyWatch.mobileNumberFocusNode.requestFocus();
                        },
                        validator: (value) {
                          return validateEmail(value);
                        },
                        textInputFormatter: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        maxLength: AppConstants.maxEmailLength,
                      ),
                    ),
                    SizedBox(width: 25),

                    ///customer email field
                    Flexible(
                      child: CommonInputFormField(
                        focusNode: editCompanyWatch.customerEmailFocusNode,
                        textEditingController:
                            editCompanyWatch.customerEmailController,
                        hintText: LocaleKeys.keyCustomerEmailId.localized,
                        textInputType: TextInputType.emailAddress,
                        onFieldSubmitted: (value) {},
                        validator: (value) {
                          return validateEmail(value);
                        },
                        textInputFormatter: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        maxLength: AppConstants.maxEmailLength,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.height * 0.025),

                ///Address dynamic field
                DynamicLangFormManager.instance.dynamicWidget(
                  editCompanyWatch.listForAddressTextField,
                  DynamicFormEnum.ADDRESS,
                  onFieldSubmitted: (value) {},
                ),

                SizedBox(height: context.height * 0.025),


                ///company hours
                CommonText(
                  title: LocaleKeys.keyCompanyHours.localized,
                  style: TextStyles.semiBold.copyWith(
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: context.height * 0.025),

                Row(
                  children: [
                    ///start time
                    Expanded(
                      child: CommonTimePickerOverlayWidget(
                        initialTime: DateFormat('hh:mm a').tryParse(editCompanyWatch.openingTimeController.text) ?? DateTime.now(),
                        onTimeSelected: (value) {

                          if (editCompanyWatch.isStartBeforeEnd(value, editCompanyWatch.closingTimeController.text) == true) {
                            editCompanyWatch.updateStartTime(DateFormat('hh:mm a').format(value));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.keySelectedStartTimeShouldBeBeforeEndTime.localized)));
                          }



                        },
                        child: CommonInputFormField(
                          textEditingController:
                          editCompanyWatch.openingTimeController,
                          isEnable: false,
                          suffixWidget: CommonSVG(strIcon: Assets.svgs.svgClock.path),
                          hintText: LocaleKeys.keyOpenTime.localized,
                          textInputType: TextInputType.text,
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    ///close time
                    Expanded(
                      child: CommonTimePickerOverlayWidget(
                        initialTime: DateFormat('hh:mm a').tryParse(editCompanyWatch.closingTimeController.text) ?? DateTime.now(),
                        onTimeSelected: (value) {
                          if(editCompanyWatch.isSelectedTimeValid(value, editCompanyWatch.openingTimeController.text) == true){
                            editCompanyWatch.updateEndTime(DateFormat('hh:mm a').format(value));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.keySelectedEndTimeShouldBeAfterStartTime.localized)));
                          }
                        },
                        child: CommonInputFormField(
                          textEditingController:
                          editCompanyWatch.closingTimeController,
                          isEnable: false,
                          suffixWidget: CommonSVG(strIcon: Assets.svgs.svgClock.path),
                          hintText: LocaleKeys.keyCloseTime.localized,
                          textInputType: TextInputType.text,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
