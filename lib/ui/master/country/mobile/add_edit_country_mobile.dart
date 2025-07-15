import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class AddEditCountryMobile extends ConsumerStatefulWidget {
  const AddEditCountryMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AddEditCountryMobile> createState() => _AddEditCountryMobileState();
}

class _AddEditCountryMobileState extends ConsumerState<AddEditCountryMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final addEditCountryWatch = ref.read(addEditCountryController);
      //addEditCountryWatch.disposeController(isNotify : true);
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
