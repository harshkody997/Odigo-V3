import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/users_management/user_management_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/user_management/web/user_management_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UserManagement extends ConsumerStatefulWidget {
  const UserManagement({super.key});

  @override
  ConsumerState<UserManagement> createState() => _CmsState();
}

class _CmsState extends ConsumerState<UserManagement> with WidgetsBindingObserver, ZoomAwareMixin {
  /// Init override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
      if (selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {
        final userManagementWatch = ref.read(userManagementController);
        userManagementWatch.disposeController(isNotify: true);
        userManagementWatch.getUserListApi(context);
      }
    });
  }

  ///Build
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const UserManagementWeb();
      },
      tablet: (BuildContext context) {
        return const UserManagementWeb();
      },
      desktop: (BuildContext context) {
        return const UserManagementWeb();
      },
    );
  }
}
