import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/faq/contract/faq_repository.dart';
import 'package:odigov3/framework/repository/faq/model/response/faq_details_response_model.dart';
import 'package:odigov3/framework/repository/faq/model/response/faq_list_response_model.dart';
import 'package:odigov3/ui/utils/app_constants.dart';

@LazySingleton(as: FaqRepository,env: Env.environments)
class FaqApiRepository extends FaqRepository{
  final DioClient apiClient;
  FaqApiRepository(this.apiClient);

  /// Faq list
  @override
  Future faqListApi({required String request, required int pageNumber, int? dataSize}) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.faqList(pageNumber, dataSize ?? AppConstants.pageSize),request);
      FaqListResponseModel responseModel = faqListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Update faq status
  @override
  Future updateFaqStatusApi({required String uuid, required bool isActive}) async{
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeFaqStatus(uuid, isActive), '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Faq details
  @override
  Future faqDetailsApi(String uuid) async{
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.faqDetails(uuid));
      FaqDetailsResponseModel responseModel = faqDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// add edit faq
  @override
  Future addEditFaqApi(String request, bool forAdd) async {
    try {
      Response? response;
      if(forAdd){
        response  = await apiClient.postRequest(ApiEndPoints.addEditFaq, request);
      } else {
        response = await apiClient.putRequest(ApiEndPoints.addEditFaq, request);
      }

      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


}