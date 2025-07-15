import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/purchase_transaction/web/helper/settle_transaction_widget_web.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_overlay_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_status_button_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class PurchaseTransactionHistoryTable extends ConsumerWidget {
  final String? purchaseUuid;
  const PurchaseTransactionHistoryTable({Key? key,required this.purchaseUuid}) : super(key: key);

  ///Build
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseDetailsWatch = ref.watch(purchaseDetailsController);
    return CommonTableGenerator(
      /// Header widgets for the table
      headerContent: [
        ///Installment Date
        CommonHeader(title: LocaleKeys.keyInstallmentDate.localized, flex: 2),
        ///Original Price
        CommonHeader(title: LocaleKeys.keyOriginalPrice.localized, flex: 2),
        ///Status
        CommonHeader(title: LocaleKeys.keyStatus.localized, flex: 2),

        ///Click To Settle
        CommonHeader(title: '',flex: 2),

        /// remarks
        CommonHeader(title: '',),

      ],

      ///List
      childrenHeader: purchaseDetailsWatch.purchaseTransactionList,

      /// Row builder for each data row
      childrenContent: (index) {
        final item = purchaseDetailsWatch.purchaseTransactionList[index];
        return [
          ///Installment Date
          CommonRow(title: formatDateToDDMMYYYY(item.installmentDate), flex: 2),
          ///Original Price
          CommonRow(title: '${AppConstants.currency} ${item.originalPrice}', flex: 2),
          ///Status
          CommonRow(flex:2,widget: Row(
            children: [
              Expanded(flex:2,child: CommonStatusButton(status: item.status??'',dotRequired:true)),
              Spacer(flex: 2),
            ],
          ), title: ''),
          ///Click To Settle
          CommonRow(
            flex: 2,
            title:'',
            widget:(item.status== StatusEnum.PENDING.name)?
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Visibility(
                    visible: purchaseDetailsWatch.purchaseDetailState.success?.data?.status!='CANCELLED',
                    child: CommonButton(
                      height: 30,
                      buttonText:LocaleKeys.keyClickToSettle.localized,
                      borderRadius: BorderRadius.circular(8),
                      borderColor: AppColors.clr03A12B,
                      backgroundColor: AppColors.clrEBFFF0,
                      buttonTextStyle: TextStyles.medium.copyWith(
                        color: AppColors.clr03A12B,
                        fontSize: 12,
                      ),
                      onTap: (){
                        showCommonWebDialog(
                          context: context,
                          keyBadge: purchaseDetailsWatch.settlePaymentDialogKey,
                          dialogBody: SettleTransactionDialogWidgetWeb(transactionId:item.uuid??'',purchaseCreatedDate: DateTime.parse(formatUtcToLocalDate(item.createdAt,outputFormat: 'yyyy-MM-dd',isLocaleNotRequired: true)??'-'),purchaseUuid: purchaseUuid,screenName: ScreenName.purchaseDetails),
                          height: 0.8,
                          width: 0.34,
                        );
                      },
                    ),
                  ),
                ),
                Spacer(flex: 1),
              ],
            ).alignAtCenterRight(): const Offstage(),
          ),
          /// remarks
          CommonRow(
            title:'',
            widget:item.remarks != null? SizedBox(
              height: 15,
              width: 30,
              child: CommonOverlayWidget(
                  child: CommonSVG(strIcon:Assets.svgs.svgInfo2.keyName,height: 20, width: 15).alignAtCenterRight(),
                  overlayChild: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: context.width* 0.01, vertical: context.height * 0.01),
                    child: CommonText(
                      title: item.remarks??'-',
                      style: TextStyles.regular.copyWith(fontSize: 14),
                      maxLines: 10,
                    ),
                  )
              ),
            ): const Offstage(),)
        ];
      },

      /// scroll listener
      isLoading: purchaseDetailsWatch.purchaseTransactionListState.isLoading,
      isLoadMore: purchaseDetailsWatch.purchaseTransactionListState.isLoadMore,
      onScrollListener: () {
        if (!purchaseDetailsWatch.purchaseTransactionListState.isLoadMore &&
            purchaseDetailsWatch.purchaseTransactionListState.success?.hasNextPage == true) {
          if (context.mounted) {
            purchaseDetailsWatch.purchaseTransactionListApi(true,purchaseUuid: purchaseUuid);
          }
        }
      },


    );
  }
}
