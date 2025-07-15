import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class CityListMobile extends ConsumerStatefulWidget {
  const CityListMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<CityListMobile> createState() => _CityListMobileState();
}

class _CityListMobileState extends ConsumerState<CityListMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final cityListWatch = ref.read(cityListController);
      // cityListWatch.disposeController(isNotify : true);
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
