import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart';
import 'package:odigov3/framework/controller/purchase_transaction/purchase_transaction_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_range_date_picker.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class SettleTransactionDialogWidgetWeb extends ConsumerStatefulWidget {
  final DateTime purchaseCreatedDate;
  final String transactionId;
  final String? purchaseUuid;
  final ScreenName? screenName;
  const SettleTransactionDialogWidgetWeb({super.key,required this.purchaseCreatedDate, required this.transactionId,this.purchaseUuid,this.screenName});

  @override
  ConsumerState<SettleTransactionDialogWidgetWeb> createState() => _SettleTransactionDialogWidgetWebState();
}

class _SettleTransactionDialogWidgetWebState extends ConsumerState<SettleTransactionDialogWidgetWeb> {

  @override
  void initState() {
    final purchaseTransactionRead = ref.read(purchaseTransactionController);
    purchaseTransactionRead.clearFormData();
    super.initState();
  }
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final  purchaseTransactionWatch= ref.watch(purchaseTransactionController);
    final purchaseDetailsWatch = ref.watch(purchaseDetailsController);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            ///Back Icon
            InkWell(
              onTap: () {
                purchaseTransactionWatch.clearFormData();
                Navigator.pop(context);
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgLeftArrow.keyName,
                height: context.height * 0.020,
                width: context.height * 0.020,
              ),
            ).paddingOnly(right: 10),

            ///Change Email title
            CommonText(
              title: LocaleKeys.keySettlePayment.localized,
              style: TextStyles.bold.copyWith(
                fontSize: 22,
                color: AppColors.black,
              ),
            ),
          ],
        ),

        const Spacer(),

        ///Form
        Form(
          key: purchaseTransactionWatch.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Date Selection description
              CommonText(
                title: LocaleKeys.keyChooseSettlementDateMsg.localized,
                style: TextStyles.regular.copyWith(color: AppColors.black,fontSize: 16),
              ).paddingOnly(bottom: 10),
              InkWell(
                  onTap: () async {
                    ///Date Picker
                    commonRangeDatePickerDialog(
                      context,
                      isRangePicker: false,
                      selectedStartDate: purchaseTransactionWatch.selectedSettleDate,
                      selectedEndDate:  purchaseTransactionWatch.selectedSettleDate,
                      firstDate: widget.purchaseCreatedDate,
                      lastDate: DateTime.now(),
                      onSelect: (dateList) {
                        ///Change Selected Date Value
                        purchaseTransactionWatch.changeSettleTransactionDateValue(dateList);
                      },
                    );
                  },
                  child: CommonInputFormField(
                    hintText: LocaleKeys.keyDDMMYYYY.localized,
                    isEnable: false,
                    suffixWidget: CommonSVG(
                      strIcon: Assets.svgs.svgCalendar.keyName,
                      height: 25,
                      width: 25,
                      //boxFit: BoxFit.scaleDown,
                    ),
                    fontSize: 13,
                    hintTextStyle: TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 13),
                    textEditingController: purchaseTransactionWatch.settlementDateCtr,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      ///Date Validation
                      return validateText(value, LocaleKeys.keySettleDateRequiredMsg.localized,minLength: 1);
                    },
                  ).paddingOnly(bottom: 20),),


              /// Remarks
              CommonText(
                title: LocaleKeys.keyRemarks.localized,
                style: TextStyles.regular.copyWith(color: AppColors.black,fontSize: 16),
              ).paddingOnly(bottom: 10),
              CommonInputFormField(
                textEditingController: purchaseTransactionWatch.settlementRemarksCtr,
                maxLength: AppConstants.maxDescriptionLength,
                hintText: LocaleKeys.keyEnterRemarksHere.localized,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLines: 6,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9/ .]')),
                ],
                validator: (value){
                  return validateText(value, LocaleKeys.keyRemarksRequiredMsg.localized);
                },
                onFieldSubmitted: (val) async{
                  if(purchaseTransactionWatch.formKey.currentState?.validate() ?? false) {
                    /// Api call
                    await purchaseTransactionWatch.settleTransactionApi(uuid: widget.transactionId).then((value) {
                      if(purchaseTransactionWatch.settleTransactionState.success?.status == ApiEndPoints.apiStatus_200){
                        purchaseTransactionWatch.purchaseTransactionListApi(false);
                        purchaseTransactionWatch.clearFormData();
                        /// Success toast
                        showToast(context: context,isSuccess:true,message: LocaleKeys.keySettledTransactionSuccessfully.localized);

                        if(widget.screenName==ScreenName.purchaseDetails){
                          purchaseDetailsWatch.purchaseTransactionListApi(false,purchaseUuid: widget.purchaseUuid);
                        }

                        /// Close dialog
                        Navigator.pop(context);
                      }
                    },);
                  }
                },
              ),
            ],
          ),
        ),
        const Spacer(),

        ///Settle transaction button
        CommonButton(
          onTap: () async {
            if(purchaseTransactionWatch.formKey.currentState?.validate() ?? false) {
              /// Api call
              await purchaseTransactionWatch.settleTransactionApi(uuid: widget.transactionId).then((value) {
                if(purchaseTransactionWatch.settleTransactionState.success?.status == ApiEndPoints.apiStatus_200){

                  /// List api call
                  purchaseTransactionWatch.purchaseTransactionListApi(false);
                  /// Success toast
                  showToast(context: context,isSuccess:true,message: LocaleKeys.keySettledTransactionSuccessfully.localized);

                  if(widget.screenName==ScreenName.purchaseDetails){
                    purchaseDetailsWatch.purchaseTransactionListApi(false,purchaseUuid: widget.purchaseUuid);
                  }

                  /// Close dialog
                  Navigator.pop(context);

                }
              },);
            }
          },
          isLoading: purchaseTransactionWatch.settleTransactionState.isLoading,
          width: context.width,
          height: 48,
          buttonText: LocaleKeys.keySaveSettlement.localized,
        ),
      ],
    ).paddingAll(20);
  }
}

