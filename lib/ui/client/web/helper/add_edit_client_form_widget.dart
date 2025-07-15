import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/add_update_client_controller.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/controller/master/city/city_list_controller.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart';
import 'package:odigov3/framework/repository/master/city/model/city_list_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/country_list_response_model.dart';
import 'package:odigov3/framework/repository/master/state/model/state_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/client/web/helper/upload_document_widget.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AddEditClientFormWidget extends ConsumerWidget {
  final String? clientUuid;
  final Function? popCallBack;

  const AddEditClientFormWidget({super.key, this.clientUuid, this.popCallBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addUpdateClientWatch = ref.watch(addUpdateClientController);
    bool isLoading =
        ref.watch(countryListController).countryListState.isLoading ||
        addUpdateClientWatch.getDocumentByUuidState.isLoading ||
        ref.watch(clientDetailsController).clientDetailsState.isLoading ||
        addUpdateClientWatch.getDocumentByUuidState.isLoading;

    return (clientUuid != null && isLoading)
        ? CommonAnimLoader() /// Loader
        : SingleChildScrollView(
            child: Form(
              key: addUpdateClientWatch.addUpdateClientFromKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          title: LocaleKeys.keyClientDetails.localized,
                          fontWeight: TextStyles.fwSemiBold,
                        ).paddingOnly(bottom: 10),

                        /// Name & Email Id Field
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: CommonInputFormField(
                                focusNode: addUpdateClientWatch.nameFocusNode,
                                textEditingController: addUpdateClientWatch.nameController,
                                hintText: LocaleKeys.keyName.localized,
                                validator: (value) {
                                  return validateTextPreventSpecialCharacters(value, LocaleKeys.keyPleaseEnterName.localized);
                                },
                                textInputType: TextInputType.name,
                                onFieldSubmitted: (value) {
                                  addUpdateClientWatch.emailFocusNode.requestFocus();
                                },
                                textInputFormatter: [
                                  SingleSpaceInputFormatter()
                                ],
                                maxLength: AppConstants.maxNameLength,
                              ),
                            ),
                            SizedBox(width: 25),
                            Flexible(
                              child: CommonInputFormField(
                                focusNode: addUpdateClientWatch.emailFocusNode,
                                textEditingController: addUpdateClientWatch.emailController,
                                hintText: LocaleKeys.keyEmailAddress.localized,
                                textInputType: TextInputType.emailAddress,
                                onFieldSubmitted: (value) {
                                  addUpdateClientWatch.mobileNumberFocusNode.requestFocus();
                                },
                                validator: (value) {
                                  return validateEmail(value);
                                },
                                textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                                maxLength: AppConstants.maxEmailLength,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),

                        /// Mobile Number &  House Number Field
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: CommonInputFormField(
                                focusNode: addUpdateClientWatch.mobileNumberFocusNode,
                                textEditingController: addUpdateClientWatch.mobileNumberController,
                                hintText: LocaleKeys.keyMobileNumber.localized,
                                textInputType: TextInputType.number,
                                onFieldSubmitted: (value) {
                                  addUpdateClientWatch.houseNumberFocusNode.requestFocus();
                                },
                                validator: (value) {
                                  return validateMobile(value);
                                },
                                textInputFormatter: [
                                  LengthLimitingTextInputFormatter(AppConstants.maxMobileLength),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                maxLength: AppConstants.maxMobileLength,
                              ),
                            ),

                            SizedBox(width: 25),

                            Flexible(
                              child: CommonInputFormField(
                                focusNode: addUpdateClientWatch.houseNumberFocusNode,
                                textEditingController: addUpdateClientWatch.houseNumberController,
                                hintText: LocaleKeys.keyHouseNumber.localized,
                                textInputType: TextInputType.text,
                                validator: (value) {
                                  return validateTextPreventSpecialCharacters(value, LocaleKeys.keyHouseNumberRequired.localized);
                                },
                                onFieldSubmitted: (value) {
                                  addUpdateClientWatch.streetNameFocusNode.requestFocus();
                                },
                                maxLength: 50,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),

                        /// Street Name & Address Line 1 Field
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: CommonInputFormField(
                                focusNode: addUpdateClientWatch.streetNameFocusNode,
                                textEditingController: addUpdateClientWatch.streetNameController,
                                hintText: LocaleKeys.keyStreetName.localized,
                                textInputType: TextInputType.text,
                                validator: (value) {
                                  return validateTextPreventSpecialCharacters(value, LocaleKeys.keyStreetNameRequired.localized);
                                },
                                onFieldSubmitted: (value) {
                                  addUpdateClientWatch.addressLine1FocusNode.requestFocus();
                                },
                                maxLength: 100,
                              ),
                            ),
                            SizedBox(width: 25),
                            Flexible(
                              child: CommonInputFormField(
                                focusNode: addUpdateClientWatch.addressLine1FocusNode,
                                textEditingController: addUpdateClientWatch.addressLine1Controller,
                                hintText: LocaleKeys.keyAddressLine1.localized,
                                textInputType: TextInputType.text,
                                validator: (value) {
                                  return validateTextPreventSpecialCharacters(value, LocaleKeys.keyAddressLine1Required.localized);
                                },
                                onFieldSubmitted: (value) {
                                  addUpdateClientWatch.addressLine2FocusNode.requestFocus();
                                },
                                maxLength: 255,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Address Line 2 & Landmark Field
                            Flexible(
                              child: CommonInputFormField(
                                focusNode: addUpdateClientWatch.addressLine2FocusNode,
                                textEditingController: addUpdateClientWatch.addressLine2Controller,
                                hintText: LocaleKeys.keyAddressLine2.localized,
                                textInputType: TextInputType.text,
                                validator: (value) {
                                  return validateTextPreventSpecialCharacters(value, LocaleKeys.keyAddressLine2Required.localized);
                                },
                                onFieldSubmitted: (value) {
                                  addUpdateClientWatch.landmarkFocusNode.requestFocus();
                                },
                                maxLength: 255,
                              ),
                            ),
                            SizedBox(width: 25),
                            Flexible(
                              child: CommonInputFormField(
                                focusNode: addUpdateClientWatch.landmarkFocusNode,
                                textEditingController: addUpdateClientWatch.landmarkController,
                                hintText: LocaleKeys.keyLandmark.localized,
                                textInputType: TextInputType.text,
                                validator: (value) {
                                  return validateTextPreventSpecialCharacters(value, LocaleKeys.keyLandmarkIsRequired.localized);
                                },
                                onFieldSubmitted: (value) {
                                  addUpdateClientWatch.postalCodeFocusNode.requestFocus();
                                },
                                maxLength: 100,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),

                        /// Postal Code & Country Dropdown Field
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: CommonInputFormField(
                                focusNode: addUpdateClientWatch.postalCodeFocusNode,
                                textEditingController: addUpdateClientWatch.postalCodeController,
                                hintText: LocaleKeys.keyPostalCode.localized,
                                textInputType: TextInputType.number,
                                validator: (value) {
                                  return validateTextPreventSpecialCharacters(value, LocaleKeys.keyPostalCodeRequired.localized);
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).unfocus();
                                },
                                textInputFormatter: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                maxLength: 10,
                              ),
                            ),

                            SizedBox(width: 25),

                            /// Select country dropdown
                            Flexible(
                              child: CommonSearchableDropdown<CountryModel>(
                                isEnable: clientUuid?.isEmpty,
                                hintText: LocaleKeys.keySelectCountry.localized,
                                onSelected: (value) {
                                  addUpdateClientWatch.updateCountryDropdown(value);
                                  addUpdateClientWatch.updateSelectedState(null);
                                  addUpdateClientWatch.stateUuidController.clear();
                                  ref
                                      .read(stateListController)
                                      .getStateListAPI(context, countryUuid: value.uuid, activeRecords: true, isCityActive: true);
                                },
                                textEditingController: addUpdateClientWatch.countryController,
                                items: ref.watch(countryListController).countryList,
                                validator: (value) => validateTextPreventSpecialCharacters(value, LocaleKeys.keyCountryIsRequired.localized),
                                title: (value) {
                                  return value.name ?? '';
                                },
                                onScrollListener: () async {
                                  if (!ref.watch(countryListController).countryListState.isLoadMore &&
                                      ref.watch(countryListController).countryListState.success?.hasNextPage == true) {
                                    if (context.mounted) {
                                      await ref
                                          .watch(countryListController)
                                          .getCountryListAPI(
                                            context,
                                            pagination: true,
                                            activeRecords: true,
                                          );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 25),

                        /// State Dropdown & City Dropdown Field
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: CommonSearchableDropdown<StateModel>(
                                isEnable:
                                    addUpdateClientWatch.selectedCountry != null &&
                                        !ref.watch(stateListController).stateListState.isLoading ||
                                    (clientUuid?.isEmpty ?? false),
                                textEditingController: addUpdateClientWatch.stateUuidController,
                                hintText: LocaleKeys.keyState.localized,
                                onSelected: (state) {
                                  addUpdateClientWatch.updateSelectedState(state);
                                  ref.read(cityListController).getCityListAPI(context, stateUuid: state.uuid, activeRecords: true);
                                },
                                items: ref.watch(stateListController).stateList,
                                validator: (value) => validateTextPreventSpecialCharacters(value, LocaleKeys.keyStateIsRequired.localized),
                                title: (value) {
                                  return value.name ?? '';
                                },
                              ),
                            ),
                            SizedBox(width: 25),

                            /// City Dropdown
                            Flexible(
                              child: CommonSearchableDropdown<CityModel>(
                                textEditingController: addUpdateClientWatch.cityUuidController,
                                hintText: LocaleKeys.keyCity.localized,
                                onSelected: (city) {
                                  addUpdateClientWatch.updateSelectedCity(city);
                                },
                                isEnable:
                                    addUpdateClientWatch.selectedState != null &&
                                        !ref.watch(cityListController).cityListState.isLoading ||
                                    (clientUuid?.isEmpty ?? false),
                                items: ref.watch(cityListController).cityList,
                                validator: (value) => validateTextPreventSpecialCharacters(value, LocaleKeys.keyCityIsRequired.localized),
                                title: (value) {
                                  return (value.name ?? '');
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).paddingAll(20),
                  ),
                  SizedBox(height: 20),

                  /// Upload Documents Widget
                  UploadDocumentWidget(clientUuid: clientUuid, popCallBack: popCallBack),
                ],
              ),
            ),
          );
  }
}
