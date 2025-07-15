import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/store/store_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/store/mobile/store_mobile.dart';
import 'package:odigov3/ui/store/web/store_web.dart';

class Store extends ConsumerStatefulWidget {
  const Store({super.key});

  @override
  ConsumerState<Store> createState() => _StoreState();
}

class _StoreState extends ConsumerState<Store> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    if(selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {
      final storeRead = ref.read(storeController);
      storeRead.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        storeRead.storeListApi(context);
      });
    }
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return const StoreWeb();
        },
        tablet: (BuildContext context) {
          return const StoreWeb();
        },
        desktop: (BuildContext context) {
          return const StoreWeb();
        },
    );
  }
}

