import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/purchase_transaction/purchase_transaction_controller.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/purchase_transaction/web/helper/purchase_transaction_filter_widget_web.dart';
import 'package:odigov3/ui/purchase_transaction/web/purchase_transaction_web.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PurchaseTransaction extends ConsumerStatefulWidget {
  const PurchaseTransaction({Key? key}) : super(key: key);

  @override
  ConsumerState<PurchaseTransaction> createState() => _PurchaseTransactionState();
}

class _PurchaseTransactionState extends ConsumerState<PurchaseTransaction> with WidgetsBindingObserver, ZoomAwareMixin{

  @override
  void initState() {
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    /// Restrict api call if view permission is not given
    if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
      final transactionRead = ref.read(purchaseTransactionController);
      transactionRead.disposeController(isNotify: false);
      SchedulerBinding.instance.addPostFrameCallback((callback) async{
        await transactionRead.purchaseTransactionListApi(false);
      });
    }
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          final transactionWatch = ref.watch(purchaseTransactionController);
          return BaseDrawerPageWidget(
              body: PurchaseTransactionWeb(),
              totalCount:transactionWatch.purchaseTransactionListState.success?.totalCount,
              listName: LocaleKeys.keyPurchaseTransaction.localized,
              showExport: false,
              showImport: false,
              showSearchBar: false,
              showAppBar: true,
              showFilters: true,
              filterButtonOnTap: () {
                /// filter dialog
                showCommonDetailDialog(
                  keyBadge: transactionWatch.filterKey,
                  context: context,
                  dialogBody: PurchaseTransactionListFilterWidgetWeb(),
                  height: 1,
                  width: 0.5,
                );
              },
              isFilterApplied:  (transactionWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title) || (transactionWatch.selectedStartDate != null && transactionWatch.selectedEndDate != null),

            );
          //:DummyPage();
        },
        tablet: (BuildContext context) {
          final transactionWatch = ref.watch(purchaseTransactionController);
          return BaseDrawerPageWidget(
              body: PurchaseTransactionWeb(),
              totalCount:transactionWatch.purchaseTransactionListState.success?.totalCount,
              listName: LocaleKeys.keyPurchaseTransaction.localized,
              showExport: false,
              showImport: false,
              showSearchBar: false,
              showAppBar: true,
              showFilters: true,
              filterButtonOnTap: () {
                /// filter dialog
                showCommonDetailDialog(
                  keyBadge: transactionWatch.filterKey,
                  context: context,
                  dialogBody: PurchaseTransactionListFilterWidgetWeb(),
                  height: 1,
                  width: 0.5,
                );
              },
              isFilterApplied:  (transactionWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title) || (transactionWatch.selectedStartDate != null && transactionWatch.selectedEndDate != null),
            );
          //:DummyPage();
        },
      desktop: (BuildContext context) {
        final transactionWatch = ref.watch(purchaseTransactionController);
        return BaseDrawerPageWidget(
            body: PurchaseTransactionWeb(),
            totalCount:transactionWatch.purchaseTransactionListState.success?.totalCount,
            listName: LocaleKeys.keyPurchaseTransaction.localized,
            showExport: false,
            showImport: false,
            showSearchBar: false,
            showAppBar: true,
            showFilters: true,
            filterButtonOnTap: () {
              /// filter dialog
              showCommonDetailDialog(
                keyBadge: transactionWatch.filterKey,
                context: context,
                dialogBody: PurchaseTransactionListFilterWidgetWeb(),
                height: 1,
                width: 0.5,
              );
            },
            isFilterApplied:  (transactionWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title) || (transactionWatch.selectedStartDate != null && transactionWatch.selectedEndDate != null),
          );
        //:DummyPage();
      },
    );
  }
}

