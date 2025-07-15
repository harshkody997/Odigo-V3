import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/city/contract/city_repository.dart';
import 'package:odigov3/framework/repository/master/city/model/add_edit_city_response_model.dart';
import 'package:odigov3/framework/repository/master/city/model/city_details_response_model.dart';
import 'package:odigov3/framework/repository/master/city/model/city_list_response_model.dart';

@LazySingleton(as: CityRepository, env: [Env.production, Env.debug])
class CityApiRepository implements CityRepository {
  final DioClient apiClient;
  CityApiRepository(this.apiClient);

  @override
  Future getCityListAPI(int pageNo, int pageSize, String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getCityList(pageNo, pageSize),request);
      CityListResponseModel responseModel = cityListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future addCityApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addEditCity,request);
      AddEditCityResponseModel responseModel = addEditCityResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future editCityApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.addEditCity,request);
      AddEditCityResponseModel responseModel = addEditCityResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeCityStatusApi(String uuid, bool status) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeCityStatus(uuid, status),'{}');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future cityDetailsApi(String uuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.cityDetails(uuid));
      CityDetailsResponseModel responseModel = cityDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
