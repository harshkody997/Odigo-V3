import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/ticket_reason/add_edit_ticket_reason_controller.dart';
import 'package:odigov3/framework/controller/master/ticket_reason/ticket_reason_list_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/master/ticket_reason/web/helper/ticket_reason_table.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';

class TicketReasonListWeb extends ConsumerStatefulWidget {
  const TicketReasonListWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<TicketReasonListWeb> createState() => _TicketReasonListWebState();
}

class _TicketReasonListWebState extends ConsumerState<TicketReasonListWeb>{


  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final ticketReasonListWatch = ref.watch(ticketReasonListController);
    return BaseDrawerPageWidget(
      searchController: ticketReasonListWatch.searchCtr,
      showImport: true,
      showExport: true,
      showAddButton: ref.watch(drawerController).isSubScreenCanAdd,
      addButtonText: LocaleKeys.keyAddTicketReason.localized,
      listName: LocaleKeys.keyReasons.localized,
      totalCount: ticketReasonListWatch.totalCount,
      searchPlaceHolderText: LocaleKeys.keySearchTicketReason.localized,
      showSearchBar: true,
      importOnTap: (){
        ticketReasonListWatch.clearFileData();
        // commonImportDialog(
        //   width: context.width * 0.4,
        //   height: context.height * 0.74,
        //   context:context,
        //   fileName: ticketReasonListWatch.filePickerResult?.files.first.name,
        //   onBrowseTap: ()async{
        //     await excelDocumentPicker(context, (value) => ticketReasonListWatch.updateFilePicked(value));
        //     return ticketReasonListWatch.filePickerResult?.files.first.name;
        //   },
        //   onSaveTap: () {
        //     if(ticketReasonListWatch.fileBytes != null){
        //       ticketReasonListWatch.importTicketReasonApi(context, document: ticketReasonListWatch.fileBytes!, fileName: 'ticketReason');
        //     }
        //     return ticketReasonListWatch.importTicketReasonState.isLoading;
        //   },
        //   dismissble: true,
        //   title: LocaleKeys.keyImportToTicketReasonMaster.localized,
        //   description: LocaleKeys.keyImportToTicketReasonMasterDes.localized,
        //   onTap: (){},
        //   onSampleTap:(){
        //     ticketReasonListWatch.sampleExportMethod(fileName: 'ticketReason');
        //     print('ticketReasonListWatch.sampleFileExportState.isLoading');
        //     print(ticketReasonListWatch.sampleFileExportState.isLoading);
        //     return ticketReasonListWatch.sampleFileExportState.isLoading;
        //   },
        //   isSaveLoading: ticketReasonListWatch.importTicketReasonState.isLoading,
        //   isSampleLoading: ticketReasonListWatch.sampleFileExportState.isLoading
        // );
        commonImportDialog(
          width: context.width * 0.4,
          height: context.height * 0.74,
          context: context,
          fileName: ticketReasonListWatch.filePickerResult?.files.first.name,
          onBrowseTap: () async {
            await excelDocumentPicker(context, (value) => ticketReasonListWatch.updateFilePicked(value));
            return ticketReasonListWatch.filePickerResult?.files.first.name;
          },
          onSaveTap: () async{
            if (ticketReasonListWatch.fileBytes != null) {
              await ticketReasonListWatch.importTicketReasonApi(
                  context,
                  document: ticketReasonListWatch.fileBytes!,
                  fileName: 'ticketReason'
              );
            }
            return ticketReasonListWatch.importTicketReasonState.isLoading;
          },
          dismissble: true,
          title: LocaleKeys.keyImportToTicketReasonMaster.localized,
          description: LocaleKeys.keyImportToTicketReasonMasterDes.localized,
          onSampleTap: () async {
            await ticketReasonListWatch.sampleExportMethod(fileName: 'ticketReason',context: context);
            return ticketReasonListWatch.sampleFileExportState.isLoading;
          },
          isSaveLoading: ticketReasonListWatch.importTicketReasonState.isLoading,
          isSampleLoading: ticketReasonListWatch.sampleFileExportState.isLoading,
        );
      },
      exportOnTap: () {
        ticketReasonListWatch.fileExportMethod(fileName: 'ticketReason',context: context);
      },
      searchbarWidth: context.width * 0.20,
      searchOnChanged: (value){
        if (ticketReasonListWatch.debounce?.isActive ?? false) {
          ticketReasonListWatch.debounce?.cancel();
        }
        ticketReasonListWatch.debounce =
            Timer(const Duration(milliseconds: 500), () async {
              ticketReasonListWatch.clearTicketReasonList();
              await ticketReasonListWatch.getTicketReasonListAPI(context,activeRecords: ticketReasonListWatch.selectedFilter?.value);
            });
      },
      addButtonOnTap: (){
        ref.read(addEditTicketReasonController).disposeController();
        ref.read(navigationStackController).push(NavigationStackItem.addTicketReason());
      },
      showFilters: true,
      isFilterApplied: ticketReasonListWatch.isFilterApplied,
      filterButtonOnTap: (){
        /// reset value
        ticketReasonListWatch.updateTempSelectedStatus(ticketReasonListWatch.selectedFilter);
        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: ticketReasonListWatch.filterKey,
          context: context,
          dialogBody: Consumer(
              builder: (context,ref,child) {
                final ticketReasonListWatch = ref.watch(ticketReasonListController);
                return CommonStatusTypeFilterWidget(
                  groupValue: ticketReasonListWatch.selectedTempFilter,
                  onSelectFilterTap: (filterType)=> ticketReasonListWatch.updateTempSelectedStatus(filterType),
                  isFilterSelected: ticketReasonListWatch.isFilterSelected,
                  isClearFilterCall: ticketReasonListWatch.isClearFilterCall,
                  onCloseTap: (){
                    ticketReasonListWatch.updateTempSelectedStatus(ticketReasonListWatch.selectedFilter);
                  },
                  onApplyFilterTap: (){
                    ticketReasonListWatch.updateSelectedStatus(ticketReasonListWatch.selectedTempFilter);
                    ticketReasonListWatch.clearTicketReasonList();
                    ticketReasonListWatch.getTicketReasonListAPI(context,activeRecords: ticketReasonListWatch.selectedFilter?.value);
                  },
                  onClearFilterTap: (){
                    ticketReasonListWatch.resetFilter();
                    ticketReasonListWatch.clearTicketReasonList();
                    ticketReasonListWatch.getTicketReasonListAPI(context,activeRecords: ticketReasonListWatch.selectedFilter?.value);
                  },
                );
              }
          ),
          height: 1,
          width: 0.5,
        );
      },
      body: TicketReasonTable(),
    );
  }


}
