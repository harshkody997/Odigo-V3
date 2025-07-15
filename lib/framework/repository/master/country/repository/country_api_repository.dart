import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/master/country/contract/country_repository.dart';
import 'package:odigov3/framework/repository/master/country/model/country_list_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/country_timezone_response_model.dart';

@LazySingleton(as: CountryRepository, env: [Env.production, Env.debug])
class CountryApiRepository implements CountryRepository {
  final DioClient apiClient;
  CountryApiRepository(this.apiClient);

  @override
  Future getCountryListAPI(int pageNo,int pageSize,String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getCountryList(pageNo, pageSize),request);
      CountryListResponseModel responseModel = countryListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future getCountryTimeZoneAPI() async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getCountryTimeZone);
      CountryTimeZoneResponseModel responseModel = countryTimeZoneResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
