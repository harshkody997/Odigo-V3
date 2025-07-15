import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class AddEditStateMobile extends ConsumerStatefulWidget {
  final bool? isEdit;
  const AddEditStateMobile({Key? key,this.isEdit}) : super(key: key);

  @override
  ConsumerState<AddEditStateMobile> createState() => _AddEditStateMobileState();
}

class _AddEditStateMobileState extends ConsumerState<AddEditStateMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final addEditStateWatch = ref.read(addEditStateController);
      //addEditStateWatch.disposeController(isNotify : true);
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
