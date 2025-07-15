import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/ticket_reason/ticket_reason_list_controller.dart';
import 'package:odigov3/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/ticket_management/web/create_ticket_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CreateTicket extends ConsumerStatefulWidget {
  const CreateTicket({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateTicket> createState() => _TicketListState();
}

class _TicketListState extends ConsumerState<CreateTicket> with WidgetsBindingObserver, ZoomAwareMixin {
  @override
  void initState() {
    final ticketListRead = ref.read(ticketManagementController);
    ticketListRead.disposeController();
    final ticketReasonListWatch = ref.read(ticketReasonListController);
    ticketReasonListWatch.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
      if(selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {

        ticketReasonListWatch.getTicketReasonListAPI(context,activeRecords: true,platformType: 'DESTINATION');
      }

    });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const CreateTicketWeb();
      },
      desktop: (BuildContext context) {
        return const CreateTicketWeb();
      },
      tablet: (BuildContext context) {
        return const CreateTicketWeb();
      },
    );
  }
}
