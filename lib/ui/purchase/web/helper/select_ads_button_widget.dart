import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/controller/client_ads/client_ads_controller.dart';
import 'package:odigov3/framework/controller/purchase/add_purchase_controller.dart';
import 'package:odigov3/framework/controller/purchase/purchase_list_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/purchase/web/helper/purchase_successful_dialog.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class SelectAdsButtonWidget extends ConsumerWidget {
  final String? purchaseUuid;
  final String? clientUuid;
  const SelectAdsButtonWidget({super.key, this.purchaseUuid,this.clientUuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientAdsWatch = ref.watch(clientAdsController);
    final addPurchaseWatch = ref.watch(addPurchaseController);
    final clientDetailsWatch = ref.watch(clientDetailsController);
    final purchaseWatch = ref.watch(purchaseListController);


    return  Row(
      children: [
        ///Purchase button
        CommonButton(
          height: context.height * 0.06,
          width: context.width * 0.15,
          onTap: () async {
            final selectedCount = clientAdsWatch.clientAdsList.where((e) => e?.isSelected == true).length;
            if(selectedCount!=0){
              await addPurchaseWatch.createPurchaseApi(clientAdsList: clientAdsWatch.clientAdsList,clientUuid: clientUuid);
              if(addPurchaseWatch.createPurchaseState.success?.status==ApiEndPoints.apiStatus_200){
                showCommonWebDialog(
                  keyBadge: addPurchaseWatch.purchaseSuccessfulDialogKey,
                  context: context,
                  dialogBody: PurchaseSuccessfulDialog(),
                  height: 0.5,
                  width: 0.4,
                );
                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                  clientDetailsWatch.updateSelectedTab(1);
                  purchaseWatch.purchaseList.clear();
                  purchaseWatch.purchaseListState.isLoading = true;
                  purchaseWatch.purchaseListState.success = null;
                  purchaseWatch.purchaseListApi(odigoClientUuid: clientUuid ?? '', false);
                  ref.read(navigationStackController).pop();
                  ref.read(navigationStackController).pop();
                });
              }
            }else{
              showToast(context: context, isSuccess: false, message: LocaleKeys.keyMinimumAndMaximumAds.localized);
            }
          },
          isLoading: addPurchaseWatch.createPurchaseState.isLoading,
          buttonText: LocaleKeys.keyPurchase.localized,
          fontSize: 14,
        ),
        SizedBox(width: context.width * 0.023),

        ///Cancel button
        CommonButton(
          height: context.height * 0.055,
          width: context.width * 0.123,
          onTap: () {
            ref.read(navigationStackController).pop();
          },
          buttonText: LocaleKeys.keyBack.localized,
          backgroundColor: AppColors.transparent,
          borderColor: AppColors.greyD0D5DD,
          buttonTextStyle: TextStyles.medium.copyWith(
            fontSize: 14,
            color: AppColors.greyD0D5DD,
          ),
        ),
      ],
    );
  }

}
