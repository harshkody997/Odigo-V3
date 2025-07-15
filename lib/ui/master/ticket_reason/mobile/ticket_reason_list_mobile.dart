import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class TicketReasonListMobile extends ConsumerStatefulWidget {
  const TicketReasonListMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<TicketReasonListMobile> createState() => _StateListMobileState();
}

class _StateListMobileState extends ConsumerState<TicketReasonListMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final ticketReasonListWatch = ref.read(ticketReasonListController);
      // ticketReasonListWatch.disposeController(isNotify : true);
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
