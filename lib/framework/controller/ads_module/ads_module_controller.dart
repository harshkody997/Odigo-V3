
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/default_ads/contract/default_ads_repository.dart';
import 'package:odigov3/framework/repository/default_ads/model/default_ads_list_response_model.dart';
import 'package:odigov3/framework/repository/default_ads/model/request_model/default_ads_list_request_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';


final adsModuleController = ChangeNotifierProvider(
      (ref) => getIt<AdsModuleController>(),
);

@injectable
class AdsModuleController extends ChangeNotifier {
  AdsModuleController(this.defaultAdsRepository);
  DefaultAdsRepository defaultAdsRepository;

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    defaultAdsListState.isLoading = true;
    defaultAdsListState.success = null;
    defaultAdsList.clear();
    statusTapIndex = -1;
    changeDefaultAdsStatusState.success = null;
    changeDefaultAdsStatusState.isLoading = false;
    searchCtr.clear();
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    selectedDestinationFilter = null;
    selectedDestinationTempFilter = null;
    destinationCtr.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  GlobalKey editAdNameDialogKey = GlobalKey();

  /// Search Controller
  TextEditingController searchCtr = TextEditingController();

  int selectedTab = 0;

  updateSelectedTab(int value) {
    selectedTab = value;
    // notifyListeners();
  }


  int statusTapIndex = -1;

  updateStatusIndex(int value){
    statusTapIndex = value;
    notifyListeners();
  }

  /// Filter key
  GlobalKey filterKey = GlobalKey();
  TextEditingController destinationCtr = TextEditingController();

  CommonEnumTitleValueModel? selectedFilter = commonActiveDeActiveList[0];
  CommonEnumTitleValueModel? selectedTempFilter = commonActiveDeActiveList[0];
  updateTempSelectedStatus(CommonEnumTitleValueModel? value){
    selectedTempFilter = value;
    notifyListeners();
  }

  updateSelectedStatus(CommonEnumTitleValueModel? value){
    selectedFilter = value;
    notifyListeners();
  }

  DestinationData? selectedDestinationFilter = null;
  DestinationData? selectedDestinationTempFilter = null;
  updateTempSelectedDestination(DestinationData? value){
    selectedDestinationTempFilter = value;
    destinationCtr.text = selectedDestinationTempFilter?.name ?? '';
    notifyListeners();
  }

  updateSelectedDestination(DestinationData? value){
    selectedDestinationFilter = value;
    notifyListeners();
  }

  resetFilter(){
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    selectedDestinationFilter = null;
    selectedDestinationTempFilter = null;
    destinationCtr.clear();
    notifyListeners();
  }

  bool get isFilterSelected => selectedFilter != selectedTempFilter || selectedDestinationFilter != selectedDestinationTempFilter;

  bool get isClearFilterCall => (selectedFilter == selectedTempFilter && selectedTempFilter != commonActiveDeActiveList[0]) || (selectedDestinationFilter == selectedDestinationTempFilter) ;


  /// ----------------------------------------------- Api Integration ----------------------------------------------------///

  ///-----------------Default ads List Api------------------------------->
  var defaultAdsListState = UIState<DefaultAdsListResponseModel>();
  List<DefaultAdsListData?> defaultAdsList =[];

  Future<UIState<DefaultAdsListResponseModel>> defaultAdsListApi(BuildContext context, {bool isForPagination = false, int? pageSize}) async {
    int pageNo = 1;
    bool apiCall = true;
    if(!isForPagination){
      pageNo = 1;
      defaultAdsList.clear();
      defaultAdsListState.isLoading = true;
      defaultAdsListState.success = null;
    }
    else if(defaultAdsListState.success?.hasNextPage ?? false){
      pageNo = (defaultAdsListState.success?.pageNumber ?? 0) + 1;
      defaultAdsListState.isLoadMore = true;
      defaultAdsListState.success = null;
    }
    else{
      apiCall = false;
    }
    notifyListeners();

    if(apiCall) {
      String request = defaultAdsListRequestModelToJson(DefaultAdsListRequestModel(
        searchKeyword: searchCtr.text,
        isArchive: false,
        activeRecords: selectedFilter?.value,
        destinationUuid: selectedDestinationFilter?.uuid
      ));

      final result = await defaultAdsRepository.defaultAdsListApi(request: request, pageNumber: pageNo, dataSize: pageSize ?? AppConstants.pageSize);

      result.when(success: (data) async {
        defaultAdsListState.success = data;
        defaultAdsList.addAll(defaultAdsListState.success?.data ?? []);
      }, failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      });

      defaultAdsListState.isLoading = false;
      defaultAdsListState.isLoadMore = false;
      notifyListeners();
    }
    return defaultAdsListState;

  }

  ///-----------------Change DefaultAds Status Api------------------------------->
  var changeDefaultAdsStatusState = UIState<CommonResponseModel>();

  Future<void> changeDefaultAdsStatusApi(BuildContext context, {required String uuid, required bool isActive, required int index}) async {
    changeDefaultAdsStatusState.isLoading = true;
    changeDefaultAdsStatusState.success = null;
    notifyListeners();

    final result = await defaultAdsRepository.changeDefaultAdsStatusApi(adsUuid: uuid, isActive: isActive);

    result.when(success: (data) async {
      changeDefaultAdsStatusState.success = data;
      if(changeDefaultAdsStatusState.success?.status == ApiEndPoints.apiStatus_200) {
        defaultAdsList[index]?.active = isActive;
      }
    },
        failure: (NetworkExceptions error) {
          //String errorMsg = NetworkExceptions.getErrorMessage(error);
          //       showCommonErrorDialog(context: context, message: errorMsg);
        });

    changeDefaultAdsStatusState.isLoading = false;
    notifyListeners();
  }

  ///-----------------DefaultAds delete Api------------------------------->
  var deleteDefaultAdsState = UIState<CommonResponseModel>();

  Future<void> deleteDefaultAdsApi(BuildContext context, {required String uuid, required int index}) async {
    deleteDefaultAdsState.isLoading = true;
    deleteDefaultAdsState.success = null;
    notifyListeners();

    final result = await defaultAdsRepository.deleteDefaultAdsApi(adsUuid: uuid);

    result.when(success: (data) async {
      deleteDefaultAdsState.success = data;
      if(deleteDefaultAdsState.success?.status == ApiEndPoints.apiStatus_200) {
        defaultAdsList.removeAt(index);
      }
    },
        failure: (NetworkExceptions error) {
          //String errorMsg = NetworkExceptions.getErrorMessage(error);
          //       showCommonErrorDialog(context: context, message: errorMsg);
        });

    deleteDefaultAdsState.isLoading = false;
    notifyListeners();
  }

}