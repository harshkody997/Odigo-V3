import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/destination_type/add_edit_destination_type_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/master/destination_type/web/add_edit_destination_type_web.dart';

class AddEditDestinationType extends ConsumerStatefulWidget {
  final String? uuid;
  const AddEditDestinationType({Key? key,this.uuid}) : super(key: key);

  @override
  ConsumerState<AddEditDestinationType> createState() => _AddEditDestinationTypeState();
}

class _AddEditDestinationTypeState extends ConsumerState<AddEditDestinationType> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    if(ref.read(drawerController).isSubScreenCanViewSidebarAndCanView){
      final addEditDestinationTypeWatch = ref.read(addEditDestinationTypeController);
      addEditDestinationTypeWatch.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        addEditDestinationTypeWatch.getLanguageListModel();
        if(widget.uuid != null){
          addEditDestinationTypeWatch.destinationTypeDetailsAPI(context, widget.uuid??'');
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
        return AddEditDestinationTypeWeb(uuid: widget.uuid);
      },
      desktop: (BuildContext context) {
        return AddEditDestinationTypeWeb(uuid: widget.uuid);
      },
      tablet: (BuildContext context) {
        return AddEditDestinationTypeWeb(uuid: widget.uuid);
      },
    );
  }
}

