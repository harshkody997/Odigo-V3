import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/add_update_client_controller.dart';
import 'package:odigov3/framework/controller/client/client_list_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class ClientListWeb extends ConsumerWidget {
  const ClientListWeb({super.key});

  ///Build Override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientWatch = ref.watch(clientListController);
    final drawerWatch = ref.watch(drawerController);
    return BaseDrawerPageWidget(
      totalCount: clientWatch.clientListState.success?.totalCount ?? 0,
      listName: LocaleKeys.keyClients.localized,
      searchPlaceHolderText: LocaleKeys.keySearchClients.localized,
      addButtonText: LocaleKeys.keyAddNewClient.localized,
      searchController: clientWatch.searchController,
      showSearchBar: true,
      showAddButton: drawerWatch.selectedMainScreen?.canAdd,
      showAppBar: true,
      showFilters: true,
      filterButtonOnTap: () {
        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: clientWatch.filterKey,
          context: context,
          dialogBody: Consumer(
            builder: (context, ref, child) {
              final clientWatch = ref.watch(clientListController);
              return CommonStatusTypeFilterWidget(
                groupValue: clientWatch.selectedTempFilter,
                onSelectFilterTap: (filterType) => clientWatch.updateTempSelectedStatus(filterType),
                isFilterSelected: clientWatch.isFilterSelected,
                isClearFilterCall: clientWatch.isClearFilterCall,
                onCloseTap: () {
                  clientWatch.updateTempSelectedStatus(clientWatch.selectedFilter);
                },
                onApplyFilterTap: () {
                  clientWatch.updateSelectedStatus(clientWatch.selectedTempFilter);
                  clientWatch.clearClientList();
                  clientWatch.getClientApi(context, activeRecords: clientWatch.selectedFilter?.value);
                },
                onClearFilterTap: () {
                  clientWatch.resetFilter();
                  clientWatch.clearClientList();
                  clientWatch.getClientApi(context, activeRecords: clientWatch.selectedFilter?.value);
                },
              );
            },
          ),
          height: 1,
          width: 0.5,
        );
      },
      addButtonOnTap: () {
        ref.read(navigationStackController).push(NavigationStackItem.addClient());
      },
      searchOnChanged: (value) {
        clientWatch.onSearchChanged(context);
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Client Table Widget
          Expanded(
            child: CommonTableGenerator(
              /// Header widgets for the table
              headerContent: [
                CommonHeader(title: LocaleKeys.keyStatus.localized),
                CommonHeader(title: LocaleKeys.keyClientName.localized, flex: 2),
                CommonHeader(title: LocaleKeys.keyEmailID.localized, flex: 3),
                CommonHeader(title: LocaleKeys.keyContact.localized, flex: 2),
                CommonHeader(title: LocaleKeys.keyAddress.localized, flex: 5),
              ],

              /// Data list from ads controller
              childrenHeader: clientWatch.clientList,

              /// Row builder for each data row
              childrenContent: (index) {
                final item = clientWatch.clientList[index];
                return [
                  /// Client Image & Client Name
                  CommonRow(title: item.name ?? '', flex: 2),
                  CommonRow(title: item.email ?? '', flex: 3),
                  CommonRow(title: item.contactNumber ?? '', flex: 2),
                  CommonRow(title: clientWatch.formatFullAddress(item), flex: 5),
                  CommonRow(title: ''),
                ];
              },

              // Feature toggles
              isStatusAvailable: true,
              // Enable status switch
              isDetailsAvailable: true,

              onForwardArrow: (index) {
                ref
                    .read(navigationStackController)
                    .push(NavigationStackItem.clientDetails(clientUuid: clientWatch.clientList[index].uuid));
              },

              // Update Status Switch Value
              onStatusTap: (value, index) async {
                clientWatch.updateStatusIndex(index);
                clientWatch.changeClientStatusAPI(context, clientWatch.clientList[index].uuid ?? '', value, index);
              },

              // Callback for status switch toggle
              statusValue: (index) => clientWatch.clientList[index].active,
              isSwitchLoading: (index) =>
                  clientWatch.changeClientStatusState.isLoading && index == clientWatch.statusTapIndex,
              onScrollListener: () async {
                if (!clientWatch.clientListState.isLoadMore &&
                    clientWatch.clientListState.success?.hasNextPage == true) {
                  if (context.mounted) {
                    await clientWatch.getClientApi(context, pagination: true);
                  }
                }
              },

              // Take reference from api loading variables
              isLoading: clientWatch.clientListState.isLoading,
              isLoadMore: clientWatch.clientListState.isLoadMore,

              /// edit
              isEditAvailable: drawerWatch.selectedMainScreen?.canEdit,
              isEditVisible: (index) => clientWatch.clientList[index].active,
              onEdit: (index) {
                ref
                    .read(addUpdateClientController)
                    .getDocumentImageByUuidApi(context, clientWatch.clientList[index].uuid ?? '');
                ref
                    .read(navigationStackController)
                    .push(NavigationStackItem.addClient(clientUUid: clientWatch.clientList[index].uuid));
              },
            ),
          ),
        ],
      ),
    );
  }
}
