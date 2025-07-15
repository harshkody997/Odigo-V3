import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddUpdateClientMobile extends ConsumerStatefulWidget {
  const AddUpdateClientMobile({super.key});

  @override
  ConsumerState<AddUpdateClientMobile> createState() =>
      _AddUpdateClientMobileState();
}

class _AddUpdateClientMobileState extends ConsumerState<AddUpdateClientMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final addUpdateClientWatch = ref.read(addUpdateClientController);
      //addUpdateClientWatch.disposeController(isNotify : true);
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
