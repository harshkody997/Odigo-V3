import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/destination/destination_controller.dart';

class DestinationMobile extends ConsumerStatefulWidget {
  const DestinationMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<DestinationMobile> createState() => _DestinationMobileState();
}

class _DestinationMobileState extends ConsumerState<DestinationMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final destinationWatch = ref.watch(destinationController);
      //destinationWatch.disposeController(isNotify : true);
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
