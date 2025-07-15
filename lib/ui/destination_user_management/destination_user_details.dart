import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_details_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/destination_user_management/web/destination_user_details_web.dart';

class DestinationUserDetails extends ConsumerStatefulWidget {
  final String userUuid;
  const DestinationUserDetails({Key? key,required this.userUuid}) : super(key: key);

  @override
  ConsumerState<DestinationUserDetails> createState() => _DestinationUserDetailsState();
}

class _DestinationUserDetailsState extends ConsumerState<DestinationUserDetails> with WidgetsBindingObserver,ZoomAwareMixin {

  @override
  void initState() {
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
      final destinationUserRead = ref.read(destinationUserDetailsController);
      destinationUserRead.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((callback) async{
        await destinationUserRead.destinationUserDetailsApi(userUuid: widget.userUuid);
      });
    }
    super.initState();
  }


  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return const DestinationUserDetailsWeb();
        },
        tablet: (BuildContext context) {
          return const DestinationUserDetailsWeb();
        },  desktop: (BuildContext context) {
          return const DestinationUserDetailsWeb();
        },
    );
  }
}

