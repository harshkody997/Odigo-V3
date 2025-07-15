import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:odigov3/ui/utils/widgets/show_common_date_picker.dart';


class PurchaseTransactionListFilterWidgetWeb extends ConsumerStatefulWidget {
  PurchaseTransactionListFilterWidgetWeb({super.key});

  @override
  ConsumerState<PurchaseTransactionListFilterWidgetWeb> createState() => _PurchaseTransactionListFilterWidgetWebState();
}

class _PurchaseTransactionListFilterWidgetWebState extends ConsumerState<PurchaseTransactionListFilterWidgetWeb> {

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((callback){
      final purchaseTransactionWatch = ref.read(purchaseTransactionController);
      purchaseTransactionWatch.prefillFilters();
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
    final purchaseTransactionWatch = ref.watch(purchaseTransactionController);
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
                purchaseTransactionWatch.prefillFilters();
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
                    ...purchaseTransactionWatch.transactionsStatusList.map(
                          (status) => CommonRadioButton<String>(
                        value: status.title,
                        title: status.title.localized,
                        borderRequired: true,
                        groupValue: purchaseTransactionWatch.tempSelectedStatus.title,
                        onTap: () {
                          purchaseTransactionWatch.changeTempSelectedStatus(status);
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
                      title: LocaleKeys.keyFilterByInstallmentDate.localized,
                      style: TextStyles.semiBold.copyWith(color: AppColors.clr101828,fontSize: 14),
                    ).paddingOnly(bottom: context.height * 0.02),

                    ///date selection field
                    CommonDateInputFormField(
                      dateController: purchaseTransactionWatch.dateController,
                      initialRange: [purchaseTransactionWatch.tempSelectedStartDate,purchaseTransactionWatch.tempSelectedEndDate],
                      isForRange: true,
                      lastDate: DateTime(DateTime.now().year, 12, 12),
                      onRangeSelected: (List<DateTime?>? value ) {
                        purchaseTransactionWatch.changeDateValue(value);
                      },
                      isForFilter: true,
                      onSelected: (value){},
                    ),
                     ///Old date selection field
                    // InkWell(
                    //   onTap: () async {
                    //     ///Range Date Picker
                    //     commonRangeDatePickerDialog(
                    //       context,
                    //       isRangePicker: true,
                    //       selectedStartDate: purchaseTransactionWatch.tempSelectedStartDate,
                    //       selectedEndDate:  purchaseTransactionWatch.tempSelectedEndDate,
                    //       firstDate: DateTime(2025, 1, 1),
                    //       onSelect: (dateList) {
                    //         ///Change Selected Date Value
                    //         purchaseTransactionWatch.changeDateValue(dateList);
                    //       },
                    //     );
                    //   },
                    //   child: CommonInputFormField(
                    //     hintText: LocaleKeys.keyDDMMYYYY.localized,
                    //     isEnable: false,
                    //     prefixWidget: CommonSVG(
                    //       strIcon: Assets.svgs.svgCalendar.keyName,
                    //       height: 10,
                    //       width: 10,
                    //       boxFit: BoxFit.scaleDown,
                    //     ),
                    //     fontSize: 13,
                    //     hintTextStyle: TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 13),
                    //     textEditingController: purchaseTransactionWatch.dateController,
                    //     textInputAction: TextInputAction.done,
                    //     validator: (value) {
                    //       ///Date Validation
                    //       return null;
                    //     },
                    //   ),
                    // ),
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
                  ( purchaseTransactionWatch.selectedStatus.title == purchaseTransactionWatch.tempSelectedStatus.title && (purchaseTransactionWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll).title ))
                      ||  ((purchaseTransactionWatch.selectedStartDate == purchaseTransactionWatch.tempSelectedStartDate) && (purchaseTransactionWatch.tempSelectedStartDate != null)) || ((purchaseTransactionWatch.selectedEndDate == purchaseTransactionWatch.tempSelectedEndDate) && (purchaseTransactionWatch.tempSelectedEndDate != null))
                  ){
                    purchaseTransactionWatch.clearFilters();
                    purchaseTransactionWatch.purchaseTransactionListApi(false);
                    Navigator.pop(
                      purchaseTransactionWatch.filterKey.currentContext!,
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
                backgroundColor: (purchaseTransactionWatch.selectedStatus.title != purchaseTransactionWatch.tempSelectedStatus.title ||
                    (purchaseTransactionWatch.selectedStartDate != purchaseTransactionWatch.tempSelectedStartDate) || (purchaseTransactionWatch.selectedEndDate != purchaseTransactionWatch.tempSelectedEndDate)
                ) ?
                AppColors.clr2997FC:AppColors.clrDCDDFF,
                borderRadius: BorderRadius.circular(8),
                buttonTextStyle: TextStyles.regular.copyWith(
                  fontSize: 16,
                  color: AppColors.white,
                ),
                buttonText: '${LocaleKeys.keyApply.localized} ${LocaleKeys.keyFilters.localized}',
                onTap: () async {
                  if(purchaseTransactionWatch.selectedStatus.title != purchaseTransactionWatch.tempSelectedStatus.title ||
                      (purchaseTransactionWatch.selectedStartDate != purchaseTransactionWatch.tempSelectedStartDate) || (purchaseTransactionWatch.selectedEndDate != purchaseTransactionWatch.tempSelectedEndDate)
                  ){
                    purchaseTransactionWatch.applyFilters();
                    Navigator.pop(
                      purchaseTransactionWatch.filterKey.currentContext!,
                    );
                    purchaseTransactionWatch.purchaseTransactionListApi(false);
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