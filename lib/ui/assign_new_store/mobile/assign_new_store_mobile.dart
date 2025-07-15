import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/assign_new_store/assign_new_store_controller.dart';

class AssignNewStoreMobile extends ConsumerStatefulWidget {
  const AssignNewStoreMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AssignNewStoreMobile> createState() => _AssignNewStoreMobileState();
}

class _AssignNewStoreMobileState extends ConsumerState<AssignNewStoreMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final assignNewStoreWatch = ref.watch(assignNewStoreController);
      //assignNewStoreWatch.disposeController(isNotify : true);
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
