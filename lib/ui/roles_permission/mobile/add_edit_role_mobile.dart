import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/roles_permission/add_edit_role_controller.dart';

class AddRoleMobile extends ConsumerStatefulWidget {
  const AddRoleMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AddRoleMobile> createState() => _AddRoleMobileState();
}

class _AddRoleMobileState extends ConsumerState<AddRoleMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final addRoleWatch = ref.watch(addEditRoleController);
      //addRoleWatch.disposeController(isNotify : true);
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
