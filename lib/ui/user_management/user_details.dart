import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/users_management/add_new_user_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/user_management/web/user_details_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UserDetails extends ConsumerStatefulWidget {
  final String? userUuid;

  const UserDetails({super.key, this.userUuid});

  @override
  ConsumerState<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends ConsumerState<UserDetails> with WidgetsBindingObserver, ZoomAwareMixin {
  /// Init override
  @override
  void initState() {
    super.initState();
    final addNewUserWatch = ref.read(addNewUserController);
    addNewUserWatch.disposeController();
    if(widget.userUuid != null){
      addNewUserWatch.getUserDetailsApiState.isLoading = true;
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
      if (selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {
        if (widget.userUuid != null) {
          await addNewUserWatch.getUserDetailsApi(context, widget.userUuid ?? '');
        }
      }
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return UserDetailsWeb(userUuid: widget.userUuid);
      },
      tablet: (BuildContext context) {
        return UserDetailsWeb(userUuid: widget.userUuid);
      },
      desktop: (BuildContext context) {
        return UserDetailsWeb(userUuid: widget.userUuid);
      },
    );
  }
}
