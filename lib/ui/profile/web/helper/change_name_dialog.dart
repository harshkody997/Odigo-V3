import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/profile/profile_controller.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class ChangeNameDialog extends ConsumerStatefulWidget {
  const ChangeNameDialog({super.key});

  @override
  ConsumerState<ChangeNameDialog> createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends ConsumerState<ChangeNameDialog> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final profileWatch = ref.watch(profileController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ///Change Mobile Title
        Row(
          children: [
            ///Back Icon
            InkWell(
              onTap: () {
                profileWatch.clearFormData();
                profileWatch.disposeKeys();
                Navigator.pop(context);
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgLeftArrow.keyName,
                height: context.height * 0.020,
                width: context.height * 0.020,
              ),
            ),
            SizedBox(width: context.width * 0.01),

            ///Change Mobile title
            CommonText(
              title: LocaleKeys.keyChangeName.localized,
              style: TextStyles.bold.copyWith(
                fontSize: 24,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: context.height * 0.01),

        const Spacer(),

        ///Name Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: profileWatch.changeMobileKey,
              child: Column(
                children: [
                  CommonInputFormField(
                    textEditingController: profileWatch.newNameController,
                    hintText: LocaleKeys.keyNewName.localized,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) async {
                      if ((profileWatch.changeMobileKey.currentState?.validate() ?? false) && context.mounted) {
                        await changeNameApi(context,ref);
                      }
                      },
                    onChanged: (value) {
                      profileWatch.validateNewName();
                    },
                    validator: (value) {
                      return validateText(
                        value,
                        LocaleKeys.keyNameIsRequired.localized,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),

        ///Change Submit
        CommonButton(
          onTap: () async {
            if ((profileWatch.changeMobileKey.currentState?.validate() ?? false) && context.mounted) {
              await changeNameApi(context,ref);
            }
          },

          height: context.height * 0.080,
          isLoading: profileWatch.changeNameState.isLoading,
          buttonText: LocaleKeys.keySave.localized,
        ),
      ],
    ).paddingSymmetric(
      horizontal: context.height * 0.050,
      vertical: context.height * 0.030,
    );
  }

  ///Change Name Api
  changeNameApi(BuildContext context,WidgetRef ref) async{
    final profileWatch = ref.watch(profileController);
    ///Change name Api
    await profileWatch.changeName(context);
    if(profileWatch.changeNameState.success?.status==ApiEndPoints.apiStatus_200 && context.mounted){
      if(context.mounted){
        Navigator.pop(profileWatch.changeMobileKey.currentContext!);
        ///Success Dialog
        profileWatch.getProfileDetail(context, ref);
      }
    }
  }
}
