import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/device/contract/device_repositiry.dart';
import 'package:odigov3/framework/repository/device/model/device_details_reponse_model.dart';
import 'package:odigov3/framework/repository/device/model/device_list_model.dart';

@LazySingleton(as: DeviceRepository, env: [Env.production, Env.debug])
class DeviceApiRepository implements DeviceRepository{
  final DioClient apiClient;
  DeviceApiRepository(this.apiClient);


  @override
  Future deviceListApi(String request, int pageNum) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getDeviceList(pageNum), request);
      DeviceListResponseModel responseModel = deviceListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future addUpdateDeviceApi(String request, {bool? isUpdate}) async{
    try {
      Response? response = !(isUpdate??true) ? await apiClient.postRequest(ApiEndPoints.addUpdateDevice, request)
          :await apiClient.putRequest(ApiEndPoints.addUpdateDevice, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future deleteDeviceApi(String deviceUuid,) async{
    try {
      Response? response = await apiClient.deleteRequest(ApiEndPoints.deleteDevice(deviceUuid),'');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future getDeviceDetailApi(String deviceUuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getDeviceDetails(deviceUuid));
      DeviceDetailsResponseModel responseModel = deviceDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future updateStatusDeviceApi(String deviceUuid, bool status) async{
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateDeviceStatus(deviceUuid,status), '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }






}