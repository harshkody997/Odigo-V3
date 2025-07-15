import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/purchase/web/helper/purchase_details_widget.dart';
import 'package:odigov3/ui/purchase/web/helper/purchase_tab_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';

class PurchaseDetailsWeb extends ConsumerWidget {
  final String? purchaseUuid;
  const PurchaseDetailsWeb({super.key, this.purchaseUuid});

  ///Build Override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseDetailsWatch = ref.watch(purchaseDetailsController);

    return BaseDrawerPageWidget(
      body: purchaseDetailsWatch.purchaseDetailState.isLoading
        ? CommonAnimLoader()
        : Column(
        children: [
          ///Purchase Detail Widget(Name, Destination,Payment type ...)
          PurchaseDetailsWidget(),

          ///Purchase Tab Widget
          PurchaseTabWidget(purchaseUuid: purchaseUuid)
        ],
      ),
    );
  }
}
