import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/robot_mapping/robot_mapping_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class RobotMappingDialog extends ConsumerStatefulWidget {
  const RobotMappingDialog({super.key});

  @override
  ConsumerState<RobotMappingDialog> createState() => _StoreMappingMobileState();
}

class _StoreMappingMobileState extends ConsumerState<RobotMappingDialog> {
  @override
  Widget build(BuildContext context) {
    final robotMappingWatch = ref.watch(robotMappingController);
    return Form(
      key: robotMappingWatch.robotMappingFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Row containing the dialog title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Localized title for the dialog
              CommonText(
                title: LocaleKeys.keyAssignRobot.localized,
                style: TextStyles.regular.copyWith(fontSize: 20, color: AppColors.black),
              ),

              /// Close icon to dismiss the dialog
              InkWell(
                onTap: () {
                  Navigator.pop(context); // Closes the dialog
                },
                child: CommonSVG(strIcon: Assets.svgs.svgClose.keyName),
              ),
            ],
          ).paddingOnly(bottom: context.height * 0.034),

          /// Text field to input the Robot ID
          CommonInputFormField(
            textEditingController: robotMappingWatch.robotIdController,
            hintText: LocaleKeys.keyRobotId.localized,
            fieldTextStyle: TextStyles.regular.copyWith(color: AppColors.black272727),
            maxLength: 25,
            placeholderText: LocaleKeys.keyRobotId.localized,

            /// Validator to ensure Robot ID is not empty
            validator: (value) {
              return validateTextIgnoreLength(value, LocaleKeys.keyRobotIdMustBeRequired.localized);
            },
          ).paddingOnly(bottom: context.height * 0.030),

          /// Save button that triggers form validation
          CommonButton(
            buttonText: LocaleKeys.keySave.localized,
            width: context.width * 0.070,
            height: context.height * 0.049,
            onTap: () {
              /// Validate the form; if valid, close the dialog
              final bool? result = robotMappingWatch.robotMappingFormKey.currentState?.validate();
              if (result == true) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.020),
    );
  }
}
