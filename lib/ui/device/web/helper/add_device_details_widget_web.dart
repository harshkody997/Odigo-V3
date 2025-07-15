import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/add_device_controller.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AddDeviceDetailsWidgetWeb extends ConsumerWidget {
  const AddDeviceDetailsWidgetWeb({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final addDeviceWatch = ref.watch(addDeviceController);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            title: LocaleKeys.keyDeviceDetails.localized,
            style: TextStyles.semiBold.copyWith(
              fontSize: 14,
            ),
          ).paddingOnly(bottom: 20),

          /// host name and serial number fields
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 17,
                child: CommonInputFormField(
                  textEditingController: addDeviceWatch.hostNameCtr,
                  focusNode: addDeviceWatch.hostNameFocus,
                  hintText: LocaleKeys.keyHostName.localized,
                  onFieldSubmitted: (value){
                    addDeviceWatch.serialNoFocus.requestFocus();
                  },
                  validator: (value){
                    return validateHostName(value);
                  },
                  maxLength: AppConstants.deviceDetailsLength,
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 17,
                child: CommonInputFormField(
                  textEditingController: addDeviceWatch.serialNoCtr,
                  focusNode: addDeviceWatch.serialNoFocus,
                  hintText: LocaleKeys.keySerialNumber.localized,
                  onFieldSubmitted: (value){
                    addDeviceWatch.navigationFocus.requestFocus();
                  },
                  validator: (value){
                    return validateSerialNo(value);
                  },
                  maxLength: AppConstants.deviceDetailsLength,
                ),
              ),
            ],
          ).paddingOnly(bottom: 25),

          /// Navigation version and powerboard version
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 17,
                child: CommonInputFormField(
                  textEditingController: addDeviceWatch.navigationVersionCtr,
                  focusNode: addDeviceWatch.navigationFocus,
                  hintText: LocaleKeys.keyNavigationVersion.localized,
                  onFieldSubmitted: (value){
                    addDeviceWatch.powerBoardVersionFocus.requestFocus();
                  },
                  validator: (value){
                    return validateNavigationVersion(value);
                  },
                  maxLength: AppConstants.deviceDetailsLength,
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 17,
                child: CommonInputFormField(
                  textEditingController: addDeviceWatch.powerBoardVersionCtr,
                  focusNode: addDeviceWatch.powerBoardVersionFocus,
                  hintText: LocaleKeys.keyPowerboardVersion.localized,
                  onFieldSubmitted: (value){
                    // addDeviceWatch.navigationFocus.requestFocus();
                  },
                  validator: (value){
                    return validatePowerBoardVersion(value);
                  },
                  maxLength: AppConstants.deviceDetailsLength,
                ),
              ),
            ],
          ).paddingOnly(bottom: 25),

        ],
      ).paddingAll(20),
    ).paddingOnly(bottom: 20);
  }
}
