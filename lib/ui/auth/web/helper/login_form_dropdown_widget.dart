import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/auth/login_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/profile/profile_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/auth/web/helper/language_shimmer.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';

class LoginFormDropdownWidget extends ConsumerWidget {
  const LoginFormDropdownWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final loginWatch = ref.watch(loginController);
    return Align(
      alignment: Alignment.centerRight,
      child: loginWatch.languageListState.isLoading || loginWatch.languageList.isEmpty
          ?LanguageShimmer()
          : Focus(
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
              selectedItem:loginWatch.languageData??loginWatch.languageList.firstWhere((languageList) => languageList.code == Session.getAppLanguage()),

              fieldTextStyle:TextStyles.regular.copyWith(color: AppColors.black333333, fontSize: 12),
                onSelected: (value) async{

                  final selectedLangCode=  await loginWatch.updateAppLanguage(value.uuid);
                  if (selectedLangCode != null) {
                    if(Session.userAccessToken!=''){
                      await ref.read(profileController).changeLanguageApi(context).then((val) async {
                        if(ref.read(profileController).changeLanguageState.success?.status == ApiEndPoints.apiStatus_200){
                          final newLocale = Locale(selectedLangCode);
                          await context.setLocale(newLocale);
                          ref.read(loginController).rebuildUI();
                          ref.read(profileController).rebuildUI();
                          loginWatch.languageController.text = (value.name??'').capitalizeFirstLetterOfSentence;
                        }
                      });
                      await ref.read(drawerController).getSideMenuListAPI(context,isNotify: true);
                      ref.read(drawerController).updateSelectedMainScreen(ScreenName.dashboard);


                    }else{
                      final newLocale = Locale(selectedLangCode);
                      await context.setLocale(newLocale);
                      ref.read(loginController).rebuildUI();
                      ref.read(profileController).rebuildUI();
                      loginWatch.languageController.text = (value.name??'').capitalizeFirstLetterOfSentence;
                    }



                  }

                },

                textEditingController: loginWatch.languageController,
                items: loginWatch.languageList,
                title: (LanguageModel language) {
                  return language.name?.capitalizeFirstLetterOfSentence ?? '';
                },
              ),
          ),
    );
  }
}
