import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/client/contract/client_repository.dart';
import 'package:odigov3/framework/repository/client/model/response/add_client_response_model.dart';
import 'package:odigov3/framework/repository/client/model/response/client_details_response_model.dart';
import 'package:odigov3/framework/repository/client/model/response/client_list_response_model.dart';
import 'package:odigov3/framework/repository/client/model/response/get_document_by_uuid_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';

@LazySingleton(as: ClientRepository, env: [Env.debug, Env.production])
class ClientApiRepository implements ClientRepository {
  final DioClient apiClient;

  ClientApiRepository(this.apiClient);

  /// Add Client Api
  @override
  Future<ApiResult<AddClientResponseModel>> addClientApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addClient, request);
      AddClientResponseModel responseModel = addClientResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Update Client Api
  @override
  Future<ApiResult<CommonResponseModel>> updateClientApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.addClient, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Active DeActive Client Api

  @override
  Future<ApiResult<CommonResponseModel>> activeDeActiveClientApi(String uuid, bool isActive) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeClientStatus(uuid, isActive), '{}');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Client List Api
  @override
  Future<ApiResult<ClientListResponseModel>> getClientListApi(int pageNumber, String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.clientList(pageNumber), request);
      ClientListResponseModel responseModel = clientListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Client Details Api
  @override
  Future<ApiResult<ClientDetailsResponseModel>> getClientDetailsApi(String uuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.clientDetails(uuid));
      ClientDetailsResponseModel responseModel = clientDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Upload Document Image Api
  @override
  Future<ApiResult<CommonResponseModel>> uploadDocumentImageApi(FormData request) async {
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.uploadDocument, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Update Document Image Api
  @override
  Future<ApiResult<CommonResponseModel>> updateDocumentImageApi(FormData request) async {
    try {
      Response? response = await apiClient.putRequestFormData(ApiEndPoints.updateDocument, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Get Document Image By Uuid Api
  @override
  Future<ApiResult<GetDocumentByUuidModel>> getDocumentImageByUuidApi(String clientUuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getDocumentByUuid(clientUuid));
      GetDocumentByUuidModel responseModel = getDocumentByUuidModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Delete Document Image Api
  @override
  Future<ApiResult<CommonResponseModel>> deleteDocumentImageApi(String request) async {
    try {
      Response? response = await apiClient.deleteRequest(ApiEndPoints.deleteDocument, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
