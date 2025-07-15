import 'package:flutter/material.dart';
import 'package:odigov3/ui/destination_user_management/web/helper/destination_user_list_widget_web.dart';

class DestinationUserWeb extends StatelessWidget {
  const DestinationUserWeb({super.key});

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Listing
        Expanded(child: DestinationUsersListWidgetWeb()),
      ],
    );
  }
}
