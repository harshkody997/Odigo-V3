abstract class DeviceRepository{

  /// Device list api
  Future deviceListApi(String request, int pageNum);

  /// Add update device api
  Future addUpdateDeviceApi(String request,{bool? isUpdate});

  /// Get device
  Future getDeviceDetailApi(String deviceUuid);

  /// Update device status
  Future updateStatusDeviceApi(String deviceUuid, bool status);

  // /// Export Device
  // Future exportDeviceApi();

  /// Delete device
  Future deleteDeviceApi(String deviceUuid);
}