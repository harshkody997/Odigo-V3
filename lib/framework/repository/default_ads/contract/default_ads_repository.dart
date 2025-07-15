
import 'package:dio/dio.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/default_ads/model/add_default_ads_response_model.dart';
import 'package:odigov3/framework/repository/default_ads/model/default_ads_details_response_model.dart';

abstract class DefaultAdsRepository {

    ///ads list Api
    Future defaultAdsListApi({required String request,required int pageNumber, int dataSize});

    ///change Ads status Api
    Future changeDefaultAdsStatusApi({required String adsUuid, required bool isActive});

    ///delete Ads Api
    Future deleteDefaultAdsApi({required String adsUuid});

    /// Add Default Ads Api
    Future<ApiResult<AddDefaultAdsResponseModel>> addDefaultAdsApi({required String request});

    /// Edit Default Ads Api
    Future<ApiResult<CommonResponseModel>> updateDefaultAdsNameApi({required String request});

    /// Default Ads Details Api
    Future<ApiResult<DefaultAdsDetailsResponseModel>> defaultAdsDetailsApi({required String defaultAdsUuid});

    /// Add Default Ads Content Api
    Future<ApiResult<CommonResponseModel>> addDefaultAdsContentApi(FormData formData, String defaultAdsUuid);

    /// Validate Ads Content Api
    Future<ApiResult<CommonResponseModel>> validateAdsContentApi(FormData formData, String mediaType);

}

