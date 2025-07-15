import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/purchase/mobile/purchase_details_mobile.dart';
import 'package:odigov3/ui/purchase/web/purchase_details_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PurchaseDetails extends ConsumerStatefulWidget {
  final String? purchaseUuid;
  const PurchaseDetails({super.key, this.purchaseUuid});

  @override
  ConsumerState<PurchaseDetails> createState() => _PurchaseDetailsState();
}

class _PurchaseDetailsState extends ConsumerState<PurchaseDetails> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Init Override
  @override
  void initState() {
    final purchaseDetailsRead = ref.read(purchaseDetailsController);
    purchaseDetailsRead.purchaseDetailState.isLoading = true;
    purchaseDetailsRead.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await purchaseDetailsRead.purchaseDetailApi(purchaseUuid: widget.purchaseUuid);
    });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return PurchaseDetailsWeb(purchaseUuid: widget.purchaseUuid);
      },
      tablet: (BuildContext context) {
        return PurchaseDetailsWeb(purchaseUuid: widget.purchaseUuid);
      },
      desktop: (BuildContext context) {
        return PurchaseDetailsWeb(purchaseUuid: widget.purchaseUuid);
      },
    );
  }
}
