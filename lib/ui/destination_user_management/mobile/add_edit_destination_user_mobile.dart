import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/destination_user_management/add_edit_destination_user_controller.dart';

class AddEditDestinationUserMobile extends ConsumerStatefulWidget {
  const AddEditDestinationUserMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AddEditDestinationUserMobile> createState() => _AddEditDestinationUserMobileState();
}

class _AddEditDestinationUserMobileState extends ConsumerState<AddEditDestinationUserMobile> {

  ///Init:- This method will trigger when widget will initialized.
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final addEditDestinationUserWatch = ref.watch(addEditDestinationUserController);
      //addEditDestinationUserWatch.disposeController(isNotify : true);
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
