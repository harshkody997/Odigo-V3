import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/master/state/web/state_list_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class StateList extends ConsumerStatefulWidget{
  const StateList({Key? key}) : super(key: key);

  @override
  ConsumerState<StateList> createState() => _StateListState();
}

class _StateListState extends ConsumerState<StateList> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    final drawerWatch = ref.read(drawerController);
    if(drawerWatch.isSubScreenCanViewSidebarAndCanView){
      final stateListWatch = ref.read(stateListController);
      stateListWatch.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        stateListWatch.getStateListAPI(context);
      });
    }
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const StateListWeb();
      },
      desktop: (BuildContext context) {
        return const StateListWeb();
      },
      tablet: (BuildContext context) {
        return const StateListWeb();
      },
    );
  }
}

