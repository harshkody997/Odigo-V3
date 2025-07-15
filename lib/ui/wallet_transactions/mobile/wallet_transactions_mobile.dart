import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/wallet_transactions/wallet_transactions_controller.dart';

class WalletTransactionsMobile extends ConsumerStatefulWidget {
  const WalletTransactionsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<WalletTransactionsMobile> createState() => _WalletTransactionsMobileState();
}

class _WalletTransactionsMobileState extends ConsumerState<WalletTransactionsMobile> {

  ///Init:- This method will trigger when widget will initialized.
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final walletTransactionsWatch = ref.watch(walletTransactionsController);
      //walletTransactionsWatch.disposeController(isNotify : true);
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
