import 'package:flutter/material.dart';
import 'package:odigov3/ui/device/web/helper/device_list_widget_web.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class DeviceWeb extends StatelessWidget {
  const DeviceWeb({super.key});

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Listing
        Expanded(child: DeviceListWidgetWeb()),
      ],
    );
  }
}

