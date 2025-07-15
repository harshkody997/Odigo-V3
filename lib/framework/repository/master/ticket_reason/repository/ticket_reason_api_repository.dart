import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/dio/dio_client.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/ticket_reason/contract/ticket_reason_repository.dart';
import 'package:odigov3/framework/repository/master/ticket_reason/model/add_edit_ticket_reason_response_model.dart';
import 'package:odigov3/framework/repository/master/ticket_reason/model/ticket_reason_details_response_model.dart';
import 'package:odigov3/framework/repository/master/ticket_reason/model/ticket_reason_list_response_model.dart';

@LazySingleton(as: TicketReasonRepository, env: [Env.production, Env.debug])
class TicketReasonApiRepository implements TicketReasonRepository {
  final DioClient apiClient;
  TicketReasonApiRepository(this.apiClient);

  @override
  Future getTicketReasonListApi(int pageNo, int pageSize,String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getTicketReasonList(pageNo, pageSize),request);
      TicketReasonListResponseModel responseModel = ticketReasonListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future addTicketReasonApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addEditTicketReason,request);
      AddEditTicketReasonResponseModel responseModel = addEditTicketReasonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future editTicketReasonApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.addEditTicketReason,request);
      AddEditTicketReasonResponseModel responseModel = addEditTicketReasonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeTicketReasonStatusApi(String uuid, bool status) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeTicketReasonStatus(uuid, status),'{}');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future ticketReasonDetailsApi(String uuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.ticketReasonDetails(uuid));
      TicketReasonDetailsResponseModel responseModel = ticketReasonDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}