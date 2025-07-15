import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ShowCmsMobile extends ConsumerStatefulWidget {
  const ShowCmsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<ShowCmsMobile> createState() => _ShowCmsMobileState();
}

class _ShowCmsMobileState extends ConsumerState<ShowCmsMobile> {


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
