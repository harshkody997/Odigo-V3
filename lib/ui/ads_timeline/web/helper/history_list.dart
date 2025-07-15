import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_timline/history_listing_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/repository/ads_sequence/model/ads_sequence_history_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class HistoryList extends ConsumerStatefulWidget {
  const HistoryList({super.key});

  @override
  ConsumerState<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends ConsumerState<HistoryList> {
  @override
  Widget build(BuildContext context) {
    final historyListingWatch = ref.watch(historyListingController);
    final destinationWatch = ref.watch(destinationController);

    return historyListingWatch.selectedDestination != null ? CommonTableGenerator(
      // Header widgets for the table
      headerContent: [
        CommonHeader(title: LocaleKeys.keySlotNo.localized, flex: 2),
        CommonHeader(title: LocaleKeys.keySlotType.localized, flex: 2),
        CommonHeader(title: LocaleKeys.keySetNo.localized, flex: 2),
        CommonHeader(title: LocaleKeys.keyClientName.localized, flex: 2),
      ],

      // Data list from ads controller
      childrenHeader: historyListingWatch.historyList,

      // Row builder for each data row
      childrenContent: (index) {
        final item = historyListingWatch.historyList[index];
        return [
          CommonRow(title: item.slotNumber.toString() ?? '', flex: 2),

          Expanded(
            flex: 2,
            child: Row(
              children: [
                slotType(item),
                Spacer(),
              ],
            ),
          ),
          CommonRow(title: item.setNumber.toString() ?? '', flex: 2),
          CommonRow(title: item.odigoClientName ?? '-', flex: 2),
        ];
      },

      /// scroll listener
      isLoading: historyListingWatch.adsSequenceHistoryListState.isLoading || destinationWatch.destinationListState.isLoading,
      isLoadMore: historyListingWatch.adsSequenceHistoryListState.isLoadMore,
      onScrollListener: () {
        if (!historyListingWatch.adsSequenceHistoryListState.isLoadMore && historyListingWatch.adsSequenceHistoryListState.success?.hasNextPage == true) {
          if (context.mounted) {
            historyListingWatch.getAdsSequenceHistoryApi(context, pagination: true);
          }
        }
      },
    ) : Offstage();
  }
}

Widget slotType(AdsSequenceHistoryData item) {
  return Container(
    decoration: BoxDecoration(color: item.purchaseUuid != null ? AppColors.clrECFDF3 : AppColors.clrEAECF0, borderRadius: BorderRadius.circular(20)),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: CommonText(
      title: item.purchaseUuid != null ? LocaleKeys.keyPurchased.localized : LocaleKeys.keyDefault.localized,
      style: TextStyles.medium.copyWith(fontSize: 14, color: item.purchaseUuid != null ? AppColors.clr027A48 : AppColors.clr6E6E6E),
      maxLines: 10,
    ),
  );
}
