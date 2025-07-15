import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/device_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';


class DeviceListWidgetWeb extends ConsumerWidget {
  const DeviceListWidgetWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceWatch = ref.watch(deviceController);
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    return CommonTableGenerator(
        headerContent: [
          CommonHeader(title: LocaleKeys.keyStatus.localized),
          CommonHeader(title: LocaleKeys.keySerialNo.localized),
          CommonHeader(title: LocaleKeys.keyHostName.localized),
          CommonHeader(title: LocaleKeys.keyDestination.localized),
          CommonHeader(title: LocaleKeys.keyAvailability.localized),
        ],
        childrenHeader: deviceWatch.devicesList,
        childrenContent: (index) {
          final item = deviceWatch.devicesList[index];
          return [
            CommonRow(title: item.serialNumber ?? '-'),
            CommonRow(title: item.hostName ?? '-'),
            CommonRow(title: item.destinationName ?? '-'),
            CommonRow(title: item.inStock??false? LocaleKeys.keyAvailable.localized:LocaleKeys.keyAssigned.localized),
            CommonRow(title: ''),
          ];
        },
        statusValue:(index) => deviceWatch.devicesList[index].active ,
        isStatusAvailable: true,
        isDetailsAvailable: true,
        onForwardArrow: (index){
          ref.read(navigationStackController).push(NavigationStackItem.deviceDetails(deviceId: deviceWatch.devicesList[index].uuid??''));
        },
        onScrollListener: () async{
          if (!deviceWatch.deviceListState.isLoadMore && deviceWatch.deviceListState.success?.hasNextPage == true) {
            if (context.mounted) {
              await deviceWatch.deviceListApi(true);
            }
          }
        },
      isSwitchLoading:(index)=> deviceWatch.updateDeviceState.isLoading && index == deviceWatch.deviceUpdatingIndex,
      onStatusTap: (value,index) async{
          await deviceWatch.updateDeviceStatusApi(deviceUuid: deviceWatch.devicesList[index].uuid??'', status: value);
      },
      isDeleteVisible :(index) =>true,
      isDeleteAvailable:true,
      onDelete: (index)async{
          await deviceWatch.deleteDeviceApi(deviceUuid:deviceWatch.devicesList[index].uuid??'');
      },
      canDeletePermission: selectedMainScreen?.canDelete,
      isLoading: deviceWatch.deviceListState.isLoading,
      isLoadMore: deviceWatch.deviceListState.isLoadMore,
      isEditAvailable: selectedMainScreen?.canEdit,
      isEditVisible:(index) => deviceWatch.devicesList[index].active,
      onEdit: (index){
      ref.read(navigationStackController).push(NavigationStackItem.addEditDevice(deviceId: deviceWatch.devicesList[index].uuid??''));
      },
    );
  }
}
