import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class AddEditCityMobile extends ConsumerStatefulWidget {
  const AddEditCityMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AddEditCityMobile> createState() => _AddEditCityMobileState();
}

class _AddEditCityMobileState extends ConsumerState<AddEditCityMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final addEditCityWatch = ref.read(addEditCityController);
      //addEditCityWatch.disposeController(isNotify : true);
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
