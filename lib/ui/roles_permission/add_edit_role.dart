import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/roles_permission/add_edit_role_controller.dart';
import 'package:odigov3/framework/controller/roles_permission/role_permission_details_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/repository/role_permission/model/role_permission_details_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/roles_permission/web/add_edit_role_web.dart';

class AddEditRole extends ConsumerStatefulWidget {
  final String? roleUuid;
  const AddEditRole({Key? key,this.roleUuid}) : super(key: key);

  @override
  ConsumerState<AddEditRole> createState() => _AddEditRoleState();
}

class _AddEditRoleState extends ConsumerState<AddEditRole> with WidgetsBindingObserver, ZoomAwareMixin{


  ///Init Override
  @override
  void initState() {
    super.initState();
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    /// Restrict api call if view permission is not given
    if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
      final addEditRoleWatch = ref.read(addEditRoleController);
      addEditRoleWatch.disposeController(isNotify: false);
      if(widget.roleUuid!=null && (selectedMainScreen?.canEdit??false)){
        ref.read(rolePermissionDetailsController).disposeController(isNotify: false);
      }
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
        await addEditRoleWatch.moduleListApi();
        if(widget.roleUuid != null && (selectedMainScreen?.canEdit??false)){
          await ref.read(rolePermissionDetailsController).rolePermissionDetailsAPI(context,widget.roleUuid??'').then((value){
            addEditRoleWatch.preFillDataOnEdit(value.success?.data?? RolePermissionModel());
          });
        }
      });
    }
  }


  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return AddEditRoleWeb(roleUuid: widget.roleUuid ,);
        },
        tablet: (BuildContext context) {
          return AddEditRoleWeb(roleUuid: widget.roleUuid ,);
        },
        desktop: (BuildContext context) {
          return AddEditRoleWeb(roleUuid: widget.roleUuid ,);
        }
    );
  }
}

