import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/destination/destination_details_controller.dart';

class DestinationDetailsMobile extends ConsumerStatefulWidget {
  const DestinationDetailsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<DestinationDetailsMobile> createState() => _DestinationDetailsMobileState();
}

class _DestinationDetailsMobileState extends ConsumerState<DestinationDetailsMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final destinationDetailsWatch = ref.watch(destinationDetailsController);
      //destinationDetailsWatch.disposeController(isNotify : true);
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
