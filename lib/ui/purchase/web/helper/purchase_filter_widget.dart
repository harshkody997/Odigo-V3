import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_list_controller.dart';
import 'package:odigov3/framework/controller/purchase_transaction/purchase_transaction_controller.dart';
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


class PurchaseFilterWidgetWeb extends ConsumerStatefulWidget {
  PurchaseFilterWidgetWeb({super.key});

  @override
  ConsumerState<PurchaseFilterWidgetWeb> createState() => _PurchaseFilterWidgetWebState();
}

class _PurchaseFilterWidgetWebState extends ConsumerState<PurchaseFilterWidgetWeb> {

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((callback){
      final purchaseListWatch = ref.watch(purchaseListController);
      purchaseListWatch.prefillFilters();
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
    final purchaseListWatch = ref.watch(purchaseListController);
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
                purchaseListWatch.prefillFilters();
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
                /// Status type Filter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      title: LocaleKeys.keyStatusType.localized,
                      style: TextStyles.semiBold.copyWith(color: AppColors.clr101828,fontSize: 14),
                    ).paddingOnly(bottom: context.height * 0.02),
                    ...purchaseListWatch.purchaseStatusList.map(
                          (status) => CommonRadioButton<String>(
                        value: status.title,
                        title: status.title.localized,
                        borderRequired: true,
                        groupValue: purchaseListWatch.tempSelectedStatus.title,
                        onTap: () {
                          purchaseListWatch.changeTempSelectedStatus(status);
                        },
                      ).paddingOnly(bottom: 8),
                    ),
                    Divider(
                      color: AppColors.clrEAECF0,
                      height: 0,
                    ).paddingSymmetric(vertical: context.height * 0.018),
                  ],
                ).paddingOnly(left: context.width * 0.012, right: context.width * 0.012),

                ///Purchase type Filter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      title: LocaleKeys.keyFilterByPurchaseType.localized,
                      style: TextStyles.semiBold.copyWith(color: AppColors.clr101828,fontSize: 14),
                    ).paddingOnly(bottom: context.height * 0.02),
                    ...purchaseListWatch.purchaseTypeList.map(
                          (status) => CommonRadioButton<String>(
                        value: status.title,
                        title: status.title.localized,
                        borderRequired: true,
                        groupValue: purchaseListWatch.tempSelectedPurchaseType.title,
                        onTap: () {
                          purchaseListWatch.changePurchaseTypeSelectedStatus(status);
                        },
                      ).paddingOnly(bottom: 8),
                    ),
                    Divider(
                      color: AppColors.clrEAECF0,
                      height: 0,
                    ).paddingSymmetric(vertical: context.height * 0.018),
                  ],
                ).paddingOnly(left: context.width * 0.012, right: context.width * 0.012),

                ///Payment type Filter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      title: LocaleKeys.keyFilterByPaymentType.localized,
                      style: TextStyles.semiBold.copyWith(color: AppColors.clr101828,fontSize: 14),
                    ).paddingOnly(bottom: context.height * 0.02),
                    ...purchaseListWatch.paymentTypeList.map(
                          (status) => CommonRadioButton<String>(
                        value: status.title,
                        title: status.title.localized,
                        borderRequired: true,
                        groupValue: purchaseListWatch.tempSelectedPaymentType.title,
                        onTap: () {
                          purchaseListWatch.changePaymentTypeSelectedStatus(status);
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
                          selectedStartDate: purchaseListWatch.tempSelectedStartDate,
                          selectedEndDate:  purchaseListWatch.tempSelectedEndDate,
                          firstDate: DateTime(2025, 1, 1),
                          onSelect: (dateList) {
                            ///Change Selected Date Value
                            purchaseListWatch.changeDateValue(dateList);
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
                        textEditingController: purchaseListWatch.dateController,
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
                  ( purchaseListWatch.selectedStatus.title == purchaseListWatch.tempSelectedStatus.title && (purchaseListWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll).title ) || purchaseListWatch.selectedPaymentType.title == purchaseListWatch.tempSelectedPaymentType.title && (purchaseListWatch.selectedPaymentType.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll).title ) || purchaseListWatch.selectedPurchaseType.title == purchaseListWatch.tempSelectedPurchaseType.title && (purchaseListWatch.selectedPurchaseType.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll).title ))
                      ||  ((purchaseListWatch.selectedStartDate == purchaseListWatch.tempSelectedStartDate) && (purchaseListWatch.tempSelectedStartDate != null)) || ((purchaseListWatch.selectedEndDate == purchaseListWatch.tempSelectedEndDate) && (purchaseListWatch.tempSelectedEndDate != null))
                  ){
                    purchaseListWatch.clearFilters();
                    purchaseListWatch.purchaseListApi(false);
                    Navigator.pop(
                      purchaseListWatch.filterKey.currentContext!,
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
                backgroundColor: (purchaseListWatch.selectedStatus.title != purchaseListWatch.tempSelectedStatus.title || purchaseListWatch.selectedPaymentType.title != purchaseListWatch.tempSelectedPaymentType.title || purchaseListWatch.selectedPurchaseType.title != purchaseListWatch.tempSelectedPurchaseType.title ||
                    (purchaseListWatch.selectedStartDate != purchaseListWatch.tempSelectedStartDate) || (purchaseListWatch.selectedEndDate != purchaseListWatch.tempSelectedEndDate)
                ) ?
                AppColors.clr2997FC:AppColors.clrDCDDFF,
                borderRadius: BorderRadius.circular(8),
                buttonTextStyle: TextStyles.regular.copyWith(
                  fontSize: 16,
                  color: AppColors.white,
                ),
                buttonText: '${LocaleKeys.keyApply.localized} ${LocaleKeys.keyFilters.localized}',
                onTap: () async {
                  if(purchaseListWatch.selectedStatus.title != purchaseListWatch.tempSelectedStatus.title || purchaseListWatch.selectedPaymentType.title != purchaseListWatch.tempSelectedPaymentType.title || purchaseListWatch.selectedPurchaseType.title != purchaseListWatch.tempSelectedPurchaseType.title ||
                      (purchaseListWatch.selectedStartDate != purchaseListWatch.tempSelectedStartDate) || (purchaseListWatch.selectedEndDate != purchaseListWatch.tempSelectedEndDate)
                  ){
                    purchaseListWatch.applyFilters();
                    Navigator.pop(
                      purchaseListWatch.filterKey.currentContext!,
                    );
                    purchaseListWatch.purchaseListApi(false);
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