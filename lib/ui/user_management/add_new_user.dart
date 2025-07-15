import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/users_management/add_new_user_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/repository/user_management/model/response/users_data.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/user_management/web/add_new_user_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddNewUser extends ConsumerStatefulWidget {
  final String? userUuid;
  final Function? popCallBack;

  const AddNewUser({super.key, this.userUuid, this.popCallBack});

  @override
  ConsumerState<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends ConsumerState<AddNewUser> with WidgetsBindingObserver, ZoomAwareMixin {
  /// Init override
  @override
  void initState() {
    super.initState();
    final addNewUserWatch = ref.read(addNewUserController);
    addNewUserWatch.disposeController();
    if(widget.userUuid != null){
      addNewUserWatch.getUserDetailsApiState.isLoading = true;
      addNewUserWatch.getAssignTypeApiState.isLoading = true;
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
      if (selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {
        /// get Assign type
        getAssignTypeApiCall(context, ref);
        if (widget.userUuid != null) {
          await addNewUserWatch.getUserDetailsApi(context, widget.userUuid ?? '');
        }
        if ((addNewUserWatch.getUserDetailsApiState.success?.data) != null) {
          addNewUserWatch.onEditUsersData(addNewUserWatch.getUserDetailsApiState.success?.data ?? UserData());
        }
      }
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return AddNewUserWeb(userUuid: widget.userUuid, mainContext: context, popCallBack: widget.popCallBack);
      },
      tablet: (BuildContext context) {
        return AddNewUserWeb(userUuid: widget.userUuid, mainContext: context, popCallBack: widget.popCallBack);
      },
      desktop: (BuildContext context) {
        return AddNewUserWeb(userUuid: widget.userUuid, mainContext: context, popCallBack: widget.popCallBack);
      },
    );
  }

  /// Assign Type Api Call
  Future<void> getAssignTypeApiCall(BuildContext context, WidgetRef ref) async {
    final addNewUserWatch = ref.watch(addNewUserController);
    await addNewUserWatch.getAssignTypeApi(context);

    addNewUserWatch.assignTypeScrollController.addListener(() async {
      if (addNewUserWatch.getAssignTypeApiState.success?.hasNextPage == true) {
        if (addNewUserWatch.assignTypeScrollController.position.maxScrollExtent ==
            addNewUserWatch.assignTypeScrollController.position.pixels) {
          if (!addNewUserWatch.getAssignTypeApiState.isLoadMore) {
            await addNewUserWatch.getAssignTypeApi(
              context,
              searchText: addNewUserWatch.searchTypeController.text,
              isForPagination: true,
            );
          }
        }
      }
    });
  }
}
