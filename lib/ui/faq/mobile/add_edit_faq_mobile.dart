import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class AddEditFaqMobile extends ConsumerStatefulWidget {
  const AddEditFaqMobile({super.key});

  @override
  ConsumerState<AddEditFaqMobile> createState() => _AddEditFaqMobileState();
}

class _AddEditFaqMobileState extends ConsumerState<AddEditFaqMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final addEditFaqWatch = ref.watch(addEditFaqController);
      //addEditFaqWatch.disposeController(isNotify : true);
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
    return const Column(
      children: [],
    );
  }


}
