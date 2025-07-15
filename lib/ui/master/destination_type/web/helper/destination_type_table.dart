import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/destination_type/add_edit_destination_type_controller.dart';
import 'package:odigov3/framework/controller/master/destination_type/destination_type_list_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class DestinationTypeTable extends ConsumerStatefulWidget {
  const DestinationTypeTable({super.key});

  @override
  ConsumerState<DestinationTypeTable> createState() => _DestinationTypeTableState();
}

class _DestinationTypeTableState extends ConsumerState<DestinationTypeTable> {

  @override
  Widget build(BuildContext context) {
    final destinationTypeListWatch = ref.watch(destinationTypeListController);
    final drawerWatch = ref.watch(drawerController);
    return CommonTableGenerator(
      headerContent: [
        CommonHeader(title: LocaleKeys.keyStatus.localized),
        CommonHeader(title: LocaleKeys.keyDestinationType.localized,flex: 10), /// destination type
      ],
      childrenHeader: destinationTypeListWatch.destinationTypeList,
      childrenContent: (int index) {
        final item = destinationTypeListWatch.destinationTypeList[index];
        return [
          CommonRow(title: item.name ?? '',flex: 10), /// destination type
          CommonRow(title: ''),
        ];
      },
      isSwitchLoading: (index) => (destinationTypeListWatch.statusTapIndex == index && destinationTypeListWatch.changeDestinationStatusState.isLoading),
      isStatusAvailable: true,
      onStatusTap: (status,index) {
        destinationTypeListWatch.updateStatusIndex(index);
        destinationTypeListWatch.changeDestinationStatusAPI(context, destinationTypeListWatch.destinationTypeList[index].uuid??'', status, index);
      },
      isEditAvailable: drawerWatch.isSubScreenCanEdit,
      canDeletePermission: drawerWatch.isSubScreenCanDelete,
      onEdit: (index){
        ref.read(addEditDestinationTypeController).disposeController();
        ref.read(navigationStackController).push(NavigationStackItem.addEditDestinationType(uuid: destinationTypeListWatch.destinationTypeList[index].uuid??''));
      },
      isEditVisible:(index) => destinationTypeListWatch.destinationTypeList[index].active,
      statusValue:(index) => destinationTypeListWatch.destinationTypeList[index].active,
      isLoading: destinationTypeListWatch.destinationTypeListState.isLoading,
      isLoadMore: destinationTypeListWatch.destinationTypeListState.isLoadMore,
      onScrollListener: () async {
        if (!destinationTypeListWatch.destinationTypeListState.isLoadMore && destinationTypeListWatch.destinationTypeListState.success?.hasNextPage == true) {
          if (mounted) {
            await destinationTypeListWatch.getDestinationTypeListAPI(context,pagination: true,activeRecords: destinationTypeListWatch.selectedFilter?.value);
          }
        }
      },
    );
  }
}
