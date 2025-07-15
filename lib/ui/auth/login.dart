import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/auth/mobile/login_mobile.dart';
import 'package:odigov3/ui/auth/web/login_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const LoginWeb();
      },
      desktop: (BuildContext context) {
        return const LoginWeb();
      },
      tablet: (BuildContext context) {
        return const LoginWeb();
      },
    );
  }
}
