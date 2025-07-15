import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart';
import 'package:odigov3/framework/controller/master/ticket_reason/add_edit_ticket_reason_controller.dart';
import 'package:odigov3/framework/controller/master/ticket_reason/ticket_reason_list_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class TicketReasonTable extends ConsumerStatefulWidget {
  const TicketReasonTable({super.key});

  @override
  ConsumerState<TicketReasonTable> createState() => _TicketReasonTableState();
}

class _TicketReasonTableState extends ConsumerState<TicketReasonTable> {

  @override
  Widget build(BuildContext context) {
    final ticketReasonListWatch = ref.watch(ticketReasonListController);
    final drawerWatch = ref.watch(drawerController);
    return CommonTableGenerator(
      headerContent: [
        CommonHeader(title: LocaleKeys.keyStatus.localized),
        CommonHeader(title: LocaleKeys.keyPlatformType.localized,flex: 2),
        CommonHeader(title: LocaleKeys.keyTicketReason.localized,flex: 7),
      ],
      childrenHeader: ticketReasonListWatch.ticketReasonList,
      childrenContent: (int index) {
        final item = ticketReasonListWatch.ticketReasonList[index];
        return [
          CommonRow(title: (item.platformType ?? '').ticketReasonPlatformTypeToString()?.text ?? '',flex: 2),
          CommonRow(title: item.reason ?? '',flex: 7),
          CommonRow(title: ''),
        ];

      },
      isEditAvailable: drawerWatch.isSubScreenCanEdit,
      canDeletePermission: drawerWatch.isSubScreenCanDelete,
      isEditVisible: (index) => ticketReasonListWatch.ticketReasonList[index].active,
      onEdit: (index){
        ref.read(addEditTicketReasonController).disposeController();
        ref.read(navigationStackController).push(NavigationStackItem.editTicketReason(uuid:ticketReasonListWatch.ticketReasonList[index].uuid??''));
      },
      isStatusAvailable: true,
      isLoading: ticketReasonListWatch.ticketReasonListState.isLoading,
      isLoadMore: ticketReasonListWatch.ticketReasonListState.isLoadMore,
      isSwitchLoading: (index) => (ticketReasonListWatch.changeStateStatusState.isLoading && ticketReasonListWatch.statusTapIndex == index),
      statusValue:(index) => ticketReasonListWatch.ticketReasonList[index].active,
      onStatusTap: (value,index) {
        ticketReasonListWatch.updateStatusIndex(index);
        ticketReasonListWatch.changeStateStatusAPI(context, ticketReasonListWatch.ticketReasonList[index].uuid??'', value,index);
      },
      onScrollListener: () async {
        if (!ticketReasonListWatch.ticketReasonListState.isLoadMore && ticketReasonListWatch.ticketReasonListState.success?.hasNextPage == true) {
          if (mounted) {
            await ticketReasonListWatch.getTicketReasonListAPI(context,pagination: true,activeRecords: ticketReasonListWatch.selectedFilter?.value);
          }
        }
      },
    );
  }
}

