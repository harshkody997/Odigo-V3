import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/add_device_controller.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_check_box.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
class AddDeviceSenorDetailsWidgetWeb extends ConsumerWidget {
  const AddDeviceSenorDetailsWidgetWeb({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final addDeviceWatch = ref.watch(addDeviceController);
    return  Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          CommonText(
            title: LocaleKeys.keySensorDetails.localized,
            style: TextStyles.semiBold.copyWith(fontSize: 14),
          ).paddingOnly(bottom: 20),
          /// Sensor Info
          Row(
            children: [

              /// Imu
              Row(
                children: [
                  CommonCheckBox(
                    checkValue: addDeviceWatch.sensorDetails.isImuOk??false,
                    onChanged: (value) {
                      addDeviceWatch.updateSensorStatus(imuStatus: value);
                    },
                  ),
                  CommonText(
                    title: LocaleKeys.keyIMU.localized,
                    style: TextStyles.regular.copyWith(fontSize: 13, color:addDeviceWatch.sensorDetails.isImuOk??false? AppColors.black: AppColors.black.withValues(alpha:0.5)),
                  ).paddingOnly(left: 5),
                ],
              ).paddingOnly(right: 10),

              /// ODOM
              Row(
                children: [
                  CommonCheckBox(
                    checkValue: addDeviceWatch.sensorDetails.isOdomOk??false,
                    onChanged: (value) {
                      addDeviceWatch.updateSensorStatus(odomStatus: value);
                    },
                  ),
                  CommonText(
                    title: LocaleKeys.keyODOM.localized,
                    style: TextStyles.regular.copyWith(fontSize: 13, color: addDeviceWatch.sensorDetails.isOdomOk??false? AppColors.black: AppColors.black.withValues(alpha:0.5)),
                  ).paddingOnly(left: 5),
                ],
              ).paddingOnly(right: 10),

              /// 3D Camera
              Row(
                children: [
                  CommonCheckBox(
                      checkValue: addDeviceWatch.sensorDetails.is3DCameraOk??false,
                      onChanged: (value) {
                        addDeviceWatch.updateSensorStatus(cameraStatus: value);
                      }),
                  CommonText(
                    title: LocaleKeys.key3DCamera.localized,
                    style: TextStyles.regular.copyWith(fontSize: 13, color: addDeviceWatch.sensorDetails.is3DCameraOk??false? AppColors.black: AppColors.black.withValues(alpha:0.5)),
                  ).paddingOnly(left: 5),
                ],
              ).paddingOnly(right: 10),

              /// Lidar
              Row(
                children: [
                  CommonCheckBox(
                    checkValue: addDeviceWatch.sensorDetails.isLidarOk??false,
                    onChanged: (value) {
                      addDeviceWatch.updateSensorStatus(lidarStatus: value);
                    },
                  ),
                  CommonText(
                    title: LocaleKeys.keyLIDAR.localized,
                    style: TextStyles.regular.copyWith(fontSize: 13, color: addDeviceWatch.sensorDetails.isLidarOk??false? AppColors.black: AppColors.black.withValues(alpha:0.5)),
                  ).paddingOnly(left: 5),
                ],
              ).paddingOnly(right: 10),
            ],
          ),
        ],
      ).paddingAll(20),
    ).paddingOnly(bottom: 20);
  }
}
