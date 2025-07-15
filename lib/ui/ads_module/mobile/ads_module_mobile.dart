import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdsModuleMobile extends ConsumerStatefulWidget {
  const AdsModuleMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AdsModuleMobile> createState() => _AdsModuleMobileState();
}

class _AdsModuleMobileState extends ConsumerState<AdsModuleMobile> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Container();
  }
}
