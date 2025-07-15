import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destiantion_list_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_multilanguage_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_price_history_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/floor_details_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/floor_list_response_model.dart';
import 'package:odigov3/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/destination_type_list_response_model.dart';
import '../../../provider/network/network.dart';
import '../contract/destination_details_repository.dart';

@LazySingleton(as: DestinationDetailsRepository, env: ['debug', 'production'])
class DestinationDetailsApiRepository implements DestinationDetailsRepository {
  final DioClient apiClient;

  DestinationDetailsApiRepository(this.apiClient);

  ///demo Api
  @override
  Future destinationDetailsApi(BuildContext context, String destinationUuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.destinationDetails(destinationUuid));
      DestinationDetailsResponseModel responseModel = destinationDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future assignDeAssignRobotApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.assignDeAssignRobot, request);
      DestinationDetailsResponseModel responseModel = destinationDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future assignDeAssignStoreApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.assignDeAssignStore, request);
      DestinationDetailsResponseModel responseModel = destinationDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<DestinationListResponseModel>> getDestinationListApi(String request, String pageNo) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.destinationList(pageNo), request);
      DestinationListResponseModel responseModel = destinationListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<DestinationTypeListResponseModel>> getDestinationTypeListApi(String request, String pageNo) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.destinationTypeList(pageNo), request);
      DestinationTypeListResponseModel responseModel = destinationTypeListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<DestinationDetailsMultiLanguageResponseModel>> manageDestinationApi(String request, {String? destinationUuid}) async {
    try {
      print(request);
      Response? response;
      if (destinationUuid != null) {
        response = await apiClient.putRequest(ApiEndPoints.manageDestination, request);
      } else {
        response = await apiClient.postRequest(ApiEndPoints.manageDestination, request);
      }
      DestinationDetailsMultiLanguageResponseModel responseModel = destinationDetailsMultiLanguageResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<DestinationDetailsMultiLanguageResponseModel>> getDestinationDetailsMultiLanguageApi(String destinationUuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.destinationDetailsMultiLanguage(destinationUuid));
      DestinationDetailsMultiLanguageResponseModel responseModel = destinationDetailsMultiLanguageResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<CommonResponseModel>> uploadDestinationImageApi(FormData request, String destinationUuid) async {
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.uploadDestinationImage(destinationUuid), request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future updateDestinationPasscode(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateDestinationPasscode,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future storeDestinationListApi({required int pageNumber, int? dataSize,required String destinationId}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.storeListDestination(destinationId,pageNumber, dataSize??10,true ));
      StoreListResponseModel responseModel = storeListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<CommonResponseModel>> changeDestinationStatusApi(String uuid, bool status) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeDestinationStatus(uuid, status),'{}');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<DestinationPriceHistoryResponseModel>> destinationPriceHistory(int pageNo, {String? destinationUuid}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.destinationPriceHistory(pageNo, destinationUuid: destinationUuid));
      DestinationPriceHistoryResponseModel responseModel = destinationPriceHistoryResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future floorListApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.floorList,request);
      FloorListResponseModel responseModel = floorListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future updateFloorApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateFloor,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future floorDetailsApi(String uuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.floorDetails(uuid));
      FloorDetailsResponseModel responseModel = floorDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
