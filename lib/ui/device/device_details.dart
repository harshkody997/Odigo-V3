import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/device/web/device_details_web.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/device/mobile/device_details_mobile.dart';
import 'package:odigov3/framework/controller/device/device_details_controller.dart';


class DeviceDetails extends ConsumerStatefulWidget {
  final String deviceId;
  const DeviceDetails({Key? key, required this.deviceId}) : super(key: key);

  @override
  ConsumerState<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends ConsumerState<DeviceDetails> with WidgetsBindingObserver, ZoomAwareMixin {

  @override
  void initState() {
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    /// Restrict api call if view permission is not given
    if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
      final deviceDetailsWatch = ref.read(deviceDetailsController);
      deviceDetailsWatch.disposeController(isNotify: false);
      SchedulerBinding.instance.addPostFrameCallback((_) async{
        await deviceDetailsWatch.deviceDetailsApi(deviceUuid: widget.deviceId);
      });
    }
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return DeviceDetailsWeb(deviceId:widget.deviceId);
        },
        tablet: (BuildContext context) {
          return DeviceDetailsWeb(deviceId:widget.deviceId);
        },
        desktop: (BuildContext context) {
          return DeviceDetailsWeb(deviceId:widget.deviceId);
        }
    );
  }
}

