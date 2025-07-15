
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_list_controller.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/purchase/web/helper/purchase_filter_widget.dart';
import 'package:odigov3/ui/purchase/web/helper/purchase_list_table_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';

class PurchaseListWeb extends ConsumerWidget {
  const PurchaseListWeb({super.key});

  ///Build Override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseListWatch = ref.watch(purchaseListController);

    return BaseDrawerPageWidget(
      showSearchBar: true,
      searchController: purchaseListWatch.purchaseSearchController,
      searchOnChanged: (value) async {
        await purchaseListWatch.purchaseListApi(false);
      },
      showFilters: true,
      filterButtonOnTap: () {
        /// filter dialog
        showCommonDetailDialog(
          keyBadge: purchaseListWatch.filterKey,
          context: context,
          dialogBody: PurchaseFilterWidgetWeb(),
          height: 1,
          width: 0.5,
        );
      },
      isFilterApplied:  (purchaseListWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title) || (purchaseListWatch.selectedStartDate != null && purchaseListWatch.selectedEndDate != null) || (purchaseListWatch.selectedPaymentType.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title) || (purchaseListWatch.selectedPurchaseType.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title),
      listName: LocaleKeys.keyPurchases.localized,
      totalCount: purchaseListWatch.purchaseListState.success?.totalCount,
      body: PurchaseListTableWidget(),
    );
  }
}
