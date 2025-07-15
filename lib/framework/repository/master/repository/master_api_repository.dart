import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/master/contract/master_repository.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';

@LazySingleton(as: MasterRepository, env: [Env.production, Env.debug])
class StorageApiRepository implements MasterRepository {
  final DioClient apiClient;

  StorageApiRepository(this.apiClient);

  /// delete archive ads
  @override
  Future getLanguageListAPI() async {
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
