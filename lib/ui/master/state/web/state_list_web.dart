import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/state/add_edit_state_controller.dart';
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/master/state/web/helper/state_table.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';

class StateListWeb extends ConsumerStatefulWidget {
  const StateListWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<StateListWeb> createState() => _StateListWebState();
}

class _StateListWebState extends ConsumerState<StateListWeb>{

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final stateListWatch = ref.watch(stateListController);
    final drawerWatch = ref.watch(drawerController);
    return BaseDrawerPageWidget(
      searchController: stateListWatch.searchCtr,
      showImport: true,
      showExport: true,
      showAddButton: drawerWatch.isSubScreenCanAdd,
      addButtonText: LocaleKeys.keyAddState.localized,
      listName: LocaleKeys.keyStates.localized,
      totalCount: stateListWatch.totalCount,
      searchPlaceHolderText: LocaleKeys.keySearchCountryState.localized,
      showSearchBar: true,
      showFilters: true,
      isFilterApplied : stateListWatch.isFilterApplied,
      filterButtonOnTap: (){
        /// reset value
        stateListWatch.updateTempSelectedStatus(stateListWatch.selectedFilter);

        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: stateListWatch.filterKey,
          context: context,
          dialogBody: Consumer(
            builder: (context,ref,child) {
              final stateListWatch = ref.watch(stateListController);
              return CommonStatusTypeFilterWidget(
                  groupValue: stateListWatch.selectedTempFilter,
                  onSelectFilterTap: (filterType)=> stateListWatch.updateTempSelectedStatus(filterType),
                  isFilterSelected: stateListWatch.isFilterSelected,
                  isClearFilterCall: stateListWatch.isClearFilterCall,
                  onCloseTap: (){
                    stateListWatch.updateTempSelectedStatus(stateListWatch.selectedFilter);
                  },
                  onApplyFilterTap: (){
                    stateListWatch.updateSelectedStatus(stateListWatch.selectedTempFilter);
                    stateListWatch.clearStateList();
                    stateListWatch.getStateListAPI(context,activeRecords: stateListWatch.selectedFilter?.value);
                  },
                  onClearFilterTap: (){
                      stateListWatch.resetFilter();
                      stateListWatch.clearStateList();
                      stateListWatch.getStateListAPI(context,activeRecords: stateListWatch.selectedFilter?.value);
                  },
              );
            }
          ),
          height: 1,
          width: 0.5,
        );

      },
      importOnTap: (){
        stateListWatch.clearFileData();
        commonImportDialog(
          width: context.width * 0.4,
          height: context.height * 0.74,
          context:context,
          fileName: stateListWatch.filePickerResult?.files.first.name,
          onBrowseTap: ()async{
            await excelDocumentPicker(context, (value) => stateListWatch.updateFilePicked(value));
            return stateListWatch.filePickerResult?.files.first.name;
          },
          onSaveTap: () async{
            if(stateListWatch.fileBytes != null){
              await stateListWatch.importStateApi(context, document: stateListWatch.fileBytes!, fileName: 'state');
            }
            return stateListWatch.importStateState.isLoading;
          },
          dismissble: true,
          title: LocaleKeys.keyImportToStateMaster.localized,
          description: LocaleKeys.keyImportToStateMasterDes.localized,
          onTap: (){},
          onSampleTap:()async{
            await stateListWatch.sampleExportMethod(fileName: 'state',context: context);
            return stateListWatch.sampleFileExportState.isLoading;
          },
          isSaveLoading: stateListWatch.importStateState.isLoading,
          isSampleLoading: stateListWatch.sampleFileExportState.isLoading
        );
      },
      exportOnTap: () {
        stateListWatch.fileExportMethod(fileName: 'state',context: context);
      },
      searchOnChanged: (value){
        if (stateListWatch.debounce?.isActive ?? false) {
          stateListWatch.debounce?.cancel();
        }
        stateListWatch.debounce =
            Timer(const Duration(milliseconds: 500), () async {
              stateListWatch.clearStateList();
              await stateListWatch.getStateListAPI(context,activeRecords: stateListWatch.selectedFilter?.value);
            });
      },
      addButtonOnTap: (){
        ref.read(addEditStateController).disposeController();
        ref.read(navigationStackController).push(NavigationStackItem.addState());
      },
      body: StateTable(),
    );
  }


}
