import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_shown_time/ads_shown_time_controller.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_radio_button.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/common_range_date_picker.dart';


class AdsShownTimeListFilter extends ConsumerStatefulWidget {
  AdsShownTimeListFilter({super.key});

  @override
  ConsumerState<AdsShownTimeListFilter> createState() => _AdsShownTimeListFilterState();
}

class _AdsShownTimeListFilterState extends ConsumerState<AdsShownTimeListFilter> {

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((callback){
      final adsShownTimeListWatch = ref.watch(adsShownTimeController);
      adsShownTimeListWatch.prefillFilters();
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
    final adsShownTimeListWatch = ref.watch(adsShownTimeController);
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
                adsShownTimeListWatch.prefillFilters();
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

                ///Purchase type Filter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      title: LocaleKeys.keyFilterByPurchaseType.localized,
                      style: TextStyles.semiBold.copyWith(color: AppColors.clr101828,fontSize: 14),
                    ).paddingOnly(bottom: context.height * 0.02),
                    ...adsShownTimeListWatch.purchaseTypeList.map(
                          (status) => CommonRadioButton<String>(
                        value: status.title,
                        title: status.title.localized,
                        borderRequired: true,
                        groupValue: adsShownTimeListWatch.tempSelectedPurchaseType.title,
                        onTap: () {
                          adsShownTimeListWatch.changePurchaseTypeSelectedStatus(status);
                        },
                      ).paddingOnly(bottom: 8),
                    ),
                    Divider(
                      color: AppColors.clrEAECF0,
                      height: 0,
                    ).paddingSymmetric(vertical: context.height * 0.018),
                  ],
                ).paddingOnly(left: context.width * 0.012, right: context.width * 0.012),

                ///Date filter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///filter by date text
                    CommonText(
                      title: LocaleKeys.keyFilterByPurchaseDate.localized,
                      style: TextStyles.semiBold.copyWith(color: AppColors.clr101828,fontSize: 14),
                    ).paddingOnly(bottom: context.height * 0.02),

                    ///date selection field
                    InkWell(
                      onTap: () async {
                        ///Range Date Picker
                        commonRangeDatePickerDialog(
                          context,
                          isRangePicker: true,
                          selectedStartDate: adsShownTimeListWatch.tempSelectedStartDate,
                          selectedEndDate:  adsShownTimeListWatch.tempSelectedEndDate,
                          firstDate: DateTime(2025, 1, 1),
                          onSelect: (dateList) {
                            ///Change Selected Date Value
                            adsShownTimeListWatch.changeDateValue(dateList);
                          },
                        );
                      },
                      child: CommonInputFormField(
                        hintText: LocaleKeys.keyDDMMYYYY.localized,
                        isEnable: false,
                        prefixWidget: CommonSVG(
                          strIcon: Assets.svgs.svgCalendar.keyName,
                          height: 10,
                          width: 10,
                          boxFit: BoxFit.scaleDown,
                        ),
                        fontSize: 13,
                        hintTextStyle: TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 13),
                        textEditingController: adsShownTimeListWatch.dateController,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          ///Date Validation
                          return null;
                        },
                      ),
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
                  ( adsShownTimeListWatch.selectedPurchaseType.title == adsShownTimeListWatch.tempSelectedPurchaseType.title && (adsShownTimeListWatch.selectedPurchaseType.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll).title ))
                      ||  ((adsShownTimeListWatch.selectedStartDate == adsShownTimeListWatch.tempSelectedStartDate) && (adsShownTimeListWatch.tempSelectedStartDate != null)) || ((adsShownTimeListWatch.selectedEndDate == adsShownTimeListWatch.tempSelectedEndDate) && (adsShownTimeListWatch.tempSelectedEndDate != null))
                  ){
                    adsShownTimeListWatch.clearFilters();
                    adsShownTimeListWatch.adsShownTimeListApi(context);
                    Navigator.pop(
                      adsShownTimeListWatch.filterKey.currentContext!,
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
                backgroundColor: (adsShownTimeListWatch.selectedPurchaseType.title != adsShownTimeListWatch.tempSelectedPurchaseType.title ||
                    (adsShownTimeListWatch.selectedStartDate != adsShownTimeListWatch.tempSelectedStartDate) || (adsShownTimeListWatch.selectedEndDate != adsShownTimeListWatch.tempSelectedEndDate)
                ) ?
                AppColors.clr2997FC:AppColors.clrDCDDFF,
                borderRadius: BorderRadius.circular(8),
                buttonTextStyle: TextStyles.regular.copyWith(
                  fontSize: 16,
                  color: AppColors.white,
                ),
                buttonText: '${LocaleKeys.keyApply.localized} ${LocaleKeys.keyFilters.localized}',
                onTap: () async {
                  if(adsShownTimeListWatch.selectedPurchaseType.title != adsShownTimeListWatch.tempSelectedPurchaseType.title ||
                      (adsShownTimeListWatch.selectedStartDate != adsShownTimeListWatch.tempSelectedStartDate) || (adsShownTimeListWatch.selectedEndDate != adsShownTimeListWatch.tempSelectedEndDate)
                  ){
                    adsShownTimeListWatch.applyFilters();
                    Navigator.pop(
                      adsShownTimeListWatch.filterKey.currentContext!,
                    );
                    adsShownTimeListWatch.adsShownTimeListApi(context);
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