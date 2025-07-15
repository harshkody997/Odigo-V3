import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/auth/reset_password_controller.dart';

class ResetPasswordMobile extends ConsumerStatefulWidget {
  const ResetPasswordMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<ResetPasswordMobile> createState() =>
      _ResetPasswordMobileState();
}

class _ResetPasswordMobileState extends ConsumerState<ResetPasswordMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final resetPasswordWatch = ref.read(resetPasswordController);
      //resetPasswordWatch.disposeController(isNotify : true);
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
