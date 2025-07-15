import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/add_device_controller.dart';
import 'package:odigov3/framework/controller/device/device_details_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/device/web/helper/add_device_button_widget_web.dart';
import 'package:odigov3/ui/device/web/helper/add_device_details_widget_web.dart';
import 'package:odigov3/ui/device/web/helper/add_device_display_details_widget_web.dart';
import 'package:odigov3/ui/device/web/helper/add_device_senor_details_widget_web.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';

class AddEditDeviceWeb extends StatelessWidget {
  final String? deviceUuid;
  const AddEditDeviceWeb({super.key, this.deviceUuid});

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return  _bodyWidget();
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Consumer(
      builder: (context,ref,child) {
        final addDeviceWatch = ref.watch(addDeviceController);
        final deviceDetailsWatch = ref.watch(deviceDetailsController);
        return BaseDrawerPageWidget(
          isApiLoading: addDeviceWatch.addUpdateDeviceState.isLoading,
          body: deviceDetailsWatch.deviceDetailsState.isLoading  && deviceUuid != null?
        /// Loader
        Center(child: CommonAnimLoader()):
        /// Empty state
        deviceDetailsWatch.deviceDetailsState.success?.data == null  && deviceUuid != null?
        Center(child: CommonEmptyStateWidget(title: LocaleKeys.keySomeThingWentWrong.localized,)):
        /// Main widget
        Stack(
          children: [
            Form(
              key: addDeviceWatch.addDeviceFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Device details fields.
                    AddDeviceDetailsWidgetWeb(),

                    /// Sensor details
                    AddDeviceSenorDetailsWidgetWeb(),

                    /// Display details
                    AddDeviceDisplayDetailsWidgetWeb(deviceId:deviceUuid,),

                    /// Buttons
                    AddDeviceButtonWidgetWeb(deviceUuid:deviceUuid),

                  ],
                ),
              ),
            ),
            /// Loader on add/update api call
            addDeviceWatch.addUpdateDeviceState.isLoading?
            Container(color: AppColors.white.withValues(alpha: 0.8),child: CommonAnimLoader()) : Offstage()
          ],
        )
        );
      }
    );
  }
}

