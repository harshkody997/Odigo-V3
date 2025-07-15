import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/store_mapping/store_mapping_controller.dart';

class StoreMappingMobile extends ConsumerStatefulWidget {
  const StoreMappingMobile({super.key});

  @override
  ConsumerState<StoreMappingMobile> createState() => _StoreMappingMobileState();
}

class _StoreMappingMobileState extends ConsumerState<StoreMappingMobile> {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final storeMappingWatch = ref.watch(storeMappingController);
      //storeMappingWatch.disposeController(isNotify : true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
