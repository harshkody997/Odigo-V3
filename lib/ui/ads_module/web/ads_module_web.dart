import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_module/ads_module_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/ads_module/web/helper/ads_module_table.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AdsModuleWeb extends ConsumerStatefulWidget {
  const AdsModuleWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<AdsModuleWeb> createState() => _AdsModuleWebState();
}

class _AdsModuleWebState extends ConsumerState<AdsModuleWeb> {

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    final adsListWatch = ref.watch(adsModuleController);
    final drawerWatch = ref.watch(drawerController);
    return BaseDrawerPageWidget(
      showAddButton: drawerWatch.selectedMainScreen?.canAdd,
      addButtonText: LocaleKeys.keyAddDestinationAds.localized,
      addButtonOnTap: () {
        ref.read(navigationStackController).push(NavigationStackItemCreateAdsDestinationPage());
      },
      showSearchBar: true,
      searchController: adsListWatch.searchCtr,
      searchPlaceHolderText: LocaleKeys.keySearchAds.localized,
      searchOnChanged: (value){
        adsListWatch.defaultAdsListApi(context);
      },
      totalCount: adsListWatch.defaultAdsListState.success?.totalCount,
      listName: LocaleKeys.keyAds.localized,
      showFilters: true,
      filterButtonOnTap: (){
        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: adsListWatch.filterKey,
          context: context,
          dialogBody: Consumer(
              builder: (context,ref,child) {
                final adsListWatch = ref.watch(adsModuleController);
                final destinationWatch = ref.watch(destinationController);
                return CommonStatusTypeFilterWidget(
                  isFilterSelected: adsListWatch.isFilterSelected,
                  isClearFilterCall: adsListWatch.isClearFilterCall,
                  onSelectFilterTap: (filterType)=> adsListWatch.updateTempSelectedStatus(filterType),
                  groupValue: adsListWatch.selectedTempFilter,
                  onCloseTap: (){
                    adsListWatch.updateTempSelectedStatus(adsListWatch.selectedFilter);
                    adsListWatch.updateTempSelectedDestination(adsListWatch.selectedDestinationFilter);
                  },
                  onApplyFilterTap: (){
                    adsListWatch.updateSelectedStatus(adsListWatch.selectedTempFilter);
                    adsListWatch.updateSelectedDestination(adsListWatch.selectedDestinationTempFilter);
                    adsListWatch.defaultAdsListApi(context);
                  },
                  onClearFilterTap: (){
                    adsListWatch.resetFilter();
                    adsListWatch.defaultAdsListApi(context);
                  },
                  otherFilterWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: AppColors.clrE5E7EB).paddingSymmetric(vertical: context.height * 0.01),
                      CommonText(
                        title: LocaleKeys.keyDestination.localized,
                        fontSize: 14,
                        fontWeight: TextStyles.fwSemiBold,
                      ).paddingOnly(bottom: context.height * 0.015),
                      CommonSearchableDropdown<DestinationData>(
                        onSelected: (value) {
                          adsListWatch.updateTempSelectedDestination(value);
                        },
                        title: (value) {
                          return (value.name ?? '');
                        },
                        textEditingController: adsListWatch.destinationCtr,
                        items: destinationWatch.destinationList,
                        validator: (value) => null,
                        hintText: LocaleKeys.keySelectDestination.localized,
                        onScrollListener: () async {
                          if (!destinationWatch.destinationListState.isLoadMore && destinationWatch.destinationListState.success?.hasNextPage == true) {
                            if (mounted) {
                              await destinationWatch.getDestinationListApi(context,pagination: true,activeRecords: true);
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
      body: AdsModuleTable(),
    );
  }

}


