import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/city/contract/city_repository.dart';
import 'package:odigov3/framework/repository/master/city/model/city_list_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';


final cityListController = ChangeNotifierProvider(
      (ref) => getIt<CityListController>(),
);

@injectable
class CityListController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    searchCtr.clear();
    cityList.clear();
    cityListState.success = null;
    cityListState.isLoading = false;
    cityListState.isLoadMore = false;
    statusTapIndex = -1;
    changeCityStatusState.isLoading = false;
    changeCityStatusState.success = null;
    pageNo = 1;
    totalCount = null;
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    if (isNotify) {
      notifyListeners();
    }
  }

  clearCityList(){
    cityList.clear();
    cityListState.success = null;
    cityListState.isLoading = false;
    cityListState.isLoadMore = false;
    pageNo = 1;
    totalCount = null;
    notifyListeners();
  }

  TextEditingController searchCtr = TextEditingController();
  List<CityModel> cityList = [];
  Timer? debounce;
  int statusTapIndex = -1;
  int pageNo = 1;
  int? totalCount;
  /// Filter key
  GlobalKey filterKey = GlobalKey();

  updateStatusIndex(int value){
    statusTapIndex = value;
    notifyListeners();
  }

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

  resetFilter(){
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    notifyListeners();
  }

  bool get isFilterSelected => selectedFilter != selectedTempFilter;

  bool get isClearFilterCall => (selectedFilter == selectedTempFilter && selectedTempFilter != commonActiveDeActiveList[0]);

  bool get isFilterApplied => selectedFilter != null && selectedFilter != commonActiveDeActiveList[0];

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  CityRepository cityRepository;
  CityListController(this.cityRepository);

  /// city list api
  UIState<CityListResponseModel> cityListState = UIState<CityListResponseModel>();
  Future getCityListAPI(BuildContext context,{bool pagination = false, int? pageSize,bool? activeRecords,String? stateUuid}) async {
    if((cityListState.success?.hasNextPage ?? false) && pagination){
      pageNo = pageNo + 1;
    }

    if (pageNo == 1) {
      cityListState.isLoading = true;
      cityList.clear();
    } else {
      cityListState.isLoadMore = true;
    }
    cityListState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {
      'searchKeyword':searchCtr.text,
      'activeRecords':activeRecords ?? selectedFilter?.value,
      'stateUuid':stateUuid,
    };
    final result = await cityRepository.getCityListAPI(pageNo, pageSize ?? AppConstants.pageSize,jsonEncode(request));

    result.when(
      success: (data) async {
        cityListState.success = data;
        cityList.addAll(cityListState.success?.data ?? []);
        totalCount = cityListState.success?.totalCount;
        cityListState.isLoading = false;
        cityListState.isLoadMore = false;
      },
      failure: (NetworkExceptions error) {
        cityListState.isLoading = false;
        cityListState.isLoadMore = false;
      },
    );
    cityListState.isLoading = false;
    cityListState.isLoadMore = false;
    notifyListeners();
  }

  /// change city status api
  UIState<CommonResponseModel> changeCityStatusState = UIState<CommonResponseModel>();
  Future changeCityStatusAPI(BuildContext context,String uuid,bool status,int index) async {
    changeCityStatusState.isLoading = true;
    changeCityStatusState.success = null;
    notifyListeners();

    final result = await cityRepository.changeCityStatusApi(uuid,status);

    result.when(
      success: (data) async {
        notifyListeners();
        changeCityStatusState.isLoading = false;
        changeCityStatusState.success = data;
        if(changeCityStatusState.success?.status == ApiEndPoints.apiStatus_200){
          cityList[index].active = status;
        }
      },
      failure: (NetworkExceptions error) {
        changeCityStatusState.isLoading = false;
      },
    );
    changeCityStatusState.isLoading = false;
    notifyListeners();
  }

}
