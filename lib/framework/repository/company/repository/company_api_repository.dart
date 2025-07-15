import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/company/contract/company_repository.dart';
import 'package:odigov3/framework/repository/company/model/company_details_response_model.dart';

@LazySingleton(as: CompanyRepository, env: Env.environments)
class CompanyApiRepository extends CompanyRepository{
  final DioClient apiClient;
  CompanyApiRepository(this.apiClient);

  @override
  Future getCompanyDetail() async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.companyDetail);
      CompanyDetailsResponseModel responseModel = companyDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


  @override
  Future editCompanyApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.companyDetail, request);
      CompanyDetailsResponseModel responseModel = companyDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future uploadCompanyImage(FormData formData, String companyUuid) async {
    try {
      Response? response = await apiClient.putRequestFormData(ApiEndPoints.companyUploadImage(companyUuid), formData);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }




}