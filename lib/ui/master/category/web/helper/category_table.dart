import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/category/category_list_controller.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class CategoryTable extends ConsumerStatefulWidget {
  const CategoryTable({super.key});

  @override
  ConsumerState<CategoryTable> createState() => _CategoryTableState();
}

class _CategoryTableState extends ConsumerState<CategoryTable> {

  @override
  Widget build(BuildContext context) {
    final categoryListWatch = ref.watch(categoryListController);
    final drawerWatch = ref.watch(drawerController);
    return CommonTableGenerator(
      headerContent: [
        CommonHeader(title: LocaleKeys.keyStatus.localized),
        CommonHeader(title: LocaleKeys.keyImage.localized,flex: 10),
      ],
      childrenHeader: categoryListWatch.categoryList,
      childrenContent: (int index) {
        final item = categoryListWatch.categoryList[index];
        return [

          // CommonRow(title: item.name ?? '',flex: 6),
          Expanded(
            flex: 10,
            child: Row(
              children: [
                ClipOval(
                  child: CacheImage(
                      imageURL: item.categoryImageUrl ?? '',
                    height: 40,
                    width: 40,
                  )
                ).paddingOnly(right: 10),
                CommonRow(title: item.name ?? '',flex: 3),
              ],
            ),
          ),
          CommonRow(title: '',),
        ];

      },
      isEditAvailable: drawerWatch.isSubScreenCanEdit,
      canDeletePermission: drawerWatch.isSubScreenCanDelete,
      onEdit: (index){
        ref.read(navigationStackController).push(NavigationStackItem.editCategory(uuid: categoryListWatch.categoryList[index].uuid??''));
      },
      isStatusAvailable: true,
      isEditVisible: (index) => categoryListWatch.categoryList[index].active,
      isLoading: categoryListWatch.categoryListState.isLoading,
      isLoadMore: categoryListWatch.categoryListState.isLoadMore,
      isSwitchLoading: (index) => (categoryListWatch.changeCategoryStatusState.isLoading && index == categoryListWatch.statusTapIndex),
      statusValue:(index) => categoryListWatch.categoryList[index].active,
      onStatusTap: (value,index) {
        categoryListWatch.updateStatusIndex(index);
        categoryListWatch.changeCategoryStatusAPI(context, categoryListWatch.categoryList[index].uuid??'', value, index);
      },
      onScrollListener: () async {
        if (!categoryListWatch.categoryListState.isLoadMore && categoryListWatch.categoryListState.success?.hasNextPage == true) {
          if (mounted) {
            await categoryListWatch.getCategoryListAPI(context,pagination: true,activeRecords: categoryListWatch.selectedFilter?.value);
          }
        }
      },
    );
  }
}

