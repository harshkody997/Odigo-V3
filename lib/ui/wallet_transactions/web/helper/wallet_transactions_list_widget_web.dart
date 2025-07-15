import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/wallet_transactions/wallet_transactions_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_overlay_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_status_button_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class WalletTransactionsListWidgetWeb extends ConsumerWidget {
  const WalletTransactionsListWidgetWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletWatch = ref.watch(walletTransactionsController);
    return CommonTableGenerator(
      headerContent: [
        CommonHeader(title: LocaleKeys.keyDate.localized),
        CommonHeader(title: LocaleKeys.keyTransactionId.localized,flex: 2),
        CommonHeader(title: LocaleKeys.keyTime.localized),
        CommonHeader(title: LocaleKeys.keyClientName.localized),
        CommonHeader(title: LocaleKeys.keyType.localized,flex: 2),
        CommonHeader(title: LocaleKeys.keyAmount.localized),
        CommonHeader(title: LocaleKeys.keyStatus.localized,),
        CommonHeader(title:''),
      ],
      childrenHeader: walletWatch.walletList,
      childrenContent: (index) {
        final item = walletWatch.walletList[index];
        return [
          CommonRow(title: formatUtcToLocalDate(item.createdAt) ?? ''),
          CommonRow(title: item.uuid ?? '-',flex: 2),
          CommonRow(title: formatTime(item.createdAt ?? 0)??'-'),
          CommonRow(title: item.odigoClientName ?? '-'),
          CommonRow(flex:2,widget: Row(
            children: [
              Expanded(flex:4,child: CommonStatusButton(status: item.transactionType??'',imagePadding: 5,iconName: item.transactionType == TransactionsType.CREDIT.name?Assets.svgs.svgArrowUpCredit.keyName:Assets.svgs.svgArrowDownDebit.keyName,width: 100,)),
              Spacer(flex: item.transactionType =='CREDIT'? 6:7),
            ],
          ), title: ''),
          CommonRow(title: '${AppConstants.currency} ${(item.originalPrice??'-').toString()}'),
          CommonRow(widget: Row(
            children: [
              Expanded(flex:3,child: CommonStatusButton(status: item.status??'',dotRequired: false,width: 50,)),
              Spacer(flex: 2),
            ],
          ),title: '',),
          CommonRow(
            title:'',
            widget:item.remarks != null && (item.remarks?.isNotEmpty??false)? SizedBox(
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
            ): const Offstage(),),

        ];
      },
      onScrollListener: () async{
        if (!walletWatch.walletListState.isLoadMore && walletWatch.walletListState.success?.hasNextPage == true) {
          if (context.mounted) {
            await walletWatch.walletListApi(true);
          }
        }
      },
      isLoading: walletWatch.walletListState.isLoading,
      isLoadMore: walletWatch.walletListState.isLoadMore,
    );
  }
}
