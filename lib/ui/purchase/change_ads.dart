import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client_ads/client_ads_controller.dart';
import 'package:odigov3/framework/controller/purchase/change_ads_controller.dart';
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/purchase/mobile/change_ads_mobile.dart';
import 'package:odigov3/ui/purchase/web/change_ads_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ChangeAds extends ConsumerStatefulWidget {
  final String? purchaseUuid;
  final String? clientUuid;

  const ChangeAds({super.key, this.purchaseUuid,this.clientUuid});

  @override
  ConsumerState<ChangeAds> createState() => _SelectAdsState();
}

class _SelectAdsState extends ConsumerState<ChangeAds> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Init Override
  @override
  void initState() {
    final changeAdsRead = ref.read(changeAdsController);
    final purchaseDetailsWatch = ref.read(purchaseDetailsController);
    final clientAdsRead = ref.read(clientAdsController);
    changeAdsRead.disposeController();

    clientAdsRead.disposeController();
    clientAdsRead.clientAdsListState.isLoading = true;

    purchaseDetailsWatch.disposeController();
    purchaseDetailsWatch.purchaseAdsState.isLoading=true;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await clientAdsRead.clientAdsListApi(context,odigoClientUuid: widget.clientUuid,activeRecords: true,status: 'ACTIVE');
      await purchaseDetailsWatch.purchaseAdsApi(purchaseUuid: widget.purchaseUuid,isOnChangeAds: true,clientAdsList: clientAdsRead.clientAdsList);
    });

    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return ChangeAdsWeb(purchaseUuid: widget.purchaseUuid);
      },
      tablet: (BuildContext context) {
        return ChangeAdsWeb(purchaseUuid: widget.purchaseUuid);
      },
      desktop: (BuildContext context) {
        return ChangeAdsWeb(purchaseUuid: widget.purchaseUuid);
      },
    );
  }
}
