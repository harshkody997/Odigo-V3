import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/roles_permission/web/helper/common_role_title_value_widget.dart';
import 'package:odigov3/ui/roles_permission/web/helper/common_view_role_permission_checkbox.dart';
import 'package:odigov3/ui/roles_permission/web/helper/role_permission_details_shimmer.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_check_box.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import '../../../framework/controller/roles_permission/role_permission_details_controller.dart';

class RolePermissionDetailsWeb extends ConsumerStatefulWidget {
  const RolePermissionDetailsWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<RolePermissionDetailsWeb> createState() => _RolePermissionDetailsWebState();
}

class _RolePermissionDetailsWebState extends ConsumerState<RolePermissionDetailsWeb> {

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final rolePermissionDetailsWatch = ref.watch(rolePermissionDetailsController);
    return BaseDrawerPageWidget(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            rolePermissionDetailsWatch.rolePermissionDetailsState.isLoading
            ? RolePermissionDetailsShimmer() :
            /// role name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                    title: rolePermissionDetailsWatch.rolePermissionDetails?.name ?? '-',
                    fontSize: 22,
                    fontWeight: TextStyles.fwSemiBold,
                ).paddingOnly(top: context.height * 0.03),

                /// roleId, createdAt, updatedAt
                Row(
                  children: [
                    CommonRoleTitleValueWidget(
                      title: LocaleKeys.keyRoleID.localized,
                      value: rolePermissionDetailsWatch.rolePermissionDetails?.uuid ?? '-',
                    ),

                    SizedBox(
                        height: context.height * 0.02,
                        child: VerticalDivider(color: AppColors.clrE0E0E0,).paddingSymmetric(horizontal: context.width * 0.01)),

                    CommonRoleTitleValueWidget(
                      title: LocaleKeys.keyCreated.localized,
                      value: formatDateDDMMYYY_HHMMA(rolePermissionDetailsWatch.rolePermissionDetails?.createdAt),
                    ),

                    SizedBox(
                        height: context.height * 0.02,
                        child: VerticalDivider(color: AppColors.clrE0E0E0,).paddingSymmetric(horizontal: context.width * 0.01)),

                    CommonRoleTitleValueWidget(
                      title: LocaleKeys.keyUpdated.localized,
                      value: formatDateDDMMYYY_HHMMA(rolePermissionDetailsWatch.rolePermissionDetails?.updatedAt),
                    ),
                  ],
                ).paddingOnly(top: context.height * 0.02,bottom: context.height * 0.04),
              ],
            ),

            /// permission list
            Expanded(
              child: CommonTableGenerator(
                  headerContent: [
                    CommonHeader(title: LocaleKeys.keyAccessTo.localized,flex: 5),
                    CommonHeader(title: LocaleKeys.keyViewAccess.localized,textAlign: TextAlign.end,flex: 2),
                    CommonHeader(title: LocaleKeys.keyCreateAccess.localized,textAlign: TextAlign.end,flex: 2),
                    CommonHeader(title: LocaleKeys.keyEditAccess.localized,textAlign: TextAlign.end,flex: 2),
                    CommonHeader(title: LocaleKeys.keyDeleteAccess.localized,textAlign: TextAlign.end,flex: 2),
                    CommonHeader(title: '')
                  ],
                  isLoading: rolePermissionDetailsWatch.rolePermissionDetailsState.isLoading,
                  childrenHeader: rolePermissionDetailsWatch.rolePermissionDetails?.moduleAndPermissionResponseDtOs ?? [],
                  childVerticalPadding: context.height * 0.01,
                  childrenContent: (index){
                    final item = rolePermissionDetailsWatch.rolePermissionDetails?.moduleAndPermissionResponseDtOs?[index];
                    return [
                      /// module name
                      CommonRow(title: item?.modulesName??'-',flex: 5),
                      CommonViewRolePermissionCheckbox(status:item?.canView), /// can view
                      CommonViewRolePermissionCheckbox(status:item?.canAdd),  /// can add
                      CommonViewRolePermissionCheckbox(status:item?.canEdit), /// can edit
                      CommonViewRolePermissionCheckbox(status:item?.canDelete), /// can delete
                      CommonHeader(title: '')
                    ];
                  },
                  onScrollListener: (){}
              ),
            )
            
            
          ],
        )
    );
  }


}
