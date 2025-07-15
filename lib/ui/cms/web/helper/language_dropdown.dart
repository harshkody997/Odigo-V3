import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/cms/cms_controller.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/auth/web/helper/language_shimmer.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';

class LanguageDropdown extends ConsumerWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cmsWatch = ref.watch(cmsController);

    return Align(
      alignment: Alignment.centerRight,
      child:
      cmsWatch.languageListState.isLoading || cmsWatch.languageList.isEmpty ?LanguageShimmer() :
      Focus(
        onKey: (FocusNode node, RawKeyEvent event) {
          if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
            // Prevent focus shift on Enter
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: CommonSearchableDropdown<LanguageModel>(
          fieldHeight: 40,
          enableSearch: false,
          borderRadius: BorderRadius.circular(7),
          fieldWidth: 130,

          // hintText: LocaleKeys.keySelectLanguage.localized,
        //  selectedItem:cmsWatch.languageList.firstWhere((languageList) => languageList.isDefault == true),
          //selectedItem:cmsWatch.languageList.firstWhere((languageList) => languageList.code == Session.getAppLanguage()),
          selectedItem:cmsWatch.languageList.firstWhere((languageList) => languageList.code == cmsWatch.selectedLanguageData?.code),
          fieldTextStyle:TextStyles.regular.copyWith(color: AppColors.black333333, fontSize: 12),
          onSelected: (value) async{
           cmsWatch.updateLanguageData(value);
          },

          textEditingController: cmsWatch.languageController,
          items: cmsWatch.languageList,
          title: (LanguageModel language) {
            return language.name?.capitalizeFirstLetterOfSentence ?? '';
          },
        ),
      ),
    );
  }
}
