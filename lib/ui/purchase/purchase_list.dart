import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_list_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/purchase/mobile/purchase_list_mobile.dart';
import 'package:odigov3/ui/purchase/web/purchase_list_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PurchaseList extends ConsumerStatefulWidget {
  const PurchaseList({super.key});

  @override
  ConsumerState<PurchaseList> createState() => _PurchaseListState();
}

class _PurchaseListState extends ConsumerState<PurchaseList> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Init Override
  @override
  void initState() {
    final purchaseListRead = ref.read(purchaseListController);
    purchaseListRead.disposeController();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await purchaseListRead.purchaseListApi(false);
    });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const PurchaseListWeb();
      },
      tablet: (BuildContext context) {
        return const PurchaseListWeb();
      },
      desktop: (BuildContext context) {
        return const PurchaseListWeb();
      },
    );
  }
}
