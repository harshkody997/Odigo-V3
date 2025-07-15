import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/roles_permission/role_permission_details_controller.dart';

class RolePermissionDetailsMobile extends ConsumerStatefulWidget {
  const RolePermissionDetailsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<RolePermissionDetailsMobile> createState() =>
      _RolePermissionDetailsMobileState();
}

class _RolePermissionDetailsMobileState
    extends ConsumerState<RolePermissionDetailsMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final rolePermissionDetailsWatch = ref.watch(
          rolePermissionDetailsController);
      //rolePermissionDetailsWatch.disposeController(isNotify : true);
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
