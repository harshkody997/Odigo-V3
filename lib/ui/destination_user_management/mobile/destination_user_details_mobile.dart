import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/destination_user_management/destination_user_details_controller.dart';

class DestinationUserDetailsMobile extends ConsumerStatefulWidget {
  const DestinationUserDetailsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<DestinationUserDetailsMobile> createState() => _DestinationUserDetailsMobileState();
}

class _DestinationUserDetailsMobileState extends ConsumerState<DestinationUserDetailsMobile> {

  ///Init:- This method will trigger when widget will initialized.
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final destinationUserDetailsWatch = ref.watch(destinationUserDetailsController);
      //destinationUserDetailsWatch.disposeController(isNotify : true);
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
