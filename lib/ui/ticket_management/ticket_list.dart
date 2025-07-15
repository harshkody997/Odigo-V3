import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/ticket_management/web/ticket_list_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TicketList extends ConsumerStatefulWidget {
  const TicketList({Key? key}) : super(key: key);

  @override
  ConsumerState<TicketList> createState() => _TicketListState();
}

class _TicketListState extends ConsumerState<TicketList> with WidgetsBindingObserver, ZoomAwareMixin {
  @override
  void initState() {
    final ticketListRead = ref.read(ticketManagementController);
    ticketListRead.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;

      if(selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {

        ticketListRead.ticketListApi(context,);
      }
    });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const TicketListWeb();
      },
      desktop: (BuildContext context) {
        return const TicketListWeb();
      },
      tablet: (BuildContext context) {
        return const TicketListWeb();
      },
    );
  }
}
