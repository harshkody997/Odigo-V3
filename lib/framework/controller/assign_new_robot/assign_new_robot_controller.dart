import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/destination/contract/destination_details_repository.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/floor_list_response_model.dart';
import 'package:odigov3/framework/repository/device/contract/device_repositiry.dart';
import 'package:odigov3/framework/repository/device/model/device_list_model.dart';
import 'package:odigov3/framework/repository/device/model/device_list_request_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';


final assignNewRobotController = ChangeNotifierProvider(
      (ref) => getIt<AssignNewRobotController>(),
);

@injectable
class AssignNewRobotController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    isLoading = false;

    selectedFloor= null;
    selectedRobot= null;
    robotSelectionCtr.text = '';
    floorSelectionCtr.text = '';
    addedRobotList.clear();
    formKey.currentState?.reset();

    if (isNotify) {
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

  TextEditingController robotSelectionCtr = TextEditingController();
  TextEditingController floorSelectionCtr = TextEditingController();

  DeviceData? selectedRobot;
  FloorListDto? selectedFloor;

  // List<String> robotList = ['Robot1','Robot2','Robot3','Robot4','Robot5','Robot6'];
  List<int> floorList = [];

  updateFloorList(List<int> value){
    floorList.clear();
    floorList.addAll(value);
    notifyListeners();
  }
  ///update robot method
  updateRobotDropdown(DeviceData? value){
    selectedRobot = value;
    notifyListeners();
  }

  ///update floor method
  updateFloorDropdown(FloorListDto? value){
    selectedFloor = value;
    notifyListeners();
  }

  final formKey = GlobalKey<FormState>();


  clearRobotFloor(){
    robotSelectionCtr.text = '';
    floorSelectionCtr.text = '';
    selectedRobot = null;
    selectedFloor = null;
    notifyListeners();
  }

  clearRobotFloorControllers(){
    robotSelectionCtr.text = '';
    floorSelectionCtr.text = '';
    notifyListeners();
  }

  ///Selected robot list
  List<RobotFloorModel> addedRobotList = [];

  updateRobotList(RobotFloorModel value, BuildContext context) {
    bool isAlreadyAdded = addedRobotList.any((element) => element.robotUuid == value.robotUuid && element.floorNumber == value.floorNumber);

    if (isAlreadyAdded) {
      showErrorDialogue(
        context: context,
        dismissble: true,
        buttonText: LocaleKeys.keyOk.localized,
        onTap: () {
          Navigator.pop(context);
        },
        animation: Assets.anim.animErrorJson.keyName,
        successMessage: LocaleKeys.keyRobotAlreadyAdded.localized,
      );
    } else {
      addedRobotList.add(value);
      notifyListeners();
    }
  }


  ///Robot robot data to list
  removeAddedRobot(int index){
    addedRobotList.removeAt(index);
    notifyListeners();
  }

  ///updated exisitng data in list
  updateLocalRobotList(RobotFloorModel value){
    addedRobotList.add(value);
    notifyListeners();
  }

  ///Validate robot
  validateRobotDrop() {
    if(selectedRobot == null){
      return LocaleKeys.keyRobotSelectionRequired.localized;
    }
  }

  ///Floor robot
  validateFloorDrop() {
    if(selectedFloor == null){
     return LocaleKeys.keyNoOfFloorRequired.localized;
    }
  }


  /// Device list
  List<DeviceData>  devicesList = [];


  /// Search Controller
  TextEditingController searchCtr = TextEditingController();

  /// page no
  int pageNo = 1;


  DeviceRepository deviceRepository;
  DestinationDetailsRepository destinationDetailsRepository;

  AssignNewRobotController(this.deviceRepository,this.destinationDetailsRepository);


  UIState<DeviceListResponseModel> deviceListGlobalState = UIState<DeviceListResponseModel>();
  Future<UIState<DeviceListResponseModel>> deviceGlobalListApi(bool pagination, {bool? inStock, bool? isActive,String? destinationUuid}) async {

    int pageNo = 1;
    bool apiCall = true;
    if(!pagination){
      pageNo = 1;
      devicesList.clear();
      deviceListGlobalState.isLoading = true;
    }
    else if(deviceListGlobalState.success?.hasNextPage ?? false){
      pageNo = (deviceListGlobalState.success?.pageNumber ?? 0) + 1;
      deviceListGlobalState.isLoadMore = true;
      deviceListGlobalState.success = null;
    } else{
      apiCall = false;
    }

    notifyListeners();
    if(apiCall) {
      String request = deviceListRequestModelToJson(
          DeviceListRequestModel(
            searchKeyword: searchCtr.text,
            inStock: inStock,
            activeRecords: isActive,
          ));

      final result = await deviceRepository.deviceListApi(request, pageNo);
      result.when(success: (data) async {
        deviceListGlobalState.success = data;
        devicesList.addAll(deviceListGlobalState.success?.data ?? []);
      }, failure: (NetworkExceptions error) {});
      deviceListGlobalState.isLoading = false;
      deviceListGlobalState.isLoadMore = false;
      notifyListeners();
    }
    return deviceListGlobalState;
  }



  /// assign robots API
  var assignRobotApiState = UIState<DestinationDetailsResponseModel>();

  Future<UIState<DestinationDetailsResponseModel>> assignRobotApi(BuildContext context, String destinationUUid) async {
    assignRobotApiState.isLoading = true;
    assignRobotApiState.success = null;
    notifyListeners();

    List arrayData = [];
    addedRobotList.forEach((element) {
      arrayData.add({
        'robot': element.robotUuid,
        'destinationFloorUuid': element.floorUuid
      });
    },);

    Map<String, dynamic> request = {
      'destinationUuid': destinationUUid,
      'robotFloorNumbers': arrayData
    };

    final result = await destinationDetailsRepository.assignDeAssignRobotApi(jsonEncode(request));
    result.when(
      success: (data) async {
        assignRobotApiState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );

    assignRobotApiState.isLoading = false;
    notifyListeners();
    return assignRobotApiState;
  }


}

class RobotFloorModel{
  String? robotSerialName;
  String? robotHostName;
  String? robotUuid;
  String? floorNumber;
  String? floorUuid;

  RobotFloorModel({this.robotSerialName,this.robotHostName,this.floorNumber,this.floorUuid,this.robotUuid});

}
