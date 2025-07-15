import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/ticket_reason/ticket_reason_list_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/master/ticket_reason/web/ticket_reason_list_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TicketReasonList extends ConsumerStatefulWidget{
  const TicketReasonList({Key? key}) : super(key: key);

  @override
  ConsumerState<TicketReasonList> createState() => _TicketReasonListState();
}

class _TicketReasonListState extends ConsumerState<TicketReasonList> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    if(ref.read(drawerController).isSubScreenCanViewSidebarAndCanView){
      final ticketReasonListWatch = ref.read(ticketReasonListController);
      ticketReasonListWatch.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ticketReasonListWatch.getTicketReasonListAPI(context);
      });
    }
    super.initState();
  }


  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const TicketReasonListWeb();
      },
      desktop: (BuildContext context) {
        return const TicketReasonListWeb();
      },
      tablet: (BuildContext context) {
        return const TicketReasonListWeb();
      },
    );
  }
}

