import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_module/ads_module_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/device/device_controller.dart';
import 'package:odigov3/framework/controller/device/device_details_controller.dart';
import 'package:odigov3/framework/controller/table_controller.dart' show tableController;
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/destination_details/web/helper/device_detail_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class RobotModuleTable extends ConsumerStatefulWidget {
  const RobotModuleTable({Key? key}) : super(key: key);

  @override
  ConsumerState<RobotModuleTable> createState() => _RobotModuleTableState();
}

class _RobotModuleTableState extends ConsumerState<RobotModuleTable> {

  ///Build
  @override
  Widget build(BuildContext context) {
    final deviceWatch = ref.watch(deviceController);
    final deviceDetailsWatch = ref.read(deviceDetailsController);

    return CommonTableGenerator(
      headerContent: [
        // CommonHeader(title: LocaleKeys.keyStatus.localized),
        CommonHeader(title: LocaleKeys.keySerialNumber.localized),

        CommonHeader(title: LocaleKeys.keyHostName.localized,flex: 1),
        CommonHeader(title: LocaleKeys.keyFloorNo.localized,flex: 2),
      ],
      childrenHeader: deviceWatch.devicesList,
      childrenContent: (index) {
        final item = deviceWatch.devicesList[index];
        return [
          CommonRow(title: item.serialNumber ?? ''),
          CommonRow(title: item.hostName ?? '',flex: 1),
          CommonRow(title: item.floorNumber.toString(),flex: 2),
          CommonRow(title:''),
        ];
      },
      
      isDetailsAvailable: true,          // Show forward arrow icon
      forwardArrowIcon: Icon(Icons.remove_red_eye_outlined, size: 20).alignAtCenterRight(),
      onForwardArrow: (index) async {
        final item = deviceWatch.devicesList[index];
        await deviceDetailsWatch.deviceDetailsApi(deviceUuid: item.uuid ?? '').then((value) {
          if(value.success?.status == ApiEndPoints.apiStatus_200){
            showCommonWebDialog(
                context: context,
                keyBadge: deviceWatch.robotDetailsDialogKey,
                width: 0.50,
                height: 0.89,
                dialogBody:  DeviceDetailDialog(robotData: deviceDetailsWatch.deviceDetailsState.success?.data,));
          }
        },);

      },


      onScrollListener: () {
        print('Api method called');
      },

      isLoading: deviceWatch.deviceListState.isLoading,
    );
  }
}
