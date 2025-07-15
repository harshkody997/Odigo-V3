import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/device/device_controller.dart';
import 'package:odigov3/framework/controller/store/store_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/framework/controller/assign_new_robot/assign_new_robot_controller.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/assign_new_robot/mobile/assign_new_robot_mobile.dart';
import 'package:odigov3/ui/assign_new_robot/web/assign_new_robot_web.dart';

class AssignNewRobot extends ConsumerStatefulWidget {
  const AssignNewRobot({Key? key}) : super(key: key);

  @override
  ConsumerState<AssignNewRobot> createState() => _AssignNewRobotState();
}

class _AssignNewRobotState extends ConsumerState<AssignNewRobot> with WidgetsBindingObserver, ZoomAwareMixin {
  @override
  void initState() {
    final assignNewRobotRead = ref.read(assignNewRobotController);
    assignNewRobotRead.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final destinationDetailsRead = ref.read(destinationDetailsController);
      final deviceListRead = ref.read(deviceController);

      final storeRead = ref.read(storeController);
      storeRead.disposeStoreDestinationController();
      // assignNewRobotRead.formKey.currentState?.reset();

      await destinationDetailsRead.floorListApi(context, destinationDetailsRead.currentDestinationUuid ?? '');

      await assignNewRobotRead.deviceGlobalListApi(false, isActive: true,inStock: true);

      deviceListRead.devicesList.forEach((element) async {
        await assignNewRobotRead.updateLocalRobotList(
          RobotFloorModel(floorNumber: element.floorNumber.toString(), robotHostName: element.hostName ?? '', robotSerialName: element.serialNumber ?? '', robotUuid: element.uuid ?? ''),
        );
      });

      await storeRead.generateFloorList(destinationDetailsRead.destinationDetailsState.success?.data?.totalFloor.toString() ?? '0').then(
        (value) {
          assignNewRobotRead.updateFloorList(value);
        },
      );
    });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const AssignNewRobotMobile();
      },
      desktop: (BuildContext context) {
        return const AssignNewRobotWeb();
      },
    );
  }
}
