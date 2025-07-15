import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class DeploymentListMobile extends ConsumerStatefulWidget {
  const DeploymentListMobile({super.key});

  @override
  ConsumerState<DeploymentListMobile> createState() => _DeploymentListMobileState();
}

class _DeploymentListMobileState extends ConsumerState<DeploymentListMobile> {

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
