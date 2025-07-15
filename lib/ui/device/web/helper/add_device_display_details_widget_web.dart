import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/add_device_controller.dart';
import 'package:odigov3/framework/controller/device/device_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';
class AddDeviceDisplayDetailsWidgetWeb extends ConsumerWidget {
  final String? deviceId;
  const AddDeviceDisplayDetailsWidgetWeb({super.key,this.deviceId});

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

          /// Android id and package id
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 17,
                child: CommonInputFormField(
                  textEditingController: addDeviceWatch.androidIdCtr,
                  focusNode: addDeviceWatch.androidIdFocus,
                  hintText: LocaleKeys.keyAndroidID.localized,
                  onFieldSubmitted: (value){
                    addDeviceWatch.packageIdFocus.requestFocus();
                  },
                  validator: (value){
                    return  validateAndroidId(value);
                  },
                  maxLength: AppConstants.androidIdLength,
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 17,
                child: CommonInputFormField(
                  textEditingController: addDeviceWatch.packageIdCtr,
                  focusNode: addDeviceWatch.packageIdFocus,
                  hintText: LocaleKeys.keyPackageID.localized,
                  maxLength: AppConstants.packageNameLength,
                  onFieldSubmitted: (value) async{
                    if(addDeviceWatch.addDeviceFormKey.currentState?.validate()??false){
                      await addDeviceWatch.addUpdateDeviceApi(deviceUuid: deviceId).then((_){
                        if(addDeviceWatch.addUpdateDeviceState.success?.status == ApiEndPoints.apiStatus_200){
                          /// Success Toast
                          showToast(context: context,isSuccess:true,message: '${LocaleKeys.keyDevice.localized} ${deviceId !=null?LocaleKeys.keyUpdatedSuccessMsg.localized:LocaleKeys.keyCreatedSuccessMsg.localized}');
                          /// List api call
                          ref.read(deviceController).deviceListApi(false);
                          /// Pop
                          ref.read(navigationStackController).pop();
                        }
                      });
                    }
                  },
                  validator: (value){
                    return  validatePackageName(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ).paddingAll(20),
    ).paddingOnly(bottom: 20);
  }
}
