import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_appbar.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/framework/controller/master/country/add_edit_country_controller.dart';

class AddEditCountryWeb extends ConsumerStatefulWidget {
  final bool? isEdit;
  const AddEditCountryWeb({Key? key,this.isEdit}) : super(key: key);

  @override
  ConsumerState<AddEditCountryWeb> createState() => _AddEditCountryWebState();
}

class _AddEditCountryWebState extends ConsumerState<AddEditCountryWeb> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final addEditCountryWatch = ref.read(addEditCountryController);
      addEditCountryWatch.disposeController(isNotify : true);
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final addEditCountryWatch = ref.watch(addEditCountryController);
    return BaseDrawerPageWidget(
      body: Column(
        children: [
          CommonAppbar(
            showAddButton: false,
            showSearchBar: false,
            showImport: false,
            showExport: false,
          ),

          Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8)
            ),
            child: Form(
              key: addEditCountryWatch.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// add country text
                  CommonText(title: widget.isEdit == true ? LocaleKeys.keyEditCountry.localized : LocaleKeys.keyAddCountry.localized,fontWeight: TextStyles.fwSemiBold,).paddingOnly(bottom: 24),

                  /// country name textFields
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // /// country name en
                      // Expanded(
                      //   child: CommonInputFormField(
                      //     textEditingController: addEditCountryWatch.countryNameENCtr,
                      //     hintText: LocaleKeys.keyCountryName.localized,
                      //     suffixIconConstraints: BoxConstraints(maxHeight: context.height * 0.07, maxWidth: context.height * 0.12),
                      //     suffixWidget: CommonFormFieldPrefixSuffixWidget(isRTL: true),
                      //     hintTextStyle: TextStyles.regular.copyWith(color: AppColors.clr7C7474),
                      //     validator: (value){
                      //       return validateText(value, LocaleKeys.keyCountryIsRequired.localized);
                      //     },
                      //   ),
                      // ),

                      SizedBox(width: context.width * 0.02),

                      /// country name ar
                      // Expanded(
                      //   child: CommonInputFormField(
                      //     textEditingController: addEditCountryWatch.countryNameARCtr,
                      //     hintText: LocaleKeys.keyCountryName.localized,
                      //     prefixIconConstraints: BoxConstraints(maxHeight: context.height * 0.07, maxWidth: context.height * 0.12),
                      //     prefixWidget: CommonFormFieldPrefixSuffixWidget(isRTL: false),
                      //     hintTextStyle: TextStyles.regular.copyWith(color: AppColors.clr7C7474),
                      //     validator: (value){
                      //       return validateText(value, LocaleKeys.keyCountryIsRequired.localized);
                      //     },
                      //   ),
                      // ),
                    ],
                  ),

                  /// country code & currency textFields
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// country code
                      Expanded(
                        child: CommonInputFormField(
                          textEditingController: addEditCountryWatch.countryCodeCtr,
                          hintText: LocaleKeys.keyCountryCode.localized,
                          hintTextStyle: TextStyles.regular.copyWith(color: AppColors.clr7C7474),
                          validator: (value){
                            return validateText(value, LocaleKeys.keyCountryCode.localized.toRequiredText,minLength: 1);
                          },
                        ),
                      ),

                      SizedBox(width: context.width * 0.02),

                      /// currency
                      Expanded(
                        child: CommonInputFormField(
                          textEditingController: addEditCountryWatch.currencyCtr,
                          hintText: LocaleKeys.keyCurrency.localized,
                          hintTextStyle: TextStyles.regular.copyWith(color: AppColors.clr7C7474),
                          validator: (value){
                            return validateText(value, LocaleKeys.keyCurrency.localized.toRequiredText);
                          },
                        ),
                      ),
                    ],
                  ).paddingOnly(top: context.height * 0.025),

                  /// save continue & back buttons
                  Row(
                    children: [

                      /// save continue button
                      CommonButton(
                        width: context.width * 0.12,
                        borderRadius: BorderRadius.circular(8),
                        fontSize: 14,
                        buttonText: LocaleKeys.keySaveContinue.localized,
                        onTap: (){
                          bool isValid = addEditCountryWatch.formKey.currentState?.validate() ?? false;
                          if(isValid){
                            ref.read(navigationStackController).pop();
                          }
                        },
                      ).paddingOnly(right: context.width * 0.01),

                      /// back button
                      CommonButton(
                        width: context.width * 0.12,
                        borderRadius: BorderRadius.circular(8),
                        fontSize: 14,
                        buttonText: LocaleKeys.keyBack.localized,
                        borderColor: AppColors.black,
                        backgroundColor: AppColors.transparent,
                        buttonTextColor: AppColors.clr787575,
                        onTap: (){
                          ref.read(navigationStackController).pop();
                        },
                      )
                    ],
                  ).paddingOnly(top: context.height * 0.025),
                ],
              ).paddingAll(context.height * 0.025),
            ),
          ).paddingAll(context.height * 0.025)
        ],
      ),
    );
  }


}
