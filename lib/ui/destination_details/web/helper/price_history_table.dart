import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/table_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class PriceHistoryTable extends ConsumerStatefulWidget {
  const PriceHistoryTable({Key? key}) : super(key: key);

  @override
  ConsumerState<PriceHistoryTable> createState() => _PriceHistoryTableState();
}

class _PriceHistoryTableState extends ConsumerState<PriceHistoryTable> {
  ///Build
  @override
  Widget build(BuildContext context) {
    // Watch state providers
    final tableWatch = ref.watch(tableController);
    final destinationDetailsWatch = ref.watch(destinationDetailsController);

    return Container(
      child: CommonTableGenerator(
        // Header widgets for the table
        headerContent: [
          CommonHeader(title: LocaleKeys.keyDate.localized),
          CommonHeader(title: LocaleKeys.keyTime.localized),
          CommonHeader(title: LocaleKeys.keyPremiumPrice.localized),
          CommonHeader(title: LocaleKeys.keyFillerPrice.localized),
        ],

        // Data list from ads controller
        childrenHeader: destinationDetailsWatch.priceHistoryList,

        // Row builder for each data row
        childrenContent: (index) {
          final item = destinationDetailsWatch.priceHistoryList[index];
          return [
            CommonRow(title: item?.createdAt.toString() ?? '-'),
            CommonRow(title: item?.createdAt.toString() ?? '-'),
            CommonRow(title: item?.premiumPrice.toString() ?? '-'),
            CommonRow(title: item?.fillerPrice.toString() ?? '-'),
          ];
        },

        onScrollListener: () {
          print('Api method called');
        },
        isLoading: destinationDetailsWatch.storeListState.isLoading,
      ),
    );
  }
}
