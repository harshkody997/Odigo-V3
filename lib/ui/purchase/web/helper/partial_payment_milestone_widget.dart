import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/controller/purchase/add_purchase_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_range_date_picker.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class PartialPaymentMilestoneWidget extends ConsumerWidget {
  const PartialPaymentMilestoneWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addPurchaseWatch = ref.watch(addPurchaseController);
    final clientDetailsWatch = ref.watch(clientDetailsController);
    return Visibility(
      visible: addPurchaseWatch.paymentType==PaymentType.PARTIAL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// payment milestone text
          CommonText(
            title: LocaleKeys.keyPaymentMilestones.localized,
            style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.black),
          ).paddingOnly(bottom: context.height * 0.02),

          ///List
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: addPurchaseWatch.partialPaymentsList.length,
            itemBuilder: (context, index) {
              final item = addPurchaseWatch.partialPaymentsList[index];
              return Form(
                key: item.formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CommonInputFormField(
                        // focusNode: purchaseListWatch.refundedPriceNode,
                        isEnable: addPurchaseWatch.selectedWeeks.isNotEmpty&&addPurchaseWatch.selectedDestination!=null,
                        textEditingController: item.amountController??TextEditingController(),
                        hintText: LocaleKeys.keyAmountToPay.localized,
                        validator: (value) {
                          return validateText(value, LocaleKeys.keyAmountToPayValidation.localized);
                        },
                        onChanged: (value){
                          addPurchaseWatch.countAmount();
                        },
                        prefixWidget: Padding(
                          child: CommonText(
                            title: '${clientDetailsWatch.clientDetailsState.success?.data?.countryCurrency ?? AppConstants.currency}',
                          ),
                          padding: EdgeInsetsGeometry.only(left: context.width * 0.01, top: context.height * 0.015),
                        ),
                        textInputType: TextInputType.number,
                        onFieldSubmitted: (value) {
                          //purchaseListWatch.remarkNode.requestFocus();
                        },
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,}$')),
                        ],
                      ),
                    ),
                    SizedBox(width: context.width * 0.01),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if(addPurchaseWatch.selectedWeeks.isNotEmpty&&addPurchaseWatch.selectedDestination!=null){
                                  DateTime startDate = addPurchaseWatch.selectedWeeks.first.startDate??DateTime.now();
                                  DateTime today = DateTime.now();

                                  DateTime initialDate = startDate.isBefore(today) ? today : startDate;

                                  ///Date Picker
                                  commonRangeDatePickerDialog(
                                    context,
                                    isRangePicker: false,
                                    selectedStartDate: item.dateValue,
                                    firstDate: initialDate,
                                    lastDate: addPurchaseWatch.selectedWeeks.last.endDate,
                                    onSelect: (dateList) {
                                      ///Change Selected Payment Date Value
                                      addPurchaseWatch.updatePartialPaymentDate(dateList.first??DateTime.now(),index);
                                    },
                                  );
                                }
                              },
                              child: CommonInputFormField(
                                hintText: LocaleKeys.keyPaymentDate.localized,
                                isEnable: false,
                                suffixWidget: CommonSVG(
                                  strIcon: Assets.svgs.svgCalendar.keyName,
                                  // boxFit: BoxFit.scaleDown,
                                ),
                                hintTextStyle: TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 13),
                                textEditingController: item.dateController??TextEditingController(),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  ///Date Validation
                                  return validateText(value,LocaleKeys.keyPaymentDateValidation.localized);
                                },
                              ),
                            ),
                          ),
                          ///+,- Button
                          Visibility(
                            visible: true,
                            child: InkWell(
                              onTap:(){
                                if(addPurchaseWatch.selectedWeeks.isNotEmpty&&addPurchaseWatch.selectedDestination!=null){
                                  if(index==(addPurchaseWatch.partialPaymentsList.length-1)){
                                    addPurchaseWatch.addValueInPartialPayment();
                                  }else{
                                    addPurchaseWatch.removeValueInPartialPayment(index);
                                  }
                                }
                              },
                              child: CommonSVG(
                                strIcon: index==(addPurchaseWatch.partialPaymentsList.length-1)?Assets.svgs.svgPlusBlue.keyName:Assets.svgs.svgMinus.keyName,
                              ).paddingOnly(left: context.width*0.007),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }, separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: context.height*0.02,
            );
          },
          ).paddingOnly(bottom: context.height * 0.02),

          ///Amount Scheduled and remaining amount
          Row(
            children: [
              CommonText(
                title: '${LocaleKeys.keyAmountScheduled.localized} : ${clientDetailsWatch.clientDetailsState.success?.data?.countryCurrency ?? AppConstants.currency} ${addPurchaseWatch.scheduledAmount}',
                style: TextStyles.regular.copyWith(fontSize: 14, color: AppColors.clr7C7474),
              ).paddingOnly(right: context.width * 0.04),

              CommonText(
                title: '${LocaleKeys.keyRemainingAmount.localized} : ${clientDetailsWatch.clientDetailsState.success?.data?.countryCurrency ?? AppConstants.currency} ${addPurchaseWatch.remainingAmount}',
                style: TextStyles.regular.copyWith(fontSize: 14, color: AppColors.clr7C7474),
              )
            ],
          )


        ],
      ),
    );
  }

}
