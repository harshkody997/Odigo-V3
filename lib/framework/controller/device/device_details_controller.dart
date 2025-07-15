import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/device/contract/device_repositiry.dart';
import 'package:odigov3/framework/repository/device/model/device_details_reponse_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import '../../dependency_injection/inject.dart';


final deviceDetailsController = ChangeNotifierProvider(
      (ref) => getIt<DeviceDetailsController>(),
);

@injectable
class DeviceDetailsController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool? isNotify}) {
    isLoading = false;
    deviceDetailsState.isLoading = true;
    deviceDetailsState.success = null;

    if (isNotify??false) {
      notifyListeners();
    }
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
  DeviceDetailsController(this.deviceRepository);

  /// Device details
  UIState<DeviceDetailsResponseModel> deviceDetailsState = UIState<DeviceDetailsResponseModel>();
  Future<UIState<DeviceDetailsResponseModel>> deviceDetailsApi({required String deviceUuid}) async {
    deviceDetailsState.isLoading = true;
    deviceDetailsState.success = null;
    notifyListeners();
    final result = await deviceRepository.getDeviceDetailApi(deviceUuid);
    result.when(success: (data) async {
      deviceDetailsState.success = data;
    }, failure: (NetworkExceptions error) {});
    deviceDetailsState.isLoading = false;
    notifyListeners();
    return deviceDetailsState;
  }
}
