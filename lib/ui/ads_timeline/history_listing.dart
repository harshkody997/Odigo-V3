import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_timline/history_listing_controller.dart';
import 'package:odigov3/framework/controller/client/client_list_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/ads_timeline/web/history_listing_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HistoryListing extends ConsumerStatefulWidget {
  const HistoryListing({super.key});

  @override
  ConsumerState<HistoryListing> createState() => _HistoryListingState();
}

class _HistoryListingState extends ConsumerState<HistoryListing> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Init Override
  @override
  void initState() {
    final destinationRead = ref.read(destinationController);
    final historyListingRead = ref.read(historyListingController);
    final clientRead = ref.read(clientListController);
    historyListingRead.disposeController();
    destinationRead.disposeController();
    clientRead.disposeController();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await destinationRead.getDestinationListApi(context, isReset: true);
      await clientRead.getClientApi(context);
    });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const HistoryListingWeb();
      },
      tablet: (BuildContext context) {
        return const HistoryListingWeb();
      },
      desktop: (BuildContext context) {
        return const HistoryListingWeb();
      },
    );
  }
}
