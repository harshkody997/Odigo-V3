import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'mobile/otp_verification_mobile.dart';
import 'web/otp_verification_web.dart';



class OtpVerification extends ConsumerStatefulWidget {
  final String? email;

   OtpVerification({super.key,this.email});

  @override
  ConsumerState<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends ConsumerState<OtpVerification> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return OtpVerificationWeb(email: widget.email);
        },
        desktop: (BuildContext context) {
          return  OtpVerificationWeb(email: widget.email);
        },
        tablet: (BuildContext context) {
          return  OtpVerificationWeb(email: widget.email);
        }
    );
  }
}
