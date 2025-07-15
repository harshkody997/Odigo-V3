import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/device_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/device/mobile/device_mobile.dart';
import 'package:odigov3/ui/device/web/device_web.dart';
import 'package:odigov3/ui/device/web/helper/device_filter_widget_web.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Device extends ConsumerStatefulWidget {
  const Device({super.key});

  @override
  ConsumerState<Device> createState() => _DeviceState();
}

class _DeviceState extends ConsumerState<Device> with WidgetsBindingObserver, ZoomAwareMixin{

  @override
  void initState() {
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    /// Restrict api call if view permission is not given
    if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
      final deviceRead = ref.read(deviceController);
      deviceRead.disposeController(isNotify: false);
      SchedulerBinding.instance.addPostFrameCallback((callback) async{
        await deviceRead.deviceListApi(false);
      });
    }
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        final deviceWatch = ref.watch(deviceController);
        SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
        return BaseDrawerPageWidget(
          body: DeviceWeb(),
          totalCount:deviceWatch.deviceListState.success?.totalCount,
          listName: LocaleKeys.keyDevices.localized,
          searchPlaceHolderText: LocaleKeys.keySearchDevicePlaceholder.localized,
          addButtonText: LocaleKeys.keyAddNewDevice.localized,
          searchController: deviceWatch.searchCtr,
          showExport: true,
          showImport: false,
          showSearchBar: true,
          showAddButton: selectedMainScreen?.canAdd,
          showAppBar: true,
          showFilters: true,
          exportOnTap: () async{
            await deviceWatch.exportDeviceApi(context);
          },
          addButtonOnTap: (){
            ref.read(navigationStackController).push(NavigationStackItem.addEditDevice());
          },
          searchOnChanged: (value) async{
            await deviceWatch.deviceListApi(false);
          },
          searchOnTap: (){},
          filterButtonOnTap: () {
            /// filter dialog
            showCommonDetailDialog(
              keyBadge: deviceWatch.filterKey,
              context: context,
              dialogBody: DeviceListFilterWidgetWeb(),
              height: 1,
              width: 0.5,
            );
          },
          isFilterApplied:  (deviceWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title) || (deviceWatch.selectedAvailabilityStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title),
        );
      },
      tablet: (BuildContext context) {
        final deviceWatch = ref.watch(deviceController);
        SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
        return BaseDrawerPageWidget(
          body: DeviceWeb(),
          totalCount:deviceWatch.deviceListState.success?.totalCount,
          listName: LocaleKeys.keyDevices.localized,
          searchPlaceHolderText:  LocaleKeys.keySearchDevicePlaceholder.localized,
          addButtonText: LocaleKeys.keyAddNewDevice.localized,
          searchController: deviceWatch.searchCtr,
          showExport: true,
          showImport: false,
          showSearchBar: true,
          showAddButton: selectedMainScreen?.canAdd,
          showAppBar: true,
          showFilters: true,
          exportOnTap: () async{
            await deviceWatch.exportDeviceApi(context);
          },
          addButtonOnTap: (){
            ref.read(navigationStackController).push(NavigationStackItem.addEditDevice());
          },
          searchOnChanged: (value) async{
            await deviceWatch.deviceListApi(false);
          },
          searchOnTap: (){},
          filterButtonOnTap: () {
            /// filter dialog
            showCommonDetailDialog(
              keyBadge: deviceWatch.filterKey,
              context: context,
              dialogBody: DeviceListFilterWidgetWeb(),
              height: 1,
              width: 0.5,
            );
          },
          isFilterApplied:  (deviceWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title) || (deviceWatch.selectedAvailabilityStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title),
        );
      },
      desktop: (BuildContext context) {
        final deviceWatch = ref.watch(deviceController);
        SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
        return BaseDrawerPageWidget(
          body: DeviceWeb(),
          totalCount:deviceWatch.deviceListState.success?.totalCount,
          listName: LocaleKeys.keyDevices.localized,
          searchPlaceHolderText:  LocaleKeys.keySearchDevicePlaceholder.localized,
          addButtonText: LocaleKeys.keyAddNewDevice.localized,
          searchController: deviceWatch.searchCtr,
          showExport: true,
          showImport: false,
          showSearchBar: true,
          showAddButton: selectedMainScreen?.canAdd,
          showAppBar: true,
          showFilters: true,
          exportOnTap: () async{
            await deviceWatch.exportDeviceApi(context);
          },
          addButtonOnTap: (){
            ref.read(navigationStackController).push(NavigationStackItem.addEditDevice());
          },
          searchOnChanged: (value) async{
            await deviceWatch.deviceListApi(false);
          },
          searchOnTap: (){},
          filterButtonOnTap: () {
            /// filter dialog
            showCommonDetailDialog(
              keyBadge: deviceWatch.filterKey,
              context: context,
              dialogBody: DeviceListFilterWidgetWeb(),
              height: 1,
            );
          },
          isFilterApplied:  (deviceWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title) || (deviceWatch.selectedAvailabilityStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title),
        );
      },
    );
  }
}


