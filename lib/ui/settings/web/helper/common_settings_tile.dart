import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:odigov3/framework/controller/settings/settings_controller.dart';
import 'package:odigov3/framework/repository/settings/model/response_model/settings_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/settings/web/helper/edit_key_dialog.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_switch_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonSettingTile extends ConsumerWidget {
  final SettingsData? settingsData;
  final void Function(bool) onSwitchChanged;
  final bool? Function()? isSwitchLoading;

  const CommonSettingTile({super.key, required this.settingsData, required this.onSwitchChanged, this.isSwitchLoading});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingWatch = ref.watch(settingsController);
    return Row(
      children: [
        /// title
        CommonText(
          title: settingsData?.fieldName?.replaceAll('_', ' ').toLowerCase().capsFirstLetterOfSentence ?? '',
          style: TextStyles.regular.copyWith(fontSize: 14, color: AppColors.clr7C7474),
        ),
        const Spacer(),

        /// value
        if(settingsData?.fieldValue?.toLowerCase() != 'true' && settingsData?.fieldValue?.toLowerCase() != 'false')
          CommonText(
            title: settingsData?.fieldValue ?? '',
            style: TextStyles.regular.copyWith(fontSize: 14, color: AppColors.black),
            maxLines: 5,
          ),
        SizedBox(width: context.width * 0.02),

        /// edit button or switch
        (settingsData?.fieldValue?.toLowerCase() != 'true' && settingsData?.fieldValue?.toLowerCase() != 'false')
            ? InkWell(
                onTap: () {
                  settingWatch.keyController.text = settingsData?.fieldValue ?? '';
                  showCommonWebDialog(
                    keyBadge: settingWatch.editKeyDialogKey,
                    width: 0.4,
                    context: context,
                    dialogBody: EditKeyDialog(
                      settingsData: settingsData,
                      title: '${LocaleKeys.keyEdit.localized} ${settingsData?.fieldName?.replaceAll('_', ' ').toLowerCase()}',
                      validationMessage: '${settingsData?.fieldName?.replaceAll('_', ' ').toLowerCase().capsFirstLetterOfSentence}${LocaleKeys.keyIsRequired.localized}',
                      hintText: '${settingsData?.fieldName?.replaceAll('_', ' ').toLowerCase().capsFirstLetterOfSentence}',
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.clr9E9E9E, width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.all(context.height * 0.008),
                  child: Row(
                    children: [
                      /// edit icon
                      SvgPicture.asset(Assets.svgs.svgEditPen.keyName, height: context.height * 0.025).paddingOnly(right: context.width * 0.004),

                      /// edit text
                      CommonText(
                        title: LocaleKeys.keyEdit.localized,
                        style: TextStyles.medium.copyWith(fontSize: 14, color: AppColors.black),
                      ),
                    ],
                  ),
                ),
              )
            /// switch
            : Transform.scale(
              scale: 0.8,
              child: SizedBox(
                height: context.height * 0.04,
                width: context.width * 0.04,
                child: isSwitchLoading?.call() == true
                      ? Center(child: LoadingAnimationWidget.waveDots(color: AppColors.black, size: 20),)
                      : CommonCupertinoSwitch(switchValue: (settingsData?.fieldValue ?? 'false').toBool(), onChanged: (val) => onSwitchChanged(val)),
              ),
            ),
      ],
    ).paddingOnly(top: context.height * 0.015);
  }
}
