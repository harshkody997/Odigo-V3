import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/dio/dio_client.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/state/contract/state_repository.dart';
import 'package:odigov3/framework/repository/master/state/model/add_edit_state_response_model.dart';
import 'package:odigov3/framework/repository/master/state/model/state_details_response_model.dart';
import 'package:odigov3/framework/repository/master/state/model/state_list_response_model.dart';

@LazySingleton(as: StateRepository, env: [Env.production, Env.debug])
class StateApiRepository implements StateRepository {
  final DioClient apiClient;
  StateApiRepository(this.apiClient);

  @override
  Future getStateListApi(int pageNo, int pageSize,String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getStateList(pageNo, pageSize),request);
      StateListResponseModel responseModel = stateListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future addStateApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addEditState,request);
      AddEditStateResponseModel responseModel = addEditStateResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future editStateApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.addEditState,request);
      AddEditStateResponseModel responseModel = addEditStateResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeStateStatusApi(String uuid, bool status) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeStateStatus(uuid, status),'{}');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future stateDetailsApi(String uuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.stateDetails(uuid));
      StateDetailsResponseModel responseModel = stateDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}