import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/deployment/deployment_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/store/add_edit_store_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/deployment/web/add_deployment_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddDeployment extends ConsumerStatefulWidget {
  const AddDeployment({super.key,});

  @override
  ConsumerState<AddDeployment> createState() => _AddDeploymentState();
}

class _AddDeploymentState extends ConsumerState<AddDeployment> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    final addEditStoreRead = ref.read(addEditStoreController);

    addEditStoreRead.disposeController();
    final destinationRead = ref.read(destinationController);
    destinationRead.disposeController();
    destinationRead.destinationListState.isLoading = true;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      destinationRead.getDestinationListApi(context, isReset: true);
      ref.watch(deploymentController).disposeDeployment();
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return AddDeploymentWeb();
      },
      tablet: (BuildContext context) {
        return AddDeploymentWeb();
      },
      desktop: (BuildContext context) {
        return AddDeploymentWeb();
      },
    );
  }
}

