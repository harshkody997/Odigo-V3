import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/notification_list/notification_controller.dart';

class NotificationListMobile extends ConsumerStatefulWidget {
  const NotificationListMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationListMobile> createState() => _NotificationMobileState();
}

class _NotificationMobileState extends ConsumerState<NotificationListMobile> {



  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Container();
  }


}
