import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_module/ads_module_controller.dart';
import 'package:odigov3/framework/controller/client/client_list_controller.dart';
import 'package:odigov3/framework/controller/create_ads/ads_details_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/ads_create/web/create_ads_web.dart';

class CreateAds extends ConsumerStatefulWidget {
  final String? uuid;
  final bool isFromDetailsScreen;
  const CreateAds({Key? key, this.uuid, this.isFromDetailsScreen = false}) : super(key: key);

  @override
  ConsumerState<CreateAds> createState() => _CreateAdsState();
}

class _CreateAdsState extends ConsumerState<CreateAds> with WidgetsBindingObserver, ZoomAwareMixin{

  @override
  void initState() {
    final createAdWatch = ref.read(createAdsController);
    final destinationRead = ref.read(destinationController);
    final adsListRead = ref.read(adsModuleController);
    final clientListRead = ref.read(clientListController);
    final adsDetailsRead = ref.read(adsDetailsController);

    if(widget.isFromDetailsScreen != true){
      Session.clientUuid = '';
    }

    createAdWatch.disposeController();
    adsDetailsRead.disposeController();
    clientListRead.disposeController();
    destinationRead.disposeController();
    if(widget.uuid?.isNotEmpty ?? false) {
      adsDetailsRead.clientAdsDetailState.isLoading = true;
      adsDetailsRead.defaultAdsDetailState.isLoading = true;
    }
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      if (adsListRead.selectedTab != 0) {
        await destinationRead.getDestinationListApi(context, isReset: true);
      } else {
        await clientListRead.getClientListWithPaginationApiCall(context);
      }

      /// Ads Details API Call
      adsDetailsAPICall(context: context, ref: ref, uuid: widget.uuid);
      if(widget.uuid?.isNotEmpty ?? false) {
        adsDetailsRead.clientAdsDetailState.isLoading = false;
        adsDetailsRead.defaultAdsDetailState.isLoading = false;
      }
    });
    super.initState();
  }
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return CreateAdsWeb(uuid: widget.uuid);
        },
        tablet: (BuildContext context) {
          return CreateAdsWeb(uuid: widget.uuid);
        },
        desktop: (BuildContext context) {
          return CreateAdsWeb(uuid: widget.uuid);
        }
    );
  }
}

/// Ads Details API Call
void adsDetailsAPICall({required WidgetRef ref, required BuildContext context, String? uuid}) async {
  final createAdWatch = ref.read(createAdsController);
  final adsListRead = ref.read(adsModuleController);
  final adsDetailsRead = ref.read(adsDetailsController);

  if (uuid != null && uuid.isNotEmpty) {
    if (adsListRead.selectedTab == 0) {
      await adsDetailsRead.clientAdsDetailApi(context, uuid);
      final clientData = adsDetailsRead.clientAdsDetailState.success?.data;
      if (clientData != null) {
        createAdWatch.onAdContentDetails(clientAdsData: adsDetailsRead.clientAdsDetailState.success?.data);
        clientData.adsMediaType == 'IMAGE' ? createAdWatch.updateMediaIndex(0) : createAdWatch.updateMediaIndex(1);
      }
    } else if (adsListRead.selectedTab == 1) {
      await adsDetailsRead.defaultAdsDetailApi(context, uuid);
      final destinationData = adsDetailsRead.defaultAdsDetailState.success?.data;
      if (destinationData != null) {
        createAdWatch.onAdContentDetails(defaultAdsData: adsDetailsRead.defaultAdsDetailState.success?.data);
        destinationData.adsMediaType == 'IMAGE' ? createAdWatch.updateMediaIndex(0) : createAdWatch.updateMediaIndex(1);
      }
    }
  }
}