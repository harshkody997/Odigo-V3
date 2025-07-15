import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/users_management/add_new_user_controller.dart';
import 'package:odigov3/framework/repository/user_management/model/response/users_data.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/user_management/web/helper/common_user_details_row_widget.dart';
import 'package:odigov3/ui/user_management/web/helper/dotted_line_widget.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class UserDetailsWeb extends ConsumerWidget {
  final String? userUuid;

  const UserDetailsWeb({super.key, this.userUuid});

  ///Build Override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addNewUserWatch = ref.watch(addNewUserController);
    UserData? userData = addNewUserWatch.getUserDetailsApiState.success?.data;
    bool? isLoading = addNewUserWatch.getUserDetailsApiState.isLoading;
    return BaseDrawerPageWidget(
      body: isLoading
          ? CommonAnimLoader()
          : Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            /// Image
                            Container(
                              alignment: Alignment.center,
                              height: context.height * 0.12,
                              width: context.height * 0.12,
                              decoration: BoxDecoration(color: AppColors.clr1F1E1F, shape: BoxShape.circle),
                              child: CommonText(
                                title: userData?.name?.isNotEmpty == true ? userData!.name![0] : '',
                                fontSize: 42,
                                fontWeight: TextStyles.fwExtraBold,
                                clrFont: AppColors.white,
                              ),
                            ).paddingOnly(right: 20),

                            /// User Name
                            CommonText(title: userData?.name ?? '', fontSize: 22, fontWeight: TextStyles.fwSemiBold),
                          ],
                        ),

                      ],
                    ),

                    /// Horizontal Dotted Line
                    DottedLine(
                      color: AppColors.clrE4E4E4,
                      strokeWidth: 1,
                      width: context.width,
                    ).paddingSymmetric(vertical: 20),

                    /// Mobile Number Row
                    CommonUserDetailsRowWidget(
                      title: LocaleKeys.keyMobileNumber.localized,
                      subTitle: userData?.contactNumber ?? '',
                    ).paddingOnly(bottom: 20),

                    /// Email Id Row
                    CommonUserDetailsRowWidget(
                      title: LocaleKeys.keyEmailId.localized,
                      subTitle: userData?.email ?? '',
                    ).paddingOnly(bottom: 20),

                    /// Role Type Row
                    CommonUserDetailsRowWidget(
                      title: LocaleKeys.keyRoleType.localized,
                      subTitle: userData?.roleName ?? '',
                    ).paddingOnly(bottom: 20),

                    /// Back Button
                    CommonButton(
                      height: 50,
                      width: 150,
                      buttonText: LocaleKeys.keyBack.localized,
                      borderColor: AppColors.clr9E9E9E,
                      backgroundColor: AppColors.transparent,
                      buttonTextColor: AppColors.clr787575,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ).alignAtBottomLeft(),
                  ],
                ).paddingSymmetric(horizontal: 25, vertical: 25),
              ),
            ),
    );
  }
}
