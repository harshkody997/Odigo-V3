import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/purchase/add_purchase_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/purchase/web/helper/add_purchase_basic_details.dart';
import 'package:odigov3/ui/purchase/web/helper/add_purchase_total_week.dart';
import 'package:odigov3/ui/purchase/web/helper/week_amount_graph.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class AddPurchaseWeb extends ConsumerStatefulWidget {
  final String? clientUuid;
  const AddPurchaseWeb({super.key,this.clientUuid});

  @override
  ConsumerState<AddPurchaseWeb> createState() => _AddPurchaseWebState();
}

class _AddPurchaseWebState extends ConsumerState<AddPurchaseWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    final destinationWatch = ref.watch(destinationController);
    final addPurchaseWatch = ref.watch(addPurchaseController);
    final clientDetailsWatch = ref.watch(clientDetailsController);
    return destinationWatch.destinationListState.isLoading || clientDetailsWatch.clientDetailsState.isLoading
      ? CommonAnimLoader()
      : SingleChildScrollView(
        child: Form(
          key: addPurchaseWatch.purchaseFormKey,
          child: Column(
            children: [
              ///Basic Details,Purchase Type
              AddPurchaseBasicDetails(),
              SizedBox(height: context.height * 0.02,),

              /// total week widget
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Add Purchase Form
                  Expanded(flex: 7, child: AddPurchaseTotalWeek()),
                  SizedBox(width: context.width * 0.01,),
                  ///Week Amount Graph
                  Expanded(flex: 3, child: WeekAmountGraph()),
                ],
              ),

              SizedBox(height: context.height * 0.02,),

              /// bottom button bar
              _bottomButtonBar(),

              SizedBox(height: context.height * 0.1,),
            ]
          ),
        ),
      );
  }

  Widget _bottomButtonBar(){
    final addPurchaseWatch = ref.watch(addPurchaseController);
    final clientDetailsWatch = ref.watch(clientDetailsController);
    return Row(
      children: [
        ///Continue Button
        CommonButton(
          buttonText: LocaleKeys.keyContinue.localized,
          buttonTextStyle: TextStyles.medium.copyWith(fontSize: 14, color: AppColors.white),
          backgroundColor:AppColors.black,
          borderRadius: BorderRadius.circular(6),
          width: context.width * 0.16,
          height: context.height * 0.06,
          onTap: () async {
            bool basicValid = addPurchaseWatch.purchaseFormKey.currentState?.validate() ?? false;

            bool partialValid = true;
            double partialPaymentAmount = 0.0;

            if (addPurchaseWatch.paymentType == PaymentType.PARTIAL) {
              for (var element in addPurchaseWatch.partialPaymentsList) {
                final amountText = element.amountController?.text ?? '0.0';
                final parsedAmount = double.tryParse(amountText) ?? 0.0;
                partialPaymentAmount += parsedAmount;
                final isValid = element.formKey.currentState?.validate() ?? false;
                if (!isValid) {
                  partialValid = false;
                }
              }
            }
            if(addPurchaseWatch.paymentType==PaymentType.PARTIAL){
              if (basicValid && partialValid) {
                if(partialPaymentAmount!=double.parse(addPurchaseWatch.finalPurchasePriceCtr.text)){
                  showToast(context: context,isSuccess:false,message:LocaleKeys.keyPartialPaymentAmountMustBeSameAs.localized,showAtBottom: false);
                }else{
                  ref.read(navigationStackController).push(NavigationStackItem.selectAds(clientUuid: widget.clientUuid));
                }
              }
            }else{
              if (basicValid) {
                ref.read(navigationStackController).push(NavigationStackItem.selectAds(clientUuid: widget.clientUuid));
              }
            }

          },
        ).paddingOnly(right: context.width * 0.02),

        ///Back Button
        CommonButton(
          buttonText: LocaleKeys.keyBack.localized,
          buttonTextStyle : TextStyles.medium.copyWith(fontSize: 14, color: AppColors.clr787575),
          backgroundColor: AppColors.transparent,
          borderColor: AppColors.clr9E9E9E,
          borderRadius: BorderRadius.circular(6),
          width: context.width * 0.16,
          height: context.height * 0.06,
          onTap: () {
            ref.read(navigationStackController).pop();
            clientDetailsWatch.updateSelectedTab(1);
          },
        ),
      ],
    );
  }
}
