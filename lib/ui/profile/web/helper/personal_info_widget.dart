import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/profile/profile_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/auth/web/helper/login_form_dropdown_widget.dart';
import 'package:odigov3/ui/profile/web/helper/common_person_info_row.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/user_management/web/helper/dotted_line_widget.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class PersonalInfoWidget extends ConsumerStatefulWidget {
  const PersonalInfoWidget({super.key});

  @override
  ConsumerState<PersonalInfoWidget> createState() => _PersonalInfoWidgetState();
}

class _PersonalInfoWidgetState extends ConsumerState<PersonalInfoWidget> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final profileWatch = ref.watch(profileController);

    final isUser = Session.getEntityType() == 'USER';

    return isUser
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildProfileContent(context, profileWatch, ref),
    ).paddingSymmetric(
      vertical: context.height * 0.020,
      horizontal: context.width * 0.02,
    )
        : SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildProfileContent(context, profileWatch, ref),
      ).paddingSymmetric(
        vertical: context.height * 0.020,
        horizontal: context.width * 0.02,
      ),
    );
  }

  List<Widget> _buildProfileContent(BuildContext context, ProfileController profileWatch, WidgetRef ref) {
    final isUser = Session.getEntityType() == 'USER';

    return [
      /// Language dropdown
      Row(
        children: [
          LoginFormDropdownWidget(),
          Spacer()
        ],
      ),

      isUser
          ? Spacer()
          : SizedBox(height: context.height * 0.03),

      /// Profile Image
      CacheImage(
        imageURL: profileWatch.profileDetailState.success?.data?.profileImage ?? '',
        placeholderName: profileWatch.profileDetailState.success?.data?.name ?? '',
        height: context.height * 0.220,
        width: context.height * 0.220,
        bottomLeftRadius: context.height * 0.2,
        bottomRightRadius: context.height * 0.2,
        topLeftRadius: context.height * 0.2,
        topRightRadius: context.height * 0.2,
      ),

      isUser
          ? Spacer()
          : SizedBox(height: 0),

      /// Company name
      CommonText(
        title: profileWatch.profileDetailState.success?.data?.name ?? '',
        style: TextStyles.semiBold.copyWith(fontSize: 22),
        maxLines: 2,
      ).paddingSymmetric(vertical: context.height * 0.035),

      isUser
          ? Spacer()
          : SizedBox(height: 0),

      /// Email
      CommonPersonalInfoRow(
        svgAsset: Assets.svgs.svgEmailWithBackground.keyName,
        label: LocaleKeys.keyEmailId.localized,
        value: profileWatch.profileDetailState.success?.data?.email ?? '-',
      ).paddingSymmetric(vertical: context.height * 0.015),

      /// Mobile
      CommonPersonalInfoRow(
        svgAsset: Assets.svgs.svgPhoneWithBackground.keyName,
        label: LocaleKeys.keyPhoneNumber.localized,
        value: profileWatch.profileDetailState.success?.data?.contactNumber ?? '-',
      ),

      /// CMS List + Divider
      if (!isUser)
        Column(
          children: [
            DottedLine(
              color: AppColors.clrE4E4E4,
              strokeWidth: 1,
              width: context.width,
            ).paddingSymmetric(vertical: context.height * 0.035),

            ListView.separated(
              itemCount: profileWatch.cmsList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText(
                      title: profileWatch.cmsList[index].title?.localized ?? '',
                      style: TextStyles.regular.copyWith(fontSize: 14),
                      maxLines: 2,
                    ),
                    InkWell(
                      onTap: () {
                        final cmsEnum = [
                          CmsValueEnum.PRIVACY_POLICY,
                          CmsValueEnum.ABOUT_US,
                          CmsValueEnum.REFUND,
                          CmsValueEnum.TERMS_AND_CONDITION
                        ][index];

                        ref.read(navigationStackController).push(
                            NavigationStackItem.showCms(title: cmsEnum.name));
                      },
                      child: CommonSVG(
                        strIcon: Assets.svgs.svgRightArrow.keyName,
                        height: context.height * 0.033,
                        width: context.height * 0.033,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: context.height * 0.015),
            ),
          ],
        ),
    ];
  }
}
