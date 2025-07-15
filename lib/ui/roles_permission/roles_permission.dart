import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/roles_permission/roles_permission_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'mobile/roles_permission_mobile.dart';
import 'web/roles_permission_web.dart';

class RolesPermission extends ConsumerStatefulWidget {
  const RolesPermission({Key? key}) : super(key: key);

  @override
  ConsumerState<RolesPermission> createState() => _RolesPermissionState();
}

class _RolesPermissionState extends ConsumerState<RolesPermission> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    /// Restrict api call if view permission is not given
    if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
      final rolesPermissionWatch = ref.read(rolesPermissionController);
      rolesPermissionWatch.disposeController(isNotify : false);
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        rolesPermissionWatch.getRoleListAPI(context);
      });
    }
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return const RolesPermissionWeb();
        },
        desktop: (BuildContext context) {
          return const RolesPermissionWeb();
        },
        tablet: (BuildContext context) {
          return const RolesPermissionWeb();
        }
    );
  }
}

