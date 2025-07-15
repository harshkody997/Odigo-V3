import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/default_ads/contract/default_ads_repository.dart';
import 'package:odigov3/framework/repository/default_ads/model/add_default_ads_response_model.dart';
import 'package:odigov3/framework/repository/default_ads/model/default_ads_details_response_model.dart';
import 'package:odigov3/framework/repository/default_ads/model/default_ads_list_response_model.dart';

@LazySingleton(as: DefaultAdsRepository, env: Env.environments)
class DefaultAdsApiRepository implements DefaultAdsRepository{
  final DioClient apiClient;
  DefaultAdsApiRepository(this.apiClient);

  @override
  Future defaultAdsListApi({required String request, required int pageNumber, int? dataSize}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.defaultAdsList(pageNumber, dataSize??10 ), request);
      DefaultAdsListResponseModel responseModel = defaultAdsListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeDefaultAdsStatusApi({required String adsUuid, required bool isActive}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeDefaultAdsStatus(adsUuid, isActive), null);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future deleteDefaultAdsApi({required String adsUuid}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.deleteDefaultAds(adsUuid), null);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


  @override
  Future<ApiResult<AddDefaultAdsResponseModel>> addDefaultAdsApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addDefaultAds, request);
      AddDefaultAdsResponseModel responseModel = addDefaultAdsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


  @override
  Future<ApiResult<CommonResponseModel>> updateDefaultAdsNameApi({required String request}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateDefaultAds, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<DefaultAdsDetailsResponseModel>> defaultAdsDetailsApi({required String defaultAdsUuid}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.defaultAdsDetails(defaultAdsUuid));
      DefaultAdsDetailsResponseModel responseModel = defaultAdsDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<CommonResponseModel>> addDefaultAdsContentApi(FormData request, String defaultAdsUuid) async {
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.addDefaultAdsContent(defaultAdsUuid), request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<CommonResponseModel>> validateAdsContentApi(FormData request, String mediaType) async {
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.validateAdsContent(mediaType), request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}
