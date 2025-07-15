import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/controller/client_ads/client_ads_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/client/web/client_details_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ClientDetails extends ConsumerStatefulWidget {
  final String? clientUuid;

  const ClientDetails({Key? key, this.clientUuid}) : super(key: key);

  @override
  ConsumerState<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends ConsumerState<ClientDetails> with WidgetsBindingObserver, ZoomAwareMixin {
  /// Init override
  @override
  void initState() {
    super.initState();
    final clientAdsRead = ref.read(clientAdsController);
    final clientDetailsWatch = ref.read(clientDetailsController);
    clientDetailsWatch.disposeController();
    clientAdsRead.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp)  {
      SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
      if (selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {
        clientAdsRead.clientAdsListApi(context, odigoClientUuid: widget.clientUuid ?? '');
        if (widget.clientUuid != null) {
          clientDetailsWatch.clientDetailsApi(context, widget.clientUuid ?? '');
        }
      }
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return ClientDetailsWeb(clientUuid: widget.clientUuid);
      },
      tablet: (BuildContext context) {
        return ClientDetailsWeb(clientUuid: widget.clientUuid);
      },
      desktop: (BuildContext context) {
        return ClientDetailsWeb(clientUuid: widget.clientUuid);
      },
    );
  }
}
