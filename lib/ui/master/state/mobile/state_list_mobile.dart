import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class StateListMobile extends ConsumerStatefulWidget {
  const StateListMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<StateListMobile> createState() => _StateListMobileState();
}

class _StateListMobileState extends ConsumerState<StateListMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final stateListWatch = ref.read(stateListController);
      // stateListWatch.disposeController(isNotify : true);
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
