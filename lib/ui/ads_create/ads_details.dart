import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/create_ads/ads_details_controller.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/ads_create/web/ads_details_web.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:responsive_builder/responsive_builder.dart';


class AdsDetails extends ConsumerStatefulWidget {
  final String uuid;
  final String adsType;
  const AdsDetails({Key? key, required this.uuid, required this.adsType}) : super(key: key);

  @override
  ConsumerState<AdsDetails> createState() => _AdsDetailsState();
}

class _AdsDetailsState extends ConsumerState<AdsDetails> with WidgetsBindingObserver, ZoomAwareMixin{

  @override
  void initState() {
    final createAdWatch = ref.read(createAdsController);
    createAdWatch.disposeController();

    final adsDetailsRead = ref.read(adsDetailsController);
    adsDetailsRead.disposeController();
    if(widget.adsType == AdsType.Client.name){
      adsDetailsRead.clientAdsDetailState.isLoading = true;
    }
    else{
      adsDetailsRead.defaultAdsDetailState.isLoading = true;
    }
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      if(widget.adsType == AdsType.Client.name){
        adsDetailsRead.clientAdsDetailApi(context, widget.uuid);
      }
      else if(widget.adsType == AdsType.Default.name){
        adsDetailsRead.defaultAdsDetailApi(context, widget.uuid);
      }
    });
    super.initState();
  }
  
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return AdsDetailsWeb(uuid: widget.uuid, adsType: widget.adsType,);
        },
        tablet: (BuildContext context) {
          return AdsDetailsWeb(uuid: widget.uuid, adsType: widget.adsType,);
        },
        desktop: (BuildContext context) {
          return AdsDetailsWeb(uuid: widget.uuid, adsType: widget.adsType,);
        }
    );
  }
}

