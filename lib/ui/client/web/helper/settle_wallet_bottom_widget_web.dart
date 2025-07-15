import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/controller/wallet_transactions/wallet_transactions_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class SettleWalletBottomWidgetWeb extends ConsumerWidget {
  final String clientUuid;
  const SettleWalletBottomWidgetWeb({super.key,required this.clientUuid});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final clientDetailsWatch = ref.watch(clientDetailsController);
    return Row(
      children: [
        CommonButton(
          onTap: () async {
            if(clientDetailsWatch.formKey.currentState?.validate() ?? false) {
              /// Api call
              await clientDetailsWatch.settleWalletApi(clientUuid:clientUuid).then((value) {
                if(clientDetailsWatch.settleWalletState.success?.status == ApiEndPoints.apiStatus_200){
                  /// Client detail api
                  clientDetailsWatch.clientDetailsApi(context, clientUuid);
                  /// Dispose wallet list
                  ref.watch(walletTransactionsController).disposeController();
                  /// Wallet list api
                  ref.watch(walletTransactionsController).walletListApi(false,clientUuid: clientUuid);
                  /// Success toast
                  showToast(context: context,isSuccess:true,message: '${LocaleKeys.keyWalletAmount.localized} ${LocaleKeys.keyUpdatedSuccessMsg.localized}');
                  /// Back
                  ref.read(navigationStackController).pop();
                }
              },);
            }
          },
          height: 43,
          width: 144,
          borderRadius: BorderRadius.circular(7),
          loaderSize: 28,
          buttonText: LocaleKeys.keySave.localized,
          buttonTextStyle: TextStyles.medium.copyWith(
            fontSize:14,
            color:AppColors.white,
          ),
        ).paddingOnly(right: 20),
        CommonButton(
          height: 43,
          width: 144,
          borderRadius: BorderRadius.circular(7),
          buttonText: LocaleKeys.keyBack.localized,
          backgroundColor: AppColors.transparent,
          borderColor: AppColors.clr9E9E9E,
          buttonTextColor: AppColors.clr787575,
          onTap: (){
            ref.read(navigationStackController).pop();
          },
        ),
      ],
    ).paddingOnly(bottom: 15,left: 20,right: 20,top: 20);
  }
}
