import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/destination/contract/destination_details_repository.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';
import '../../dependency_injection/inject.dart';


final assignNewStoreController = ChangeNotifierProvider(
      (ref) => getIt<AssignNewStoreController>(),
);

@injectable
class AssignNewStoreController extends ChangeNotifier {

  final formKey = GlobalKey<FormState>();

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    isLoading = false;

    selectedFloor= null;
    selectedStore= null;
    storeSelectionCtr.clear();
    floorSelectionCtr.clear();
    addedStoreList.clear();
    formKey.currentState?.reset();
    showLog("storeSelectionCtr.text ${storeSelectionCtr.text}");
    showLog("floorSelectionCtr.text ${floorSelectionCtr.text}");
    showLog("selectedFloor??'' ${selectedFloor}");
    showLog("selectedStore ${selectedStore}");
    if(isNotify) {
      notifyListeners();
    }
  }

  clearStoreAssignedList(){
    addedStoreList.clear();
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

  TextEditingController storeSelectionCtr = TextEditingController();
  TextEditingController floorSelectionCtr = TextEditingController();

  StoreData? selectedStore;
  String? selectedFloor;

  List<int> floorList = [];

  updateFloorList(List<int> value){
    floorList.clear();
    floorList.addAll(value);
    notifyListeners();
  }
  ///update store method
  updateStoreDropdown(StoreData? value){
    selectedStore = value;
    notifyListeners();
  }

  ///update floor method
  updateFloorDropdown(String? value){
    selectedFloor = value;
    notifyListeners();
  }

  clearStoreFloor(){
    storeSelectionCtr.text = '';
    floorSelectionCtr.text = '';
    notifyListeners();
  }

  ///Selected store list
  List<StoreFloorModel> addedStoreList = [];

  ///Add store data to list
  updateStoreList(StoreFloorModel value, BuildContext context) {
    final isDuplicate = addedStoreList.any((element) =>
    element.storeUuid == value.storeUuid &&
        element.floorNumber == value.floorNumber);

    if (isDuplicate) {
      // Clipboard.setData(ClipboardData(text: LocaleKeys.keyOk.localized));
      // showToast(context: context,isSuccess: true,title:LocaleKeys.keyCopiedToClipboard.localized,duration:500);
      showErrorDialogue(
        context: context,
        dismissble: true,
        buttonText: LocaleKeys.keyOk.localized,
        onTap: () {
          Navigator.pop(context);
        },
        animation: Assets.anim.animErrorJson.keyName,
        successMessage: LocaleKeys.keyStoreAlreadyAssigned.localized,
      );
    } else {
      addedStoreList.add(value);
    }

    notifyListeners();
  }


  ///store store data to list
  removeAddedStore(int index){
    addedStoreList.removeAt(index);
    notifyListeners();
  }

  ///Validate store
  validateStoreDrop() {
    if(selectedStore == null){
      return LocaleKeys.keyStoreSelectionRequired.localized;
    }
  }

  ///Floor store
  validateFloorDrop() {
    if(selectedFloor == null){
      return LocaleKeys.keyNoOfFloorRequired.localized;
    }
  }

  /// -------------- API INTEGRATIONS -----------------

  DestinationDetailsRepository destinationDetailsRepository;

  AssignNewStoreController(this.destinationDetailsRepository);


  /// assign store API
  var assignStoreApiState = UIState<DestinationDetailsResponseModel>();


  Future<UIState<DestinationDetailsResponseModel>> assignStoreApi(BuildContext context, String destinationUUid) async {
    assignStoreApiState.isLoading = true;
    assignStoreApiState.success = null;
    notifyListeners();


    List arrayData = [];
    addedStoreList.forEach((element) {
      arrayData.add({
        'storeUuid': element.storeUuid,
        'floorNumber': element.floorNumber
      });
      print('arrayData ${arrayData}');
    },);

    Map<String, dynamic> request = {
      'destinationUuid': destinationUUid,
      'storeAssignDeassignDTOs': arrayData
    };

    final result = await destinationDetailsRepository.assignDeAssignStoreApi(jsonEncode(request));
    result.when(
      success: (data) async {
        assignStoreApiState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );

    assignStoreApiState.isLoading = false;
    notifyListeners();
    return assignStoreApiState;
  }

}

class StoreFloorModel{
  String? storeName;
  String? storeUuid;
  String? floorNumber;

  StoreFloorModel({this.storeName,this.floorNumber,this.storeUuid});

}
