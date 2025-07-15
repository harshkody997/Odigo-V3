import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/city/add_edit_city_controller.dart';
import 'package:odigov3/framework/controller/master/city/city_list_controller.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/master/country/model/country_list_response_model.dart';
import 'package:odigov3/framework/repository/master/state/model/state_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';

class AddEditCityFormWidget extends ConsumerStatefulWidget {
  final bool? isEdit;
  final String? uuid;
  const AddEditCityFormWidget({super.key,this.isEdit,this.uuid});

  @override
  ConsumerState<AddEditCityFormWidget> createState() => _AddEditCityWidgetState();
}

class _AddEditCityWidgetState extends ConsumerState<AddEditCityFormWidget> {

  @override
  Widget build(BuildContext context) {
    final addEditCityWatch = ref.watch(addEditCityController);
    final stateListWatch = ref.watch(stateListController);
    final countryListWatch = ref.watch(countryListController);
    return Stack(
      children: [
        AbsorbPointer(
          absorbing : stateListWatch.stateListState.isLoading || addEditCityWatch.isLoading,
          child: Form(
            key: addEditCityWatch.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                /// select country dropdown
                CommonSearchableDropdown<CountryModel>(
                  isEnable: !(widget.isEdit ?? false),
                  hintText: LocaleKeys.keySelectCountry.localized,
                  // hintTextStyle: TextStyles.regular.copyWith(fontSize: 12,color:AppColors.clr8D8D8D),
                  onSelected: (value) {
                    addEditCityWatch.updateCountryDropdown(value);
                    addEditCityWatch.updateStateDropdown(null);
                    addEditCityWatch.stateCtr.clear();
                    stateListWatch.getStateListAPI(context,countryUuid: value.uuid,activeRecords: true);
                  },
                  textEditingController: addEditCityWatch.countryCtr,
                  items: countryListWatch.countryList,
                  validator: (value) => validateText(value, LocaleKeys.keyCountryIsRequired.localized),
                  title: (value) {
                    return value.name ?? '';
                  },
                  onScrollListener: () async {
                    if (!countryListWatch.countryListState.isLoadMore && countryListWatch.countryListState.success?.hasNextPage == true) {
                      if (mounted) {
                        await countryListWatch.getCountryListAPI(context,pagination: true,activeRecords: true);
                      }
                    }
                  },
                ).paddingOnly(bottom: context.height * 0.025),


                /// select state dropdown
                CommonSearchableDropdown<StateModel>(
                  isEnable: !(widget.isEdit ?? false),
                  hintText: LocaleKeys.keySelectState.localized,
                  // hintTextStyle: TextStyles.regular.copyWith(fontSize: 12,color:AppColors.clr8D8D8D),
                  onSelected: (value) => addEditCityWatch.updateStateDropdown(value),
                  textEditingController: addEditCityWatch.stateCtr,
                  items: stateListWatch.stateList,
                  validator: (value)=> validateText(value, LocaleKeys.keyStateIsRequired.localized),
                  title: (value) {
                    return value.name ?? '';
                  },
                  onScrollListener: () async {
                    if (!stateListWatch.stateListState.isLoadMore && stateListWatch.stateListState.success?.hasNextPage == true) {
                      if (mounted) {
                        await stateListWatch.getStateListAPI(context,pagination: true,activeRecords: true);
                      }
                    }
                  },
                ),

                DottedLine(dashColor: AppColors.clrE4E4E4,).paddingSymmetric(vertical: context.height * 0.03),

                /// city name textFields
                DynamicLangFormManager.instance.dynamicWidget(
                  addEditCityWatch.languageListTextFields,
                  DynamicFormEnum.CITY,
                  onFieldSubmitted: (value) => checkValidateAndApiCall(ref)
                ),

                /// save continue & back buttons
                Row(
                  children: [
                    /// save continue button
                    CommonButton(
                      width: context.width * 0.1,
                      borderRadius: BorderRadius.circular(8),
                      fontSize: 14,
                      buttonText: LocaleKeys.keySave.localized,
                      isLoading: addEditCityWatch.isLoading,
                      onTap: () => checkValidateAndApiCall(ref),
                    ).paddingOnly(right: context.width * 0.01),

                    /// back button
                    CommonButton(
                      width: context.width * 0.1,
                      borderRadius: BorderRadius.circular(8),
                      fontSize: 14,
                      buttonText: LocaleKeys.keyBack.localized,
                      borderColor: AppColors.black,
                      backgroundColor: AppColors.transparent,
                      buttonTextColor: AppColors.clr787575,
                      onTap: () => ref.read(navigationStackController).pop(),
                    ),
                  ],
                ).paddingOnly(top: context.height * 0.025),

              ],
            ),
          ),
        ),
        Visibility(
            visible: stateListWatch.stateListState.isLoading,
            child: Center(child: CommonAnimLoader()))
      ],
    );
  }

  callCityListApiAndPop(WidgetRef ref){
    ref.read(cityListController).clearCityList();
    ref.read(cityListController).getCityListAPI(context);
    ref.read(navigationStackController).pop();
  }

  void checkValidateAndApiCall(WidgetRef ref) {
    final addEditCityWatch = ref.watch(addEditCityController);
    bool isValid = addEditCityWatch.formKey.currentState?.validate() ?? false;
    if (isValid) {
      if(widget.isEdit == true){
        addEditCityWatch.editCityAPI(context,widget.uuid).then((value){
          if(value.success?.status == ApiEndPoints.apiStatus_200){
            callCityListApiAndPop(ref);
          }
        });
      }else{
        addEditCityWatch.addCityAPI(context).then((value){
          if(value.success?.status == ApiEndPoints.apiStatus_200){
            callCityListApiAndPop(ref);
          }
        });
      }
    }
  }
}
