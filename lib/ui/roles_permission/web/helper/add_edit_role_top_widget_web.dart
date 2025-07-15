import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/roles_permission/add_edit_role_controller.dart';
import 'package:odigov3/framework/repository/role_permission/model/module_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_check_box.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class AddEditRoleTopWidgetWeb extends ConsumerWidget {
  final String? roleUuid;
  const AddEditRoleTopWidgetWeb({super.key,this.roleUuid});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final addEditRoleWatch = ref.watch(addEditRoleController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Name
        CommonInputFormField(
          textEditingController: addEditRoleWatch.nameCtr,
          focusNode: addEditRoleWatch.nameFocus,
          hintText: LocaleKeys.keyEnterRoleName.localized,
          onFieldSubmitted: (value){
            addEditRoleWatch.descriptionFocus.requestFocus();
          },
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.next,
          textInputFormatter: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z/ ]')),
          ],
          validator: (value){
            return validateText(value, LocaleKeys.keyPleaseEnterName.localized);
          },
          maxLength: 40,
        ).paddingOnly(bottom: 20,top: 5),

        /// Description
        CommonInputFormField(
          textEditingController: addEditRoleWatch.descriptionCtr,
          focusNode: addEditRoleWatch.descriptionFocus,
          hintText: LocaleKeys.keyDescription.localized,
          onFieldSubmitted: (value){
            //addEditRoleWatch.descriptionFocus.requestFocus();
          },
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textInputFormatter: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z/ .]')),
          ],
          validator: (value){
            return validateText(value, LocaleKeys.keyMessageMustBeRequired.localized);
          },
          maxLength: AppConstants.maxDescriptionLength,
        ).paddingOnly(bottom: 20,),


        /// Permission Table
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.clrEAECF0, width: 1),
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.6), blurRadius: 2, offset: Offset(0, 1)),
              BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.1), blurRadius: 3, offset: Offset(0, 1)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// header
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {

                  /// Select All
                  0: FlexColumnWidth(1.5),

                  /// Access to
                  1: FlexColumnWidth(3.3),

                  /// View Access
                  2: FlexColumnWidth(2),

                  /// Create Access
                  3: FlexColumnWidth(2),

                  /// Edit Access
                  4: FlexColumnWidth(2),

                  /// Delete Access
                  5: FlexColumnWidth(2),

                },
                children: [
                  TableRow(
                    children: [
                      Row(
                        children: [
                        CommonCheckBox(
                            checkValue: addEditRoleWatch.isAllModulesSelected,
                            onChanged: (val){
                              addEditRoleWatch.updateAllModulesSelection(val??false);
                            },
                        ),
                        CommonText(
                          title: LocaleKeys.keySelectAll.localized,
                          style: TextStyles.medium.copyWith(
                            fontSize: 12,
                            color: AppColors.clr667085,
                          ),
                        ),
                      ],
                      ),
                      CommonText(
                      title: LocaleKeys.keyAccessTo.localized,
                      style: TextStyles.medium.copyWith(
                        fontSize: 12,
                        color: AppColors.clr667085,
                      ),
                    ),
                      CommonText(
                      title: '${LocaleKeys.keyView.localized} ${LocaleKeys.keyAccess.localized}',
                      textAlign: TextAlign.center,
                      style: TextStyles.medium.copyWith(
                        fontSize: 12,
                        color: AppColors.clr667085,
                      ),
                    ),
                      CommonText(
                      title: '${LocaleKeys.keyCreate.localized} ${LocaleKeys.keyAccess.localized}',
                        textAlign: TextAlign.center,
                        style: TextStyles.medium.copyWith(
                        fontSize: 12,
                        color: AppColors.clr667085,
                      ),
                    ),
                      CommonText(
                      title: '${LocaleKeys.keyEdit.localized} ${LocaleKeys.keyAccess.localized}',
                        textAlign: TextAlign.center,
                        style: TextStyles.medium.copyWith(
                        fontSize: 12,
                        color: AppColors.clr667085,
                      ),
                    ),
                      CommonText(
                      title: '${LocaleKeys.keyDelete.localized} ${LocaleKeys.keyAccess.localized}',
                        textAlign: TextAlign.center,
                        style: TextStyles.medium.copyWith(
                        fontSize: 12,
                        color: AppColors.clr667085,
                      ),
                    ),
                    ],
                  ),
                ],
              ).paddingOnly(left: 10,right: 10,),
              Divider(color: AppColors.clrEAECF0,height: 0,),

              /// body
              ListView.separated(
                  shrinkWrap: true,
                  itemCount: (addEditRoleWatch.moduleList.length),
                  itemBuilder: (context, index) {
                    ModuleModel moduleData = addEditRoleWatch.moduleList[index];
                    return Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        /// Select All
                        0: FlexColumnWidth(1.5),

                        /// Access to
                        1: FlexColumnWidth(3.3),

                        /// View Access
                        2: FlexColumnWidth(2),

                        /// Create Access
                        3: FlexColumnWidth(2),

                        /// Edit Access
                        4: FlexColumnWidth(2),

                        /// Delete Access
                        5: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                            children: [
                              /// Select All
                              Row(
                                children: [
                                  CommonCheckBox(
                                    checkValue: moduleData.isSelectedAll??false,
                                    isDisable:moduleData.nameEnglish == 'Dashboard',
                                    onChanged: (val) async{
                                      addEditRoleWatch.actionOnRequiredModules(index);
                                      final isDisabled = await addEditRoleWatch.checkDependency(index);
                                      if(isDisabled && !(val??false)){
                                        showToast(context: context,isSuccess: false,message: '${moduleData.name} ${LocaleKeys.keyModuleDependencyMsg.localized}');
                                      }else{
                                        if (moduleData.nameEnglish != 'Dashboard') {
                                          addEditRoleWatch.setPermissionData(index: index,selectAll: val);
                                        }
                                      }
                                    },
                                  ),
                                  CommonText(
                                    title:'',
                                    style: TextStyles.medium.copyWith(
                                      fontSize: 12,
                                      color: AppColors.clr667085,
                                    ),
                                  ),
                                ],
                              ),
                              /// Access To
                              CommonText(
                                title: moduleData.name??'',
                                style: TextStyles.medium.copyWith(
                                  color: AppColors.clr101828,
                                  fontSize: 14,
                                ),
                              ),
                              /// View PERMISSION
                              Center(
                                child: CommonCheckBox(
                                  checkValue:moduleData.canView??false ,
                                  isDisable:moduleData.nameEnglish == 'Dashboard',
                                  onChanged: (val)async{
                                    addEditRoleWatch.actionOnRequiredModules(index);
                                    final isDisabled = await addEditRoleWatch.checkDependency(index);
                                    if(isDisabled && !(val??false)){
                                      showToast(context: context,isSuccess: false,message: '${moduleData.name} is dependent on other modules');
                                    }else{
                                      if (moduleData.nameEnglish != 'Dashboard') {
                                        addEditRoleWatch.setPermissionData(index: index,view: val);
                                      }
                                    }

                                  },
                                ),
                              ),
                          /// Add PERMISSION
                              Center(
                                child: CommonCheckBox(
                                  isDisable:moduleData.nameEnglish == 'Dashboard',
                                  checkValue:moduleData.canAdd??false ,
                                  onChanged: (val){
                                    addEditRoleWatch.actionOnRequiredModules(index);
                                    if(moduleData.nameEnglish != 'Dashboard'){
                                      addEditRoleWatch.setPermissionData(index: index,create: val);
                                    }
                                  },
                                ),
                              ),
                              /// Edit Permission
                              Center(
                                child: CommonCheckBox(
                                  isDisable:moduleData.nameEnglish == 'Dashboard',
                                  checkValue:moduleData.canEdit??false ,
                                  onChanged: (val){
                                    addEditRoleWatch.actionOnRequiredModules(index);
                                    if(moduleData.nameEnglish != 'Dashboard'){
                                      addEditRoleWatch.setPermissionData(index: index,edit: val);
                                    }
                                  },
                                ),
                              ),

                              Center(
                                child: CommonCheckBox(
                                  isDisable:moduleData.nameEnglish == 'Dashboard',
                                  checkValue:moduleData.canDelete??false ,
                                  onChanged: (val){
                                    addEditRoleWatch.actionOnRequiredModules(index);
                                    if(moduleData.nameEnglish != 'Dashboard'){
                                      addEditRoleWatch.setPermissionData(index: index,delete: val);
                                    }
                                  },
                                ),
                              ),
                            ],
                        ),
                      ],
                    ).paddingOnly(left: 10,right: 10,);
                  },
                  separatorBuilder: (context,index){
                    return index != addEditRoleWatch.moduleList.length? Divider(color: AppColors.clrEAECF0,height: 2,):const Offstage();
                  },
                  ),
            ],
          ),
        ),
      ],
    );
  }
}