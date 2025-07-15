import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DestinationTypeListMobile extends ConsumerStatefulWidget {
  const DestinationTypeListMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<DestinationTypeListMobile> createState() => _DestinationTypeListMobileState();
}

class _DestinationTypeListMobileState extends ConsumerState<DestinationTypeListMobile> {


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
