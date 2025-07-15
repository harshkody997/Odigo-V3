import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/role_permission/contract/role_permission_repository.dart';
import 'package:odigov3/framework/repository/role_permission/model/add_update_role_request_model.dart';
import 'package:odigov3/framework/repository/role_permission/model/module_list_response_model.dart';
import 'package:odigov3/framework/repository/role_permission/model/role_permission_details_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';


final addEditRoleController = ChangeNotifierProvider(
      (ref) => getIt<AddEditRoleController>(),
);

@injectable
class AddEditRoleController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool? isNotify}) {
    nameCtr.clear();
    descriptionCtr.clear();
    moduleListState.isLoading = true;
    moduleListState.success = null;
    moduleList.clear();
    modulesPermissionData.clear();
    addUpdateRoleState.isLoading = false;
    addUpdateRoleState.success = null;
    Future.delayed(const Duration(milliseconds: 50), () {
      formKey.currentState?.reset();
    });
    if (isNotify??false) {
      notifyListeners();
    }
  }

  /// Module list
  List<ModuleModel> moduleList = [];

  /// Module Permission Dto data
  List<ModuleAndPermissionDto> modulesPermissionData =[];


  /// Form Key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Text Editing Controllers
  TextEditingController nameCtr = TextEditingController();
  TextEditingController descriptionCtr = TextEditingController();

  /// Focus node
  FocusNode nameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  /// Set permission data
  void setPermissionData({required int index, bool? selectAll, bool? view, bool? create, bool? edit, bool? delete}) {
    if (selectAll != null) {
      moduleList[index].isSelectedAll = selectAll;
      moduleList[index].canView =  selectAll;
      moduleList[index].canAdd =  selectAll;
      moduleList[index].canEdit =  selectAll;
      moduleList[index].canDelete = selectAll;
    } else if (view != null) {
      moduleList[index].canView = !(moduleList[index].canView ?? false);
      if (moduleList[index].canView == false) {
        moduleList[index].canAdd = false;
        moduleList[index].canEdit = false;
        moduleList[index].canDelete = false;
      }
    } else if (create != null) {
      moduleList[index].canAdd = !(moduleList[index].canAdd ?? false);
      if (moduleList[index].canView == false) {
        moduleList[index].canView = true;
      }
    } else if (edit != null) {
      moduleList[index].canEdit = !(moduleList[index].canEdit ?? false);
      if (moduleList[index].canView == false) {
        moduleList[index].canView = true;
      }
    } else if (delete !=null) {
      moduleList[index].canDelete = !(moduleList[index].canDelete ?? false);
      if (moduleList[index].canView == false) {
        moduleList[index].canView = true;
      }
    }

    /// update select all of individual modules
    checkIndividualModuleAllSelected(index);

    /// update select all of header
    checkUncheckAllModulesSelectionOnIndividualChange();

    notifyListeners();
  }

  /// Check dependency on other modules
  Future<bool> checkDependency(int index) async {
    List<String?> matchedUUid = moduleList[index].dependentModulesList?.map((module) => module.uuid).toList()??[];
    int count = 0;
    ModuleModel dto = moduleList[index];
    for (var element in matchedUUid) {
      dto = moduleList.firstWhere((e) => e.uuid == element);
      if((dto.canView??false) || (dto.canEdit??false) || (dto.canAdd??false) || (dto.canDelete ??false)){
        count++;
      }
    }
    return count > 0;
  }

  /// Action on checking required modules
  void actionOnRequiredModules(int index) {
    if (!(moduleList[index].canView??false)) {
      List<RequiredModuleList>? requiredModuleList;
      requiredModuleList = moduleList[index].requiredModuleList;
      for (int i = 0; i < (requiredModuleList?.length ?? 0); i++) {
        moduleList.where((element)=>element.uuid == requiredModuleList?[i].uuid).firstOrNull?.canView = true;
      }
    }
    notifyListeners();
  }

  bool isAllModulesSelected = false;
  /// Update all modules permission
  void updateAllModulesSelection(bool value){
    isAllModulesSelected = value;
    for(int i = 0; i<moduleList.length; i++){
      if(moduleList[i].name != 'Dashboard'){
       moduleList[i].canView = value;
       moduleList[i].canEdit = value;
       moduleList[i].canDelete = value;
       moduleList[i].canAdd = value;
       moduleList[i].isSelectedAll = value;
      }
    }
    notifyListeners();
  }

  /// Check individual modules all selection
  void checkIndividualModuleAllSelected(index){
    if((moduleList[index].canAdd??false) && (moduleList[index].canDelete??false) && (moduleList[index].canEdit??false)){
      moduleList[index].isSelectedAll = true;
    }else{
      moduleList[index].isSelectedAll = false;
    }
  }

  /// Prefill data on edit
  void preFillDataOnEdit(RolePermissionModel data){
    nameCtr.text = data.name??'';
    descriptionCtr.text = data.description??'';
    for(int i= 0;i<moduleList.length;i++){
      moduleList[i].canView = data.moduleAndPermissionResponseDtOs?.where((element)=>element.modulesUuid == moduleList[i].uuid).firstOrNull?.canView??false;
      moduleList[i].canAdd = data.moduleAndPermissionResponseDtOs?.where((element)=>element.modulesUuid == moduleList[i].uuid).firstOrNull?.canAdd??false;
      moduleList[i].canEdit = data.moduleAndPermissionResponseDtOs?.where((element)=>element.modulesUuid == moduleList[i].uuid).firstOrNull?.canEdit??false;
      moduleList[i].canDelete = data.moduleAndPermissionResponseDtOs?.where((element)=>element.modulesUuid == moduleList[i].uuid).firstOrNull?.canDelete??false;

      /// update select all of individual modules
      checkIndividualModuleAllSelected(i);
    }

    /// update select all of header
    checkUncheckAllModulesSelectionOnIndividualChange();
  }

  /// Check uncheck all modules all selection on individual change
  void checkUncheckAllModulesSelectionOnIndividualChange(){
    int count = 0;
    for(int i = 0; i<moduleList.length; i++){
      if(!((moduleList[i].canAdd??false) && (moduleList[i].canAdd??false) && (moduleList[i].canDelete??false) && (moduleList[i].canEdit??false))){
        count++;
      }
    }
    if(count>0){
      isAllModulesSelected = false;
    }else{
      isAllModulesSelected = true;
    }
    notifyListeners();
  }



  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  RolePermissionRepository rolePermissionRepository;
  AddEditRoleController(this.rolePermissionRepository);

  /// Module list api 
  UIState<ModuleListResponseModel> moduleListState = UIState<ModuleListResponseModel>();
  Future<void> moduleListApi() async {
    moduleListState.isLoading = true;
    moduleListState.success = null;
    notifyListeners();
    final result = await rolePermissionRepository.moduleListApi('''{}''',1,100);
    result.when(success: (data) async {
      moduleListState.success = data;
      for (var value in moduleListState.success?.data??[]) {
        moduleList.add(
            ModuleModel(
              uuid: value.uuid,
              active: value.active,
              name: value.name,
              nameEnglish: value.nameEnglish,
              requiredModuleList: value.requiredModuleList,
              dependentModulesList: value.dependentModulesList,
              canView: value.nameEnglish == 'Dashboard'?true: false,
              canAdd: value.nameEnglish == 'Dashboard'?true :false,
              canEdit: value.nameEnglish == 'Dashboard'?true:false,
              canDelete: value.nameEnglish == 'Dashboard'?true: false,
              isSelectedAll: value.nameEnglish == 'Dashboard'?true:false,
            )
        );
      }
    }, failure: (NetworkExceptions error) {});
    moduleListState.isLoading = false;
    notifyListeners();
  }


  /// Add update role api
  UIState<CommonResponseModel> addUpdateRoleState = UIState<CommonResponseModel>();
  Future<void> addUpdateRoleApi({String? roleUuid}) async {
    addUpdateRoleState.isLoading = true;
    addUpdateRoleState.success = null;
    notifyListeners();

    modulesPermissionData = [];
    for(int i = 0;i<moduleList.length;i++){
      modulesPermissionData.add(
          ModuleAndPermissionDto(
            modulesUuid: moduleList[i].uuid??'',
            canView:moduleList[i].canView,
            canAdd:moduleList[i].canAdd,
            canEdit:moduleList[i].canEdit,
            canDelete:moduleList[i].canDelete,
          )
      );
    }
    String request = addUpdateRoleRequestModelToJson(
      roleUuid == null?
          AddUpdateRoleRequestModel(
            name: nameCtr.text,
            description: descriptionCtr.text,
            moduleAndPermissionDtOs: modulesPermissionData,
            userType: 'USER'
          )
          :AddUpdateRoleRequestModel(
          uuid: roleUuid,
          name: nameCtr.text,
          description: descriptionCtr.text,
          moduleAndPermissionDtOs: modulesPermissionData,
          userType: 'USER'
      )
    );
    final result = await rolePermissionRepository.addUpdateRolePermissionApi(request);
    result.when(success: (data) async {
     addUpdateRoleState.success = data;
    }, failure: (NetworkExceptions error) {});
    addUpdateRoleState.isLoading = false;
    notifyListeners();
  }
}
