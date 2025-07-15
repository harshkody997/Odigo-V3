import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/controller/destination/manage_destination_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/destination_type/destination_type_list_controller.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/destination_type_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/destination/web/helper/destination_table.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';

class DestinationWeb extends ConsumerStatefulWidget {
  const DestinationWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<DestinationWeb> createState() => _DestinationWebState();
}

class _DestinationWebState extends ConsumerState<DestinationWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    final destinationWatch = ref.watch(destinationController);
    return BaseDrawerPageWidget(
      addButtonText: LocaleKeys.keyAddDestination.localized,
      addButtonOnTap: () {
        ref.read(manageDestinationController).disposeController();
        ref.read(navigationStackController).push(NavigationStackItem.manageDestination());
      },
      showAddButton: ref.watch(drawerController).isMainScreenCanAdd,
      totalCount: destinationWatch.totalCount,
      listName: LocaleKeys.keyDestinations.localized,
      searchController: destinationWatch.searchCtr,
      searchPlaceHolderText: LocaleKeys.keySearchDestinations.localized,
      showSearchBar: true,
      searchOnChanged: (value){
        destinationWatch.clearDestinationList();
        destinationWatch.getDestinationListApi(context,activeRecords:destinationWatch.selectedFilter?.value,destinationTypeUuid: destinationWatch.selectedDestinationTypeFilter?.uuid);
      },
      showFilters: true,
      isFilterApplied: destinationWatch.isFilterApplied,
      filterButtonOnTap: (){
        /// reset value
        destinationWatch.updateTempSelectedStatus(destinationWatch.selectedFilter);
        destinationWatch.updateTempSelectedDestinationType(destinationWatch.selectedDestinationTypeFilter);

        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: destinationWatch.filterKey,
          context: context,
          dialogBody: Consumer(
              builder: (context,ref,child) {
                final destinationWatch = ref.watch(destinationController);
                final destinationTypeWatch = ref.watch(destinationTypeListController);
                return CommonStatusTypeFilterWidget(
                  isFilterSelected: destinationWatch.isFilterSelected,
                  isClearFilterCall: destinationWatch.isClearFilterCall,
                  onSelectFilterTap: (filterType)=> destinationWatch.updateTempSelectedStatus(filterType),
                  groupValue: destinationWatch.selectedTempFilter,
                  onCloseTap: (){
                    destinationWatch.updateTempSelectedStatus(destinationWatch.selectedFilter);
                    destinationWatch.updateTempSelectedDestinationType(destinationWatch.selectedDestinationTypeFilter);
                  },
                  onApplyFilterTap: (){
                    destinationWatch.updateSelectedStatus(destinationWatch.selectedTempFilter);
                    destinationWatch.updateSelectedDestinationType(destinationWatch.selectedDestinationTypeTempFilter);
                    destinationWatch.clearDestinationList();
                    destinationWatch.getDestinationListApi(context,activeRecords: destinationWatch.selectedFilter?.value,destinationTypeUuid: destinationWatch.selectedDestinationTypeFilter?.uuid);
                  },
                  onClearFilterTap: (){
                    destinationWatch.resetFilter();
                    destinationWatch.clearDestinationList();
                    destinationWatch.getDestinationListApi(context,activeRecords: destinationWatch.selectedFilter?.value,destinationTypeUuid: destinationWatch.selectedDestinationTypeFilter?.uuid);
                  },
                  otherFilterWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: AppColors.clrE5E7EB).paddingSymmetric(vertical: context.height * 0.01),
                      CommonText(
                        title: LocaleKeys.keyFilterByDestinationType.localized,
                        fontSize: 14,
                        fontWeight: TextStyles.fwSemiBold,
                      ).paddingOnly(bottom: context.height * 0.015),
                      CommonSearchableDropdown<DestinationType>(
                        onSelected: (value) {
                          destinationWatch.updateTempSelectedDestinationType(value);
                        },
                        title: (value) {
                          return (value.name ?? '');
                        },
                        textEditingController: destinationWatch.destinationTypeCtr,
                        items: destinationTypeWatch.destinationTypeList,
                        validator: (value) => null,
                        hintText: LocaleKeys.keySelectDestinationType.localized,
                        onScrollListener: () async {
                          if (!destinationTypeWatch.destinationTypeListState.isLoadMore && destinationTypeWatch.destinationTypeListState.success?.hasNextPage == true) {
                            if (mounted) {
                              await destinationTypeWatch.getDestinationTypeListAPI(context,pagination: true,activeRecords: true);
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
      body: DestinationTable(),
    );
  }
}
