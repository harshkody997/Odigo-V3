import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/profile/contract/profile_repository.dart';
import 'package:odigov3/framework/repository/profile/model/response/change_password_response_model.dart';
import 'package:odigov3/framework/repository/profile/model/response/profile_detail_response.dart';
import 'package:odigov3/framework/repository/profile/model/response/update_email_response_model.dart';
import 'package:odigov3/framework/utils/session.dart';

@LazySingleton(as: ProfileRepository, env: Env.environments)
class ProfileApiRepository extends ProfileRepository{
  final DioClient apiClient;
  ProfileApiRepository(this.apiClient);

  @override
  Future getProfileDetail() async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.profileDetail);
      ProfileDetailResponseModel responseModel = profileDetailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }



  @override
  Future changeName(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeName,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeContactNumber(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeContactNumber,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


  @override
  Future changePassword(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changePassword,request);
      ChangePasswordResponseModel responseModel = changePasswordResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Update the mobile no and the email
  @override
  Future updateEmail(String request) async{
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateEmail,request);
      UpdateEmailResponseModel responseModel = updateEmailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Check Password API
  @override
  Future checkPassword(String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.checkPassword,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Send Otp Api
  @override
  Future sendOtpApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.resendOtp,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeLanguageApi() async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeLanguage(Session.sessionBox.get(keyAppLanguageUuid)), null);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}