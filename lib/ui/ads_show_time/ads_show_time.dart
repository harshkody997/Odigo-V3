import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_shown_time/ads_shown_time_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_details_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/ads_show_time/web/ads_show_time_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AdsShowTime extends ConsumerStatefulWidget {
  const AdsShowTime({super.key});

  @override
  ConsumerState<AdsShowTime> createState() => _AdsShowTimeState();
}

class _AdsShowTimeState extends ConsumerState<AdsShowTime> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Init Override
  @override
  void initState() {
    ref.read(destinationUserDetailsController).disposeController(isNotify: false);
    final adsShownTimeRead = ref.read(adsShownTimeController);
    adsShownTimeRead.disposeController(isNotify: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      /// Destination list api call
      ref.read(destinationController).getDestinationListApi(context,isReset: true,pagination: false,activeRecords: true,);
    });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return AdsShowTimeWeb();
      },
      tablet: (BuildContext context) {
        return AdsShowTimeWeb();
      },
      desktop: (BuildContext context) {
        return AdsShowTimeWeb();
      },
    );
  }
}
