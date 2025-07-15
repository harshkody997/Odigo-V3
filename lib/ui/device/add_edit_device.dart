import 'package:flutter/material.dart';
import 'package:odigov3/framework/controller/device/add_device_controller.dart';
import 'package:odigov3/framework/controller/device/device_details_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/repository/device/model/device_list_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/device/web/add_edit_device_web.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/device/mobile/add_edit_device_mobile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class AddEditDevice extends ConsumerStatefulWidget {
  final String? deviceUuid;
  const AddEditDevice({Key? key, this.deviceUuid}) : super(key: key);

  @override
  ConsumerState<AddEditDevice> createState() => _AddEditDeviceState();
}

class _AddEditDeviceState extends ConsumerState<AddEditDevice> with WidgetsBindingObserver, ZoomAwareMixin{
  ///Init:- This method will trigger when widget will initialized.
  @override
  void initState() {
    super.initState();
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    /// Restrict api call if view permission is not given
    if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
      final addDeviceWatch = ref.read(addDeviceController);
      addDeviceWatch.disposeController(isNotify : false);
      if(widget.deviceUuid!=null && (selectedMainScreen?.canEdit??false)){
        ref.read(deviceDetailsController).disposeController(isNotify: false);
      }
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
        if(widget.deviceUuid != null && (selectedMainScreen?.canEdit??false)){
          await ref.read(deviceDetailsController).deviceDetailsApi(deviceUuid: widget.deviceUuid??'').then((value){
            addDeviceWatch.fillFormOnUpdate(value.success?.data?? DeviceData());
          });
        }
      });
    }
  }

  ///Dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return  AddEditDeviceWeb(deviceUuid:widget.deviceUuid);
        },
        tablet: (BuildContext context) {
          return  AddEditDeviceWeb(deviceUuid:widget.deviceUuid);
        },
        desktop: (BuildContext context) {
          return  AddEditDeviceWeb(deviceUuid:widget.deviceUuid);
        }
    );
  }
}
