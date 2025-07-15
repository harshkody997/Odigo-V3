import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/store/store_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/framework/controller/assign_new_store/assign_new_store_controller.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/assign_new_store/web/assign_new_store_web.dart';

class AssignNewStore extends ConsumerStatefulWidget {
  const AssignNewStore({Key? key}) : super(key: key);

  @override
  ConsumerState<AssignNewStore> createState() => _AssignNewStoreState();
}

class _AssignNewStoreState extends ConsumerState<AssignNewStore>  with WidgetsBindingObserver, ZoomAwareMixin{


  @override
  void initState() {

    final assignStoreRead = ref.read(assignNewStoreController);
    assignStoreRead.disposeController();

    final storeRead = ref.read(storeController);
    storeRead.storeListState.isLoading = true;

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final destinationDetailsRead = ref.read(destinationDetailsController);

      destinationDetailsRead.storeList.forEach((element) {
        assignStoreRead.updateStoreList(StoreFloorModel(storeUuid: element?.uuid??'',floorNumber:element?.floorNumber.toString() ?? '0',storeName: element?.name ?? ''), context);
      },);

      storeRead.disposeStoreDestinationController();
      await storeRead.storeListApi(context,isForPagination: false,);
      await storeRead.generateFloorList(destinationDetailsRead.destinationDetailsState.success?.data?.totalFloor.toString()??'0').then((value) {
        assignStoreRead.updateFloorList(value);
      },);
    });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return const AssignNewStoreWeb();
        },
        tablet: (BuildContext context) {
          return const AssignNewStoreWeb();
        },
        desktop: (BuildContext context) {
          return const AssignNewStoreWeb();
        }
    );
  }
}

