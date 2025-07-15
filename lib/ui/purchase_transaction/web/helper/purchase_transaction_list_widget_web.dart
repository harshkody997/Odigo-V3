import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase_transaction/purchase_transaction_controller.dart';
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
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class PurchaseTransactionListWidgetWeb extends ConsumerWidget {
  const PurchaseTransactionListWidgetWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionWatch = ref.watch(purchaseTransactionController);
    return CommonTableGenerator(
      headerContent: [
        CommonHeader(title: LocaleKeys.keyPurchaseId.localized,flex:3,),
        CommonHeader(title: LocaleKeys.keyCreatedDate.localized,flex:2,),
        CommonHeader(title: LocaleKeys.keyClientName.localized,flex:2,),
        CommonHeader(title: LocaleKeys.keyDestinationName.localized,flex:2,),
        CommonHeader(title: LocaleKeys.keyInstallmentDate.localized,flex: 2),
        CommonHeader(title: LocaleKeys.keyAmount.localized),
        CommonHeader(title: LocaleKeys.keyStatus.localized,flex: 2),
        CommonHeader(title: '',flex: 2),
        CommonHeader(title: '',),
      ],
      childrenHeader: transactionWatch.purchaseTransactionList,
      childrenContent: (index) {
        final item = transactionWatch.purchaseTransactionList[index];
        return [
          CommonRow(title: item.purchaseUuid ?? '-',flex:3,),
          CommonRow(title: formatUtcToLocalDate(item.createdAt) ?? '',flex:2),
          CommonRow(title: item.odigoClientName ?? '-',flex:2,),
          CommonRow(title: item.destinationName ?? '-',flex:2,),
          CommonRow(flex:2,title: item.installmentDate != null? DateFormat('dd/MM/yyyy',).format(DateTime.parse((item.installmentDate??'-').toString())):'-'),
          CommonRow(title: '${AppConstants.currency} ${(item.originalPrice??'-').toString()}'),
          CommonRow(flex:2,widget: Row(
            children: [
              Expanded(flex:3,child: CommonStatusButton(status: item.status??'',dotRequired:true)),
              Spacer(flex: 1),
            ],
          ), title: ''),
         CommonRow(
           flex: 2,
           title:'',
           widget:(item.status== StatusEnum.PENDING.name)?
           Row(
             children: [
               Expanded(
                 flex: 3,
                 child: CommonButton(
                   height: 30,
                   buttonText:LocaleKeys.keyMarkAsPaid.localized,
                   borderRadius: BorderRadius.circular(8),
                   borderColor: AppColors.clr03A12B,
                   backgroundColor: AppColors.clrEBFFF0,
                   buttonTextStyle: TextStyles.medium.copyWith(
                     color: AppColors.clr03A12B,
                     fontSize: 12,
                   ),
                   onTap: (){
                     if(item.createdAt != null){
                       showCommonWebDialog(
                         context: context,
                         keyBadge: transactionWatch.settleTransactionKey,
                         dialogBody: SettleTransactionDialogWidgetWeb(transactionId:item.uuid??'',purchaseCreatedDate: DateTime.parse(formatUtcToLocalDate(item.createdAt,outputFormat: 'yyyy-MM-dd',isLocaleNotRequired: true)??'-')),
                         height: 0.8,
                         width: 0.34,
                       );
                     }else{
                       showToast(context: context,isSuccess: false);
                     }
                   },
                  ),
               ),
               Spacer(flex: 1),
             ],
           ).alignAtCenterRight(): const Offstage(),
         ),
         CommonRow(
           title:'',
           widget:item.remarks != null &&  (item.remarks?.isNotEmpty??false)? SizedBox(
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
      onScrollListener: () async{
        if (!transactionWatch.purchaseTransactionListState.isLoadMore && (transactionWatch.purchaseTransactionListState.success?.hasNextPage??false)) {
          if (context.mounted) {
            await transactionWatch.purchaseTransactionListApi(true);
          }
        }
      },
      isLoading: transactionWatch.purchaseTransactionListState.isLoading,
      isLoadMore: transactionWatch.purchaseTransactionListState.isLoadMore,
    );
  }
}
