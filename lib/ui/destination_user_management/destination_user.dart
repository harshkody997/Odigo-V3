import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/destination_user_management/web/destination_user_web.dart';
import 'package:odigov3/ui/destination_user_management/web/helper/destination_user_filter_widget_web.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DestinationUser extends ConsumerStatefulWidget {
  const DestinationUser({Key? key}) : super(key: key);

  @override
  ConsumerState<DestinationUser> createState() => _DestinationUserState();
}

class _DestinationUserState extends ConsumerState<DestinationUser> with WidgetsBindingObserver,ZoomAwareMixin {

  ///Init:- This method will trigger when widget will initialized.
  @override
  void initState() {
    super.initState();
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    /// Restrict api call if view permission is not given
    if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
      final destinationUserWatch = ref.read(destinationUserController);
      destinationUserWatch.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
        await destinationUserWatch.destinationUserListApi(false);
      });
    }
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          final destinationUserWatch = ref.watch(destinationUserController);
          SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
          return   BaseDrawerPageWidget(
            body: DestinationUserWeb(),
            totalCount:destinationUserWatch.destinationUserListState.success?.totalCount ,
            listName: LocaleKeys.keyDestinationUsers.localized,
            searchPlaceHolderText: LocaleKeys.keySearchUser.localized,
            addButtonText: LocaleKeys.keyAddNewUser.localized,
            searchController: destinationUserWatch.searchCtr,
            showExport: false,
            showImport: false,
            showSearchBar: true,
            showAddButton: selectedMainScreen?.canAdd,
            showAppBar: true,
            showFilters: true,
            addButtonOnTap: (){
              ref.read(navigationStackController).push(NavigationStackItem.addEditDestinationUser());
            },
            searchOnChanged: (value) async{
              await destinationUserWatch.destinationUserListApi(false);
            },
            searchOnTap: (){},
            filterButtonOnTap: () {
              /// filter dialog
              showCommonDetailDialog(
                keyBadge: destinationUserWatch.filterKey,
                context: context,
                dialogBody: DestinationUserListFilterWidgetWeb(),
                height: 1,
                width: 0.5,
              );
            },
            isFilterApplied:  (destinationUserWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title),
          );
          },
        tablet: (BuildContext context) {
          final destinationUserWatch = ref.watch(destinationUserController);
          SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
          return   BaseDrawerPageWidget(
            body: DestinationUserWeb(),
            totalCount:destinationUserWatch.destinationUserListState.success?.totalCount,
            listName: LocaleKeys.keyDestinationUsers.localized,
            searchPlaceHolderText: LocaleKeys.keySearchUser.localized,
            addButtonText: LocaleKeys.keyAddNewUser.localized,
            searchController: destinationUserWatch.searchCtr,
            showExport: false,
            showImport: false,
            showSearchBar: true,
            showAddButton: selectedMainScreen?.canAdd,
            showAppBar: true,
            showFilters: true,
            addButtonOnTap: (){
              ref.read(navigationStackController).push(NavigationStackItem.addEditDestinationUser());
            },
            searchOnChanged: (value) async{
              await destinationUserWatch.destinationUserListApi(false);
            },
            searchOnTap: (){},
            filterButtonOnTap: () {
              /// filter dialog
              showCommonDetailDialog(
                keyBadge: destinationUserWatch.filterKey,
                context: context,
                dialogBody: DestinationUserListFilterWidgetWeb(),
                height: 1,
                width: 0.5,
              );
            },
            isFilterApplied:  (destinationUserWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title),
          );
          },
        desktop: (BuildContext context) {
          final destinationUserWatch = ref.watch(destinationUserController);
          SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
          return   BaseDrawerPageWidget(
            body: DestinationUserWeb(),
            totalCount:destinationUserWatch.destinationUserListState.success?.totalCount,
            listName: LocaleKeys.keyDestinationUsers.localized,
            searchPlaceHolderText: LocaleKeys.keySearchUser.localized,
            addButtonText: LocaleKeys.keyAddNewUser.localized,
            searchController: destinationUserWatch.searchCtr,
            showExport: false,
            showImport: false,
            showSearchBar: true,
            showAddButton: selectedMainScreen?.canAdd,
            showAppBar: true,
            showFilters: true,
            addButtonOnTap: (){
              ref.read(navigationStackController).push(NavigationStackItem.addEditDestinationUser());
            },
            searchOnChanged: (value) async{
              await destinationUserWatch.destinationUserListApi(false);
            },
            searchOnTap: (){},
            filterButtonOnTap: () {
              /// filter dialog
              showCommonDetailDialog(
                keyBadge: destinationUserWatch.filterKey,
                context: context,
                dialogBody: DestinationUserListFilterWidgetWeb(),
                height: 1,
                width: 0.5,
              );
            },
            isFilterApplied:  (destinationUserWatch.selectedStatus.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title),
          );
        },
    );
  }
}

