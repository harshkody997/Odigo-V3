import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/wallet_transactions/wallet_transactions_controller.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/wallet_transactions/web/helper/wallet_filter_widget_web.dart';
import 'package:odigov3/ui/wallet_transactions/web/wallet_transactions_web.dart';
import 'package:responsive_builder/responsive_builder.dart';


class WalletTransactions extends ConsumerStatefulWidget {
  const WalletTransactions({Key? key}) : super(key: key);

  @override
  ConsumerState<WalletTransactions> createState() => _WalletTransactionsState();
}

class _WalletTransactionsState extends ConsumerState<WalletTransactions> with WidgetsBindingObserver, ZoomAwareMixin {
  @override
  void initState() {
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    /// Restrict api call if view permission is not given
    if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
      final walletRead = ref.read(walletTransactionsController);
      walletRead.disposeController(isNotify: false);
      SchedulerBinding.instance.addPostFrameCallback((callback) async{
        await walletRead.walletListApi(false);
      });
    }
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        final walletWatch = ref.watch(walletTransactionsController);
        return BaseDrawerPageWidget(
            body: WalletTransactionsWeb(),
            totalCount:walletWatch.walletListState.success?.totalCount,
            listName: LocaleKeys.keyWalletTransactions.localized,
            showExport: false,
            showImport: false,
            showSearchBar: false,
            showAppBar: true,
            showFilters: true,
            filterButtonOnTap: () {
              /// filter dialog
              showCommonDetailDialog(
                keyBadge: walletWatch.filterKey,
                context: context,
                dialogBody: WalletListFilterWidgetWeb(),
                height: 1,
                width: 0.5,
              );
            },
          isFilterApplied:  (walletWatch.selectedType.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title) || (walletWatch.selectedStartDate != null && walletWatch.selectedEndDate != null),
        );
        //:DummyPage();
      },
      tablet: (BuildContext context) {
        final walletWatch = ref.watch(walletTransactionsController);
        return BaseDrawerPageWidget(
            body: WalletTransactionsWeb(),
            totalCount:walletWatch.walletListState.success?.totalCount,
            listName: LocaleKeys.keyWalletTransactions.localized,
            showExport: false,
            showImport: false,
            showSearchBar: false,
            showAppBar: true,
            showFilters: true,
            filterButtonOnTap: () {
              /// filter dialog
              showCommonDetailDialog(
                keyBadge: walletWatch.filterKey,
                context: context,
                dialogBody: WalletListFilterWidgetWeb(),
                height: 1,
                width: 0.5,
              );
            },
          isFilterApplied:  (walletWatch.selectedType.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title) || (walletWatch.selectedStartDate != null && walletWatch.selectedEndDate != null),
        );
        //:DummyPage();
      },
      desktop: (BuildContext context) {
        final walletWatch = ref.watch(walletTransactionsController);
        return BaseDrawerPageWidget(
            body: WalletTransactionsWeb(),
            totalCount:walletWatch.walletListState.success?.totalCount,
            listName: LocaleKeys.keyWalletTransactions.localized,
            showExport: false,
            showImport: false,
            showSearchBar: false,
            showAppBar: true,
            showFilters: true,
            filterButtonOnTap: () {
              /// filter dialog
              showCommonDetailDialog(
                keyBadge: walletWatch.filterKey,
                context: context,
                dialogBody: WalletListFilterWidgetWeb(),
                height: 1,
                width: 0.5,
              );
            },
          isFilterApplied:  (walletWatch.selectedType.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title) || (walletWatch.selectedStartDate != null && walletWatch.selectedEndDate != null),
        );
        //:DummyPage();
      },
    );
  }
}

