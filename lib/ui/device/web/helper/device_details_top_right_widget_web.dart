import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/device_details_controller.dart';
import 'package:odigov3/framework/repository/device/model/device_list_model.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/device/web/helper/device_details_common_tile_widget_web.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class DeviceDetailsTopRightWidgetWeb extends ConsumerWidget {
  const DeviceDetailsTopRightWidgetWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceDetailsWatch = ref.read(deviceDetailsController);
    DeviceData? deviceData = deviceDetailsWatch.deviceDetailsState.success?.data;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            title: LocaleKeys.keyDisplayDetails.localized,
            style: TextStyles.semiBold.copyWith(
              fontSize: 14,
              color: AppColors.black,
            ),
          ).paddingOnly(bottom: 20),

          /// Andorid id
          DeviceDetailsCommonTileWidgetWeb(
            title:LocaleKeys.keyAndroidID.localized,
            value: deviceData?.deviceDetails?.firstOrNull?.applicationId??'-',
          ).paddingOnly(bottom: 15),

          /// Package id
          DeviceDetailsCommonTileWidgetWeb(
            title:LocaleKeys.keyPackageID.localized,
            value: deviceData?.deviceDetails?.firstOrNull?.packageId??'-',
          ).paddingOnly(bottom: 15),
        ],
      ).paddingAll(20),
    );
  }
}
