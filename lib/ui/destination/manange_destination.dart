import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/destination/manage_destination_controller.dart';
import 'package:odigov3/framework/controller/master/city/city_list_controller.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/controller/master/destination_type/destination_type_list_controller.dart';
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/destination/mobile/destination_mobile.dart';
import 'package:odigov3/ui/destination/web/destination_web.dart';
import 'package:odigov3/ui/destination/web/manage_destination_web.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ManageDestination extends ConsumerStatefulWidget {
  final String? destinationUuid;

  const ManageDestination({Key? key, this.destinationUuid}) : super(key: key);

  @override
  ConsumerState<ManageDestination> createState() => _ManageDestinationState();
}

class _ManageDestinationState extends ConsumerState<ManageDestination> with WidgetsBindingObserver, ZoomAwareMixin {
  @override
  void initState() {
    final manageDestinationWatch = ref.read(manageDestinationController);
    manageDestinationWatch.disposeController();
    ref.read(stateListController).disposeController();
    ref.read(countryListController).disposeController();
    ref.read(destinationTypeListController).disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      manageDestinationWatch.getLanguageListModel(false);
      manageDestinationWatch.destinationDetailsState.success = null;
      if (widget.destinationUuid != null) {
        await manageDestinationWatch.destinationDetailsApi(context, widget.destinationUuid!);
      }
      await ref.read(countryListController).getCountryListAPI(context, activeRecords: true);
      await ref.read(destinationTypeListController).getDestinationTypeListAPI(context, activeRecords: true);
      await ref.read(countryListController).getCountryTimezoneListAPI(context);
      if ((manageDestinationWatch.destinationDetailsState.success?.data) != null) {
        manageDestinationWatch.fillDataOnDetails(context, manageDestinationWatch.destinationDetailsState.success!.data!);
      }
    });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      desktop: (BuildContext context) {
        return const ManageDestinationWeb();
      },
      mobile: (BuildContext context) {
        return const ManageDestinationWeb();
      },
      tablet: (BuildContext context) {
        return const ManageDestinationWeb();
      },
    );
  }
}
