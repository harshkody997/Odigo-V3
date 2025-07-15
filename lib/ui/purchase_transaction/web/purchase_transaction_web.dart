import 'package:flutter/material.dart';
import 'package:odigov3/ui/purchase_transaction/web/helper/purchase_transaction_list_widget_web.dart';

class PurchaseTransactionWeb extends StatelessWidget {
  const PurchaseTransactionWeb({super.key});

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Listing
        Expanded(child: PurchaseTransactionListWidgetWeb()),
      ],
    );
  }
}
