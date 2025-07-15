import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/auth/otp_verification_controller.dart';

class OtpVerificationMobile extends ConsumerStatefulWidget {
  const OtpVerificationMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<OtpVerificationMobile> createState() =>
      _OtpVerificationMobileState();
}

class _OtpVerificationMobileState extends ConsumerState<OtpVerificationMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final otpVerificationWatch = ref.read(otpVerificationController);
      //otpVerificationWatch.disposeController(isNotify : true);
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
