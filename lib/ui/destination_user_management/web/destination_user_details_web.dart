import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_details_controller.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/destination_user_management/web/helper/destination_user_details_bottom_widget_web.dart';
import 'package:odigov3/ui/destination_user_management/web/helper/destination_user_details_top_widget_web.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';

class DestinationUserDetailsWeb extends StatelessWidget {
  const DestinationUserDetailsWeb({super.key});


  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(
      body: _bodyWidget(),
    );
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Consumer(
        builder: (context,ref,child) {
          final userWatch = ref.watch(destinationUserDetailsController);
          return userWatch.destinationUserDetailsState.isLoading?
          Center(child: CommonAnimLoader()):Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Top Widget
              DestinationUserDetailsTopWidgetWeb(),

              DottedLine(dashColor: AppColors.clrE4E4E4,).paddingSymmetric(vertical: 25),

              /// Bottom Widget
              DestinationUserDetailsBottomWidgetWeb(),

            ],
          ).paddingAll(15);
        }
      ),
    );
  }

}

