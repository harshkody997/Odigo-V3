import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class StoreDetailMobile extends ConsumerStatefulWidget {
  const StoreDetailMobile({super.key});

  @override
  ConsumerState<StoreDetailMobile> createState() => _StoreDetailMobileState();
}

class _StoreDetailMobileState extends ConsumerState<StoreDetailMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final storeDetailWatch = ref.watch(storeDetailController);
      //storeDetailWatch.disposeController(isNotify : true);
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
