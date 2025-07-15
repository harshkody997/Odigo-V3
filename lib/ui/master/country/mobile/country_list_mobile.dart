import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class CountryListMobile extends ConsumerStatefulWidget {
  const CountryListMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<CountryListMobile> createState() => _StateListMobileState();
}

class _StateListMobileState extends ConsumerState<CountryListMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final countryListWatch = ref.read(countryListController);
      //countryListWatch.disposeController(isNotify : true);
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
