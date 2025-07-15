import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/device_details_controller.dart';
import 'package:odigov3/framework/repository/device/model/device_list_model.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_check_box.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class DeviceDetailsSensorWidgetWeb extends ConsumerWidget {
  const DeviceDetailsSensorWidgetWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceDetailsWatch = ref.read(deviceDetailsController);
    DeviceData? deviceData = deviceDetailsWatch.deviceDetailsState.success?.data;
    return Container(
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
                  AbsorbPointer(
                    absorbing: true,
                    child: CommonCheckBox(checkValue: deviceData?.sensorDetails?.isImuOk ?? false, onChanged: (bool) {}),
                  ),
                  CommonText(
                    title: LocaleKeys.keyIMU.localized,
                    style: TextStyles.regular.copyWith(fontSize: 13, color: deviceData?.sensorDetails?.isImuOk??false? AppColors.black: AppColors.black.withValues(alpha:0.5)),
                  ).paddingOnly(left: 5),
                ],
              ).paddingOnly(right: 10),

              /// ODOM
              Row(
                children: [
                  AbsorbPointer(
                    absorbing: true,
                    child: CommonCheckBox(checkValue: deviceData?.sensorDetails?.isOdomOk ?? false, onChanged: (bool) {}),
                  ),
                  CommonText(
                    title: LocaleKeys.keyODOM.localized,
                    style: TextStyles.regular.copyWith(fontSize: 13, color: deviceData?.sensorDetails?.isOdomOk??false? AppColors.black: AppColors.black.withValues(alpha:0.5)),
                  ).paddingOnly(left: 5),
                ],
              ).paddingOnly(right: 10),

              /// 3D Camera
              Row(
                children: [
                  AbsorbPointer(
                    absorbing: true,
                    child: CommonCheckBox(checkValue: deviceData?.sensorDetails?.is3DCameraOk ?? false, onChanged: (bool) {}),
                  ),
                  CommonText(
                    title: LocaleKeys.key3DCamera.localized,
                    style: TextStyles.regular.copyWith(fontSize: 13, color: deviceData?.sensorDetails?.is3DCameraOk??false? AppColors.black: AppColors.black.withValues(alpha:0.5)),
                  ).paddingOnly(left: 5),
                ],
              ).paddingOnly(right: 10),

              /// Lidar
              Row(
                children: [
                  AbsorbPointer(
                    absorbing: true,
                    child: CommonCheckBox(checkValue: deviceData?.sensorDetails?.isLidarOk ?? false, onChanged: (bool) {}),
                  ),
                  CommonText(
                    title: LocaleKeys.keyLIDAR.localized,
                    style: TextStyles.regular.copyWith(fontSize: 13, color: deviceData?.sensorDetails?.isLidarOk??false? AppColors.black: AppColors.black.withValues(alpha:0.5)),
                  ).paddingOnly(left: 5),
                ],
              ).paddingOnly(right: 10),
            ],
          ),
        ],
      ).paddingAll(20),
    );
  }
}
