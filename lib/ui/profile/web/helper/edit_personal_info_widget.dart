import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/profile/profile_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/profile/web/helper/change_email_dialog.dart';
import 'package:odigov3/ui/profile/web/helper/change_mobile_dialog.dart';
import 'package:odigov3/ui/profile/web/helper/change_name_dialog.dart';
import 'package:odigov3/ui/profile/web/helper/change_password_dialog.dart';
import 'package:odigov3/ui/profile/web/helper/common_edit_data_row.dart';
import 'package:odigov3/ui/profile/web/helper/dot_lines_widget.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class EditPersonalInfoWidget extends ConsumerStatefulWidget {
  const EditPersonalInfoWidget({super.key});

  @override
  ConsumerState<EditPersonalInfoWidget> createState() =>
      _EditPersonalInfoWidgetState();
}

class _EditPersonalInfoWidgetState
    extends ConsumerState<EditPersonalInfoWidget> {
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
      children: [
        ///Title
        CommonText(
          title: LocaleKeys.keyDetails.localized,
          style: TextStyles.semiBold.copyWith(
            fontSize: 16,
            color: AppColors.black,
          ),
        ),

        ///Admin name
        Row(
          children: [
            CommonText(
              title: LocaleKeys.keyAdminName.localized,
              style: TextStyles.regular.copyWith(
                fontSize: 16,
                color: AppColors.clr7C7474,
              ),
            ),
            Spacer(),
            CommonText(
              title: profileWatch.profileDetailState.success?.data?.name ?? '',
              style: TextStyles.regular.copyWith(
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
            SizedBox(width: context.width * 0.015),
            ///edit button
            Visibility(
              visible: profileWatch.profileDetailState.success?.data?.roleName != RoleType.SUPER_ADMIN.name,
              child: InkWell(
                onTap: () {
                  profileWatch.clearFormData();
                  profileWatch.disposeKeys();
                  showCommonWebDialog(
                    context: context,
                    keyBadge: profileWatch.changeEmailDialogKey,
                    height: 0.35,
                    width: 0.35,
                    dialogBody: const ChangeNameDialog(),
                  );
                },
                child: Container(
                  height: context.height * 0.06,
                  width: context.width * 0.065,
                  decoration: BoxDecoration(
                    color: AppColors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: AppColors.greyD0D5DD),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonSVG(strIcon:  Assets.svgs.svgEdit2.path),
                      CommonText(
                        title: LocaleKeys.keyEdit.localized,
                        style: TextStyles.medium.copyWith(
                          fontSize: 14,
                          color: AppColors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ).paddingSymmetric(vertical: context.height * 0.025),

        ///change email
        CommonEditDataRow(
          label: LocaleKeys.keyEmailId.localized,
          value: profileWatch.profileDetailState.success?.data?.email ?? '',
          buttonText: LocaleKeys.keyChangeEmail.localized,
          onButtonTap: () {
            profileWatch.clearFormData();
            profileWatch.disposeKeys();
            showCommonWebDialog(
              context: context,
              keyBadge: profileWatch.changeEmailDialogKey,
              dialogBody: const ChangeEmailDialog(),
              height: 0.54,
              width: 0.4,
            );
          },
        ),

        ///change mobile
        CommonEditDataRow(
          label: LocaleKeys.keyMobileNumber.localized,
          value: profileWatch.profileDetailState.success?.data?.contactNumber ?? '',
          buttonText: LocaleKeys.keyChangeContact.localized,
          onButtonTap: () {
            ///clear data before opening dialog
            profileWatch.clearFormData();
            profileWatch.disposeKeys();
            showCommonWebDialog(
              context: context,
              keyBadge: profileWatch.changeEmailDialogKey,
              height: 0.45,
              width: 0.35,
              dialogBody: const ChangeMobileDialog(),
            );
          },
        ),
        Spacer(),

        ///Dot lines widget
        DotLinesWidget(),
        SizedBox(height: context.height * 0.03),
        Row(
          children: [
            ///change password button
            CommonButton(
              height: 48,
              width: 144,
              onTap: () {
                profileWatch.clearFormData();
                profileWatch.disposeKeys();
                showCommonWebDialog(
                    keyBadge: profileWatch.sendOtpDialogKey,
                    context: context,
                    dialogBody: const ChangePasswordDialog(),
                    height: 0.69,
                    width: 0.5
                );
              },
              buttonText: LocaleKeys.keyChangePassword.localized,
            ),
            SizedBox(width: context.width * 0.023),

            ///Back button
            CommonButton(
              height: 48,
              width: 145,
              onTap: () {
                ref.read(navigationStackController).pop();

              },
              buttonText: LocaleKeys.keyBack.localized,
              backgroundColor: AppColors.transparent,
              borderColor: AppColors.greyD0D5DD,
              buttonTextStyle: TextStyles.medium.copyWith(
                fontSize: 14,
                color: AppColors.clr787575,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
