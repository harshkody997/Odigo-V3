import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CmsMobile extends ConsumerStatefulWidget {
  const CmsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<CmsMobile> createState() => _CmsMobileState();
}

class _CmsMobileState extends ConsumerState<CmsMobile> {


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
