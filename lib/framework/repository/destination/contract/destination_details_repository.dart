import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destiantion_list_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_multilanguage_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_price_history_response_model.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/destination_type_list_response_model.dart';

abstract class DestinationDetailsRepository {
  ///destination details Api
  Future destinationDetailsApi(BuildContext context, String destinationUuid);

  ///destination assign robot api
  Future assignDeAssignRobotApi(String request);

  ///destination assign store api
  Future assignDeAssignStoreApi(String request);
  ///Update destination passcode api
  Future updateDestinationPasscode(String request);

  ///Store destination list api
  Future storeDestinationListApi({required int pageNumber, int? dataSize,required String destinationId});

  ///Destination List Api
  Future<ApiResult<DestinationListResponseModel>> getDestinationListApi(String request, String pageNo);

  Future<ApiResult<DestinationTypeListResponseModel>> getDestinationTypeListApi(String request, String pageNo);

  Future<ApiResult<DestinationDetailsMultiLanguageResponseModel>> manageDestinationApi(String request, {String? destinationUuid});

  Future<ApiResult<DestinationDetailsMultiLanguageResponseModel>> getDestinationDetailsMultiLanguageApi(String destinationUuid);

  Future<ApiResult<CommonResponseModel>> uploadDestinationImageApi(FormData formData, String destinationUuid);

  Future<ApiResult<CommonResponseModel>> changeDestinationStatusApi(String uuid,bool status);

  Future<ApiResult<DestinationPriceHistoryResponseModel>> destinationPriceHistory(int pageNo, {String? destinationUuid});

  Future floorListApi(String request);

  Future updateFloorApi(String request);

  Future floorDetailsApi(String uuid);
}
