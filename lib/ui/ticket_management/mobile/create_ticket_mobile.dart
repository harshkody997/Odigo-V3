import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class CreateTicketMobile extends ConsumerStatefulWidget {
  const CreateTicketMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateTicketMobile> createState() => _CreateTicketMobileState();
}

class _CreateTicketMobileState extends ConsumerState<CreateTicketMobile> {

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
    return Container();
  }


}
