import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/device_details_controller.dart';
import 'package:odigov3/framework/repository/device/model/device_list_model.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/device/web/helper/device_details_common_tile_widget_web.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class DeviceDetailsTopLeftWidgetWeb extends ConsumerWidget {
  const DeviceDetailsTopLeftWidgetWeb({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final deviceDetailsWatch = ref.read(deviceDetailsController);
    DeviceData? deviceData = deviceDetailsWatch.deviceDetailsState.success?.data;
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
              color: AppColors.black,
            ),
          ).paddingOnly(bottom: 20),

          /// Host name
          DeviceDetailsCommonTileWidgetWeb(
            title:LocaleKeys.keyHostName.localized,
            value: deviceData?.hostName??'-',
          ).paddingOnly(bottom: 15),

          /// Navigation version
          DeviceDetailsCommonTileWidgetWeb(
            title:LocaleKeys.keyNavigationVersion.localized,
            value: deviceData?.navigationVersion??'-',
          ).paddingOnly(bottom: 15),

          /// Serial number
          DeviceDetailsCommonTileWidgetWeb(
            title:LocaleKeys.keySerialNumber.localized,
            value: deviceData?.serialNumber??'-',
          ).paddingOnly(bottom: 15),

          /// Robot uuid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: CommonText(
                  title: LocaleKeys.keyRobotUUID.localized,
                  style: TextStyles.regular.copyWith(
                    fontSize: 15,
                    color:  AppColors.clr7C7474,
                  ),
                ),
              ),
              const Spacer(flex: 1,),
              Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      CommonText(
                        title: deviceData?.uuid??'-',
                        style: TextStyles.regular.copyWith(
                          fontSize: 15,
                          color:  AppColors.black,
                        ),
                        maxLines: 2,
                      ).paddingOnly(right: 15),

                      InkWell(
                        onTap: (){
                          Clipboard.setData(ClipboardData(text: deviceData?.uuid ?? ''));
                          showToast(context: context,isSuccess: true,title:LocaleKeys.keyCopiedToClipboard.localized);
                        },
                        child: CommonSVG(
                          strIcon: Assets.svgs.svgCopy.keyName,
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          ).paddingOnly(bottom: 15),

          /// PowerBoard number
          DeviceDetailsCommonTileWidgetWeb(
            title:LocaleKeys.keyPowerboardVersion.localized,
            value: deviceData?.powerBoardVersion??'-',
          ),
        ],
      ).paddingAll(20),
    );
  }
}
