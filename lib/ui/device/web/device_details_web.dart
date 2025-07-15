import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/device_details_controller.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/device/web/helper/device_details_sensor_widget_web.dart';
import 'package:odigov3/ui/device/web/helper/device_details_top_left_widget_web.dart';
import 'package:odigov3/ui/device/web/helper/device_details_top_right_widget_web.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';

class DeviceDetailsWeb extends StatelessWidget {
  final String deviceId;
  const DeviceDetailsWeb({super.key,required this.deviceId});

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(
      body: _bodyWidget(),
    );
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Consumer(
      builder: (context,ref,child) {
        final deviceDetailsWatch = ref.watch(deviceDetailsController);
        return deviceDetailsWatch.deviceDetailsState.isLoading?
        Center(child: CommonAnimLoader()):Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Device details and display details
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 20,
                              child: DeviceDetailsTopLeftWidgetWeb()
                          ),
                          Spacer(),
                          Expanded(
                              flex: 20,
                              child: DeviceDetailsTopRightWidgetWeb()
                          ),
                        ],
                      ).paddingOnly(bottom: 20),
                    ),

                    /// Sensor
                    DeviceDetailsSensorWidgetWeb(),

                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
