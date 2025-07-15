import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/roles_permission/web/helper/roles_permission_table.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import '../../../framework/controller/roles_permission/roles_permission_controller.dart';

class RolesPermissionWeb extends ConsumerStatefulWidget {
  const RolesPermissionWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<RolesPermissionWeb> createState() => _RolesPermissionWebState();
}

class _RolesPermissionWebState extends ConsumerState<RolesPermissionWeb> {

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final rolePermissionWatch = ref.watch(rolesPermissionController);
    final drawerWatch = ref.watch(drawerController);
    return BaseDrawerPageWidget(
      addButtonText: LocaleKeys.keyAddNewRole.localized,
      addButtonOnTap: () {
        ref.read(navigationStackController).push(NavigationStackItem.addEditRolePermission());
      },
      listName: LocaleKeys.keyRoles.localized,
      totalCount: rolePermissionWatch.roleList.length,
      showAddButton: drawerWatch.isMainScreenCanAdd,
      showSearchBar: true,
      searchController: rolePermissionWatch.searchCtr,
      searchPlaceHolderText: LocaleKeys.keySearchRoleName.localized,
      searchOnChanged: (value){
        rolePermissionWatch.clearRolePermission();
        rolePermissionWatch.getRoleListAPI(context,searchKeyword: value,activeRecords: rolePermissionWatch.selectedFilter?.value);
      },
      showFilters: true,
      isFilterApplied: rolePermissionWatch.isFilterApplied,
      filterButtonOnTap: (){
        /// reset value
        rolePermissionWatch.updateTempSelectedStatus(rolePermissionWatch.selectedFilter);

        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: rolePermissionWatch.filterKey,
          context: context,
          dialogBody: Consumer(
              builder: (context,ref,child) {
                final rolePermissionWatch = ref.watch(rolesPermissionController);
                return CommonStatusTypeFilterWidget(
                  groupValue: rolePermissionWatch.selectedTempFilter,
                  onSelectFilterTap: (filterType)=> rolePermissionWatch.updateTempSelectedStatus(filterType),
                  isFilterSelected: rolePermissionWatch.isFilterSelected,
                  isClearFilterCall: rolePermissionWatch.isClearFilterCall,
                  onCloseTap: (){
                    rolePermissionWatch.updateTempSelectedStatus(rolePermissionWatch.selectedFilter);
                  },
                  onApplyFilterTap: (){
                    rolePermissionWatch.updateSelectedStatus(rolePermissionWatch.selectedTempFilter);
                    rolePermissionWatch.clearRolePermission();
                    rolePermissionWatch.getRoleListAPI(context,activeRecords: rolePermissionWatch.selectedFilter?.value);
                  },
                  onClearFilterTap: (){
                    rolePermissionWatch.resetFilter();
                    rolePermissionWatch.clearRolePermission();
                    rolePermissionWatch.getRoleListAPI(context,activeRecords: rolePermissionWatch.selectedFilter?.value);
                  },
                );
              }
          ),
          height: 1,
          width: 0.5,
        );

      },
      body: RolesPermissionTable(),
    );

  }


}
