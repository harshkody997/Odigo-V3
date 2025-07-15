import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/device_controller.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_radio_button.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class DeviceListFilterWidgetWeb extends ConsumerStatefulWidget {
  DeviceListFilterWidgetWeb({super.key});

  @override
  ConsumerState<DeviceListFilterWidgetWeb> createState() => _DeviceListFilterWidgetWebState();
}

class _DeviceListFilterWidgetWebState extends ConsumerState<DeviceListFilterWidgetWeb> {

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((callback){
      final deviceWatch = ref.read(deviceController);
      deviceWatch.prefillFilters();
    });
    super.initState();
  }
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final deviceWatch = ref.watch(deviceController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Title and cross button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///Filter title
            CommonText(
              title: LocaleKeys.keyFilters.localized,
              style: TextStyles.semiBold.copyWith(
                fontSize: 18,
                color: AppColors.clr101828,
              ),
            ),

            ///Cross Icon
            InkWell(
              onTap: () {
                Navigator.pop(context);
                deviceWatch.prefillFilters();
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgCrossIconBg.keyName,
                height: 30,
                width: 30,
              ),
            ),
          ],
        ).paddingOnly(left: context.width * 0.01,right: context.width*0.007,top: 10),
        Divider(
          color: AppColors.clrEAECF0,
          height: 0,
        ).paddingSymmetric(vertical: context.height * 0.018),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Status Filter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      title: LocaleKeys.keyStatusType.localized,
                      style: TextStyles.semiBold.copyWith(color: AppColors.clr101828,fontSize: 14),
                    ).paddingOnly(bottom: context.height * 0.02),
                    ...commonActiveDeActiveList.map(
                          (status) => CommonRadioButton<String>(
                            value: status.title,
                            title: status.title.localized,
                            borderRequired: true,
                            groupValue: deviceWatch.tempSelectedStatus.title,
                            onTap: () {
                              deviceWatch.changeTempSelectedStatus(status);
                            },
                          ).paddingOnly(bottom: 8),
                    ),
                  ],
                ).paddingOnly(left: context.width * 0.012, right: context.width * 0.012, bottom: context.height * 0.02,),

                Divider(color: AppColors.clrEAECF0, height: 1).paddingSymmetric(horizontal: context.width * 0.01,),

                /// Availability Filter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    CommonText(
                      title: LocaleKeys.keyAvailability.localized,
                      style: TextStyles.semiBold.copyWith(color: AppColors.clr101828,fontSize: 14),
                    ).paddingOnly(bottom: context.height * 0.02),

                    ...deviceWatch.availabilityStatusList.map(
                          (status) => CommonRadioButton<String>(
                            value: status.title,
                            title: status.title.localized,
                            borderRequired: true,
                            groupValue: deviceWatch.tempSelectedAvailability.title,
                            onTap: () {
                              deviceWatch.changeTempSelectedAvailability(status);
                            },
                          ).paddingOnly(bottom: 8),
                    ),
                  ],
                ).paddingOnly(left: context.width * 0.012, right: context.width * 0.012, bottom: context.height * 0.02,),

              ],
            ),
          ),
        ),


        Divider(color: AppColors.clrEAECF0, height: 1),

        /// Clear filter and apply filter button.
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ///Clear filter button
            Expanded(
              child: CommonButton(
                height: context.height * 0.065,
                onTap: () async {


                  if(
                  ( deviceWatch.selectedStatus.title == deviceWatch.tempSelectedStatus.title && (deviceWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll).title ))
                      ||
                      ( deviceWatch.selectedAvailabilityStatus.title == deviceWatch.tempSelectedAvailability.title && (deviceWatch.selectedAvailabilityStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll).title ))
                  ){
                    deviceWatch.clearFilters();
                    deviceWatch.deviceListApi(false);
                    Navigator.pop(
                      deviceWatch.filterKey.currentContext!,
                    );
                  }
                },
                buttonText: LocaleKeys.keyClearFilter.localized,
                backgroundColor: AppColors.transparent,
                borderColor: AppColors.clrD1D5DC,
                borderRadius: BorderRadius.circular(8),
                buttonTextStyle: TextStyles.semiBold.copyWith(
                  fontSize: 14,
                  color: AppColors.clr6A7282,
                ),
              ),
            ),

            SizedBox(width: context.width * 0.012),

            ///Apply filter button
            Expanded(
              child: CommonButton(
                height: context.height * 0.065,
                backgroundColor: (deviceWatch.selectedStatus.title != deviceWatch.tempSelectedStatus.title || deviceWatch.selectedAvailabilityStatus.title != deviceWatch.tempSelectedAvailability.title ) ?
                AppColors.clr2997FC:AppColors.clrDCDDFF,
                borderRadius: BorderRadius.circular(8),
                buttonTextStyle: TextStyles.regular.copyWith(
                  fontSize: 16,
                  color: AppColors.white,
                ),
                buttonText: '${LocaleKeys.keyApply.localized} ${LocaleKeys.keyFilters.localized}',
                onTap: () async {
                  if(deviceWatch.selectedStatus.title != deviceWatch.tempSelectedStatus.title || deviceWatch.selectedAvailabilityStatus.title != deviceWatch.tempSelectedAvailability.title ){
                    deviceWatch.applyFilters();
                    Navigator.pop(
                      deviceWatch.filterKey.currentContext!,
                    );
                    deviceWatch.deviceListApi(false);
                  }
                },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: context.width * 0.01, vertical: context.height * 0.016,).alignAtBottomCenter(),

      ],
    );
  }
}