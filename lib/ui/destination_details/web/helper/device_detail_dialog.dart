import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/repository/device/model/device_list_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/store/web/helper/common_title_desc_widget.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_check_box.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class DeviceDetailDialog extends StatelessWidget {
  final DeviceData? robotData;

  const DeviceDetailDialog({super.key, required this.robotData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              title: LocaleKeys.keyDeviceDetails.localized,
              style: TextStyles.regular.copyWith(fontSize: 20, color: AppColors.black),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CommonSVG(strIcon: Assets.svgs.svgClose.keyName),
            ),
          ],
        ).paddingOnly(bottom: context.height * 0.034),
        Expanded(
          child: ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expanded(
                  //   flex: 1,
                  //   child: commonTitleAndDesc(context, title: LocaleKeys.keyRobotType.localized, subtitle: "robotData").paddingOnly(right: context.width * 0.040),
                  // ),
                  Expanded(
                    flex: 1,
                    child: commonTitleAndDesc(
                      context,
                      title: LocaleKeys.keySerialNumber.localized,
                      subtitle: "#${robotData?.serialNumber ?? ''}",
                    ).paddingOnly(right: context.width * 0.040),
                  ),
                  Expanded(
                    flex: 1,
                    child: commonTitleAndDesc(context, title: LocaleKeys.keyHostName.localized, subtitle: robotData?.hostName ?? ''),
                  ),
                  Spacer()
                ],
              ).paddingOnly(bottom: context.height * 0.035),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: commonTitleAndDesc(
                      context,
                      title: LocaleKeys.keyNavigationNumber.localized,
                      subtitle: robotData?.navigationVersion ?? '',
                    ).paddingOnly(right: context.width * 0.040),
                  ),
                  Expanded(
                    flex: 2,
                    child: commonTitleAndDesc(
                      context,
                      title: LocaleKeys.keyPowerboardNumber.localized,
                      subtitle: robotData?.powerBoardVersion ?? '',
                    ).paddingOnly(right: context.width * 0.040),
                  ),
                ],
              ).paddingOnly(bottom: context.height * 0.035),
              const Divider(
                color: AppColors.lightPinkF7F7FC,
              ).paddingOnly(bottom: context.height * 0.010),
              CommonText(
                title: LocaleKeys.keySensorDetails.localized,
                style: TextStyles.regular.copyWith(fontSize: 20),
              ).paddingOnly(bottom: context.height * 0.024),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: context.width * 0.12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              title: LocaleKeys.keyIMU.localized,
                              style: TextStyles.regular.copyWith(color: AppColors.black),
                            ),
                            CommonCheckBox(
                              checkValue: robotData?.sensorDetails?.isImuOk ?? false,
                              onChanged: (value) {
                                // DynamicMultipleSelectionHelper.helper.isAllSelectedUpdate(ref,value,widget.field,allFields:  widget.field.possibleValues );
                              },
                            ),
                          ],
                        ),
                      ).paddingOnly(right: context.width * 0.020),
                      SizedBox(
                        width: context.width * 0.12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              title: LocaleKeys.key3DCamera.localized,
                              style: TextStyles.regular.copyWith(color: AppColors.black),
                            ),
                            CommonCheckBox(
                              checkValue: robotData?.sensorDetails?.is3DCameraOk ?? false,
                              onChanged: (value) {
                                // DynamicMultipleSelectionHelper.helper.isAllSelectedUpdate(ref,value,widget.field,allFields:  widget.field.possibleValues );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: context.height * 0.010),

                  Row(
                    children: [
                      SizedBox(
                        width: context.width * 0.12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              title: LocaleKeys.keyODOM.localized,
                              style: TextStyles.regular.copyWith(color: AppColors.black),
                            ),

                            CommonCheckBox(
                              checkValue: robotData?.sensorDetails?.isOdomOk ?? false,
                              onChanged: (value) {
                                // DynamicMultipleSelectionHelper.helper.isAllSelectedUpdate(ref,value,widget.field,allFields:  widget.field.possibleValues );
                              },
                            ),
                          ],
                        ),
                      ).paddingOnly(right: context.width * 0.020),
                      SizedBox(
                        width: context.width * 0.12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              title: LocaleKeys.keyLIDAR.localized,
                              style: TextStyles.regular.copyWith(color: AppColors.black),
                            ),
                            CommonCheckBox(
                              checkValue: robotData?.sensorDetails?.isLidarOk ?? false,
                              onChanged: (value) {
                                // DynamicMultipleSelectionHelper.helper.isAllSelectedUpdate(ref,value,widget.field,allFields:  widget.field.possibleValues );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Consumer(
              //     builder: (context, ref, child) {
              //       final robotListWatch = ref.watch(robotListController);
              //
              //       return GridView.count(
              //           shrinkWrap: true,
              //           crossAxisCount: 2,
              //           mainAxisSpacing: 2,
              //           childAspectRatio: 9/1,
              //           children: List.generate(robotListWatch.sensorDetail.length, (index) {
              //             return Row(
              //               children: [
              //                 CommonText(title:  robotListWatch.sensorDetail[index], textStyle: TextStyles.regular.copyWith(color: AppColors.black)),
              //                 CommonCheckBox(
              //                   value: true,
              //                   onChanged: (value) {
              //                     // DynamicMultipleSelectionHelper.helper.isAllSelectedUpdate(ref,value,widget.field,allFields:  widget.field.possibleValues );
              //                   },
              //                 ),
              //               ],
              //             );
              //           },
              //           ));
              //     }
              // ).paddingOnly(bottom: context.height * 0.030),
              const Divider(
                color: AppColors.lightPinkF7F7FC,
              ).paddingOnly(bottom: context.height * 0.01),
              /*GridView.count(
                shrinkWrap: true,
                childAspectRatio: 3.30,
                crossAxisCount: 2,
                // Number of columns
                crossAxisSpacing: context.width * 0.010,
                mainAxisSpacing: context.height * 0.020,
                children: List.generate(robotData?.deviceDetails?.length ?? 0, (index) {
                  return Container(
                    // height: context.height * 0.100,
                    padding: EdgeInsets.symmetric(horizontal: context.width * 0.010, vertical: context.height * 0.020),
                    decoration: BoxDecoration(
                      color: AppColors.whiteF7F7FC,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            commonTitleAndDesc(
                              context,
                              title: LocaleKeys.keyAndroidID.localized,
                              subtitle: robotData?.deviceDetails?[index].applicationId ?? '',
                            ).paddingOnly(right: context.width * 0.020),
                            commonTitleAndDesc(context, title: LocaleKeys.keyPackageID.localized, subtitle: robotData?.deviceDetails?[index].packageId ?? ''), // Expanded(child
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),*/

              /// convert grid to wrap to avoid render overflow
              Wrap(
                spacing: context.width * 0.010,
                runSpacing: context.height * 0.020,
                children: List.generate(robotData?.deviceDetails?.length ?? 0, (index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.width * 0.010,
                      vertical: context.height * 0.020,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.whiteF7F7FC,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: context.width * 0.020,
                          runSpacing: context.height * 0.010,
                          children: [
                            commonTitleAndDesc(
                              context,
                              title: LocaleKeys.keyAndroidID.localized,
                              subtitle: robotData?.deviceDetails?[index].applicationId ?? '',
                            ),
                            commonTitleAndDesc(
                              context,
                              title: LocaleKeys.keyPackageID.localized,
                              subtitle: robotData?.deviceDetails?[index].packageId ?? '',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030);
  }
}
