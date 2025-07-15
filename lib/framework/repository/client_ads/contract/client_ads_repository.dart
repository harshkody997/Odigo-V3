
import 'package:dio/dio.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/repository/client_ads/model/client_ads_details_response_model.dart';
import 'package:odigov3/framework/repository/client_ads/model/add_client_ads_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';

abstract class ClientAdsRepository {

    ///ads list Api
    Future clientAdsListApi({required String request,required int pageNumber, int dataSize});

    ///change Ads status Api
    Future changeClientAdsStatusApi({required String adsUuid, required bool isActive});

    ///delete Ads Api
    Future deleteClientAdsApi({required String adsUuid});

    /// Add Client Ads Api
    Future<ApiResult<AddClientAdsResponseModel>> addClientAdsApi({required String request});

    /// Edit Client Ads Api
    Future<ApiResult<CommonResponseModel>> updateClientAdsNameApi({required String request});

    /// Client Ads Details Api
    Future<ApiResult<ClientAdsDetailsResponseModel>> clientAdsDetailsApi({required String clientAdsUuid});

    /// Add Client Ads Content Api
    Future<ApiResult<CommonResponseModel>> addClientAdsContentApi(FormData formData, String clientAdsUuid);

    ///accept Reject Ads Api
    Future acceptRejectAdsApi(String request);

}

