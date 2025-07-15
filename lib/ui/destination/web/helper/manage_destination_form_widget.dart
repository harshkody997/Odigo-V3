import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/manage_destination_controller.dart';
import 'package:odigov3/framework/controller/master/destination_type/destination_type_list_controller.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/destination_type_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_image_upload_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';

class ManageDestinationFormWidget extends ConsumerWidget {
  const ManageDestinationFormWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manageDestinationWatch = ref.watch(manageDestinationController);
    final horizontalSpacing = context.height * 0.025;
    final verticalSpacing = context.height * 0.02;
    return SizedBox(
      // height: context.height * 0.48,
      child: CommonDashboardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              title: LocaleKeys.keyAddDestination.localized,
              style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
            ),
            SizedBox(height: verticalSpacing),
            DynamicLangFormManager.instance.dynamicWidget(manageDestinationWatch.destinationNameTextFields, DynamicFormEnum.DESTINATION_NAME),
            SizedBox(height: verticalSpacing),
            CommonSearchableDropdown<DestinationType>(
              isEnable: ref.read(manageDestinationController).destinationDetailsState.success?.data?.uuid == null,
              onSelected: (value) {
                manageDestinationWatch.selectedDestinationType = value;
                manageDestinationWatch.notifyListeners();
              },
              title: (value) {
                return (value.name ?? '');
              },
              textEditingController: manageDestinationWatch.selectDestinationTypeController,
              items: ref.watch(destinationTypeListController).destinationTypeList,
              validator: (value) => validateText(value, LocaleKeys.keyDestinationTypeIsRequired.localized),
              hintText: LocaleKeys.keySelectDestinationType.localized,
              onFieldSubmitted: (value) => FocusScope.of(context).nextFocus(),
            ),
            SizedBox(height: verticalSpacing),

            CommonInputFormField(
              focusNode: manageDestinationWatch.numberOfFloorFocusNode,
              textEditingController: manageDestinationWatch.numberOfFloorController,
              hintText: LocaleKeys.keyNumberOfFloor.localized,
              maxLength: AppConstants.maxLength3,
              textInputFormatter:[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) => validateText(value, LocaleKeys.keyNoOfFloorRequired.localized),
              onFieldSubmitted: (value) => manageDestinationWatch.passcodeFocusNode.requestFocus(),
            ),

            SizedBox(height: verticalSpacing),

            CommonInputFormField(
              focusNode: manageDestinationWatch.passcodeFocusNode,
              textEditingController: manageDestinationWatch.passcodeController,
              obscureText: !manageDestinationWatch.isPasscodeVisible,
              hintText: LocaleKeys.keyPasscode.localized,
              maxLength: AppConstants.maxLength6,
              validator: (password) => validatePasscode(password),
              textInputFormatter:[
                FilteringTextInputFormatter.digitsOnly,
              ],
              suffixWidget: InkWell(
                onTap: () {
                  manageDestinationWatch.updateIsPasscodeVisible(!manageDestinationWatch.isPasscodeVisible);
                },
                child: CommonSVG(strIcon: manageDestinationWatch.isPasscodeVisible ? Assets.svgs.svgHidePasswordSvg.path : Assets.svgs.svgShowPasswordSvg.path),
              ),
            ),

            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     // Expanded(
            //     //   child: CommonInputFormField(
            //     //     textEditingController: manageDestinationWatch.passwordController,
            //     //     obscureText: !manageDestinationWatch.isPasswordVisible,
            //     //     hintText: LocaleKeys.keyPassword.localized,
            //     //     validator: (password) => validatePassword(password),
            //     //     suffixWidget: InkWell(
            //     //       onTap: () {
            //     //         manageDestinationWatch.updateIsPasswordVisible(!manageDestinationWatch.isPasswordVisible);
            //     //       },
            //     //       child: CommonSVG(strIcon: manageDestinationWatch.isPasswordVisible ? Assets.svgs.svgPasswordHide.path : Assets.svgs.svgPasswordUnhide.path),
            //     //     ),
            //     //   ),
            //     // ),
            //     Expanded(
            //       child: CommonInputFormField(
            //         focusNode: manageDestinationWatch.numberOfFloorFocusNode,
            //         textEditingController: manageDestinationWatch.numberOfFloorController,
            //         hintText: LocaleKeys.keyNumberOfFloor.localized,
            //         maxLength: AppConstants.maxLength3,
            //         textInputFormatter:[
            //           FilteringTextInputFormatter.digitsOnly,
            //         ],
            //         validator: (value) => validateText(value, LocaleKeys.keyNoOfFloorRequired.localized),
            //         onFieldSubmitted: (value) => manageDestinationWatch.passcodeFocusNode.requestFocus(),
            //       ),
            //     ),
            //     SizedBox(width: horizontalSpacing),
            //     Expanded(
            //       child: CommonInputFormField(
            //         focusNode: manageDestinationWatch.passcodeFocusNode,
            //         textEditingController: manageDestinationWatch.passcodeController,
            //         obscureText: !manageDestinationWatch.isPasscodeVisible,
            //         hintText: LocaleKeys.keyPasscode.localized,
            //         maxLength: AppConstants.maxPasswordLength,
            //         validator: (password) => validatePasscode(password),
            //         suffixWidget: InkWell(
            //           onTap: () {
            //             manageDestinationWatch.updateIsPasscodeVisible(!manageDestinationWatch.isPasscodeVisible);
            //           },
            //           child: CommonSVG(strIcon: manageDestinationWatch.isPasscodeVisible ? Assets.svgs.svgHidePasswordSvg.path : Assets.svgs.svgShowPasswordSvg.path),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: verticalSpacing),
            CommonImageUploadFormField(
              labelText: LocaleKeys.keyDestinationImage.localized,
              selectedImage: manageDestinationWatch.destinationImage,
              cacheImage: manageDestinationWatch.destinationDetailsState.success?.data?.imageUrl,
              onImageSelected: (image) {
                manageDestinationWatch.destinationImage = image;
                manageDestinationWatch.notifyListeners();
              },
              onImageRemoved: () {
                manageDestinationWatch.destinationImage = null;
                manageDestinationWatch.destinationDetailsState.success?.data?.imageUrl = null;
                manageDestinationWatch.notifyListeners();
              },
            ),
          ],
        ),
      ),
    );
  }
}
