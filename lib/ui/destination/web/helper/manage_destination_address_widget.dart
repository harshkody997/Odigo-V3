import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/manage_destination_controller.dart';
import 'package:odigov3/framework/controller/master/city/city_list_controller.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart';
import 'package:odigov3/framework/repository/master/city/model/city_list_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/country_list_response_model.dart';
import 'package:odigov3/framework/repository/master/state/model/state_details_response_model.dart';
import 'package:odigov3/framework/repository/master/state/model/state_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class ManageDestinationAddressWidget extends ConsumerWidget {
  const ManageDestinationAddressWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manageDestinationWatch = ref.watch(manageDestinationController);
    final countryListWatch = ref.watch(countryListController);
    final stateListWatch = ref.watch(stateListController);
    final cityListWatch = ref.watch(cityListController);
    final horizontalSpacing = context.height * 0.025;
    final verticalSpacing = context.height * 0.02;
    return SizedBox(
      // height: context.height * 0.48,
      child: CommonDashboardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              title: LocaleKeys.keyAddress.localized,
              style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
            ),
            SizedBox(height: verticalSpacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CommonInputFormField(
                    focusNode: manageDestinationWatch.addressHouseNumberFocusNode,
                    textEditingController: manageDestinationWatch.addressHouseNumberController,
                    hintText: LocaleKeys.keyHouseNameNumber.localized,
                    validator: (value) => validateText(value, LocaleKeys.keyHouseNameRequired.localized),
                    onFieldSubmitted: (value) => manageDestinationWatch.addressStreetNameFocusNode.requestFocus(),
                    maxLength: AppConstants.maxLength60,
                  ),
                ),
                SizedBox(width: horizontalSpacing),
                Expanded(
                  child: CommonInputFormField(
                    focusNode: manageDestinationWatch.addressStreetNameFocusNode,
                    textEditingController: manageDestinationWatch.addressStreetNameController,
                    hintText: LocaleKeys.keyStreetName.localized,
                    validator: (value) => validateText(value, LocaleKeys.keyStreetNameRequired.localized),
                    onFieldSubmitted: (value) => manageDestinationWatch.addressLine1FocusNode.requestFocus(),
                    maxLength: AppConstants.maxLength60,
                  ),
                ),
              ],
            ),
            SizedBox(height: verticalSpacing),
            CommonInputFormField(
              focusNode: manageDestinationWatch.addressLine1FocusNode,
              textEditingController: manageDestinationWatch.addressLine1Controller,
              hintText: LocaleKeys.keyAddressLine1.localized,
              validator: (value) => validateText(value, LocaleKeys.keyAddressLine1Required.localized),
              onFieldSubmitted: (value) => manageDestinationWatch.addressLine2FocusNode.requestFocus(),
              maxLength: AppConstants.maxEmailLength,
            ),
            SizedBox(height: verticalSpacing),
            CommonInputFormField(
              focusNode: manageDestinationWatch.addressLine2FocusNode,
              textEditingController: manageDestinationWatch.addressLine2Controller,
              hintText: LocaleKeys.keyAddressLine2.localized,
              validator: (value) => validateText(value, LocaleKeys.keyAddressLine2Required.localized),
              onFieldSubmitted: (value) => manageDestinationWatch.addressLandmarkFocusNode.requestFocus(),
              maxLength: AppConstants.maxEmailLength,
            ),
            SizedBox(height: verticalSpacing),
            CommonInputFormField(
              focusNode: manageDestinationWatch.addressLandmarkFocusNode,
              textEditingController: manageDestinationWatch.addressLandmarkController,
              hintText: LocaleKeys.keyLandmark.localized,
              validator: (value) => validateText(value, LocaleKeys.keyLandmarkIsRequired.localized),
              onFieldSubmitted: (value) => FocusScope.of(context).nextFocus(),
              maxLength: AppConstants.maxEmailLength,
            ),
            SizedBox(height: verticalSpacing),
            /// select country dropdown
            CommonSearchableDropdown<CountryModel>(
              isEnable: ref.read(manageDestinationController).destinationDetailsState.success?.data?.uuid == null,
              hintText: LocaleKeys.keySelectCountry.localized,
              // hintTextStyle: TextStyles.regular.copyWith(fontSize: 12,color:AppColors.clr8D8D8D),
              onSelected: (country) {
                manageDestinationWatch.updateCountryDropdown(country);
                manageDestinationWatch.addressStateController.clear();
                manageDestinationWatch.updateSelectedState(null);
                manageDestinationWatch.addressCityController.clear();
                manageDestinationWatch.updateSelectedCity(null);
                ref.read(stateListController).getStateListAPI(context, countryUuid: country.uuid,activeRecords: true, isCityActive: true);
              },
              textEditingController: manageDestinationWatch.addressCountryController,
              items: countryListWatch.countryList,
              validator: (value) => validateText(value, LocaleKeys.keyCountryIsRequired.localized),
              title: (value) {
                return value.name ?? '';
              },
              onScrollListener: () async {
                if (!countryListWatch.countryListState.isLoadMore && countryListWatch.countryListState.success?.hasNextPage == true) {
                  if (context.mounted) {
                    await countryListWatch.getCountryListAPI(context,pagination: true);
                  }
                }
              },
            ),
            SizedBox(height: verticalSpacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CommonSearchableDropdown<StateModel>(
                    textEditingController: manageDestinationWatch.addressStateController,
                    hintText: LocaleKeys.keySelectState.localized,
                    onSelected: (state) {
                      manageDestinationWatch.updateSelectedState(state);
                      manageDestinationWatch.addressCityController.clear();
                      manageDestinationWatch.updateSelectedCity(null);
                      cityListWatch.getCityListAPI(context, stateUuid: state.uuid,activeRecords: true);
                    },
                    isEnable: ref.read(manageDestinationController).destinationDetailsState.success?.data?.uuid == null && manageDestinationWatch.selectedCountry != null && !ref.watch(stateListController).stateListState.isLoading,
                    items: stateListWatch.stateList,
                    validator: (value) => validateText(value, LocaleKeys.keyStateIsRequired.localized),
                    title: (value) => value.name ?? '',
                    onFieldSubmitted: (value) => FocusScope.of(context).nextFocus(),
                    onScrollListener: () async {
                      if (!stateListWatch.stateListState.isLoadMore && stateListWatch.stateListState.success?.hasNextPage == true) {
                        if (context.mounted) {
                          await stateListWatch.getStateListAPI(context,pagination: true,countryUuid: manageDestinationWatch.selectedCountry?.uuid);
                        }
                      }
                    },
                  ),
                ),
                SizedBox(width: horizontalSpacing),
                Expanded(
                  child: CommonSearchableDropdown<CityModel>(
                    textEditingController: manageDestinationWatch.addressCityController,
                    hintText: LocaleKeys.keySelectCity.localized,
                    onSelected: (city) {
                      manageDestinationWatch.updateSelectedCity(city);
                    },
                    isEnable: ref.read(manageDestinationController).destinationDetailsState.success?.data?.uuid == null && manageDestinationWatch.selectedState != null && !ref.watch(cityListController).cityListState.isLoading,
                    items: cityListWatch.cityList,
                    validator: (value) => validateText(value, LocaleKeys.keyCityIsRequired.localized),
                    title: (value) {
                      return (value.name ?? '');
                    },
                    onScrollListener: () async {
                      if (!cityListWatch.cityListState.isLoadMore && cityListWatch.cityListState.success?.hasNextPage == true) {
                        if (context.mounted) {
                          await cityListWatch.getCityListAPI(context,pagination: true,stateUuid: manageDestinationWatch.selectedState?.uuid);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: verticalSpacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CommonInputFormField(
                    focusNode: manageDestinationWatch.addressPostalCodeFocusNode,
                    textEditingController: manageDestinationWatch.addressPostalCodeController,
                    hintText: LocaleKeys.keyPostalCode.localized,
                    validator: (value) => validateText(value, LocaleKeys.keyPostalCodeRequired.localized,minLength: 3),
                    onFieldSubmitted: (value) => FocusScope.of(context).nextFocus(),
                    maxLength: AppConstants.maxLength10,
                    textInputFormatter:[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(width: horizontalSpacing),

                Expanded(
                  child: CommonSearchableDropdown<String>(
                    isEnable: ref.read(manageDestinationController).destinationDetailsState.success?.data?.uuid == null,
                    textEditingController: manageDestinationWatch.addressTimeZoneController,
                    hintText: '${LocaleKeys.keySelect.localized} ${LocaleKeys.keyTimezone.localized}',
                    onSelected: (timezone) => manageDestinationWatch.updateSelectedTimezone(timezone),
                    items: countryListWatch.countryTimeZoneList,
                    validator: (value) => validateText(value, LocaleKeys.keyTimeZoneIsRequired.localized),
                    title: (value) => (value ?? ''),
                  ),
                )

                // Expanded(
                //   child: CommonInputFormField(
                //     focusNode: manageDestinationWatch.addressTimeZoneFocusNode,
                //     textEditingController: manageDestinationWatch.addressTimeZoneController,
                //     hintText: LocaleKeys.keyTimeZone.localized,
                //     validator: (value) => validateText(value, LocaleKeys.keyTimeZoneIsRequired.localized),
                //     onFieldSubmitted: (value) => manageDestinationWatch.premiumPriceFocusNode.requestFocus(),
                //     maxLength: AppConstants.maxLength60,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
