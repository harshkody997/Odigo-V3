import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/assign_new_store/assign_new_store_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/device/device_controller.dart';
import 'package:odigov3/framework/controller/store/store_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/destination_details/web/destination_details_web.dart';

class DestinationDetails extends ConsumerStatefulWidget {
  final String destinationUuid;
  const DestinationDetails({Key? key,required this.destinationUuid}) : super(key: key);

  @override
  ConsumerState<DestinationDetails> createState() => _DestinationDetailsState();
}

class _DestinationDetailsState extends ConsumerState<DestinationDetails> with WidgetsBindingObserver, ZoomAwareMixin{


  @override
  void initState() {
    final destinationDetailRead = ref.read(destinationDetailsController);
    destinationDetailRead.disposeController(isNotify: true);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
     _getDataMethods();
    },);
    super.initState();
  }
  _getDataMethods() async {
    final destinationDetailRead = ref.read(destinationDetailsController);
    final storeRead = ref.read(storeController);
    final assignNewStoreRead = ref.read(assignNewStoreController);
    final deviceRead = ref.read(deviceController);

    storeRead.disposeStoreDestinationController();
    assignNewStoreRead.clearStoreAssignedList();
    deviceRead.disposeController(isNotify: true);

    destinationDetailRead.updateCurrentDestinationId(widget.destinationUuid);

    await destinationDetailRead.destinationDetailsApi(context, widget.destinationUuid);
    await destinationDetailRead.storeDestinationListApi(context);
    await destinationDetailRead.destinationPriceHistoryListApi(context);
    destinationDetailRead.floorListApi(context, widget.destinationUuid);


    await deviceRead.deviceListApi(false,destinationUuid: destinationDetailRead.currentDestinationUuid ?? '');

    // if(destinationDetailRead.storeListState.success?.status == ApiEndPoints.apiStatus_200){
    //   destinationDetailRead.storeList.forEach((element) {
    //     assignNewStoreRead.updateStoreList(StoreFloorModel(storeUuid: element?.uuid??'',floorNumber:element?.floorNumber.toString() ?? '0',storeName: element?.name ?? ''), context);
    //   },);
    // }
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return const DestinationDetailsWeb();
        },
        tablet: (BuildContext context) {
          return const DestinationDetailsWeb();
        },
        desktop: (BuildContext context) {
          return const DestinationDetailsWeb();
        }
    );
  }
}

