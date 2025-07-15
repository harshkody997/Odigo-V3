import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/dio/dio_client.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/cms/contract/cms_repository.dart';
import 'package:odigov3/framework/repository/cms/model/add_cms_response_model.dart';
import 'package:odigov3/framework/repository/cms/model/cms_list_response_model.dart';
import 'package:odigov3/framework/repository/cms/model/cms_response_model.dart';
import 'package:odigov3/framework/repository/cms/model/get_cms_type_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';

@LazySingleton(as: CmsRepository, env: [Env.debug, Env.production])
class CmsApiRepository implements CmsRepository {
  final DioClient apiClient;

  CmsApiRepository(this.apiClient);

  @override
  addCmsApi(String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addCms, request);
      AddCmsResponseModel responseModel = addCmsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  updateCmsApi(String request) async{
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateCms, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  cmsListApi(String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getCmsListApi, request);
      CmsListResponseModel responseModel = cmsListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  cmsTypeApi(String cmsType,String platformType) async{
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getCmsTypeApi(cmsType,platformType));
      GetCmsTypeResponseModel responseModel = getCmsTypeResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  cmsApi(String cmsType,String platformType) async{
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getCmsApi(cmsType,platformType));
      CmsResponseModel responseModel = cmsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }



}
