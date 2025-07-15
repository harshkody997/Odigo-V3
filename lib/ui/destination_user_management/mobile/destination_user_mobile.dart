import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/destination_user_management/destination_user_controller.dart';

class DestinationUserMobile extends ConsumerStatefulWidget {
  const DestinationUserMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<DestinationUserMobile> createState() => _DestinationUserMobileState();
}

class _DestinationUserMobileState extends ConsumerState<DestinationUserMobile> {

  ///Init:- This method will trigger when widget will initialized.
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final destinationUserWatch = ref.watch(destinationUserController);
      //destinationUserWatch.disposeController(isNotify : true);
    });
  }

  ///Dispose:- This method will trigger when widget about to remove from navigation stack.
  @override
  void dispose() {
    super.dispose();
  }

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Container();
  }


}
