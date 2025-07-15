import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/controller/roles_permission/role_permission_details_controller.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/roles_permission/web/helper/add_edit_role_bottom_buttons_widget_web.dart';
import 'package:odigov3/ui/roles_permission/web/helper/add_edit_role_top_widget_web.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import '../../../framework/controller/roles_permission/add_edit_role_controller.dart';

class AddEditRoleWeb extends StatelessWidget {
  final String? roleUuid;
  const AddEditRoleWeb({super.key,this.roleUuid});

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(body: _bodyWidget());
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Consumer(
        builder: (context,ref,child) {
          final addEditRole = ref.watch(addEditRoleController);
          final roleDetailsWatch = ref.watch(rolePermissionDetailsController);
          return addEditRole.moduleListState.isLoading || (roleDetailsWatch.rolePermissionDetailsState.isLoading  && roleUuid != null)?
          /// Loader
          Center(child: CommonAnimLoader()):
          /// Empty state
          addEditRole.moduleList.isEmpty || (roleDetailsWatch.rolePermissionDetailsState.success?.data == null  && roleUuid != null)?
          Center(
              child:CommonEmptyStateWidget(title: LocaleKeys.keySomeThingWentWrong.localized,)
          )
          /// Main Widget
          :Form(
            key: addEditRole.formKey,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    title: roleUuid!= null?  LocaleKeys.keyEditRole.localized:LocaleKeys.keyAddRole.localized,
                    style: TextStyles.semiBold.copyWith(
                      color: AppColors.black,
                      fontSize: 16,
                    ),
                  ).paddingOnly(bottom: 15),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          /// Top Widget
                          AddEditRoleTopWidgetWeb(roleUuid:roleUuid).paddingOnly(bottom: 10),

                          /// Bottom Widget
                          AddEditRoleBottomButtonsWidgetWeb(roleUuid:roleUuid)
                        ],
                      ),
                    ),
                  ),
                ],
              ).paddingAll(10),
            ),
          );
        }
    );
  }
}
