
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/controller/purchase/add_purchase_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/purchase/web/helper/partial_payment_milestone_widget.dart';
import 'package:odigov3/ui/purchase/web/helper/purchase_price_formatter.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class PurchaseTypeAndPaymentMilestoneWidget extends ConsumerWidget {
  const PurchaseTypeAndPaymentMilestoneWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addPurchaseWatch = ref.watch(addPurchaseController);
    final clientDetailsWatch = ref.watch(clientDetailsController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Final Purchase Price text
        CommonText(
          title: LocaleKeys.keyFinalPurchasePrice.localized,
          style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.black),
        ).paddingOnly(bottom: context.height * 0.025),

        /// Enter Final Purchase Price text field
        CommonInputFormField(
          isEnable: addPurchaseWatch.selectedWeeks.isNotEmpty&&addPurchaseWatch.selectedDestination!=null,
          textEditingController: addPurchaseWatch.finalPurchasePriceCtr,
          hintText: LocaleKeys.keyEnterFinalPurchasePrice.localized,
          textInputAction: TextInputAction.next,
          textInputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
            PurchasePriceInputFormatter(maxValue: addPurchaseWatch.totalAmount), // Use your actual finalAmount
          ],
          onFieldSubmitted: (value) async {},
          onChanged: (value) {
            addPurchaseWatch.changePurchasePrice(value);
          },
          validator: (value) {
            return validatePurchasePrice(value,addPurchaseWatch.totalAmount);
          },
        ).paddingOnly(bottom: context.height * 0.02),

        /// Remarks text
        CommonText(
          title: LocaleKeys.keyRemarks.localized,
          style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.black),
        ).paddingOnly(bottom: context.height * 0.02),

        ///Remark Text field
        CommonInputFormField(
          isEnable: addPurchaseWatch.selectedWeeks.isNotEmpty&&addPurchaseWatch.selectedDestination!=null,
          textEditingController: addPurchaseWatch.remarksCtr,
          hintText: LocaleKeys.keyAddRemarks.localized,
          textInputAction: TextInputAction.next,
          textInputFormatter: [
            LengthLimitingTextInputFormatter(AppConstants.maxAddressLength),
          ],
          maxLines: 3,
          onFieldSubmitted: (value) async {},
          onChanged: (value) {},
          validator: (value) {
            // return validateTextIgnoreLength(value, LocaleKeys.keyRemarksIsRequired.localized);
          },
        ).paddingOnly(bottom: context.height * 0.02),

        /// purchase Type text
        CommonText(
          title: LocaleKeys.keyPaymentType.localized,
          style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.black),
        ).paddingOnly(bottom: context.height * 0.01),

        ///How to pay
        CommonText(
          title: LocaleKeys.keyHowToPay.localized,
          style: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr7C7474),
          maxLines: 5,
        ).paddingOnly(bottom: context.height * 0.02),

        /// purchase type widget
        Row(
          children: [
            Expanded(
              child: _commonPaymentTypeWidget(ref, PaymentType.PARTIAL),
            ),
            SizedBox(width: context.width * 0.01),
            Expanded(
              child: _commonPaymentTypeWidget(ref, PaymentType.FULL),
            ),
          ],
        ).paddingOnly(bottom: context.height * 0.02),

        ///Partial Payment Widget
        PartialPaymentMilestoneWidget(),

        /// wallet amount text
        if((clientDetailsWatch.clientDetailsState.success?.data?.wallet ?? -1) > 0)
          Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Checkbox
            Padding(
              padding: EdgeInsets.only(top: 2), // aligns vertically with text
              child: SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: addPurchaseWatch.isWalletUsedForPayment,
                  onChanged: (checked) {
                    addPurchaseWatch.updateIsWalletUsedForPayment(checked ?? false);
                  },
                  activeColor: AppColors.clr0066FF,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),

            SizedBox(width: 6), // space between checkbox and text

            /// Texts
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Wallet Amount Text
                CommonText(
                  title: '${LocaleKeys.keyWalletAmount.localized} (${clientDetailsWatch.clientDetailsState.success?.data?.countryCurrency ?? AppConstants.currency} ${clientDetailsWatch.clientDetailsState.success?.data?.wallet})',
                  style: TextStyles.semiBold.copyWith(
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 4),
                CommonText(
                  title: LocaleKeys.keyApplyWalletBalance.localized,
                  style: TextStyles.regular.copyWith(
                    fontSize: 12,
                    color: AppColors.clr7C7474,
                  ),
                ),
              ],
            ).paddingOnly(top: 4),
          ],
        ).paddingOnly(top: context.height * 0.02)

      ],
    );
  }

  Widget _commonPaymentTypeWidget(WidgetRef ref, PaymentType paymentType){
    final addPurchaseWatch = ref.watch(addPurchaseController);
    return InkWell(
      onTap: () {
        addPurchaseWatch.updatePaymentType(paymentType);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: addPurchaseWatch.paymentType == paymentType ? AppColors.clr2997FC : AppColors.clrEAEAEA,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              title: paymentType == PaymentType.PARTIAL ? LocaleKeys.keyPartialPayment.localized : LocaleKeys.keyFullPayment.localized,
              style: TextStyles.regular.copyWith(
                fontSize: 14,
                color: addPurchaseWatch.paymentType == paymentType ? AppColors.clr2997FC : AppColors.clr7C7474,
              ),
            ),
            CommonSVG(
              strIcon: addPurchaseWatch.paymentType == paymentType ? Assets.svgs.svgCheckCircleRoundedSelected.keyName : Assets.svgs.svgCheckCircleRounded.keyName,
            ),
          ],
        ).paddingSymmetric(vertical: 13, horizontal: 18),
      ),
    );
  }
}
