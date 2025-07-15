
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/dio/dio_client.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/auth/contract/login_repository.dart';
import 'package:odigov3/framework/repository/auth/model/login_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';

@LazySingleton(as: LoginRepository, env: [Env.debug, Env.production])
class LoginApiRepository implements LoginRepository {
  final DioClient apiClient;

  LoginApiRepository(this.apiClient);

  @override
  Future forgotPasswordApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.forgotPassword, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future loginApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.login, request);
      LoginResponseModel responseModel = loginResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future resendOtpApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.resendOtp, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future resetPasswordApi(String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.resetPassword, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future verifyOtpApi(String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.verifyOtp, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future getLanguageListAPI() async{
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getLanguageList);
      GetLanguageListResponseModel responseModel = getLanguageListResponseModelFromJson(response.toString());
      if (responseModel.status == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(error: NetworkExceptions.defaultError(responseModel.message ?? ''));
      }
    } catch (err) {
      print('error $err');
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


}
