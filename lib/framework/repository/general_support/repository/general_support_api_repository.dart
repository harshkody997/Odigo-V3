import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/repository/general_support/contract/general_support_repository.dart';
import 'package:odigov3/framework/repository/general_support/model/contact_us_list_response.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';

@LazySingleton(as: GeneralSupportRepository, env: Env.environments)
class GeneralSupportApiRepository implements GeneralSupportRepository{
  final DioClient apiClient;
  GeneralSupportApiRepository(this.apiClient);

  @override
  Future contactUsListApi({required int pageNumber, int? dataSize}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.contactUsList(pageNumber, dataSize??10 ));
      ContactUsListResponseModel responseModel = contactUsListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


}
