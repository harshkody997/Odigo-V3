import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/category/category_list_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/category/web/helper/category_table.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';

class CategoryListWeb extends ConsumerStatefulWidget {
  const CategoryListWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoryListWeb> createState() => _CategoryListWebState();
}

class _CategoryListWebState extends ConsumerState<CategoryListWeb> {

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final categoryListWatch = ref.watch(categoryListController);
    return BaseDrawerPageWidget(
      searchController: categoryListWatch.searchCtr,
      showImport: true,
      showExport: true,
      showAddButton: ref.watch(drawerController).isSubScreenCanAdd,
      addButtonText: LocaleKeys.keyAddCategory.localized,
      listName: LocaleKeys.keyCategories.localized,
      totalCount: categoryListWatch.totalCount,
      searchPlaceHolderText: LocaleKeys.keySearchCategories.localized,
      showSearchBar: true,
      importOnTap: (){
        categoryListWatch.clearFileData();
        commonImportDialog(
            width: context.width * 0.4,
            height: context.height * 0.74,
            context:context,
            fileName: categoryListWatch.filePickerResult?.files.first.name,
            onBrowseTap: ()async{
              await excelDocumentPicker(context, (value) => categoryListWatch.updateFilePicked(value));
              return categoryListWatch.filePickerResult?.files.first.name;
            },
            onSaveTap: () async{
              if(categoryListWatch.fileBytes != null){
                await categoryListWatch.importTicketReasonApi(context, document: categoryListWatch.fileBytes!, fileName: 'category');
              }
              return categoryListWatch.importCategoryState.isLoading;
            },
            dismissble: true,
            title: LocaleKeys.keyImportToCategoryMaster.localized,
            description: LocaleKeys.keyImportToCategoryMasterDes.localized,
            onTap: (){},
            onSampleTap:()async{
              await categoryListWatch.sampleExportMethod(fileName: 'category',context: context);
              return  categoryListWatch.sampleFileExportState.isLoading;
            },
            isSaveLoading: categoryListWatch.importCategoryState.isLoading,
            isSampleLoading: categoryListWatch.sampleFileExportState.isLoading
        );
      },
      exportOnTap: () {
        categoryListWatch.fileExportMethod(fileName: 'category',context: context);
      },

      searchOnChanged: (value){
        if (categoryListWatch.debounce?.isActive ?? false) {
          categoryListWatch.debounce?.cancel();
        }
        categoryListWatch.debounce =
            Timer(const Duration(milliseconds: 500), () async {
              categoryListWatch.clearCategoryList();
              await categoryListWatch.getCategoryListAPI(context,activeRecords: categoryListWatch.selectedFilter?.value);
            });
      },
      addButtonOnTap: (){
        ref.read(navigationStackController).push(NavigationStackItem.addCategory());
      },
      searchbarWidth: context.width * 0.2,
      showFilters: true,
      isFilterApplied: categoryListWatch.isFilterApplied,
      filterButtonOnTap: (){
        /// reset value
        categoryListWatch.updateTempSelectedStatus(categoryListWatch.selectedFilter);

        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: categoryListWatch.filterKey,
          context: context,
          dialogBody: Consumer(
              builder: (context,ref,child) {
                final categoryListWatch = ref.watch(categoryListController);
                return CommonStatusTypeFilterWidget(
                  groupValue: categoryListWatch.selectedTempFilter,
                  onSelectFilterTap: (filterType)=> categoryListWatch.updateTempSelectedStatus(filterType),
                  isFilterSelected: categoryListWatch.isFilterSelected,
                  isClearFilterCall: categoryListWatch.isClearFilterCall,
                  onCloseTap: (){
                    categoryListWatch.updateTempSelectedStatus(categoryListWatch.selectedFilter);
                  },
                  onApplyFilterTap: (){
                    categoryListWatch.updateSelectedStatus(categoryListWatch.selectedTempFilter);
                    categoryListWatch.clearCategoryList();
                    categoryListWatch.getCategoryListAPI(context,activeRecords: categoryListWatch.selectedFilter?.value);
                  },
                  onClearFilterTap: (){
                    categoryListWatch.resetFilter();
                    categoryListWatch.clearCategoryList();
                    categoryListWatch.getCategoryListAPI(context,activeRecords: categoryListWatch.selectedFilter?.value);
                  },
                );
              }
          ),
          height: 1,
          width: 0.5,
        );
      },

      body: CategoryTable(),
    );
  }

}
