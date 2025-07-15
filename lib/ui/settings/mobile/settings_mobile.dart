import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class SettingsMobile extends ConsumerStatefulWidget {
  const SettingsMobile({super.key});

  @override
  ConsumerState<SettingsMobile> createState() => _SettingsMobileState();
}

class _SettingsMobileState extends ConsumerState<SettingsMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final settingsWatch = ref.watch(settingsController);
      //settingsWatch.disposeController(isNotify : true);
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
