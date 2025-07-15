import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/role_permission/contract/role_permission_repository.dart';
import 'package:odigov3/framework/repository/role_permission/model/module_list_response_model.dart';
import 'package:odigov3/framework/repository/role_permission/model/role_list_response_model.dart';
import 'package:odigov3/framework/repository/role_permission/model/role_permission_details_response_model.dart';

@LazySingleton(as: RolePermissionRepository, env: [Env.production, Env.debug])
class RolePermissionApiRepository implements RolePermissionRepository{
  final DioClient apiClient;
  RolePermissionApiRepository(this.apiClient);

  ///Role list Api
  @override
  Future roleListApi(String request,int pageNo,int pageSize,bool? activeRecords) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.roleList(pageNo,pageSize,activeRecords), request);
      RoleListResponseModel responseModel = roleListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future addUpdateRolePermissionApi(String request,{bool? isUpdate}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addEditRolePermission, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeRoleStatus(String uuid, bool isActive) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeRoleStatus(uuid, isActive), '{}');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future moduleListApi(String request, int pageNo, int pageSize) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.modulesList, request);
      ModuleListResponseModel responseModel = moduleListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future rolePermissionDetailsApi(String uuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.rolePermissionDetails(uuid));
      RolePermissionDetailsResponseModel responseModel = rolePermissionDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
