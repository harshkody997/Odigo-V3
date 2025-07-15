import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/device/add_device_controller.dart';

class AddEditDeviceMobile extends ConsumerStatefulWidget {
  const AddEditDeviceMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AddEditDeviceMobile> createState() => _AddEditDeviceMobileState();
}

class _AddEditDeviceMobileState extends ConsumerState<AddEditDeviceMobile> {

  ///Init:- This method will trigger when widget will initialized.
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final addDeviceWatch = ref.watch(addDeviceController);
      //addDeviceWatch.disposeController(isNotify : true);
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
