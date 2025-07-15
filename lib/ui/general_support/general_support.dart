import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/general_support/general_support_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/general_support/mobile/general_support_mobile.dart';
import 'package:odigov3/ui/general_support/web/general_support_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class GeneralSupport extends ConsumerStatefulWidget {
  const GeneralSupport({super.key});

  @override
  ConsumerState<GeneralSupport> createState() => _GeneralSupportState();
}

class _GeneralSupportState extends ConsumerState<GeneralSupport> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    final generalSupportRead = ref.read(generalSupportController);
    generalSupportRead.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      if((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false) ){
        ///contact us list api
        generalSupportRead.contactUsListApi(context);
      }

    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const GeneralSupportMobile();
      },
      desktop: (BuildContext context) {
        return const GeneralSupportWeb();
      },
    );
  }
}

