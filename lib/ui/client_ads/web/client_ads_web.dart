import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_list_controller.dart';
import 'package:odigov3/framework/controller/client_ads/client_ads_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/client/model/response/client_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/client_ads/web/helper/client_ads_table.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class ClientAdsWeb extends ConsumerStatefulWidget {
  const ClientAdsWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<ClientAdsWeb> createState() => _ClientAdsWebState();
}

class _ClientAdsWebState extends ConsumerState<ClientAdsWeb> {

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    final clientAdsWatch = ref.watch(clientAdsController);
    final drawerWatch = ref.watch(drawerController);
    return BaseDrawerPageWidget(
      showAddButton: drawerWatch.selectedMainScreen?.canAdd,
      addButtonOnTap: () {
        ref.read(navigationStackController).push(NavigationStackItemCreateAdsClientPage());
      },
      addButtonText: LocaleKeys.keyAddClientAds.localized,
      showSearchBar: true,
      searchController: clientAdsWatch.searchCtr,
      searchPlaceHolderText: LocaleKeys.keySearchAds.localized,
      searchOnChanged: (value){
        clientAdsWatch.clientAdsListApi(context);
      },
      totalCount: clientAdsWatch.clientAdsListState.success?.totalCount,
      listName: LocaleKeys.keyAds.localized,
      showFilters: true,
      filterButtonOnTap: (){
        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: clientAdsWatch.filterKey,
          context: context,
          dialogBody: Consumer(
              builder: (context,ref,child) {
                final clientAdsWatch = ref.watch(clientAdsController);
                final clientListWatch = ref.watch(clientListController);
                return CommonStatusTypeFilterWidget(
                  isFilterSelected: clientAdsWatch.isFilterSelected,
                  isClearFilterCall: clientAdsWatch.isClearFilterCall,
                  onSelectFilterTap: (filterType)=> clientAdsWatch.updateTempSelectedStatus(filterType),
                  groupValue: clientAdsWatch.selectedTempFilter,
                  onCloseTap: (){
                    clientAdsWatch.updateTempSelectedStatus(clientAdsWatch.selectedFilter);
                    clientAdsWatch.updateTempSelectedClient(clientAdsWatch.selectedClientFilter);
                  },
                  onApplyFilterTap: (){
                    clientAdsWatch.updateSelectedStatus(clientAdsWatch.selectedTempFilter);
                    clientAdsWatch.updateSelectedClient(clientAdsWatch.selectedClientTempFilter);
                    clientAdsWatch.clientAdsListApi(context);
                  },
                  onClearFilterTap: (){
                    clientAdsWatch.resetFilter();
                    clientAdsWatch.clientAdsListApi(context);
                  },
                  otherFilterWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: AppColors.clrE5E7EB).paddingSymmetric(vertical: context.height * 0.01),
                      CommonText(
                        title: LocaleKeys.keyClients.localized,
                        fontSize: 14,
                        fontWeight: TextStyles.fwSemiBold,
                      ).paddingOnly(bottom: context.height * 0.015),
                      CommonSearchableDropdown<ClientData>(
                        onSelected: (value) {
                          clientAdsWatch.updateTempSelectedClient(value);
                        },
                        title: (value) {
                          return (value.name ?? '');
                        },
                        textEditingController: clientAdsWatch.clientFilterCtr,
                        items: clientListWatch.clientList,
                        validator: (value) => null,
                        hintText: LocaleKeys.keySelectClients.localized,
                        onScrollListener: () async {
                          if (!clientListWatch.clientListState.isLoadMore && clientListWatch.clientListState.success?.hasNextPage == true) {
                            if (mounted) {
                              await clientListWatch.getClientApi(context,pagination: true, activeRecords: true);
                              ref.read(searchController).notifyListeners();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
          ),
          height: 1,
          width: 0.5,
        );
      },
      body: ClientAdsTable(),
    );
  }

}


