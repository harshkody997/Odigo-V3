import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/roles_permission/roles_permission_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class RolesPermissionTable extends ConsumerStatefulWidget {
  const RolesPermissionTable({Key? key}) : super(key: key);

  @override
  ConsumerState<RolesPermissionTable> createState() => _RolesPermissionTableState();
}

class _RolesPermissionTableState extends ConsumerState<RolesPermissionTable> {
  /// Builds the widget tree
  @override
  Widget build(BuildContext context) {
    final rolePermissionWatch = ref.watch(rolesPermissionController);
    final drawerWatch = ref.watch(drawerController);

    return CommonTableGenerator(
        headerContent: [
          CommonHeader(title: LocaleKeys.keyStatus.localized), /// status
          CommonHeader(title: LocaleKeys.keyRoleID.localized,flex: 3), /// role Id
          CommonHeader(title: LocaleKeys.keyRoleName.localized,flex: 3), /// role name
          CommonHeader(title: LocaleKeys.keyCreated.localized,flex: 3), /// created
          CommonHeader(title: LocaleKeys.keyUpdated.localized,flex: 3), /// updated
        ],
        childrenHeader: rolePermissionWatch.roleList,
        childrenContent: (int index) {
          final item = rolePermissionWatch.roleList[index];
         return [
           CommonRow(title: item.uuid ?? '',flex: 3), /// role Id
           CommonRow(title: item.name ?? '',flex: 3), /// role name
           CommonRow(title: formatDateDDMMYYY_HHMMA(item.createdAt),flex: 3), /// created at
           CommonRow(title: formatDateDDMMYYY_HHMMA(item.updatedAt),flex: 3), /// updated at
           CommonRow(title: ''),
         ];
        },
        isEditAvailable: drawerWatch.isMainScreenCanEdit,
        isDetailsAvailable: true,
        isEditVisible: (index) => rolePermissionWatch.roleList[index].active,
        isLoading: rolePermissionWatch.roleListState.isLoading,
        isLoadMore: rolePermissionWatch.roleListState.isLoadMore,
        statusValue: (index) => rolePermissionWatch.roleList[index].active,
        isStatusAvailable: true,
        canDeletePermission: drawerWatch.isMainScreenCanDelete,
        isSwitchLoading: (index) => (rolePermissionWatch.changeRoleStatusState.isLoading && index == rolePermissionWatch.statusTapIndex),
        onEdit: (index){
          ref.read(navigationStackController).push(NavigationStackItem.addEditRolePermission(roleId: rolePermissionWatch.roleList[index].uuid??''));
        },
        onForwardArrow: (index){
          ref.read(navigationStackController).push(NavigationStackItem.rolesAndPermissionDetails(roleUuid: rolePermissionWatch.roleList[index].uuid??''));
        },
        onStatusTap: (status,index){
          rolePermissionWatch.updateStatusIndex(index);
          rolePermissionWatch.changeStateStatusAPI(context, rolePermissionWatch.roleList[index].uuid??'', status, index);
        },
        onScrollListener: () async {
          if (!rolePermissionWatch.roleListState.isLoadMore && rolePermissionWatch.roleListState.success?.hasNextPage == true) {
            if (mounted) {
              await rolePermissionWatch.getRoleListAPI(context,pagination: true,activeRecords: rolePermissionWatch.selectedFilter?.value);
            }
          }
        }
    );
  }
}
