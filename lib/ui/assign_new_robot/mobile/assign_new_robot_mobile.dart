import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/assign_new_robot/assign_new_robot_controller.dart';

class AssignNewRobotMobile extends ConsumerStatefulWidget {
  const AssignNewRobotMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AssignNewRobotMobile> createState() => _AssignNewRobotMobileState();
}

class _AssignNewRobotMobileState extends ConsumerState<AssignNewRobotMobile> {

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
