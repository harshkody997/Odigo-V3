import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_module/ads_module_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/ads_module/mobile/ads_module_mobile.dart';
import 'package:odigov3/ui/ads_module/web/ads_module_web.dart';

class AdsModule extends ConsumerStatefulWidget {
  const AdsModule({Key? key}) : super(key: key);

  @override
  ConsumerState<AdsModule> createState() => _AdsModuleState();
}

class _AdsModuleState extends ConsumerState<AdsModule> with WidgetsBindingObserver, ZoomAwareMixin{

  ///Init Override
  @override
  void initState() {
    super.initState();
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    if(selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {
      final adsRead = ref.read(adsModuleController);
      adsRead.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        adsRead.defaultAdsListApi(context);

        /// for filter
        final destinationWatch = ref.read(destinationController);
        destinationWatch.clearDestinationList();
        destinationWatch.getDestinationListApi(context, activeRecords: true);
      });
    }
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return const AdsModuleWeb();
        },
        tablet: (BuildContext context) {
          return const AdsModuleWeb();
        },
        desktop: (BuildContext context) {
          return const AdsModuleWeb();
        }
    );
  }
}

