import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/destination_type/destination_type_list_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/master/destination_type/web/destination_type_list_web.dart';

class DestinationTypeList extends ConsumerStatefulWidget {
  const DestinationTypeList({Key? key}) : super(key: key);

  @override
  ConsumerState<DestinationTypeList> createState() => _DestinationTypeListState();
}

class _DestinationTypeListState extends ConsumerState<DestinationTypeList> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    if(ref.read(drawerController).isSubScreenCanViewSidebarAndCanView){
      final destinationTypeListWatch = ref.read(destinationTypeListController);
      destinationTypeListWatch.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        destinationTypeListWatch.getDestinationTypeListAPI(context);
      });
    }
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const DestinationTypeListWeb();
      },
      desktop: (BuildContext context) {
        return const DestinationTypeListWeb();
      },
      tablet: (BuildContext context) {
        return const DestinationTypeListWeb();
      },
    );
  }
}

