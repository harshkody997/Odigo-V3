import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class PurchaseWeekTable extends ConsumerWidget {
  const PurchaseWeekTable({Key? key}) : super(key: key);

  ///Build
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseDetailsWatch = ref.watch(purchaseDetailsController);
    return CommonTableGenerator(

      isLoading: purchaseDetailsWatch.purchaseDetailState.isLoading,

      /// Header widgets for the table
      headerContent: [
        ///Week
        CommonHeader(title: LocaleKeys.keyWeek.localized, flex: 2),
        ///Start Date
        CommonHeader(title: LocaleKeys.keyStartDate.localized, flex: 2),
        ///End Date
        CommonHeader(title: LocaleKeys.keyEndDate.localized, flex: 2),
      ],

      ///List
      childrenHeader: purchaseDetailsWatch.purchaseDetailState.success?.data?.purchaseWeeks??[],

      /// Row builder for each data row
      childrenContent: (index) {
        final item = purchaseDetailsWatch.purchaseDetailState.success?.data?.purchaseWeeks?[index];
        return [
          ///Week
          CommonRow(title: '${LocaleKeys.keyWeek.localized} ${item?.week ?? ''}', flex: 2),
          ///Start Date
          CommonRow(title: formatDateToDDMMYYYY(item?.startDate), flex: 2),
          ///End Date
          CommonRow(title:formatDateToDDMMYYYY(item?.endDate), flex: 2),
        ];
      }, onScrollListener: () {  },


    );
  }
}
