import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/destination_user_management/contract/destination_user_repository.dart';
import 'package:odigov3/framework/repository/destination_user_management/model/destination-user_details_response_model.dart';
import 'package:odigov3/framework/repository/destination_user_management/model/destination_user_list_response_model.dart';

@LazySingleton(as: DestinationUserRepository, env: [Env.production, Env.debug])
class DestinationUserApiRepository implements DestinationUserRepository{
  final DioClient apiClient;
  DestinationUserApiRepository(this.apiClient);

  @override
  Future destinationUserListApi(String searchText, int pageNo,{bool? isActive}) async{
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getDestinationUserList(pageNo,searchText:searchText,isActive: isActive));
      DestinationUserListResponseModel responseModel = destinationUserListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future getDestinationUserDetails(String userUuid) async{
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.destinationUserDetails(userUuid));
      DestinationUserDetailsResponseModel responseModel = destinationUserDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeDestinationUserPassword(String request) async{
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeDestinationUserPassword,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future updateDestinationUserStatusApi(String userId, bool status) async{
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateDestinationUserStatus(userId,status), '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future addUpdateDestinationUserApi(String request, {bool? isUpdate}) async{
    try {
      Response? response = !(isUpdate??true) ? await apiClient.postRequest(ApiEndPoints.addUpdateDestinationUser, request)
          :await apiClient.putRequest(ApiEndPoints.addUpdateDestinationUser, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}