import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client_ads/client_ads_controller.dart';
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class ChangeAdsButtonWidget extends ConsumerWidget {
  final String? purchaseUuid;
  final String? clientUuid;
  const ChangeAdsButtonWidget({super.key, this.purchaseUuid,this.clientUuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseDetailsWatch = ref.watch(purchaseDetailsController);
    final clientAdsWatch = ref.watch(clientAdsController);
    return  Row(
      children: [
        ///Save button
        CommonButton(
          height: context.height * 0.06,
          width: context.width * 0.123,
          onTap: () async {
            final selectedCount = clientAdsWatch.clientAdsList.where((e) => e?.isSelected == true).length;
            if(selectedCount!=0){
              await purchaseDetailsWatch.updatePurchaseAdsApi(clientAdsList: clientAdsWatch.clientAdsList,purchaseUuid: purchaseUuid);
              if(purchaseDetailsWatch.updatePurchaseAdsState.success?.status==ApiEndPoints.apiStatus_200){
                purchaseDetailsWatch.purchaseAdsApi(purchaseUuid: purchaseUuid);
                purchaseDetailsWatch.updateSelectedTab(1);
                ref.read(navigationStackController).pop();
              }
            }else{
              showToast(context: context, isSuccess: false, message: LocaleKeys.keyMinimumAndMaximumAds.localized);
            }
          },
          isLoading: purchaseDetailsWatch.updatePurchaseAdsState.isLoading,
          buttonText: LocaleKeys.keySave.localized,
          fontSize: 14,
        ),
        SizedBox(width: context.width * 0.023),

        ///Cancel button
        CommonButton(
          height: context.height * 0.055,
          width: context.width * 0.123,
          onTap: () {
            purchaseDetailsWatch.updateSelectedTab(1);
            ref.read(navigationStackController).pop();
          },
          buttonText: LocaleKeys.keyCancel.localized,
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
