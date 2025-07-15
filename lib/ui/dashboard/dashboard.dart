import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_list_controller.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/dashboard/web/dashboard_web.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Dashboard> with WidgetsBindingObserver, ZoomAwareMixin {
  @override
  void initState() {
    super.initState();
    final dashboardWatch = ref.read(dashboardController);
    final clientListRead = ref.read(clientListController);
    dashboardWatch.disposeController();

    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        dashboardWatch.dashboardCountApi(context);
        if((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)){
          dashboardWatch.robotDataListApi(context, ref, robotDataList: dashboardWatch.uptimeRobotList,);
          dashboardWatch.storeDataListApi(context, ref, storeDataList: dashboardWatch.efficiencyStoreList, initial: true,);
          dashboardWatch.allGraphApiCall(context, ref);
        }
        else {
          dashboardWatch.destinationDataListApi(context, ref);
        }

        clientListRead.getClientApi(context);
        dashboardWatch.categoryDataListApi(context, ref, categoryList: dashboardWatch.interactionCategoryList, initial: true);

        print('Session.fcmToken-----${Session.fcmToken}');
        if (Session.fcmToken.isNotEmpty) {
          await dashboardWatch.registerDeviceFcmToken(context);
        }
      },
    );
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const DashboardWeb();
      },
      tablet: (BuildContext context) {
        return const DashboardWeb();
      },
      desktop: (BuildContext context) {
        return const DashboardWeb();
      },
    );
  }
}
