import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/controller/master/state/add_edit_state_controller.dart';
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/master/country/model/country_list_response_model.dart';
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

class AddEditStateFormWidget extends ConsumerStatefulWidget {
  final bool? isEdit;
  final String? uuid;
  const AddEditStateFormWidget({super.key, this.isEdit,this.uuid});

  @override
  ConsumerState<AddEditStateFormWidget> createState() => _AddEditStateWidgetState();
}

class _AddEditStateWidgetState extends ConsumerState<AddEditStateFormWidget> {
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final addEditStateWatch = ref.watch(addEditStateController);
    final countryListWatch = ref.watch(countryListController);
    return AbsorbPointer(
      absorbing: addEditStateWatch.isLoading || addEditStateWatch.stateDetailsState.isLoading,
      child: Form(
        key: addEditStateWatch.formKey,
        child: Column(
          children: [

            /// select country dropdown
            CommonSearchableDropdown<CountryModel>(
              isEnable: !(widget.isEdit ?? false),
              hintText: LocaleKeys.keySelectCountry.localized,
              // hintTextStyle: TextStyles.regular.copyWith(fontSize: 12,color:AppColors.clr8D8D8D),
              onSelected: (value) => addEditStateWatch.updateCountryDropdown(value),
              textEditingController: addEditStateWatch.countryCtr,
              items: countryListWatch.countryList,
              validator: (value) => validateText(value, LocaleKeys.keyCountryIsRequired.localized),
              title: (value) {
                return value.name ?? '';
              },
              onScrollListener: () async {
                if (!countryListWatch.countryListState.isLoadMore && countryListWatch.countryListState.success?.hasNextPage == true) {
                  if (mounted) {
                    await countryListWatch.getCountryListAPI(context,pagination: true);
                  }
                }
              },
            ),

            /// state textField
            DynamicLangFormManager.instance.dynamicWidget(
                addEditStateWatch.listForTextField,
                DynamicFormEnum.STATE,
                onFieldSubmitted: (value) => checkValidateAndApiCall(ref)
            ).paddingOnly(top: context.height * 0.025),

            /// save continue & back buttons
            Row(
              children: [
                /// save continue button
                CommonButton(
                  width: context.width * 0.1,
                  borderRadius: BorderRadius.circular(8),
                  fontSize: 14,
                  buttonText: LocaleKeys.keySave.localized,
                  isLoading: addEditStateWatch.isLoading,
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
    );
  }
  callStateListApiAndPop(WidgetRef ref){
    ref.read(stateListController).clearStateList();
    ref.read(stateListController).getStateListAPI(context);
    ref.read(navigationStackController).pop();
  }

  void checkValidateAndApiCall(WidgetRef ref) {
    final addEditStateWatch = ref.watch(addEditStateController);
    bool isValid = addEditStateWatch.formKey.currentState?.validate() ?? false;
    if (isValid) {
      if(widget.isEdit == true){
        addEditStateWatch.editStateAPI(context,widget.uuid).then((value){
          if(value.success?.status == ApiEndPoints.apiStatus_200){
            callStateListApiAndPop(ref);
          }
        });
      }else{
        addEditStateWatch.addStateAPI(context).then((value){
          if(value.success?.status == ApiEndPoints.apiStatus_200){
            callStateListApiAndPop(ref);
          }
        });
      }

    }
  }
}
