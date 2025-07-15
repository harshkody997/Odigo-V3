import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/destination_user_management/add_edit_destination_user_controller.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_details_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/destination_user_management/web/helper/add_edit_destination_user_button_widget_web.dart';
import 'package:odigov3/ui/destination_user_management/web/helper/add_edit_destination_user_form_widget_web.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';


class AddEditDestinationUserWeb extends StatelessWidget {
  final String? userUuid;
  const AddEditDestinationUserWeb({super.key, this.userUuid});

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return  _bodyWidget();
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Consumer(
        builder: (context,ref,child) {
          final addEditUserDeviceWatch = ref.watch(addEditDestinationUserController);
          final userDetailWatch = ref.watch(destinationUserDetailsController);
          final destinationWatch = ref.watch(destinationController);
          return  BaseDrawerPageWidget(
            isApiLoading: addEditUserDeviceWatch.addUpdateUserState.isLoading,
            body: destinationWatch.destinationListState.isLoading || (userDetailWatch.destinationUserDetailsState.isLoading  && userUuid != null) ?
            /// Loader
            Center(child: CommonAnimLoader()):
            /// Empty state
            (destinationWatch.destinationList.isEmpty || ((userDetailWatch.destinationUserDetailsState.success?.data == null) && userUuid != null )) && (Session.getEntityType() == RoleType.SUPER_ADMIN.name || Session.getEntityType() == RoleType.USER.name)?
            Center(child: CommonEmptyStateWidget(title: LocaleKeys.keySomeThingWentWrong.localized,)):
            /// Main widget
            Stack(
              children: [
                Form(
                key: addEditUserDeviceWatch.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Form fields
                      AddEditDestinationUserFormWidgetWeb(userId: userUuid,),

                      /// Buttons
                      AddEditDestinationUserButtonWidgetWeb(userId:userUuid),
                    ],
                  ),
                ),
                          ),
                /// Loader on add/update api call
                addEditUserDeviceWatch.addUpdateUserState.isLoading?
                Container(color: AppColors.white.withValues(alpha: 0.8),child: CommonAnimLoader()) : Offstage()
              ],
            )
          );
        }
    );
  }
}

