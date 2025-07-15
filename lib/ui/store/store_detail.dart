import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/store/store_detail_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/store/mobile/store_detail_mobile.dart';
import 'package:odigov3/ui/store/web/store_detail_web.dart';

class StoreDetail extends ConsumerStatefulWidget {
  final String storeUuid;
  const StoreDetail({super.key, required this.storeUuid});

  @override
  ConsumerState<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends ConsumerState<StoreDetail> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    if(selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {
      final storeDetailRead = ref.read(storeDetailController);
      storeDetailRead.disposeController();
      final destinationRead = ref.read(destinationController);
      destinationRead.destinationListState.isLoading = true;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        storeDetailRead.storeLanguageDetailApi(context, widget.storeUuid);
        destinationRead.getDestinationListApi(context, isReset: true, storeUuid: widget.storeUuid);
      });
    }
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return StoreDetailWeb(storeUuid: widget.storeUuid);
        },
        tablet: (BuildContext context) {
          return StoreDetailWeb(storeUuid: widget.storeUuid);
        },
        desktop: (BuildContext context) {
          return StoreDetailWeb(storeUuid: widget.storeUuid);
        },
    );
  }
}

