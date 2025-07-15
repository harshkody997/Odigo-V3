import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/destination_type/destination_type_list_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/destination_type/web/helper/destination_type_table.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';

class DestinationTypeListWeb extends ConsumerStatefulWidget {
  const DestinationTypeListWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<DestinationTypeListWeb> createState() => _DestinationTypeListWebState();
}

class _DestinationTypeListWebState extends ConsumerState<DestinationTypeListWeb> {

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final destinationTypeListWatch = ref.watch(destinationTypeListController);
    return BaseDrawerPageWidget(
      searchController: destinationTypeListWatch.searchCtr,
      listName: LocaleKeys.keyDestinationType.localized,
      totalCount: destinationTypeListWatch.totalCount,
      searchPlaceHolderText: LocaleKeys.keySearchByLocationName.localized,
      showSearchBar: true,
      searchbarWidth: context.width * 0.15,
      searchOnChanged: (value) async {
        destinationTypeListWatch.clearDestinationTypeList();
        await destinationTypeListWatch.getDestinationTypeListAPI(context,activeRecords: destinationTypeListWatch.selectedFilter?.value);
      },
      showImport: true,
      showExport: true,
      showAddButton: ref.watch(drawerController).isSubScreenCanAdd,
      addButtonText: LocaleKeys.keyAddDestinationType.localized,
      addButtonOnTap: () => ref.read(navigationStackController).push(NavigationStackItem.addEditDestinationType()),
      addButtonTextFontSize: 10,
      importOnTap: (){
        destinationTypeListWatch.clearFileData();
        commonImportDialog(
          width: context.width * 0.4,
          height: context.height * 0.74,
          context: context,
          fileName: destinationTypeListWatch.filePickerResult?.files.first.name,
          onBrowseTap: () async {
            await excelDocumentPicker(context, (value) => destinationTypeListWatch.updateFilePicked(value));
            return destinationTypeListWatch.filePickerResult?.files.first.name;
          },
          onSaveTap: () async{
            if (destinationTypeListWatch.fileBytes != null) {
              await destinationTypeListWatch.importTicketReasonApi(
                  context,
                  document: destinationTypeListWatch.fileBytes!,
                  fileName: 'destinationType'
              );
            }
            return destinationTypeListWatch.importDestinationTypeState.isLoading;
          },
          dismissble: true,
          title: LocaleKeys.keyImportToDestinationTypeMaster.localized,
          description: LocaleKeys.keyImportToDestinationTypeMasterDes.localized,
          onSampleTap: () async {
            await destinationTypeListWatch.sampleExportMethod(fileName: 'destinationType',context: context);
            return destinationTypeListWatch.sampleFileExportState.isLoading;
          },
          isSaveLoading: destinationTypeListWatch.importDestinationTypeState.isLoading,
          isSampleLoading: destinationTypeListWatch.sampleFileExportState.isLoading,
        );
      },
      exportOnTap: (){
        destinationTypeListWatch.fileExportMethod(fileName: 'destinationType',context: context);
      },
      showFilters: true,
      isFilterApplied: destinationTypeListWatch.isFilterApplied,
      filterButtonOnTap: (){
        /// reset value
        destinationTypeListWatch.updateTempSelectedStatus(destinationTypeListWatch.selectedFilter);

        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: destinationTypeListWatch.filterKey,
          context: context,
          dialogBody: Consumer(
              builder: (context,ref,child) {
                final destinationTypeListWatch = ref.watch(destinationTypeListController);
                return CommonStatusTypeFilterWidget(
                  groupValue: destinationTypeListWatch.selectedTempFilter,
                  onSelectFilterTap: (filterType)=> destinationTypeListWatch.updateTempSelectedStatus(filterType),
                  isFilterSelected: destinationTypeListWatch.isFilterSelected,
                  isClearFilterCall: destinationTypeListWatch.isClearFilterCall,
                  onCloseTap: (){
                    destinationTypeListWatch.updateTempSelectedStatus(destinationTypeListWatch.selectedFilter);
                  },
                  onApplyFilterTap: (){
                    destinationTypeListWatch.updateSelectedStatus(destinationTypeListWatch.selectedTempFilter);
                    destinationTypeListWatch.clearDestinationTypeList();
                    destinationTypeListWatch.getDestinationTypeListAPI(context,activeRecords: destinationTypeListWatch.selectedFilter?.value);
                  },
                  onClearFilterTap: (){
                    destinationTypeListWatch.resetFilter();
                    destinationTypeListWatch.clearDestinationTypeList();
                    destinationTypeListWatch.getDestinationTypeListAPI(context,activeRecords: destinationTypeListWatch.selectedFilter?.value);
                  },
                );
              }
          ),
          height: 1,
          width: 0.5,
        );
      },
      body: DestinationTypeTable(),
    );
  }


}
