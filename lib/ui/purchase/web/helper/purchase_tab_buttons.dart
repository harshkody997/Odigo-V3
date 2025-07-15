import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';

class PurchaseTabButtons extends ConsumerWidget {
  final String? purchaseUuid;
  final String? clientUuid;
  const PurchaseTabButtons({super.key, this.purchaseUuid,this.clientUuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseDetailsWatch = ref.watch(purchaseDetailsController);

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              ///Purchase Weeks Tab Button
              CommonButton(
                buttonText: LocaleKeys.keyPurchaseWeeks.localized,
                backgroundColor: purchaseDetailsWatch.selectedTab == 0 ? AppColors.clr2997FC : AppColors.white,
                borderColor: purchaseDetailsWatch.selectedTab == 0 ? AppColors.clr2997FC : AppColors.clrE0E0E0,
                width: context.width * 0.10,
                buttonTextStyle: TextStyles.medium.copyWith(
                  color: purchaseDetailsWatch.selectedTab == 0 ? AppColors.white : AppColors.clrE0E0E0,
                  fontSize: 12,
                ),
                height: context.height * 0.06,
                onTap: () {
                  purchaseDetailsWatch.updateSelectedTab(0);
                },
              ),
              SizedBox(width: context.width*0.02),

              ///Purchase Ads Tab Button
              CommonButton(
                buttonText: LocaleKeys.keyPurchaseAds.localized,
                backgroundColor: purchaseDetailsWatch.selectedTab == 1 ? AppColors.clr2997FC : AppColors.white,
                borderColor: purchaseDetailsWatch.selectedTab == 1 ? AppColors.clr2997FC : AppColors.clrE0E0E0,
                width: context.width * 0.1,
                height: context.height * 0.06,
                buttonTextStyle: TextStyles.medium.copyWith(
                  color: purchaseDetailsWatch.selectedTab == 1 ? AppColors.white : AppColors.clrE0E0E0,
                  fontSize: 12,
                ),
                onTap: () async {
                  purchaseDetailsWatch.purchaseAdsApi(purchaseUuid: purchaseUuid);
                  purchaseDetailsWatch.updateSelectedTab(1);
                },
              ),
              SizedBox(width: context.width*0.02),

              ///Purchase Wallet History Tab Button
              CommonButton(
                buttonText: LocaleKeys.keyPurchaseWalletHistory.localized,
                backgroundColor: purchaseDetailsWatch.selectedTab == 2 ? AppColors.clr2997FC : AppColors.white,
                borderColor: purchaseDetailsWatch.selectedTab == 2 ? AppColors.clr2997FC : AppColors.clrE0E0E0,
                width: context.width * 0.15,
                height: context.height * 0.06,
                buttonTextStyle: TextStyles.medium.copyWith(
                  color: purchaseDetailsWatch.selectedTab == 2 ? AppColors.white : AppColors.clrE0E0E0,
                  fontSize: 12,
                ),
                onTap: () {
                  purchaseDetailsWatch.purchaseTransactionListApi(false,purchaseUuid: purchaseUuid);
                  purchaseDetailsWatch.updateSelectedTab(2);
                },
              ),

              Spacer(),

              ///Change Ads
              Visibility(
                visible: purchaseDetailsWatch.selectedTab==1 && (purchaseDetailsWatch.purchaseDetailState.success?.data?.status!='CANCELLED' && purchaseDetailsWatch.purchaseDetailState.success?.data?.status!='COMPLETED'),
                child: CommonButton(
                  buttonText: LocaleKeys.keyChangeAds.localized,
                  backgroundColor: AppColors.black,
                  width: context.width * 0.12,
                  buttonTextStyle: TextStyles.medium.copyWith(
                    color:  AppColors.white,
                    fontSize: 12,
                  ),
                  height: context.height * 0.06,
                  onTap: () {
                    ref.read(navigationStackController).push(NavigationStackItem.changeAds(purchaseUuid: purchaseUuid,clientUuid: clientUuid));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
