import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/dio/dio_client.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/user_management/contract/user_management_repository.dart';
import 'package:odigov3/framework/repository/user_management/model/response/get_assign_type_response_model.dart';
import 'package:odigov3/framework/repository/user_management/model/response/get_user_details_response_model.dart';
import 'package:odigov3/framework/repository/user_management/model/response/get_users_response_model.dart';

@LazySingleton(as: UserManagementRepository, env: Env.environments)
class UserManagementApiRepository implements UserManagementRepository {
  final DioClient apiClient;

  UserManagementApiRepository(this.apiClient);

  ///Add User Api
  @override
  Future addUserApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addUser, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
      // if (responseModel.status == ApiEndPoints.apiStatus_200) {
      //   return ApiResult.success(data: responseModel);
      // } else {
      //   return ApiResult.failure(error: NetworkExceptions.defaultError(responseModel.message ?? ''));
      // }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Update User Api
  @override
  Future updateUserApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateUser, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
      // if (responseModel.status == ApiEndPoints.apiStatus_200) {
      //   return ApiResult.success(data: responseModel);
      // } else {
      //   return ApiResult.failure(
      //       error: NetworkExceptions.defaultError(responseModel.message ?? ''));
      // }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Active DeActive User Api
  @override
  Future activeDeActiveUserApi(String userId, bool isActive) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.activeDeActiveUser(userId, isActive), '{}');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

      // if (responseModel.status == ApiEndPoints.apiStatus_200) {
      //   return ApiResult.success(data: responseModel);
      // } else {
      //   return ApiResult.failure(
      //       error: NetworkExceptions.defaultError(responseModel.message ?? ''));
      // }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Get User Details Api
  @override
  Future getUserDetailsApi(String userId) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getUsersDetails(userId));
      UserDetailsResponseModel responseModel = userDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
      // if (responseModel.status == ApiEndPoints.apiStatus_200) {
      //   return ApiResult.success(data: responseModel);
      // } else {
      //   return ApiResult.failure(
      //       error: NetworkExceptions.defaultError(responseModel.message ?? ''));
      // }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Get Users List Api
  @override
  Future getUsersListApi(int pageNumber, String searchKeyword) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getUsersList(pageNumber, searchKeyword));
      GetUserListResponseModel responseModel = getUserListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
      // if (responseModel.status == ApiEndPoints.apiStatus_200) {
      //   return ApiResult.success(data: responseModel);
      // } else {
      //   return ApiResult.failure(
      //       error: NetworkExceptions.defaultError(responseModel.message ?? ''));
      // }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Get Assign Type Api
  @override
  Future getAssignTypeApi(String request, int pageNumber, {bool? isActive}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getAssignType(pageNumber, isActive), request);
      GetAssignTypeResponseModel responseModel = getAssignTypeResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
      // if (responseModel.status == ApiEndPoints.apiStatus_200) {
      //   return ApiResult.success(data: responseModel);
      // } else {
      //   return ApiResult.failure(
      //       error: NetworkExceptions.defaultError(responseModel.message ?? ''));
      // }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
