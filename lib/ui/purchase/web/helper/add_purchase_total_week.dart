import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/add_purchase_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/purchase/web/helper/purchase_type_and_payment_milestone_widget.dart';
import 'package:odigov3/ui/purchase/web/helper/week_selection_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AddPurchaseTotalWeek extends ConsumerWidget {
  final String? clientUuid;
  const AddPurchaseTotalWeek({super.key,this.clientUuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: context.height * 0.03, horizontal: context.width* 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// total week text
          CommonText(
            title: LocaleKeys.keyTotalWeek.localized,
            style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.black),
          ).paddingOnly(bottom: context.height * 0.01),
          CommonText(
            title: LocaleKeys.keyChooseWeeksBooking.localized,
            style: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr7C7474),
            maxLines: 5,
          ).paddingOnly(bottom: context.height * 0.02),
          /// week selection widget
          WeekSelectionWidget(),
          SizedBox(height: context.height * 0.03,),

          ///Purchase Type and Payment Milestone
          PurchaseTypeAndPaymentMilestoneWidget()

         /* addPurchaseWatch.isCalculated?_calculateButton(context, ref).paddingOnly(bottom: context.height*0.03):SizedBox(),

          /// calculate button
          !addPurchaseWatch.isCalculated
              ? _calculateButton(context, ref)
              : PurchaseTypeAndPaymentMilestoneWidget(),*/
        ],
      ),
    );
  }

  Widget _calculateButton(BuildContext context, WidgetRef ref){
    final addPurchaseWatch = ref.watch(addPurchaseController);
    return CommonButton(
      onTap: () {
      /*  addPurchaseWatch.basicDetailFormKey.currentState?.validate();
        addPurchaseWatch.totalWeekFormKey.currentState?.validate();
        if(addPurchaseWatch.basicDetailFormKey.currentState?.validate()==true && addPurchaseWatch.totalWeekFormKey.currentState?.validate()==true){
          addPurchaseWatch.calculateWeeklyPrice(addPurchaseWatch.purchaseType==PurchaseType.PREMIUM?addPurchaseWatch.selectedDestination?.premiumPrice??0:addPurchaseWatch.selectedDestination?.fillerPrice??0);
          if(!addPurchaseWatch.isCalculated){
            addPurchaseWatch.updateIsCalculated(true);
          }
        }*/
      },
      width: context.width * 0.15,
      height: context.height * 0.06,
      borderRadius: BorderRadius.circular(6),
      buttonText: LocaleKeys.keyCalculate.localized,
      buttonTextStyle: TextStyles.medium.copyWith(color: AppColors.white, fontSize: 14),
    );
  }
}
