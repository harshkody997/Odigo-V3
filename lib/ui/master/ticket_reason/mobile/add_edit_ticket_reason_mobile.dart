import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class AddEditTicketReasonMobile extends ConsumerStatefulWidget {
  const AddEditTicketReasonMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AddEditTicketReasonMobile> createState() =>
      _AddEditTicketReasonMobileState();
}

class _AddEditTicketReasonMobileState
    extends ConsumerState<AddEditTicketReasonMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final addEditTicketReasonWatch = ref.watch(addEditTicketReasonController);
      //addEditTicketReasonWatch.disposeController(isNotify : true);
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
