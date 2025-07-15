import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/dio/dio_client.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/destination_type/contract/destination_type_repository.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/add_edit_destination_type_response_model.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/destination_type_details_response_model.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/destination_type_list_response_model.dart';
import 'package:odigov3/framework/repository/master/state/model/add_edit_state_response_model.dart';
import 'package:odigov3/framework/repository/master/state/model/state_details_response_model.dart';

@LazySingleton(as: DestinationTypeRepository, env: [Env.production, Env.debug])
class DestinationTypeApiRepository implements DestinationTypeRepository {
  final DioClient apiClient;
  DestinationTypeApiRepository(this.apiClient);

  @override
  Future getDestinationTypeListApi(int pageNo,int pageSize, String? destinationUuid,String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getDestinationTypeList(pageNo, pageSize,destinationUuid),request);
      DestinationTypeListResponseModel responseModel = destinationTypeListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future addDestinationTypeApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addEditDestinationType,request);
      AddEditDestinationTypeResponseModel responseModel = addEditDestinationTypeResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future editDestinationTypeApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.addEditDestinationType,request);
      AddEditDestinationTypeResponseModel responseModel = addEditDestinationTypeResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeDestinationTypeStatusApi(String uuid, bool status) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeDestinationTypeStatus(uuid, status),'{}');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future destinationTypeDetailsApi(String uuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.destinationTypeDetails(uuid));
      DestinationTypeDetailsResponseModel responseModel = destinationTypeDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}