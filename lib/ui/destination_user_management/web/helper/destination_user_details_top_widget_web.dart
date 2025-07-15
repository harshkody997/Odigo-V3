import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_details_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/repository/destination_user_management/model/destination_user_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/destination_user_management/web/helper/destination_user_change_password_dialog.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_initials_text_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class DestinationUserDetailsTopWidgetWeb extends ConsumerWidget {
  const DestinationUserDetailsTopWidgetWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userWatch = ref.read(destinationUserDetailsController);
    DestinationUserData? userData = userWatch.destinationUserDetailsState.success?.data;
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CommonInitialTextWidget(
              text: userData?.name ?? '',
            ).paddingOnly(right: 30),
            CommonText(
              title: userData?.name ?? '',
              style: TextStyles.semiBold.copyWith(fontSize: 22, color: AppColors.black),
            ),
          ],
        ),
        (userData?.active ?? false) && (selectedMainScreen?.canEdit ?? false)
            ? InkWell(
                onTap: () {
                  showCommonWebDialog(
                    context: context,
                    keyBadge: userWatch.changePasswordDialogKey,
                    dialogBody: DestinationUserChangePasswordDialog(),
                    height: 0.6,
                    width: 0.35,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.transparent,
                    border: Border.all(color: AppColors.clrD0D5DD, width: 1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: context.width * 0.01),
                  child: Row(
                    children: [
                      /// edit icon
                      CommonSVG(strIcon:Assets.svgs.svgEditPen.keyName, height: 20).paddingOnly(right: context.width * 0.004),

                      /// edit text
                      CommonText(
                        title:  LocaleKeys.keyChangePassword.localized,
                        style: TextStyles.medium.copyWith(fontSize: 14, color: AppColors.black),
                      ),
                    ],
                  ),
                ),
              )
            : const Offstage(),
      ],
    );
  }
}
