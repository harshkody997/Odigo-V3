import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/destination/manage_destination_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class ManageDestinationOwnerDetailsWidget extends ConsumerWidget {
  const ManageDestinationOwnerDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manageDestinationWatch = ref.watch(manageDestinationController);
    final horizontalSpacing = context.height * 0.025;
    final verticalSpacing = context.height * 0.02;
    return SizedBox(
      // height: context.height * 0.25,
      child: CommonDashboardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              title: LocaleKeys.keyOwnerDetails.localized,
              style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
            ),
            SizedBox(height: verticalSpacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CommonInputFormField(
                    focusNode: manageDestinationWatch.ownerNameFocusNode,
                    textEditingController: manageDestinationWatch.ownerNameController,
                    hintText: LocaleKeys.keyOwnerName.localized,
                    validator: (value) => validateText(value, LocaleKeys.keyOwnerNameRequired.localized),
                    onFieldSubmitted: (value) => manageDestinationWatch.ownerContactFocusNode.requestFocus(),
                    maxLength: AppConstants.maxLength60,
                  ),
                ),
                SizedBox(width: horizontalSpacing),
                Expanded(
                  child: CommonInputFormField(
                    focusNode: manageDestinationWatch.ownerContactFocusNode,
                    textEditingController: manageDestinationWatch.ownerContactController,
                    hintText: LocaleKeys.keyMobileNumber.localized,
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) => validateMobile(value),
                    onFieldSubmitted: (value) => manageDestinationWatch.ownerEmailIdFocusNode.requestFocus(),
                    maxLength: AppConstants.maxMobileLength,
                  ),
                ),
              ],
            ),
            SizedBox(height: verticalSpacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CommonInputFormField(
                    focusNode: manageDestinationWatch.ownerEmailIdFocusNode,
                    textEditingController: manageDestinationWatch.ownerEmailIdController,
                    hintText: LocaleKeys.keyEmailID.localized,
                    textInputFormatter: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    validator: (value) => validateEmail(value),
                    onFieldSubmitted: (value) => manageDestinationWatch.ownerPasswordFocusNode.requestFocus(),
                    maxLength: AppConstants.maxEmailLength,
                  ),
                ),
                if (manageDestinationWatch.destinationDetailsState.success?.data == null) ...{
                  SizedBox(width: horizontalSpacing),
                  Expanded(
                    child: CommonInputFormField(
                      focusNode: manageDestinationWatch.ownerPasswordFocusNode,
                      textEditingController: manageDestinationWatch.ownerPasswordController,
                      obscureText: !manageDestinationWatch.isOwnerPasswordVisible,
                      hintText: LocaleKeys.keyPassword.localized,
                      validator: (password) => validatePassword(password),
                      onFieldSubmitted: (value) => manageDestinationWatch.addressHouseNumberFocusNode.requestFocus(),
                      maxLength: AppConstants.maxPasswordLength,
                      suffixWidget: InkWell(
                        onTap: () {
                          manageDestinationWatch.updateIsOwnerPasswordVisible(!manageDestinationWatch.isOwnerPasswordVisible);
                        },
                        child: CommonSVG(strIcon: manageDestinationWatch.isOwnerPasswordVisible ? Assets.svgs.svgHidePasswordSvg.path : Assets.svgs.svgShowPasswordSvg.path),
                      ),
                    ),
                  ),
                },
              ],
            ),
          ],
        ),
      ),
    );
  }
}
