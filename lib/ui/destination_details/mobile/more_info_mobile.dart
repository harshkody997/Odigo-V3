import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class MoreInfoMobile extends ConsumerStatefulWidget {
  const MoreInfoMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<MoreInfoMobile> createState() => _MoreInfoMobileState();
}

class _MoreInfoMobileState extends ConsumerState<MoreInfoMobile> {


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
