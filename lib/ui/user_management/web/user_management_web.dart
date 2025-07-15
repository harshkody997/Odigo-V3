import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/users_management/user_management_controller.dart';
import 'package:odigov3/framework/repository/user_management/model/response/users_data.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class UserManagementWeb extends ConsumerWidget {
  const UserManagementWeb({super.key});

  ///Build Override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userManagementWatch = ref.watch(userManagementController);
    final drawerWatch = ref.watch(drawerController);
    return BaseDrawerPageWidget(
      totalCount: userManagementWatch.getUserListApiState.success?.totalCount ?? 0,
      listName: LocaleKeys.keyUsers.localized,
      searchPlaceHolderText: LocaleKeys.keySearchUser.localized,
      addButtonText: LocaleKeys.keyAddNewUser.localized,
      searchController: userManagementWatch.searchController,
      showSearchBar: true,
      showAddButton: drawerWatch.selectedMainScreen?.canAdd,
      showAppBar: true,
      addButtonOnTap: () {
        ref.read(navigationStackController).push(NavigationStackItem.addUser());
      },
      searchOnChanged: (value) {
        userManagementWatch.onSearchChanged(context);
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// User Table Widget
          Expanded(
            child: CommonTableGenerator(
              /// Header widgets for the table
              headerContent: [
                CommonHeader(title: LocaleKeys.keyStatus.localized),
                CommonHeader(title: LocaleKeys.keyUsername.localized, flex: 2),
                CommonHeader(title: LocaleKeys.keyContactNumber.localized, flex: 2),
                CommonHeader(title: LocaleKeys.keyEmailId.localized, flex: 3),
                CommonHeader(title: LocaleKeys.keyRoleName.localized, flex: 3),
              ],

              /// Data list from Users List
              childrenHeader: userManagementWatch.usersList,

              /// Row builder for each data row
              childrenContent: (index) {
                final item = userManagementWatch.usersList[index];
                return [
                  CommonRow(title: item.name ?? '', flex: 2),
                  CommonRow(title: item.contactNumber ?? '', flex: 2),
                  CommonRow(title: item.email ?? '', flex: 3),
                  CommonRow(title: item.roleName ?? '', flex: 3),
                  CommonRow(title: ''),
                ];
              },

              // Feature toggles
              isStatusAvailable: true,
              // Enable status switch
              isDetailsAvailable: true,

              onForwardArrow: (index) {
                ref.read(navigationStackController).push(NavigationStackItem.userDetails(userUuid: userManagementWatch.usersList[index].uuid));
              },

              // Update Status Switch Value
              onStatusTap: (bool? userData, index) async {
                final item = userManagementWatch.usersList[index];
                activeDeActiveUserApiCall(context, ref, item, index);
              },

              // Callback for status switch toggle
              statusValue: (index) => userManagementWatch.usersList[index].active,
              isSwitchLoading: (index) => userManagementWatch.toggleActiveDeActiveUserState.isLoading && index == userManagementWatch.updatingUserIndex,
              onScrollListener: () async {
                if (!userManagementWatch.getUserListApiState.isLoadMore && userManagementWatch.getUserListApiState.success?.hasNextPage == true) {
                  if (context.mounted) {
                    await userManagementWatch.getUserListApi(context);
                  }
                }
              },

              // Take reference from api loading variables
              isLoading: userManagementWatch.getUserListApiState.isLoading,
              isLoadMore: userManagementWatch.getUserListApiState.isLoadMore,

              /// edit
              isEditAvailable: drawerWatch.selectedMainScreen?.canEdit,
              isEditVisible: (index) => userManagementWatch.usersList[index].active,
              onEdit: (index) {
                ref.read(navigationStackController).push(NavigationStackItem.addUser(userUuid: userManagementWatch.usersList[index].uuid));
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Get users List Api Call
  Future<void> getUsersListApiCall(BuildContext context, WidgetRef ref, {bool isForPagination = true}) async {
    final userManagementWatch = ref.watch(userManagementController);
    if (!isForPagination) {
      userManagementWatch.isHasMorePage = false;
    }
    await userManagementWatch.getUserListApi(context);
  }

  /// Active DeActive User Api Call
  Future<void> activeDeActiveUserApiCall(BuildContext context, WidgetRef ref, UserData? userData, int index) async {
    final userManagementWatch = ref.watch(userManagementController);
    await userManagementWatch.toggleActiveDeActiveUserApi(context, userData, index);
  }
}
