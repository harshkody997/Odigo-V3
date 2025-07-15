import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/auth/forgot_password_controller.dart';

class ForgotPasswordMobile extends ConsumerStatefulWidget {
  const ForgotPasswordMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordMobile> createState() =>
      _ForgotPasswordMobileState();
}

class _ForgotPasswordMobileState extends ConsumerState<ForgotPasswordMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final forgotPasswordWatch = ref.read(forgotPasswordController);
      //forgotPasswordWatch.disposeController(isNotify : true);
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
