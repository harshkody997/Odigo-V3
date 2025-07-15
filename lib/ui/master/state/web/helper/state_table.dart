import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class StateTable extends ConsumerStatefulWidget {
  const StateTable({super.key});

  @override
  ConsumerState<StateTable> createState() => _StateTableState();
}

class _StateTableState extends ConsumerState<StateTable> {

  @override
  Widget build(BuildContext context) {
    final stateListWatch = ref.watch(stateListController);
    final drawerWatch = ref.watch(drawerController);
    return CommonTableGenerator(
      headerContent: [
        CommonHeader(title: LocaleKeys.keyStatus.localized), /// status
        CommonHeader(title: LocaleKeys.keyCountryName.localized,flex: 4), /// country name
        CommonHeader(title: LocaleKeys.keyStateName.localized,flex: 10), /// state name
      ],
      childrenHeader: stateListWatch.stateList,
      childrenContent: (int index) {
        final item = stateListWatch.stateList[index];
        return [
          CommonRow(title: item.countryName ?? '',flex: 4), /// country name
          CommonRow(title: item.name ?? '',flex: 10), /// state name
          CommonRow(title: ''), /// if edit icon alignment
        ];

      },
      isEditAvailable: drawerWatch.isSubScreenCanEdit,
      onEdit: (index){
        ref.read(navigationStackController).push(NavigationStackItem.editState(uuid: stateListWatch.stateList[index].uuid??''));
      },
      isStatusAvailable: true,
      canDeletePermission: drawerWatch.isSubScreenCanDelete,
      isEditVisible:(index) => stateListWatch.stateList[index].active,
      statusValue:(index) => stateListWatch.stateList[index].active,
      isLoading: stateListWatch.stateListState.isLoading,
      isLoadMore: stateListWatch.stateListState.isLoadMore,
      isSwitchLoading:(index) => stateListWatch.changeStateStatusState.isLoading && index == stateListWatch.statusTapIndex,
      onStatusTap: (value,index) {
        stateListWatch.updateStatusIndex(index);
        stateListWatch.changeStateStatusAPI(context, stateListWatch.stateList[index].uuid??'', value,index);
      },
      onScrollListener: () async {
        if (!stateListWatch.stateListState.isLoadMore && stateListWatch.stateListState.success?.hasNextPage == true) {
          if (mounted) {
            await stateListWatch.getStateListAPI(context,pagination: true,activeRecords: stateListWatch.selectedFilter?.value);
          }
        }
      },
    );
  }
}

