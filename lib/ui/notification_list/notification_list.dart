import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/notification_list/notification_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'web/notification_list_web.dart';


class NotificationList extends ConsumerStatefulWidget {
  const NotificationList({super.key});

  @override
  ConsumerState<NotificationList> createState() => _NotificationListState();
}


class _NotificationListState extends ConsumerState<NotificationList> with WidgetsBindingObserver, ZoomAwareMixin {

  @override
  void initState() {
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
    //   final notificationScreenWatch = ref.read(notificationController);
    //   notificationScreenWatch.disposeController(isNotify : true);
    //   await notificationScreenWatch.notificationListAPI(context);
    //   if(notificationScreenWatch.notificationListState.success?.status == ApiEndPoints.apiStatus_200){
    //     if(notificationScreenWatch.readAllNotificationState.success == null){
    //       if(mounted){
    //         await notificationScreenWatch.readAllNotificationAPI(context);
    //       }
    //     }
    //   }
    //   notificationScreenWatch.notificationListController.addListener(() async {
    //     if ((notificationScreenWatch.notificationListController.position.pixels >=
    //         notificationScreenWatch.notificationListController.position.maxScrollExtent - 100)) {
    //       if ((notificationScreenWatch.notificationListState.success?.hasNextPage ?? false) &&
    //           !(notificationScreenWatch.notificationListState.isLoadMore)) {
    //         notificationScreenWatch.increasePageNumber();
    //         await notificationScreenWatch.notificationListAPI(context);
    //       }
    //     }
    //   });
    // });
    super.initState();
  }
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return NotificationListWeb();
        },
        desktop: (BuildContext context) {
          return const NotificationListWeb();
        },
        tablet: (BuildContext context){
          return const NotificationListWeb();
        }
    );
  }
}

