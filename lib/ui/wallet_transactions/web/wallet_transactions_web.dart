import 'package:flutter/material.dart';
import 'package:odigov3/ui/wallet_transactions/web/helper/wallet_transactions_list_widget_web.dart';

class WalletTransactionsWeb extends StatelessWidget {
  const WalletTransactionsWeb({super.key});

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
        Expanded(child: WalletTransactionsListWidgetWeb()),
      ],
    );
  }
}
