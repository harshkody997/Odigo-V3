import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/destination_type/destination_type_list_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/destination/mobile/destination_mobile.dart';
import 'package:odigov3/ui/destination/web/destination_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Destination extends ConsumerStatefulWidget {
  const Destination({Key? key}) : super(key: key);

  @override
  ConsumerState<Destination> createState() => _DestinationState();
}

class _DestinationState extends ConsumerState<Destination> with WidgetsBindingObserver, ZoomAwareMixin {
  @override
  void initState() {
    if(ref.read(drawerController).isMainScreenCanViewSidebarAndCanView){
      final destinationRead = ref.read(destinationController);
      destinationRead.disposeController();
      ref.read(destinationTypeListController).disposeController();

      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        destinationRead.getDestinationListApi(context, isReset: true);
        ref.read(destinationTypeListController).getDestinationTypeListAPI(context,activeRecords: true);
      });
    }
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const DestinationWeb();
      },
      desktop: (BuildContext context) {
        return const DestinationWeb();
      },
      tablet: (BuildContext context) {
        return const DestinationWeb();
      },
    );
  }
}
