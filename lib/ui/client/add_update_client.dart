import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/add_update_client_controller.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/repository/client/model/response/client_details_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/client/web/add_update_client_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddUpdateClient extends ConsumerStatefulWidget {
  final Function? popCallBack;
  final String? clientUUid;

  const AddUpdateClient({super.key, this.popCallBack, this.clientUUid});

  @override
  ConsumerState<AddUpdateClient> createState() => _AddUpdateClientState();
}

class _AddUpdateClientState extends ConsumerState<AddUpdateClient> with WidgetsBindingObserver, ZoomAwareMixin {
  /// Init override
  @override
  void initState() {
    super.initState();
    final addUpdateClientWatch = ref.read(addUpdateClientController);
    addUpdateClientWatch.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
      if (selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {
        final clientDetailsWatch = ref.read(clientDetailsController);
        final countryListWatch = ref.read(countryListController);
        countryListWatch.disposeController(isNotify: true);
        clientDetailsWatch.disposeController(isNotify: true);
        await countryListWatch.getCountryListAPI(context, activeRecords: true);
        if (widget.clientUUid != null) {
          addUpdateClientWatch.changeIsAddMoreVisibility(isAddMore: true);
          await clientDetailsWatch.clientDetailsApi(context, widget.clientUUid ?? '');
          await addUpdateClientWatch.getDocumentImageByUuidApi(context, widget.clientUUid ?? '');
        }

        if ((clientDetailsWatch.clientDetailsState.success?.data) != null) {
          await addUpdateClientWatch.fillDataOnDetails(context, clientDetailsWatch.clientDetailsState.success?.data ?? ClientDetailsData());
        }
      }
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return AddUpdateClientWeb(popCallBack: widget.popCallBack, clientUuid: widget.clientUUid);
      },
      tablet: (BuildContext context) {
        return AddUpdateClientWeb(popCallBack: widget.popCallBack, clientUuid: widget.clientUUid);
      },
      desktop: (BuildContext context) {
        return AddUpdateClientWeb(popCallBack: widget.popCallBack, clientUuid: widget.clientUUid);
      },
    );
  }
}
