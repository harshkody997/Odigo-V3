import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/store/store_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class StoreWeb extends ConsumerStatefulWidget {
  const StoreWeb({super.key});

  @override
  ConsumerState<StoreWeb> createState() => _StoreWebState();
}

class _StoreWebState extends ConsumerState<StoreWeb> {

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final storeWatch = ref.watch(storeController);
    final drawerWatch = ref.watch(drawerController);
    return BaseDrawerPageWidget(
      showAddButton: drawerWatch.selectedMainScreen?.canAdd,
      addButtonOnTap: () {
        ref.read(navigationStackController).push(NavigationStackItem.addEditStore());
      },
      addButtonText: LocaleKeys.keyAddStore.localized,
      totalCount: storeWatch.storeListState.success?.totalCount,
      listName: LocaleKeys.keyStores.localized,
      showSearchBar: true,
      searchController: storeWatch.searchCtr,
      searchPlaceHolderText: LocaleKeys.keySearchByStore.localized,
      searchOnChanged: (value){
        final storeWatch = ref.read(storeController);
        if(!storeWatch.storeListState.isLoading) {
          storeWatch.storeListApi(context, searchKeyword: value);
        }
      },
      showFilters: true,
      filterButtonOnTap: (){

        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: storeWatch.filterKey,
          context: context,
          dialogBody: Consumer(
              builder: (context,ref,child) {
                final storeWatch = ref.watch(storeController);
                return CommonStatusTypeFilterWidget(
                  groupValue: storeWatch.selectedTempFilter,
                  onSelectFilterTap: (filterType)=> storeWatch.updateTempSelectedStatus(filterType),
                  isFilterSelected: storeWatch.isFilterSelected,
                  isClearFilterCall: storeWatch.isClearFilterCall,
                  onCloseTap: (){
                    storeWatch.updateTempSelectedStatus(storeWatch.selectedFilter);
                  },
                  onApplyFilterTap: (){
                    storeWatch.updateSelectedStatus(storeWatch.selectedTempFilter);
                    storeWatch.storeListApi(context);
                  },
                  onClearFilterTap: (){
                    storeWatch.resetFilter();
                    storeWatch.storeListApi(context);
                  },
                );
              }
          ),
          height: 1,
          width: 0.5,
        );

      },
      showExport: true,
      exportOnTap: () {
        storeWatch.exportStoreApi(fileName: 'store',context: context);
      },
      showImport: true,
      importOnTap: () {
        storeWatch.clearFileData();
        commonImportDialog(
            width: context.width * 0.4,
            height: context.height * 0.74,
            context:context,
            fileName: storeWatch.filePickerResult?.files.first.name,
            onBrowseTap: () async {
              await excelDocumentPicker(context, (value) => storeWatch.updateFilePicked(value));
              return storeWatch.filePickerResult?.files.first.name;
            },
            onSaveTap: () async {
              if(storeWatch.fileBytes != null){
                await storeWatch.importStoreApi(context, document: storeWatch.fileBytes!, fileName: 'store');
                storeWatch.storeListApi(context);
              }
              return storeWatch.importStoreState.isLoading;
            },
            dismissble: true,
            title: LocaleKeys.keyImportToStore.localized,
            description: LocaleKeys.keyImportToStoreDes.localized,
            onTap: (){},
            onSampleTap:() async{
              await storeWatch.storeSampleDownloadApi(fileName: 'store',context: context);
              return storeWatch.storeSampleDownloadState.isLoading;
            },
            isSaveLoading: storeWatch.importStoreState.isLoading,
            isSampleLoading: storeWatch.storeSampleDownloadState.isLoading
        );
      },
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    final drawerWatch = ref.watch(drawerController);
    final storeWatch = ref.watch(storeController);
    return CommonTableGenerator(
      headerContent: [
        CommonHeader(title: LocaleKeys.keyStatus.localized),
        CommonHeader(title: LocaleKeys.keyStoreName.localized, flex: 3),
        CommonHeader(title: LocaleKeys.keyCategoryName.localized, flex: 8),
      ],
      childrenHeader: storeWatch.storeList,
      childrenContent: (index) {
        final item = storeWatch.storeList[index];
        return [CommonRow(title: item?.name ?? '', flex: 3), CommonRow(title: item?.businessCategories?.map((e) => e.name).join(', ')??'', flex: 8), CommonRow(title: '')];
      },
      /// status
      isSwitchLoading: (index) => storeWatch.changeStoreStatusState.isLoading && index == storeWatch.statusTapIndex,
      isStatusAvailable: true,
      statusValue: (index) => storeWatch.storeList[index]?.active,
      onStatusTap: (value, index) async {
        storeWatch.updateStatusIndex(index);
        storeWatch.changeStoreStatusApi(context, storeUuid: storeWatch.storeList[index]?.uuid ?? '', isActive: value, index: index);
      },
      /// edit
      isEditAvailable: drawerWatch.selectedMainScreen?.canEdit,
      isEditVisible: (index) => storeWatch.storeList[index]?.active,
      onEdit: (index) {
        ref.read(navigationStackController).push(NavigationStackItem.addEditStore(storeUuid: storeWatch.storeList[index]?.uuid));
      },
      /// details
      isDetailsAvailable: true,
      onForwardArrow: (index) {
        ref.read(navigationStackController).push(NavigationStackItem.storeDetail(storeUuid: storeWatch.storeList[index]?.uuid ?? ''));
      },
      /// scroll listener
      isLoading: storeWatch.storeListState.isLoading,
      isLoadMore: storeWatch.storeListState.isLoadMore,
      onScrollListener: () {
        if (!storeWatch.storeListState.isLoadMore && storeWatch.storeListState.success?.hasNextPage == true) {
          if (mounted) {
            storeWatch.storeListApi(context, isForPagination: true);
          }
        }
      },
    );
  }
}
