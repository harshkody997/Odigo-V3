import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/dio/dio_client.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/settings/contract/settings_repository.dart';
import 'package:odigov3/framework/repository/settings/model/response_model/settings_list_response_model.dart';

@LazySingleton(as: SettingsRepository, env: Env.environments)
class SettingsApiRepository extends SettingsRepository{
  final DioClient apiClient;
  SettingsApiRepository(this.apiClient);

  @override
  Future getSettingsList({required int pageNo, required int dataSize}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.settingsList(pageNo, dataSize));
      SettingsListResponseModel responseModel = settingsListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


  ///Update Status
  @override
  Future updateSetting(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateSetting,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


}