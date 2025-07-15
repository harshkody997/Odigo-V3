import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';


class DestinationUsersListWidgetWeb extends ConsumerWidget {
  const DestinationUsersListWidgetWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinationUserWatch = ref.watch(destinationUserController);
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    return CommonTableGenerator(
      headerContent: [
        CommonHeader(title: LocaleKeys.keyStatus.localized),
        CommonHeader(title: LocaleKeys.keyName.localized),
        CommonHeader(title: LocaleKeys.keyDestination.localized),
        CommonHeader(title: LocaleKeys.keyContactNumber.localized),
        CommonHeader(title: LocaleKeys.keyEmailId.localized,flex: 2),
      ],
      childrenHeader: destinationUserWatch.destinationUserList,
      childrenContent: (index) {
        final item = destinationUserWatch.destinationUserList[index];
        return [
          CommonRow(title: item.name ?? '-'),
          CommonRow(title: item.destinationName ?? '-'),
          CommonRow(title: item.contactNumber ?? '-'),
          CommonRow(title: item.email ?? '-',flex: 2),
          CommonHeader(title: ''),
        ];
      },
      statusValue:(index) => destinationUserWatch.destinationUserList[index].active ,
      isStatusAvailable: true,
      isDetailsAvailable: true,
      onForwardArrow: (index){
        ref.read(navigationStackController).push(NavigationStackItem.destinationUserDetails(userUuid: destinationUserWatch.destinationUserList[index].uuid??''));
      },
      onScrollListener: () async{
        if (!destinationUserWatch.destinationUserListState.isLoadMore && destinationUserWatch.destinationUserListState.success?.hasNextPage == true) {
          if (context.mounted) {
            await destinationUserWatch.destinationUserListApi(true);
          }
        }
      },
      isSwitchLoading:(index)=> destinationUserWatch.updateUserState.isLoading && index == destinationUserWatch.userUpdatingIndex,
      onStatusTap: (value,index) async{
        await destinationUserWatch.updateDeviceStatusApi(userId: destinationUserWatch.destinationUserList[index].uuid??'', status: value);
      },
      isLoading: destinationUserWatch.destinationUserListState.isLoading,
      isLoadMore: destinationUserWatch.destinationUserListState.isLoadMore,
      canDeletePermission: selectedMainScreen?.canDelete,
      isEditAvailable: selectedMainScreen?.canEdit,
      isEditVisible:(index) => destinationUserWatch.destinationUserList[index].active,
      onEdit: (index){
        ref.read(navigationStackController).push(NavigationStackItem.addEditDestinationUser(userUuid: destinationUserWatch.destinationUserList[index].uuid??''));
      },
    );
  }
}
