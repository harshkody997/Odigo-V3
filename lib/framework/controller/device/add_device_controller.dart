import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/device/contract/device_repositiry.dart';
import 'package:odigov3/framework/repository/device/model/add_update_device_request_model.dart';
import 'package:odigov3/framework/repository/device/model/device_list_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';


final addDeviceController = ChangeNotifierProvider(
      (ref) => getIt<AddDeviceController>(),
);

@injectable
class AddDeviceController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool? isNotify }) {
    isLoading = false;
    /// Clear form
    clearForm();
    if (isNotify??false) {
      notifyListeners();
    }
  }

  /// Clear form
  void clearForm(){
    serialNoCtr.clear();
    hostNameCtr.clear();
    navigationVersionCtr.clear();
    powerBoardVersionCtr.clear();
    packageIdCtr.clear();
    androidIdCtr.clear();
    sensorDetails = SensorDetails(
        isImuOk: false,
        isOdomOk: false,
        is3DCameraOk: false,
        isLidarOk: false
    );
    addUpdateDeviceState.success = null;
    addUpdateDeviceState.isLoading = false;
    Future.delayed(const Duration(milliseconds: 50), () {
      addDeviceFormKey.currentState?.reset();
    });
  }

  /// Text Editing Controllers
  TextEditingController serialNoCtr = TextEditingController();
  TextEditingController hostNameCtr = TextEditingController();
  TextEditingController navigationVersionCtr = TextEditingController();
  TextEditingController powerBoardVersionCtr = TextEditingController();
  TextEditingController packageIdCtr = TextEditingController();
  TextEditingController androidIdCtr = TextEditingController();

  /// Focus nodes
  FocusNode serialNoFocus = FocusNode();
  FocusNode hostNameFocus = FocusNode();
  FocusNode navigationFocus = FocusNode();
  FocusNode powerBoardVersionFocus = FocusNode();
  FocusNode packageIdFocus = FocusNode();
  FocusNode androidIdFocus = FocusNode();

  /// Device Detail uuid
  String? deviceDetailUuid;

  /// Form Key
  GlobalKey<FormState> addDeviceFormKey = GlobalKey<FormState>();

  /// Sensor Deatils object
  SensorDetails  sensorDetails = SensorDetails(
      isImuOk: false,
      isOdomOk: false,
      is3DCameraOk: false,
      isLidarOk: false
  );

  /// Update Sensor status
  void updateSensorStatus({bool? imuStatus,bool? odomStatus,bool? cameraStatus,bool? lidarStatus }){
    sensorDetails.isImuOk = imuStatus ?? sensorDetails.isImuOk;
    sensorDetails.isOdomOk = odomStatus ?? sensorDetails.isOdomOk;
    sensorDetails.is3DCameraOk = cameraStatus ?? sensorDetails.is3DCameraOk;
    sensorDetails.isLidarOk = lidarStatus ?? sensorDetails.isLidarOk;
    notifyListeners();
  }

  void fillFormOnUpdate(DeviceData deviceData){
    serialNoCtr.text = deviceData.serialNumber??'';
    hostNameCtr.text = deviceData.hostName??'';
    navigationVersionCtr.text =  deviceData.navigationVersion??'';
    powerBoardVersionCtr.text = deviceData.powerBoardVersion??'';
    packageIdCtr.text =  deviceData.deviceDetails?.firstOrNull?.packageId??'';
    androidIdCtr.text = deviceData.deviceDetails?.firstOrNull?.applicationId??'';
    deviceDetailUuid = deviceData.deviceDetails?.firstOrNull?.uuid??'';
    sensorDetails = SensorDetails(
        isImuOk: deviceData.sensorDetails?.isImuOk,
        isOdomOk: deviceData.sensorDetails?.isOdomOk,
        is3DCameraOk: deviceData.sensorDetails?.is3DCameraOk,
        isLidarOk: deviceData.sensorDetails?.isLidarOk,
    );
    notifyListeners();
  }



  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  ///Progress Indicator
  bool isLoading = false;

  void updateLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }
  DeviceRepository deviceRepository;
  AddDeviceController(this.deviceRepository);

  UIState<CommonResponseModel> addUpdateDeviceState = UIState<CommonResponseModel>();
  Future<void> addUpdateDeviceApi({String? deviceUuid }) async {
    addUpdateDeviceState.isLoading = true;
    addUpdateDeviceState.success = null;
    notifyListeners();
    String request = addUpdateDeviceRequestModelToJson(
       !(deviceUuid != null)? AddUpdateDeviceRequestModel(
          hostName: hostNameCtr.text,
          serialNumber: serialNoCtr.text,
          powerBoardVersion: powerBoardVersionCtr.text,
          navigationVersion: navigationVersionCtr.text,
          sensorDetails: sensorDetails,
          deviceDetails: [
            DeviceDetail(
              uuid: deviceDetailUuid,
              applicationId: androidIdCtr.text,
              packageId: packageIdCtr.text,
              robotDeviceType: 'MAIN_PANEL',
            ),
          ],
        ):
        AddUpdateDeviceRequestModel(
          uuid: deviceUuid,
          hostName: hostNameCtr.text,
          serialNumber: serialNoCtr.text,
          powerBoardVersion: powerBoardVersionCtr.text,
          navigationVersion: navigationVersionCtr.text,
          sensorDetails: sensorDetails,
          deviceDetails: [
            DeviceDetail(
              uuid: deviceDetailUuid,
              applicationId: androidIdCtr.text,
              packageId: packageIdCtr.text,
              robotDeviceType: 'MAIN_PANEL',
            ),
      ],
    ));
    final result = await deviceRepository.addUpdateDeviceApi(request,isUpdate: deviceUuid!=null);
    result.when(success: (data) async {
      addUpdateDeviceState.success = data;
    }, failure: (NetworkExceptions error) {});
    addUpdateDeviceState.isLoading = false;
    notifyListeners();
  }
}
