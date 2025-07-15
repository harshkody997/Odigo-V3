import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/repository/client_ads/model/add_client_ads_response_model.dart';
import 'package:odigov3/framework/repository/client_ads/model/client_ads_details_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/client_ads/contract/client_ads_repository.dart';
import 'package:odigov3/framework/repository/client_ads/model/client_ads_list_response_model.dart';

@LazySingleton(as: ClientAdsRepository, env: Env.environments)
class ClientAdsApiRepository implements ClientAdsRepository{
  final DioClient apiClient;
  ClientAdsApiRepository(this.apiClient);

  @override
  Future clientAdsListApi({required String request, required int pageNumber, int? dataSize}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.clientAdsList(pageNumber, dataSize??10 ), request);
      ClientAdsListResponseModel responseModel = clientAdsListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeClientAdsStatusApi({required String adsUuid, required bool isActive}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeClientAdsStatus(adsUuid, isActive), null);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future deleteClientAdsApi({required String adsUuid}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.deleteClientAds(adsUuid), null);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<AddClientAdsResponseModel>> addClientAdsApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addClientAds, request);
      AddClientAdsResponseModel responseModel = addClientAdsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


  @override
  Future<ApiResult<CommonResponseModel>> updateClientAdsNameApi({required String request}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateClientAds, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<ClientAdsDetailsResponseModel>> clientAdsDetailsApi({required String clientAdsUuid}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.clientAdsDetails(clientAdsUuid));
      ClientAdsDetailsResponseModel responseModel = clientAdsDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<CommonResponseModel>> addClientAdsContentApi(FormData request, String clientAdsUuid) async {
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.addClientAdsContent(clientAdsUuid), request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future acceptRejectAdsApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.acceptRejectAds, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}
