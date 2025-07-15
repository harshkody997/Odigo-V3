import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/role_permission/contract/role_permission_repository.dart';
import 'package:odigov3/framework/repository/role_permission/model/role_list_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';


final rolesPermissionController = ChangeNotifierProvider(
      (ref) => getIt<RolesPermissionController>(),
);

@injectable
class RolesPermissionController extends ChangeNotifier {

  RolePermissionRepository rolePermissionRepository;
  RolesPermissionController(this.rolePermissionRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    pageNo = 1;
    roleList = [];
    statusTapIndex = -1;
    searchCtr.clear();
    roleListState.isLoading = false;
    roleListState.isLoadMore = false;
    roleListState.success = null;
    changeRoleStatusState.isLoading = false;
    changeRoleStatusState.success = null;
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    if (isNotify) {
      notifyListeners();
    }
  }

  clearRolePermission(){
    pageNo = 1;
    roleList = [];
    roleListState.isLoading = false;
    roleListState.isLoadMore = false;
    roleListState.success = null;
    notifyListeners();
  }

  int pageNo = 1;
  List<RoleModel> roleList = [];
  int statusTapIndex = -1;
  TextEditingController searchCtr = TextEditingController();
  /// Filter key
  GlobalKey filterKey = GlobalKey();

  updateStatusIndex(int value){
    statusTapIndex = value;
    notifyListeners();
  }

  String formatDate(int? dateTime){
    return DateFormat('dd/MM/yyyy - hh:mma').format(DateTime.fromMillisecondsSinceEpoch(dateTime ?? 0,)).toUpperCase();
  }

  CommonEnumTitleValueModel? selectedFilter = commonActiveDeActiveList[0];
  CommonEnumTitleValueModel? selectedTempFilter = commonActiveDeActiveList[0];
  updateTempSelectedStatus(CommonEnumTitleValueModel? value){
    selectedTempFilter = value;
    notifyListeners();
  }

  updateSelectedStatus(CommonEnumTitleValueModel? value){
    selectedFilter = value;
    notifyListeners();
  }

  resetFilter(){
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    notifyListeners();
  }

  bool get isFilterSelected => selectedFilter != selectedTempFilter;

  bool get isClearFilterCall => (selectedFilter == selectedTempFilter && selectedTempFilter != commonActiveDeActiveList[0]);

  bool get isFilterApplied => selectedFilter != null && selectedFilter != commonActiveDeActiveList[0];


  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  /// role list api
  UIState<RoleListResponseModel> roleListState = UIState<RoleListResponseModel>();
  Future<UIState<RoleListResponseModel>> getRoleListAPI(BuildContext context,{bool pagination = false, int? pageSize,bool? activeRecords,String? searchKeyword}) async {
    if((roleListState.success?.hasNextPage ?? false) && pagination){
      pageNo = pageNo + 1;
    }

    if (pageNo == 1) {
      roleListState.isLoading = true;
      roleList.clear();
    } else {
      roleListState.isLoadMore = true;
    }
    roleListState.success = null;

    notifyListeners();

    Map<String, dynamic> request = {
      'searchKeyword':searchKeyword ?? searchCtr.text,
      'activeRecords':activeRecords,
    };

    final result = await rolePermissionRepository.roleListApi(jsonEncode(request),pageNo, pageSize ?? AppConstants.pageSize,activeRecords);

    result.when(
      success: (data) async {
        roleListState.success = data;
        roleList.addAll(roleListState.success?.data ?? []);
        roleListState.isLoading = false;
        roleListState.isLoadMore = false;
      },
      failure: (NetworkExceptions error) {
        roleListState.isLoading = false;
        roleListState.isLoadMore = false;
      },
    );
    roleListState.isLoading = false;
    roleListState.isLoadMore = false;
    notifyListeners();
    return roleListState;
  }

  /// change role status api
  UIState<CommonResponseModel> changeRoleStatusState = UIState<CommonResponseModel>();
  Future changeStateStatusAPI(BuildContext context,String uuid,bool status,int index) async {
    changeRoleStatusState.isLoading = true;
    changeRoleStatusState.success = null;
    notifyListeners();

    final result = await rolePermissionRepository.changeRoleStatus(uuid,status);

    result.when(
      success: (data) async {
        notifyListeners();
        changeRoleStatusState.isLoading = false;
        changeRoleStatusState.success = data;
        if(changeRoleStatusState.success?.status == ApiEndPoints.apiStatus_200){
          roleList[index].active = status;
        }
      },
      failure: (NetworkExceptions error) {
        changeRoleStatusState.isLoading = false;
      },
    );
    changeRoleStatusState.isLoading = false;
    notifyListeners();
  }
}
