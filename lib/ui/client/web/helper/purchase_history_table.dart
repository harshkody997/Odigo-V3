import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_list_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/client/web/helper/purchase_status_widget.dart';
import 'package:odigov3/ui/purchase/web/helper/cancel_dialog.dart';
import 'package:odigov3/ui/purchase/web/helper/refund_dialog.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class PurchaseHistoryTable extends ConsumerStatefulWidget {
  final String? clientUuid;

  const PurchaseHistoryTable({Key? key, this.clientUuid}) : super(key: key);

  @override
  ConsumerState<PurchaseHistoryTable> createState() => _PurchaseHistoryTableState();
}

class _PurchaseHistoryTableState extends ConsumerState<PurchaseHistoryTable> {

  @override
  void initState() {
    final purchaseWatch = ref.read(purchaseListController);
    purchaseWatch.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await purchaseWatch.purchaseListApi(odigoClientUuid: widget.clientUuid ?? '', false);
    });
    super.initState();
  }

  ///Build
  @override
  Widget build(BuildContext context) {
    // Watch state providers
    final purchaseListWatch = ref.watch(purchaseListController);

    return CommonTableGenerator(
      // Header widgets for the table
      headerContent: [
        CommonHeader(title: LocaleKeys.keyDestination.localized, flex: 2),
        CommonHeader(title: LocaleKeys.keyPurchaseType.localized, flex: 2),
        CommonHeader(title: LocaleKeys.keyStatus.localized, flex: 2),
        CommonHeader(title: ''),
      ],

      // Data list from ads controller
      childrenHeader: purchaseListWatch.purchaseList,

      // Row builder for each data row
      childrenContent: (index) {
        final item = purchaseListWatch.purchaseList[index];
        return [
          CommonRow(title: item.destinationName ?? '', flex: 2),
          CommonRow(title: item.purchaseType ?? '', flex: 2),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                PurchaseStatusWidget(status: item.status ?? ''),
                Spacer(),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Refund Button
                Visibility(
                  visible: item.status=='COMPLETED' && item.purchaseType=='FILLER' /*&& item.paymentType=='PARTIAL'*/,
                  child: Flexible(
                    child: CommonButton(
                      height: 32,
                      width: context.width * 0.1,
                      onTap: () {
                        purchaseListWatch.clearRefundDialogValue();
                        purchaseListWatch.purchaseRefundDetailApi(purchaseUuid: item.uuid);
                        showCommonWebDialog(
                          keyBadge: purchaseListWatch.refundDialogKey,
                          context: context,
                          dialogBody: RefundDialog(purchaseUuid: item.uuid),
                          height: 0.67,
                          width: 0.4,
                        );
                      },
                      buttonText: LocaleKeys.keyRefund.localized,
                      buttonTextColor: AppColors.clr2997FC,
                      backgroundColor: AppColors.clrEAF5FF,
                      borderColor: AppColors.clr2997FC,
                    ),
                  ).paddingOnly(right: context.width*0.01),
                ),

                /// Cancel Text Button
                Visibility(
                  visible: (item.status=='UPCOMING' || item.status=='ONGOING') && item.paymentType=='PARTIAL',
                  child: InkWell(
                    onTap: () async {
                      purchaseListWatch.clearCancelDialogValue();
                      purchaseListWatch.purchaseCancelDetailApi(purchaseUuid: item.uuid);
                      showCommonWebDialog(
                        keyBadge: purchaseListWatch.cancelDialogKey,
                        context: context,
                        dialogBody: CancelDialog(purchaseUuid: item.uuid),
                        height: 0.67,
                        width: 0.4,
                      );
                    },
                    child: CommonText(
                      title: LocaleKeys.keyCancel.localized,
                      clrFont: AppColors.clrFF3B30,
                      fontWeight: TextStyles.fwMedium,
                      textDecoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ).alignAtCenterRight(),
          ),
        ];
      },

      // Show forward arrow icon
      isDetailsAvailable: true,

      // // Callback for status switch toggle
      // onStatusTap: (value, index) {
      //   clientDetailsWatch.updateAdsListStatusIndex(index);
      // },

      // Call pagination api method here
      isLoading: purchaseListWatch.purchaseListState.isLoading,
      isLoadMore: purchaseListWatch.purchaseListState.isLoadMore,
      onForwardArrow: (index){
        ref.read(navigationStackController).push(NavigationStackItem.purchaseDetails(purchaseUuid:purchaseListWatch.purchaseList[index].uuid??''));
      },
      onScrollListener: () {
        if (!purchaseListWatch.purchaseListState.isLoadMore &&
            purchaseListWatch.purchaseListState.success?.hasNextPage == true) {
          if (context.mounted) {
            purchaseListWatch.purchaseListApi(odigoClientUuid: widget.clientUuid ?? '', false);
          }
        }
      },
    );
  }
}
