import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/create_purchase_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/purchase/mobile/purchase_mobile.dart';
import 'package:odigov3/ui/purchase/web/purchase_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Purchase extends ConsumerStatefulWidget {
  const Purchase({super.key});

  @override
  ConsumerState<Purchase> createState() => _CreatePurchaseState();
}

class _CreatePurchaseState extends ConsumerState<Purchase> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Init Override
  @override
  void initState() {
    final createPurchaseRead = ref.read(createPurchaseController);
    createPurchaseRead.disposeController(isNotify: true);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {});
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const PurchaseWeb();
      },
      tablet: (BuildContext context) {
        return const PurchaseWeb();
      },
      desktop: (BuildContext context) {
        return const PurchaseWeb();
      },
    );
  }
}
