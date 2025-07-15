import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/dio/dio_client.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/notification/contract/notification_repository.dart';
import 'package:odigov3/framework/repository/notification/model/notification_list_response_model.dart';
import 'package:odigov3/framework/repository/notification/model/notification_unread_count_reponse_model.dart';


@LazySingleton(as: NotificationRepository, env: [Env.debug, Env.production])
class NotificationApiRepository implements NotificationRepository{
  final DioClient apiClient;
  NotificationApiRepository(this.apiClient);

  @override
  Future deleteNotification(String notificationId) async{
    try {
      Response? response = await apiClient.deleteRequest(ApiEndPoints.notificationListDeleteNotification(notificationId), '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future deleteNotificationList() async {
    try {
      Response? response = await apiClient.deleteRequest(ApiEndPoints.notificationListDeleteAll, '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future notificationListAPI(String request, int pageNumber) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.notificationList(pageNumber),request);
      NotificationListResponseModel responseModel = notificationListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future notificationUnreadCountAPI(String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.notificationUnReadCount,request);
      NotificationUnReadCountResponseModel responseModel = notificationUnReadCountResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future readAllNotification()async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.notificationReadAll);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
  }

