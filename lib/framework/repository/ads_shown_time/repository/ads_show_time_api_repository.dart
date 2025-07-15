import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/ads_shown_time/contract/ads_show_time_repository.dart';
import 'package:odigov3/framework/repository/ads_shown_time/model/ads_shown_time_response_model.dart';

@LazySingleton(as: AdsShowTimeRepository,env: Env.environments)
class AdsShowTimeApiRepository extends AdsShowTimeRepository{
  final DioClient apiClient;
  AdsShowTimeApiRepository(this.apiClient);

  /// Faq list
  @override
  Future adsShownTimeListApi({required String request, required int pageNumber}) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.adsShowTimeList(pageNumber),request);
      AdsShownTimeListResponseModel responseModel = adsShownTimeListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }



}