import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/ticket_management/web/helper/ticket_details_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_status_button_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class TicketTableForUser extends ConsumerStatefulWidget {
  const TicketTableForUser({Key? key}) : super(key: key);

  @override
  ConsumerState<TicketTableForUser> createState() => _TicketTableForUserState();
}

class _TicketTableForUserState extends ConsumerState<TicketTableForUser> {
  /// Builds the widget tree
  @override
  Widget build(BuildContext context) {
    // Watch state providers
    final ticketWatch = ref.watch(ticketManagementController);

    return CommonTableGenerator(
      // Header widgets for the table
      isLoading: ticketWatch.ticketListState.isLoading,
      headerContent: [
        CommonHeader(title: LocaleKeys.keyTicketDate.localized, flex: 2),
        CommonHeader(title: LocaleKeys.keyReason.localized, flex: 3),
        CommonHeader(title: LocaleKeys.keyStatus.localized, flex: 2),
        CommonHeader(title: '', flex: 2),
      ],

      // Data list from ads controller
      childrenHeader: ticketWatch.ticketList,

      // Row builder for each data row
      childrenContent: (index) {
        final item = ticketWatch.ticketList[index];
        return [
          ///generated date
          CommonRow(
            title:
            '${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(item?.createdAt ?? 0, isUtc: true))}',
            flex: 2,
          ),
          CommonRow(title: item?.ticketReason ?? '-', flex: 3),


          ///Status widget
          CommonRow(flex:2,widget: Row(
            children: [
              Expanded(flex:2,child: CommonStatusButton(status: item?.ticketStatus??'',dotRequired:true)),
              Spacer(flex: 1),
            ],
          ), title: ''),
          CommonRow(title: '',flex: 2),
          CommonRow(title: ''),
        ];
      },

      // Enable status switch
      isDetailsAvailable: true,
      // Show forward arrow icon

      // Delete callback (unused for now)
      onScrollListener: () async {
        if (!ticketWatch.ticketListState.isLoadMore &&
            ticketWatch.ticketListState.success?.hasNextPage == true) {
          if (mounted) {
            ///ticket list api
            await ticketWatch.ticketListApi(context, isForPagination: true);
          }
        }
      },
      onForwardArrow: (index) {
        /// Ticket detail dialog
        showCommonWebDialog(
          keyBadge: ref.watch(ticketManagementController).ticketDetailDialogKey,
          context: context,
          dialogBody: TicketDetailsDialog(index: index),
          height: 1,
          width: 0.4,
        );
      },
    );
  }
}
