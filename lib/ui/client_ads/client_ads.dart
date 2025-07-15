import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_list_controller.dart';
import 'package:odigov3/framework/controller/client_ads/client_ads_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/client_ads/web/client_ads_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ClientAds extends ConsumerStatefulWidget {
  const ClientAds({Key? key}) : super(key: key);

  @override
  ConsumerState<ClientAds> createState() => _ClientAdsState();
}

class _ClientAdsState extends ConsumerState<ClientAds> with WidgetsBindingObserver, ZoomAwareMixin{

  ///Init Override
  @override
  void initState() {
    super.initState();
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    if(selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {
      final clientAdsRead = ref.read(clientAdsController);
      clientAdsRead.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        clientAdsRead.clientAdsListApi(context);

        final clientListRead = ref.read(clientListController);
        clientListRead.clearClientList();
        clientListRead.getClientApi(context, activeRecords: true);
      });
    }
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return const ClientAdsWeb();
        },
        tablet: (BuildContext context) {
          return const ClientAdsWeb();
        },
        desktop: (BuildContext context) {
          return const ClientAdsWeb();
        }
    );
  }
}

