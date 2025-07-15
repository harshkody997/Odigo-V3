import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdsDetailsMobile extends ConsumerStatefulWidget {
  const AdsDetailsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AdsDetailsMobile> createState() => _AdsDetailsMobileState();
}

class _AdsDetailsMobileState extends ConsumerState<AdsDetailsMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
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
