import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/purchase/add_purchase_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/purchase/web/add_purchase_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddPurchase extends ConsumerStatefulWidget {
  final String? clientUuid;
  const AddPurchase({super.key,this.clientUuid});

  @override
  ConsumerState<AddPurchase> createState() => _AddPurchaseState();
}

class _AddPurchaseState extends ConsumerState<AddPurchase> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    final addPurchaseRead = ref.read(addPurchaseController);
    addPurchaseRead.disposeController();

    final destinationWatch = ref.read(destinationController);
    destinationWatch.disposeController();
    destinationWatch.destinationListState.isLoading = true;

    final clientDetailsWatch = ref.read(clientDetailsController);
    clientDetailsWatch.disposeController();
    clientDetailsWatch.clientDetailsState.isLoading = true;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      addPurchaseRead.addValueInPartialPayment();
      destinationWatch.getDestinationListApi(context, activeRecords: true);
      if (widget.clientUuid != null) {
        clientDetailsWatch.clientDetailsApi(context, widget.clientUuid ?? '');
      }
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return AddPurchaseWeb(clientUuid: widget.clientUuid);
        },
        tablet: (BuildContext context) {
          return AddPurchaseWeb(clientUuid: widget.clientUuid);
        },
        desktop: (BuildContext context) {
          return AddPurchaseWeb(clientUuid: widget.clientUuid);
        },
    );
  }
}

