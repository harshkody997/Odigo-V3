import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class AddPurchaseMobile extends ConsumerStatefulWidget {
  const AddPurchaseMobile({super.key});

  @override
  ConsumerState<AddPurchaseMobile> createState() => _AddPurchaseMobileState();
}

class _AddPurchaseMobileState extends ConsumerState<AddPurchaseMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {

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
    return const Column(
      children: [],
    );
  }


}
