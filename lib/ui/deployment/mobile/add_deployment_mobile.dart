import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class AddDeploymentMobile extends ConsumerStatefulWidget {
  const AddDeploymentMobile({super.key});

  @override
  ConsumerState<AddDeploymentMobile> createState() => _AddDeploymentMobileState();
}

class _AddDeploymentMobileState extends ConsumerState<AddDeploymentMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {

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
