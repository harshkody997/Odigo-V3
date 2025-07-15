import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/city/add_edit_city_controller.dart';
import 'package:odigov3/framework/controller/master/city/city_list_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/city/web/helper/city_table.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';

class CityListWeb extends ConsumerStatefulWidget {
  const CityListWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<CityListWeb> createState() => _CityListWebState();
}

class _CityListWebState extends ConsumerState<CityListWeb>{

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final cityListWatch = ref.watch(cityListController);
    return BaseDrawerPageWidget(
      searchController: cityListWatch.searchCtr,
      showImport: false,
      showExport: false,
      showAddButton: ref.watch(drawerController).isSubScreenCanAdd,
      addButtonText: LocaleKeys.keyAddCity.localized,
      totalCount: cityListWatch.totalCount,
      listName: LocaleKeys.keyCites.localized,
      searchPlaceHolderText: LocaleKeys.keySearchCountryStateCity.localized,
      showSearchBar: true,
      searchOnChanged: (value){
        if (cityListWatch.debounce?.isActive ?? false) {
          cityListWatch.debounce?.cancel();
        }
        cityListWatch.debounce =
            Timer(const Duration(milliseconds: 500), () async {
              cityListWatch.clearCityList();
              await cityListWatch.getCityListAPI(context,activeRecords: cityListWatch.selectedFilter?.value);
            });
      },
      addButtonOnTap: (){
        ref.read(addEditCityController).disposeController();
        ref.read(navigationStackController).push(NavigationStackItem.addCity());
      },
      showFilters: true,
      isFilterApplied: cityListWatch.isFilterApplied,
      filterButtonOnTap: (){
        /// reset value
        cityListWatch.updateTempSelectedStatus(cityListWatch.selectedFilter);
        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: cityListWatch.filterKey,
          context: context,
          dialogBody: Consumer(
              builder: (context,ref,child) {
                final cityListWatch = ref.watch(cityListController);
                return CommonStatusTypeFilterWidget(
                  groupValue: cityListWatch.selectedTempFilter,
                  onSelectFilterTap: (filterType)=> cityListWatch.updateTempSelectedStatus(filterType),
                  isFilterSelected: cityListWatch.isFilterSelected,
                  isClearFilterCall: cityListWatch.isClearFilterCall,
                  onCloseTap: (){
                    cityListWatch.updateTempSelectedStatus(cityListWatch.selectedFilter);
                  },
                  onApplyFilterTap: (){
                    cityListWatch.updateSelectedStatus(cityListWatch.selectedTempFilter);
                    cityListWatch.clearCityList();
                    cityListWatch.getCityListAPI(context,activeRecords: cityListWatch.selectedFilter?.value);
                  },
                  onClearFilterTap: (){
                    cityListWatch.resetFilter();
                    cityListWatch.clearCityList();
                    cityListWatch.getCityListAPI(context,activeRecords: cityListWatch.selectedFilter?.value);
                  },
                );
              }
          ),
          height: 1,
          width: 0.5,
        );
      },
      body: CityTable(),
    );
  }


}
