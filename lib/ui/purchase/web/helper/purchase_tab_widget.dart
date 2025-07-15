import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/purchase/web/helper/purchase_ads_table.dart';
import 'package:odigov3/ui/purchase/web/helper/purchase_tab_buttons.dart';
import 'package:odigov3/ui/purchase/web/helper/purchase_transaction_history_table.dart';
import 'package:odigov3/ui/purchase/web/helper/purchase_week_table.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class PurchaseTabWidget extends ConsumerWidget {
  final String? purchaseUuid;

  const PurchaseTabWidget({super.key,required this.purchaseUuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseDetailsWatch = ref.watch(purchaseDetailsController);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            /// Robot store tab controller
            PurchaseTabButtons(purchaseUuid: purchaseUuid,clientUuid: purchaseDetailsWatch.purchaseDetailState.success?.data?.odigoClientUuid??''),
            SizedBox(height: 25),

            Expanded(
              child: purchaseDetailsWatch.selectedTab == 0
                  ? PurchaseWeekTable()
                  : (purchaseDetailsWatch.selectedTab == 1)
                  ? PurchaseAdsTable()
                  : PurchaseTransactionHistoryTable(purchaseUuid: purchaseUuid),
            ),
          ],
        ).paddingSymmetric(vertical: 18, horizontal: 27),
      ).paddingOnly(top: 30),
    );
  }
}
