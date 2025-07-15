import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../../framework/controller/master/destination_type/add_edit_destination_type_controller.dart';

class AddEditDestinationTypeMobile extends ConsumerStatefulWidget {
  const AddEditDestinationTypeMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AddEditDestinationTypeMobile> createState() =>
      _AddEditDestinationTypeMobileState();
}

class _AddEditDestinationTypeMobileState
    extends ConsumerState<AddEditDestinationTypeMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final addEditDestinationTypeWatch = ref.watch(
          addEditDestinationTypeController);
      //addEditDestinationTypeWatch.disposeController(isNotify : true);
    });
  }

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
