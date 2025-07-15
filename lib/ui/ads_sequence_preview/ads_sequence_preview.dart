import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_sequence_preview/ads_sequence_preview_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_details_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/ads_sequence_preview/web/ads_sequence_preview_web.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:responsive_builder/responsive_builder.dart';
class AdsSequencePreview extends ConsumerStatefulWidget {
  const AdsSequencePreview({Key? key}) : super(key: key);

  @override
  ConsumerState<AdsSequencePreview> createState() => _AdsSequencePreviewState();
}

class _AdsSequencePreviewState extends ConsumerState<AdsSequencePreview> with WidgetsBindingObserver, ZoomAwareMixin{
  @override
  void initState() {
    ref.read(destinationUserDetailsController).disposeController(isNotify: false);
    final adsSequencePreviewRead = ref.read(adsSequencePreviewController);
    adsSequencePreviewRead.disposeController(isNotify: false);
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
        if((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)){
          adsSequencePreviewRead.adsSequencePreviewListApi();
        }else{
          /// Destination list api call
          ref.read(destinationController).getDestinationListApi(context,isReset: true,pagination: false,activeRecords: true,);
        }

      });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return const AdsSequencePreviewWeb();
        },
        tablet: (BuildContext context) {
          return const AdsSequencePreviewWeb();
        },
        desktop: (BuildContext context) {
          return const AdsSequencePreviewWeb();
        }
    );
  }
}

