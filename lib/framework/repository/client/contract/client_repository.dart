import 'package:dio/dio.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/repository/client/model/response/add_client_response_model.dart';
import 'package:odigov3/framework/repository/client/model/response/client_details_response_model.dart';
import 'package:odigov3/framework/repository/client/model/response/client_list_response_model.dart';
import 'package:odigov3/framework/repository/client/model/response/get_document_by_uuid_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';

abstract class ClientRepository {
  /// Add Client Api
  Future<ApiResult<AddClientResponseModel>> addClientApi(String request);

  /// Update Client Api
  Future<ApiResult<CommonResponseModel>> updateClientApi(String request);

  /// Active DeActive Client Api
  Future<ApiResult<CommonResponseModel>> activeDeActiveClientApi(String uuid, bool isActive);

  /// Get Client List Api
  Future<ApiResult<ClientListResponseModel>> getClientListApi(int pageNumber, String request);

  /// Get Client Details Api
  Future<ApiResult<ClientDetailsResponseModel>> getClientDetailsApi(String uuid);

  /// Upload Document Image Api
  Future<ApiResult<CommonResponseModel>> uploadDocumentImageApi(FormData formData);

  /// Update Document Image Api
  Future<ApiResult<CommonResponseModel>> updateDocumentImageApi(FormData formData);

  /// Get Document Image By Uuid Api
  Future<ApiResult<GetDocumentByUuidModel>> getDocumentImageByUuidApi(String clientUuid);

  /// Delete Document Image Api
  Future<ApiResult<CommonResponseModel>> deleteDocumentImageApi(String request);
}
