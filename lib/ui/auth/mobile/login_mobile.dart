import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class LoginMobile extends ConsumerStatefulWidget {
  const LoginMobile({super.key});

  @override
  ConsumerState<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends ConsumerState<LoginMobile> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Container(color: AppColors.red);
  }
}
