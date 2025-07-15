import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/wallet_transactions/wallet_transactions_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_overlay_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_status_button_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class WalletHistoryTable extends ConsumerStatefulWidget {
  final String? clientUuid;
  const WalletHistoryTable({super.key,required this.clientUuid});

  @override
  ConsumerState<WalletHistoryTable> createState() => _WalletHistoryTableState();
}

class _WalletHistoryTableState extends ConsumerState<WalletHistoryTable> {

  @override
  void initState() {
    super.initState();
    final walletTransactionRead = ref.read(walletTransactionsController);
    walletTransactionRead.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      walletTransactionRead.walletListApi(false,clientUuid: widget.clientUuid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletTransactionWatch = ref.watch(walletTransactionsController);
    return CommonTableGenerator(
        headerContent: [
          CommonHeader(title: LocaleKeys.keyDate.localized),
          CommonHeader(title: LocaleKeys.keyTime.localized),
          CommonHeader(title: LocaleKeys.keyTransactionId.localized),
          CommonHeader(title: LocaleKeys.keyAmount.localized),
          CommonHeader(title: LocaleKeys.keyType.localized),
          CommonHeader(title: LocaleKeys.keyInfo.localized),
          CommonHeader(title: ''),
        ],
        childrenHeader: walletTransactionWatch.walletList,
        childrenContent: (index){
          final item = walletTransactionWatch.walletList[index];
          return [
            CommonRow(title: formatUtcToLocalDate(item.createdAt) ?? ''), /// date
            CommonRow(title: formatTime(item.createdAt ?? 0)??'-'), /// time
            CommonRow(title: item.uuid ?? '-'), /// transaction id
            CommonRow(widget: Row( /// type
              children: [
                Expanded(flex:2,child: CommonStatusButton(status: item.transactionType??'',iconName: item.transactionType == TransactionsType.CREDIT.name?Assets.svgs.svgArrowUpCredit.keyName:Assets.svgs.svgArrowDownDebit.keyName,width: 200,)),
                Spacer(flex: 2),
              ],
            ), title: ''),
            CommonRow(title: '${AppConstants.currency} ${(item.originalPrice??'-').toString()}'),
            CommonRow(widget: Row( /// info
              children: [
                Expanded(flex:3,child: CommonStatusButton(status: item.status??'',dotRequired: false,width: 50,)),
                Spacer(flex: 2),
              ],
            ),title: '',),

            /// Remarks overlay
            CommonRow(
              title: '',
              widget: item.remarks != null || (item.remarks != '') ? SizedBox(
                height: 15,
                width: 30,
                child: CommonOverlayWidget(
                    child: CommonSVG(strIcon: Assets.svgs.svgInfo2.keyName, height: 20, width: 15).alignAtCenterRight(),
                    overlayChild: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: context.width * 0.01, vertical: context.height * 0.01),
                      child: CommonText(
                        title: item.remarks ?? '-',
                        style: TextStyles.regular.copyWith(fontSize: 14),
                        maxLines: 10,
                      ),
                    )
                ),
              ) : const Offstage(),)

          ];
        },
      onScrollListener: () async{
        if (!walletTransactionWatch.walletListState.isLoadMore && walletTransactionWatch.walletListState.success?.hasNextPage == true) {
          if (context.mounted) {
            await walletTransactionWatch.walletListApi(true);
          }
        }
      },
      isLoading: walletTransactionWatch.walletListState.isLoading,
      isLoadMore: walletTransactionWatch.walletListState.isLoadMore,
    );
  }
}
