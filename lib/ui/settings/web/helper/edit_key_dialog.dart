import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/settings/settings_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/settings/model/response_model/settings_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class EditKeyDialog extends StatelessWidget {
  final SettingsData? settingsData;
  final String? title;
  final String? validationMessage;
  final String? hintText;
  const EditKeyDialog({super.key, required this.settingsData, this.title, this.validationMessage, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final settingWatch = ref.watch(settingsController);
        return Form(
          key: settingWatch.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// title
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CommonSVG(
                      strIcon: Assets.svgs.svgBackButtonWithoutBg.keyName,
                    ).paddingOnly(right: 10),
                  ),
                  CommonText(
                    title: title ?? LocaleKeys.keyEditKey.localized,
                    style: TextStyles.semiBold.copyWith(
                      fontSize: 14,
                    ),
                  )
                ],
              ).paddingOnly(bottom: context.height * 0.030),
              /// form field
              CommonInputFormField(
                textEditingController: settingWatch.keyController,
                hintText: hintText ?? LocaleKeys.keyKey.localized,
                fieldTextStyle: TextStyles.regular.copyWith(
                  fontSize: 14,
                  color: AppColors.black272727,
                ),
                maxLength: 500,
                placeholderText: hintText ?? LocaleKeys.keyKey.localized,
                validator: (value) {
                  if(settingsData?.fieldName==SettingEnum.FTP_SERVER_URL.name || settingsData?.fieldName==SettingEnum.DYNAMIC_IP.name){
                    final RegExp urlPattern =RegExp(r'\b(?!http-)(?:https?:?\/{0,2}|www\.)[^\s]+', caseSensitive: false);
                    if(value.toString().trim()==''){
                      return validationMessage ?? LocaleKeys.keyURLIsRequired.localized;
                    }
                    else if (urlPattern.hasMatch(value??'')) {
                      return null;
                    } else{
                      return LocaleKeys.keyEnteredURLIsNotValid.localized;
                    }
                  }
                  return validateTextIgnoreLength(value, validationMessage ?? LocaleKeys.keyIsRequired.localized);
                },
              ).paddingOnly(bottom: context.height * 0.025),
              /// save button
              CommonButton(
                buttonText: LocaleKeys.keySave.localized,
                height: context.height * 0.049,
                borderRadius: BorderRadius.circular(6),
                isLoading: settingWatch.updateSettingsState.isLoading,
                onTap: () async {
                  final bool? result = settingWatch.formKey.currentState?.validate();
                  if(result == true){
                    await settingWatch.updateSettingsApi(uuid: settingsData?.uuid ?? '', encrypted: settingsData?.encrypted ?? false, fieldName: settingsData?.fieldName ?? '', fieldValue: settingWatch.keyController.text);
                    if(settingWatch.updateSettingsState.success?.status == ApiEndPoints.apiStatus_200) {
                      Navigator.pop(context);
                    }
                  }
                },
              )
            ],
          ).paddingSymmetric(horizontal: context.width * 0.020 , vertical: context.height * 0.020 ),
        );
      },
    );
  }
}
