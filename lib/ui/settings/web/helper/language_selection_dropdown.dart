import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/auth/login_controller.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';

class LanguageSelectionDropdown extends ConsumerWidget {
  const LanguageSelectionDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginWatch = ref.watch(loginController);

    return CommonSearchableDropdown<LanguageModel>(
      onSelected: (value) async{
        final selectedLangCode=  await loginWatch.updateAppLanguage(value.uuid);
        if (selectedLangCode != null) {
          final newLocale = Locale(selectedLangCode);
          await context.setLocale(newLocale);
          ref.read(loginController).rebuildUI();
          loginWatch.languageController.text = (value.name??'').capitalizeFirstLetterOfSentence;


        }
      },
      selectedItem:loginWatch.languageList.firstWhere((languageList) => languageList.code == Session.getAppLanguage()),
      textEditingController: loginWatch.languageController,
      items: loginWatch.languageList,
      title: (LanguageModel language) {
        return language.name?.capsFirstLetterOfSentence ?? '';
      },
      fieldTextStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 14),
      borderRadius: BorderRadius.circular(6),
    ).alignAtCenterRight();
  }
}
