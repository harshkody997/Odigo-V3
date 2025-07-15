import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class SplashMobile extends ConsumerStatefulWidget {
  const SplashMobile({super.key});

  @override
  ConsumerState<SplashMobile> createState() => _SplashMobileState();
}

class _SplashMobileState extends ConsumerState<SplashMobile> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Container(color: AppColors.white);
  }
}
