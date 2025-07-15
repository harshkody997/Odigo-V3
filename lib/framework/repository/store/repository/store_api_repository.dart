import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/store/model/add_store_response_model.dart';
import 'package:odigov3/framework/repository/store/model/store_detail_response_model.dart';
import 'package:odigov3/framework/repository/store/model/store_language_detail_api.dart';
import 'package:odigov3/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/store/contract/store_repository.dart';

@LazySingleton(as: StoreRepository, env: Env.environments)
class StoreApiRepository implements StoreRepository{
  final DioClient apiClient;
  StoreApiRepository(this.apiClient);

  @override
  Future storeListApi({required String request, required int pageNumber, int? dataSize}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.storeList(pageNumber, dataSize??10 ), request,isTokenRequiredInHeader: false);
      StoreListResponseModel responseModel = storeListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeStoreStatusApi({required String storeUuid, required bool isActive}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeStoreStatus(storeUuid, isActive), null);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future storeDetailApi({required String storeUuid}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.storeDetail(storeUuid));
      StoreDetailResponseModel responseModel = storeDetailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future storeLanguageDetailApi({required String storeUuid}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.storeLanguageDetail(storeUuid));
      StoreLanguageDetailResponseModel responseModel = storeLanguageDetailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future addEditStoreApi(String request, bool forAdd) async {
    try {
      Response? response;
      if(forAdd){
        response  = await apiClient.postRequest(ApiEndPoints.addUpdateStore, request);
      } else {
         response = await apiClient.putRequest(ApiEndPoints.addUpdateStore, request);
      }

      AddStoreResponseModel responseModel = addStoreResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future uploadStoreImage(FormData formData, String storeUuid) async {
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.storeUploadImage(storeUuid), formData);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}
