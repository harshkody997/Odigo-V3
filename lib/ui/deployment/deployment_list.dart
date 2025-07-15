import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/deployment/deployment_controller.dart';
import 'package:odigov3/framework/controller/store/store_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/deployment/web/deployment_list_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DeploymentList extends ConsumerStatefulWidget {
  const DeploymentList({super.key});

  @override
  ConsumerState<DeploymentList> createState() => _DeploymentListState();
}

class _DeploymentListState extends ConsumerState<DeploymentList> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    final deploymentRead = ref.read(deploymentController);
    deploymentRead.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      deploymentRead.deploymentListApi(context);
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const DeploymentListWeb();
      },
      tablet: (BuildContext context) {
        return const DeploymentListWeb();
      },
      desktop: (BuildContext context) {
        return const DeploymentListWeb();
      },
    );
  }
}

