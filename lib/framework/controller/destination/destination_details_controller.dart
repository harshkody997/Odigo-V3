import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/destination/contract/destination_details_repository.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_price_history_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/floor_list_response_model.dart';
import 'package:odigov3/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import '../../dependency_injection/inject.dart';


final destinationDetailsController = ChangeNotifierProvider(
      (ref) => getIt<DestinationDetailsController>(),
);

@injectable
class DestinationDetailsController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    destinationDetailsState.isLoading = true;
    destinationDetailsState.success = null;
    selectedTab = 0;
    currentDestinationUuid = '';
    updateDestinationPasscodeApiState.success = null;
    updateDestinationPasscodeApiState.isLoading = false;
    priceHistoryState.success = null;
    priceHistoryState.isLoading = false;
    priceHistoryList.clear();
    floorNameController.clear();
    floorListState.isLoading = false;
    floorListState.success = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  String? currentDestinationUuid;
  updateCurrentDestinationId(String value){
    currentDestinationUuid = value;
    notifyListeners();
  }

  GlobalKey editFloorNameDialogKey = GlobalKey();
  final GlobalKey<FormState> editFloorNameFormKey = GlobalKey<FormState>();
  TextEditingController floorNameController = TextEditingController();

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  ///Progress Indicator
  bool isLoading = false;

  void updateLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// Manage Robots status index
  int statusRobotTapIndex = -1;
  bool statusRobotValue = false;
  updateRobotListStatusIndex(int value){
    statusRobotTapIndex = value;
    statusRobotValue = !statusRobotValue;
    notifyListeners();
  }

  int selectedTab = 0;

  updateSelectedTab(int value){
    selectedTab = value;
    print('selectedTab ${selectedTab}');
    notifyListeners();
  }



  /// -------------- API INTEGRATIONS -----------------

  DestinationDetailsRepository destinationDetailsRepository;

  DestinationDetailsController(this.destinationDetailsRepository);

  /// destination details API
  var destinationDetailsState = UIState<DestinationDetailsResponseModel>();

  Future<void> destinationDetailsApi(BuildContext context, String destinationUUid) async {
    destinationDetailsState.isLoading = true;
    destinationDetailsState.success = null;
    notifyListeners();

    final result = await destinationDetailsRepository.destinationDetailsApi(context, destinationUUid);
    result.when(
      success: (data) async {
        destinationDetailsState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );

    destinationDetailsState.isLoading = false;
    notifyListeners();
  }


  ///-----------------Store List Api------------------------------->
  var storeListState = UIState<StoreListResponseModel>();
  List<StoreData?> storeList =[];

  Future<void> storeDestinationListApi(BuildContext context, {bool isForPagination = false, int? pageSize}) async {
    int pageNo = 1;
    bool apiCall = true;
    if(!isForPagination){
      pageNo = 1;
      storeList.clear();
      storeListState.isLoading = true;
      storeListState.success = null;
    }
    else if(storeListState.success?.hasNextPage ?? false){
      pageNo = (storeListState.success?.pageNumber ?? 0) + 1;
      storeListState.isLoadMore = true;
      storeListState.success = null;
    }
    else{
      apiCall = false;
    }
    notifyListeners();

    if(apiCall) {
      final result = await destinationDetailsRepository.storeDestinationListApi(destinationId: currentDestinationUuid ?? '', pageNumber: pageNo, dataSize: pageSize ?? AppConstants.pageSize);

      result.when(success: (data) async {
        storeListState.success = data;
        storeList.addAll(storeListState.success?.data ?? []);
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      });

      storeListState.isLoading = false;
      storeListState.isLoadMore = false;
      notifyListeners();
    }
  }


  void clearFormData() {
    isShowNewPassword = false;
    isShowConfirmPassword = false;
    confirmPasswordController.clear();
    newPasswordController.clear();
    notifyListeners();
  }




  final GlobalKey<FormState> changePasswordKey = GlobalKey<FormState>();


  GlobalKey changePasswordDialogKey = GlobalKey();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();

  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();

  ///show password variable
  bool isShowNewPassword = false;
  bool isShowConfirmPassword = false;

  /// to change  password visibility
  void changePasswordVisibility() {
    isShowNewPassword = !isShowNewPassword;
    notifyListeners();
  }
  /// to change  password visibility
  void changeConfirmPasswordVisibility() {
    isShowConfirmPassword = !isShowConfirmPassword;
    notifyListeners();
  }

  var updateDestinationPasscodeApiState = UIState<CommonResponseModel>();

  Future<UIState<CommonResponseModel>> updateDestinationPasscodeApi(BuildContext context, String destinationUUid) async {
    updateDestinationPasscodeApiState.isLoading = true;
    updateDestinationPasscodeApiState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {
      'uuid' : destinationUUid,
      'password' : newPasswordController.text
    };

    final result = await destinationDetailsRepository.updateDestinationPasscode(jsonEncode(request));
    result.when(
      success: (data) async {
        updateDestinationPasscodeApiState.success = data;

        if(updateDestinationPasscodeApiState.success?.status == ApiEndPoints.apiStatus_200) {
          destinationDetailsState.success?.data?.passcode = newPasswordController.text;
        }
      },
      failure: (NetworkExceptions error) {},
    );

    updateDestinationPasscodeApiState.isLoading = false;
    notifyListeners();
    return updateDestinationPasscodeApiState;
  }


  UIState<DestinationPriceHistoryResponseModel> priceHistoryState = UIState<DestinationPriceHistoryResponseModel>();
  List<PriceHistoryData?> priceHistoryList =[];

  Future<void> destinationPriceHistoryListApi(BuildContext context, {bool isForPagination = false, int? pageSize}) async {
    int pageNo = 1;
    bool apiCall = true;
    if (!isForPagination) {
      pageNo = 1;
      priceHistoryList.clear();
      priceHistoryState.isLoading = true;
      priceHistoryState.success = null;
    }
    else if (priceHistoryState.success?.hasNextPage ?? false) {
      pageNo = (priceHistoryState.success?.pageNumber ?? 0) + 1;
      priceHistoryState.isLoadMore = true;
      priceHistoryState.success = null;
    }
    else {
      apiCall = false;
    }
    notifyListeners();

    if (apiCall) {
      final result = await destinationDetailsRepository.destinationPriceHistory(pageNo, destinationUuid: currentDestinationUuid ?? '');

      result.when(success: (data) async {
        priceHistoryState.success = data;
        priceHistoryList.addAll(priceHistoryState.success?.data ?? []);
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      });

      priceHistoryState.isLoading = false;
      priceHistoryState.isLoadMore = false;
      notifyListeners();
    }
  }

  ///----------------- Store details Api------------------------------->
  var floorListState = UIState<FloorListResponseModel>();
  List<FloorListDto>? floorList = [];

  Future<void> floorListApi(BuildContext context, String destinationUuid) async {
    floorListState.isLoading = true;
    floorListState.success = null;
    floorList?.clear();
    notifyListeners();

    Map<String, dynamic> request = {
        'destinationUuid': destinationUuid
        // "searchKeyword": "string",
        // "floorNumber": 0
      };

    final result = await destinationDetailsRepository.floorListApi(jsonEncode(request));

    result.when(
      success: (data) async {
        floorListState.success = data;
        floorList?.addAll(floorListState.success?.data ?? []);
      },
      failure: (NetworkExceptions error) {
        //String errorMsg = NetworkExceptions.getErrorMessage(error);
        //       showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    floorListState.isLoading = false;
    notifyListeners();
  }

}