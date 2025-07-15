import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client_ads/client_ads_controller.dart';
import 'package:odigov3/framework/controller/purchase/change_ads_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/purchase/mobile/select_ads_mobile.dart';
import 'package:odigov3/ui/purchase/web/select_ads_web.dart';

class SelectAds extends ConsumerStatefulWidget {
  final String? clientUuid;
  const SelectAds({super.key,this.clientUuid});

  @override
  ConsumerState<SelectAds> createState() => _SelectAdsState();
}

class _SelectAdsState extends ConsumerState<SelectAds> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Init Override
  @override
  void initState() {
    final changeAdsRead = ref.read(changeAdsController);
    final clientAdsRead = ref.read(clientAdsController);
    changeAdsRead.disposeController();
    clientAdsRead.clientAdsListState.isLoading = true;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await clientAdsRead.clientAdsListApi(context,odigoClientUuid: widget.clientUuid,activeRecords: true,status: 'ACTIVE');
    });

    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return SelectAdsWeb(clientUuid: widget.clientUuid);
      },
      tablet: (BuildContext context) {
        return SelectAdsWeb(clientUuid: widget.clientUuid);
      },
      desktop: (BuildContext context) {
        return SelectAdsWeb(clientUuid: widget.clientUuid);
      },
    );
  }
}
