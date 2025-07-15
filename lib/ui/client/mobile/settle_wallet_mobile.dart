import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/client/settle_wallet_controller.dart';

class SettleWalletMobile extends ConsumerStatefulWidget {
  const SettleWalletMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<SettleWalletMobile> createState() => _SettleWalletMobileState();
}

class _SettleWalletMobileState extends ConsumerState<SettleWalletMobile> {

  ///Init:- This method will trigger when widget will initialized.
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final settleWalletWatch = ref.watch(settleWalletController);
      //settleWalletWatch.disposeController(isNotify : true);
    });
  }

  ///Dispose:- This method will trigger when widget about to remove from navigation stack.
  @override
  void dispose() {
    super.dispose();
  }

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Container();
  }


}
