import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/device_details_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/roles_permission/role_permission_details_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/roles_permission/web/role_permission_details_web.dart';

class RolePermissionDetails extends ConsumerStatefulWidget {
  final String uuid;
  const RolePermissionDetails({Key? key,required this.uuid}) : super(key: key);

  @override
  ConsumerState<RolePermissionDetails> createState() => _RolePermissionDetailsState();
}

class _RolePermissionDetailsState extends ConsumerState<RolePermissionDetails> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    /// Restrict api call if view permission is not given
    if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
      final rolePermissionDetailsWatch = ref.read(rolePermissionDetailsController);
      rolePermissionDetailsWatch.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
        await rolePermissionDetailsWatch.rolePermissionDetailsAPI(context, widget.uuid);
      });
    }

  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const RolePermissionDetailsWeb();
      },
      desktop: (BuildContext context) {
        return const RolePermissionDetailsWeb();
      },
      tablet: (BuildContext context) {
        return RolePermissionDetailsWeb();
      },
    );
  }
}

