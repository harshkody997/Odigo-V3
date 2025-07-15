import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/ticket_reason/add_edit_ticket_reason_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/master/ticket_reason/web/add_edit_ticket_reason_web.dart';

class AddEditTicketReason extends ConsumerStatefulWidget{
  final bool? isEdit;
  final String? uuid;
  const AddEditTicketReason({Key? key,this.isEdit,this.uuid,}) : super(key: key);

  @override
  ConsumerState<AddEditTicketReason> createState() => _AddEditTicketReasonState();
}

class _AddEditTicketReasonState extends ConsumerState<AddEditTicketReason> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    if(ref.read(drawerController).isSubScreenCanViewSidebarAndCanView){
      final addEditTicketReasonWatch = ref.read(addEditTicketReasonController);
      addEditTicketReasonWatch.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        addEditTicketReasonWatch.getLanguageListModel();
        if(widget.isEdit == true){
          addEditTicketReasonWatch.ticketReasonDetailsAPI(context, widget.uuid??'');
        }
      });
    }
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return AddEditTicketReasonWeb(isEdit: widget.isEdit,uuid: widget.uuid);
      },
      desktop: (BuildContext context) {
        return AddEditTicketReasonWeb(isEdit: widget.isEdit,uuid: widget.uuid);
      },
      tablet: (BuildContext context) {
        return AddEditTicketReasonWeb(isEdit: widget.isEdit,uuid: widget.uuid);
      },
    );
  }
}

