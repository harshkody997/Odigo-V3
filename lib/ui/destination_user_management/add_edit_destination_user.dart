import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/destination_user_management/add_edit_destination_user_controller.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_details_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/repository/destination_user_management/model/destination_user_list_response_model.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/destination_user_management/web/add_edit_destination_user_web.dart';

class AddEditDestinationUser extends ConsumerStatefulWidget {
  final String? userUuid;
  const AddEditDestinationUser({Key? key,this.userUuid}) : super(key: key);

  @override
  ConsumerState<AddEditDestinationUser> createState() => _AddEditDestinationUserState();
}

class _AddEditDestinationUserState extends ConsumerState<AddEditDestinationUser> with  WidgetsBindingObserver,ZoomAwareMixin{

  @override
  void initState() {
    super.initState();
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    /// Restrict api call if view permission is not given
    if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
      if(Session.getEntityType() != RoleType.DESTINATION.name && Session.getEntityType() != RoleType.DESTINATION_USER.name){
        ref.read(destinationController).disposeDestinationListForOtherModules(isNotify:false);
      }

      final destinationUserWatch = ref.read(addEditDestinationUserController);
      destinationUserWatch.disposeController(isNotify : false);
      if(widget.userUuid!=null && (selectedMainScreen?.canEdit??false)){
        ref.read(destinationUserDetailsController).disposeController(isNotify: false);
      }
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
        /// If destination is not logged in then do not call api
        if(Session.getEntityType() != RoleType.DESTINATION.name && Session.getEntityType() != RoleType.DESTINATION_USER.name){
          ref.read(destinationController).getDestinationListApi(context,isReset: true,pagination: false,activeRecords: true);
        }
        if(widget.userUuid != null && (selectedMainScreen?.canEdit??false)){
          await ref.read(destinationUserDetailsController).destinationUserDetailsApi(userUuid: widget.userUuid??'').then((value){
            destinationUserWatch.fillFormOnUpdate(value.success?.data?? DestinationUserData());
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
          return AddEditDestinationUserWeb(userUuid:widget.userUuid);
        },
        tablet: (BuildContext context) {
          return AddEditDestinationUserWeb(userUuid:widget.userUuid);
        },
        desktop: (BuildContext context) {
          return  AddEditDestinationUserWeb(userUuid:widget.userUuid);
        }
    );
  }
}

