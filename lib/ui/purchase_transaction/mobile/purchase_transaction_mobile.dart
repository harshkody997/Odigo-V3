import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/purchase_transaction/purchase_transaction_controller.dart';

class PurchaseTransactionMobile extends ConsumerStatefulWidget {
  const PurchaseTransactionMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<PurchaseTransactionMobile> createState() => _PurchaseTransactionMobileState();
}

class _PurchaseTransactionMobileState extends ConsumerState<PurchaseTransactionMobile> {

  ///Init:- This method will trigger when widget will initialized.
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final purchaseTransactionWatch = ref.watch(purchaseTransactionController);
      //purchaseTransactionWatch.disposeController(isNotify : true);
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
