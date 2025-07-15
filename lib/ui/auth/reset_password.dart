import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'mobile/reset_password_mobile.dart';
import 'web/reset_password_web.dart';


class ResetPassword extends ConsumerStatefulWidget {
  String? email;
  String? otp;
   ResetPassword({super.key,this.email,this.otp});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return ResetPasswordWeb(email: widget.email,otp: widget.otp,);
        },
        desktop: (BuildContext context) {
          return  ResetPasswordWeb(email: widget.email,otp: widget.otp,);
        },
        tablet: (BuildContext context) {
          return  ResetPasswordWeb(email: widget.email,otp: widget.otp,);
        }
    );
  }
}
