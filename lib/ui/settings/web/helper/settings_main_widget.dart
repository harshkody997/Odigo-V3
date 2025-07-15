import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/auth/login_controller.dart';
import 'package:odigov3/framework/controller/settings/settings_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/settings/model/response_model/settings_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/settings/web/helper/common_settings_tile.dart';
import 'package:odigov3/ui/settings/web/helper/language_selection_dropdown.dart';
import 'package:odigov3/ui/settings/web/helper/settings_shimmer.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class SettingsMainWidget extends ConsumerWidget {
  const SettingsMainWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsWatch = ref.watch(settingsController);
    final loginWatch = ref.watch(loginController);
    return settingsWatch.settingsListState.isLoading || loginWatch.languageListState.isLoading
        ? CommonAnimLoader()
    : Container(
      height: double.infinity,
      color: AppColors.clrF7F9FB,
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.white),
          padding: EdgeInsets.all(context.height * 0.022),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// settings title
              CommonText(
                title: LocaleKeys.keySetting.localized,
                style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.black),
              ),
              ...List.generate(settingsWatch.settingsListState.success?.data?.length ?? 0, (index) {
                SettingsData? data = settingsWatch.settingsListState.success?.data?[index];
                return CommonSettingTile(settingsData: data, onSwitchChanged: (val) async {
                  if(!(data?.fieldValue?.toLowerCase() != 'true' && data?.fieldValue?.toLowerCase() != 'false')){
                    settingsWatch.updateStatusIndex(index);
                    await settingsWatch.updateSettingsApi(uuid: data?.uuid ?? '', encrypted: data?.encrypted ?? false, fieldName: data?.fieldName ?? '', fieldValue: val.toString());
                    if(settingsWatch.updateSettingsState.success?.status == ApiEndPoints.apiStatus_200) {
                      data?.fieldValue = val.toString();
                    }
                    settingsWatch.notify();
                  }
                },
                  isSwitchLoading: () => settingsWatch.updateSettingsState.isLoading && index == settingsWatch.statusTapIndex,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
