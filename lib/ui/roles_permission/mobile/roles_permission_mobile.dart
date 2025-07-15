import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/roles_permission/roles_permission_controller.dart';

class RolesPermissionMobile extends ConsumerStatefulWidget {
  const RolesPermissionMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<RolesPermissionMobile> createState() =>
      _RolesPermissionMobileState();
}

class _RolesPermissionMobileState extends ConsumerState<RolesPermissionMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final rolesPermissionWatch = ref.watch(rolesPermissionController);
      //rolesPermissionWatch.disposeController(isNotify : true);
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
