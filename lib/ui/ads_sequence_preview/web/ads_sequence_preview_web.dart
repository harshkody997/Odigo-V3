import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_sequence_preview/ads_sequence_preview_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/destination_user_management/add_edit_destination_user_controller.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_details_controller.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/ads_sequence_preview/web/helper/ads_sequence_preview_bottom_widget.dart';
import 'package:odigov3/ui/ads_sequence_preview/web/helper/ads_sequence_preview_top_widget.dart';
import 'package:odigov3/ui/destination_user_management/web/helper/add_edit_destination_user_button_widget_web.dart';
import 'package:odigov3/ui/destination_user_management/web/helper/add_edit_destination_user_form_widget_web.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';


class AdsSequencePreviewWeb extends StatelessWidget {
  const AdsSequencePreviewWeb({super.key});

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return  _bodyWidget();
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Consumer(
        builder: (context,ref,child) {
          final adsSequencePreviewWatch = ref.watch(adsSequencePreviewController);
          final destinationWatch = ref.watch(destinationController);
          return  BaseDrawerPageWidget(
              isApiLoading: adsSequencePreviewWatch.updateSequenceState.isLoading,
              body: destinationWatch.destinationListState.isLoading?
              /// Loader
              Center(child: CommonAnimLoader()):
              /// Empty state
              destinationWatch.destinationList.isEmpty && (Session.getEntityType() == RoleType.SUPER_ADMIN.name || Session.getEntityType() == RoleType.USER.name)?
              Center(child: CommonEmptyStateWidget(title: LocaleKeys.keySomeThingWentWrong.localized,)):
              /// Main widget
              (Session.getEntityType() == RoleType.SUPER_ADMIN.name || Session.getEntityType() == RoleType.USER.name)? Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          /// Top Widget
                          AdsSequencePreviewTopWidget(),
                          /// Bottom Widget
                          Expanded(child: AdsSequencePreviewBottomWidget()),
                        ],
                      ).paddingAll(20),
                  ),
                  /// Loader on update api call
                  adsSequencePreviewWatch.updateSequenceState.isLoading?
                  Container(color: AppColors.white.withValues(alpha: 0.8),child: CommonAnimLoader()) : Offstage()
                ],
              ):AdsSequencePreviewBottomWidget(),
          );
        }
    );
  }
}

