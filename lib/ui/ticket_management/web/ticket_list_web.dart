import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/ticket_management/web/helper/ticket_list_filter_dialog.dart';
import 'package:odigov3/ui/ticket_management/web/helper/ticket_table_for_user.dart';
import 'package:odigov3/ui/ticket_management/web/helper/ticket_table_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';

class TicketListWeb extends ConsumerStatefulWidget {
  const TicketListWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<TicketListWeb> createState() => _TicketListWebState();
}

class _TicketListWebState extends ConsumerState<TicketListWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    final ticketWatch = ref.watch(ticketManagementController);
    final drawerWatch = ref.watch(drawerController);

    return BaseDrawerPageWidget(
      showAddButton: Session.getRoleType() != 'SUPER_ADMIN' &&  (drawerWatch.selectedMainScreen?.canAdd ?? false),
      addButtonOnTap: () {
        ref.read(navigationStackController).push(NavigationStackItem.createTicket());
      },
      isFilterApplied: ticketWatch.isFilterApplied,
      addButtonText: LocaleKeys.keyCreateTicket.localized,
      totalCount: ticketWatch.ticketList.length,
      listName: LocaleKeys.keyTicket.localized,
      searchController: ticketWatch.searchCtr,
      searchPlaceHolderText: LocaleKeys.keySearchTicketHintText.localized,
      showSearchBar: true,
      showFilters: true,
      filterButtonOnTap: () {
        /// filter dialog
        showCommonDetailDialog(
          keyBadge: ticketWatch.ticketFilterDialogKey,
          context: context,
          dialogBody:  TicketListFilterDialog(),
          height: 1,
          width: 0.5,
        );
      },
      searchOnChanged: (value){
        final ticketWatch = ref.read(ticketManagementController);
        if(!ticketWatch.ticketListState.isLoading) {
          ticketWatch.ticketListApi(context, searchKeyword: value);
        }
      },
      body: Session.getRoleType() == 'SUPER_ADMIN' ? TicketTableWidget() : TicketTableForUser(),
    );
  }
}
