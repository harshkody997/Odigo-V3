import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_list_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/client/web/client_list_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ClientList extends ConsumerStatefulWidget {
  const ClientList({super.key});

  @override
  ConsumerState<ClientList> createState() => _ClientList();
}

class _ClientList extends ConsumerState<ClientList> with WidgetsBindingObserver, ZoomAwareMixin {
  /// Init override
  @override
  void initState() {
    final clientListWatch = ref.read(clientListController);
    clientListWatch.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
      if (selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {
        await clientListWatch.getClientListWithPaginationApiCall(context);
      }
    });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return ClientListWeb();
      },
      tablet: (BuildContext context) {
        return ClientListWeb();
      },
      desktop: (BuildContext context) {
        return ClientListWeb();
      },
    );
  }
}
