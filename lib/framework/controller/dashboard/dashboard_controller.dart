import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/client/model/response/client_list_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/contract/dashboard_repository.dart';
import 'package:odigov3/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/category_data_list_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/dashboard_count_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/dashboard_peak_usage_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/dashboard_week_interaction_count_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/destination_name_data_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/most_requested_store_request_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/most_requested_store_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/navigation_efficiency_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/request_model/dashboard_week_interaction_count_request_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/request_model/interactions_request_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/request_model/uptime_request_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/response_model/interactions_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/robot_data_list_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/store_data_list_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/total_navigation_request_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/request_model/dashboard_peak_usage_request_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/total_navigation_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/uptime_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/request_model/ads_count_request_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/response_model/ads_count_response_model.dart';
import 'package:odigov3/framework/repository/notification/model/device_detail_request_model.dart';
import 'package:odigov3/framework/utils/extension/int_extension.dart';
import 'package:odigov3/framework/utils/extension/time_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_functions.dart';

final dashboardController = ChangeNotifierProvider((ref) => getIt<DashboardController>());

@injectable
class DashboardController extends ChangeNotifier {

  DashboardRepository dashboardRepository;
  DashboardController(this.dashboardRepository, this.authRepository);

  disposeController({bool isNotify = false}){
    selectedDestination = null;
    destinationSearchCtr.clear();
    yearsDynamicList.clear();
    for (int i = 0; i <= numPreviousYears; i++) {
      yearsDynamicList.add((DateTime.now().year - i).toString());
    }
    destinationList.clear();
    destinationNameListState.success = null;
    mostRequestedStoreListState.success = null;
    navigationEfficiencyState.success = null;
    destinationNameListState.isLoading = false;
    destinationNameListState.isLoadMore = false;
    categoryDataListState.success = null;
    categoryDataListState.isLoading = false;
    categoryDataListState.isLoadMore = false;
    storeDataListState.success = null;
    storeDataListState.isLoading = false;
    storeDataListState.isLoadMore = false;
    robotDataListState.success = null;
    robotDataListState.isLoading = false;
    robotDataListState.isLoadMore = false;
    dashboardCountState.success = null;
    dashboardCountState.isLoading = true;
    xTitlesPeakUsage = ['10:00-12:00', '12:00-02:00', '02:00-04:00', '04:00-06:00'];
    monthGraphDataListPeakUsage = [0,0,0,0];
    selectedPeakUsageCategory = null;
    peakUsageCategoryList.clear();
    peakUsageCategorySearchCtr.clear();
    peakUsageStoreList.clear();
    selectedPeakUsageStore = null;
    peakUsageStoreSearchCtr.clear();
    peakUsageSelectedDate = DateTime.now();
    dashboardPeakUsageState.success= null;
    dashboardPeakUsageState.isLoading = false;
    commonCategoryList.clear();
    weekInteractionCountCategoryList.clear();
    selectedWeekInteractionCountCategory = null;
    weekInteractionCountCategorySearchCtr.clear();
    weekInteractionCountStoreList.clear();
    selectedWeekInteractionCountStore = null;
    weekInteractionCountStoreSearchCtr.clear();
    startDateWeekdays = DateTime.now().subtract(const Duration(days: 6));
    endDateWeekdays = DateTime.now();
    weekInteractionCountDateController.text = formatDateRange([
      DateTime.now().subtract(const Duration(days: 6)),
      DateTime.now(),
    ]);
    dashboardWeekInteractionCountState.success = null;
    dashboardWeekInteractionCountState.isLoading = false;
    selectedUptimeRobot = null;
    uptimeRobotSearchCtr.clear();
    uptimeSelectedDate = DateTime.now().subtract(Duration(days: 1));
    dashboardUptimeState.isLoading = false;
    dashboardUptimeState.success = null;
    navigationRequestType = false;
    navigationRequestStoreList.clear();
    navigationRequestStoreList.addAll(commonStoreList);
    selectedNavigationRequestStore = null;
    navigationRequestStoreSearchCtr.clear();
    selectedNavigationMonth = null;
    selectedNavigationRequestYear = DateTime.now().year.toString();
    totalNavigationRequestState.success = null;
    totalNavigationRequestState.isLoading = false;
    averageNavigationRequestState.success = null;
    averageNavigationRequestState.isLoading = false;
    selectedInteractionCategory = null;
    interactionCategoryList.clear();
    interactionCategoryList.addAll(commonCategoryList);
    interactionCategorySearchCtr.clear();
    selectedInteractionStore = null;
    interactionStoreList.clear();
    interactionStoreSearchCtr.clear();
    selectedYearInteractionsIndex=DateTime.now().year.toString();
    selectedInteractionMonth=null;
    interactionInitialType=false;
    selectedClient = null;
    selectedAdsCountMonth= null;
    selectedYearAdsCount = '${DateTime.now().year}';
    if(isNotify) {
      notifyListeners();
    }
  }


  /// overview
  String? overviewMonth;
  String? overviewYear;


  updateOverviewMonth(String overviewMonth) {
    this.overviewMonth = overviewMonth;
    notifyListeners();
  }

  updateOverviewYear(String overviewYear) {
    this.overviewYear = overviewYear;
    notifyListeners();
  }

  /// earning
  List<String> earningTabList = [LocaleKeys.keyAllTime, LocaleKeys.keyVendor, LocaleKeys.keyAgency];
  String? selectedEarningTab = LocaleKeys.keyAllTime;

  updateSelectedEarningTab(String selectedEarningTab) {
    this.selectedEarningTab = selectedEarningTab;
    notifyListeners();
  }

  List<String> daysList =['1','2','3','4','5'];
  String? dayOfMonth;

  void updateDay(String? selectedDay) {
    dayOfMonth = selectedDay;
    notifyListeners();
  }


  /// sales
  List<String> salesTabList = [LocaleKeys.keyClients, LocaleKeys.keyVendor, LocaleKeys.keyAgency];
  String? selectedSalesTab = LocaleKeys.keyClients;

  updateSelectedSalesTab(String selectedSalesTab) {
    this.selectedSalesTab = selectedSalesTab;
    notifyListeners();
  }


  List<CategoryDataListDto> mostRequestedCategoryList = [];
  CategoryDataListDto? selectedMostRequestedStoreCategory;
  TextEditingController mostRequestedCategorySearchCtr = TextEditingController();

  void updateMostRequestedSelectedCategory(CategoryDataListDto? selectedCategory) {
    selectedMostRequestedStoreCategory = selectedCategory;
    notifyListeners();
  }


  resetEfficiency()
  {
    selectedEfficiencyStore = null;
    efficiencyStoreSearchCtr.clear();
    notifyListeners();
  }

  resetMostRequestedStoreData()
  {
    selectedEfficiencyStore = null;
    mostRequestedStoreMonth =null;
    mostRequestedStoreYear =null;
    selectedMostRequestedStoreCategory =null;
    dayOfMonth =null;
    mostRequestedCategorySearchCtr.clear();

    notifyListeners();
  }

  List<String> storeList = ['Store 1', 'Store 2'];
  String? selectedStore;


  updateSelectedStore(String selectedStore) {
    this.selectedStore = selectedStore;
    notifyListeners();
  }

  DateTime? uptimeFilterDate;

  updateUptimeFilterDate(DateTime uptimeFilterDate) {
    this.uptimeFilterDate = uptimeFilterDate;
    notifyListeners();
  }

  /// most requested store
  String? mostRequestedStoreMonth;
  String? mostRequestedStoreYear;

  final monthMap = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };
  void updateMostRequestedStoreMonth(String month) {
    mostRequestedStoreMonth = month;
    daysList = AppConstants.constant.getDaysList(mostRequestedStoreMonth);
    notifyListeners();
  }

  void updateMostRequestedStoreYear(String year) {
    mostRequestedStoreYear = year;
    notifyListeners();
  }


  final OverlayPortalController tooltipControllerClientAdsCount = OverlayPortalController();

  void hideTooltipControllerCategoryAdsCount() {
    if (tooltipControllerClientAdsCount.isShowing) {
      tooltipControllerClientAdsCount.hide();
    }
  }



  int selectedYearIndex = 0 ;
  String? selectedYearAdsCount=DateTime.now().year.toString();

  List<String> yearsDynamicList = [];
  String? selectedAdsCountMonth;
  String? selectedYear = DateTime.now().year.toString();
  String? selectedMonth;

  int? adsCountDayOfMonth;
  List<int> adsCountDaysList =[1,2,3,4,5];

  List<String> xTitlesAdsCountRequests = ['Jan', 'Feb', 'March', 'April', 'May', 'June', 'July','August','Sept','Oct','Nov','Dec'];

  bool adsCountInitialType = false; /// true = average, false= total
  adsCountInteractionsGraphValues(){
    adsCountInitialType = !adsCountInitialType;
    showLog('adsCountInitialType $adsCountInitialType');
    notifyListeners();
  }

  disposeAdsCountGraphData(){
    selectedClient = null;
    selectedAdsCountMonth= null;
    selectedYearAdsCount = '${DateTime.now().year}';
    adsCountInitialType = false;
    notifyListeners();
  }

  void updateAdsCountMonthYear(String selectedMonth) {
    selectedAdsCountMonth = selectedMonth;
    adsCountDaysList = getDaysList(selectedMonth);

    notifyListeners();
  }

  /// Function to update the year
  Future<void> updateYearAdsCountIndex(BuildContext context, String value) async {
    selectedYearAdsCount = value;
    notifyListeners();
  }

  void clearAdsCountMonthYear(dynamic selectedMonth) {
    selectedAdsCountMonth = selectedMonth;
    notifyListeners();
  }


  Future<void> getYears() async{
    yearsDynamicList.clear();
    for (int i = 0; i <= numPreviousYears; i++) {
      yearsDynamicList.add((DateTime.now().year - i).toString());
    }
    notifyListeners();
  }

  ClientData? selectedClient;

  void updateSelectedClient(ClientData? value) {
    selectedClient = value;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  /// all graph api call / init
  void allGraphApiCall(BuildContext context, WidgetRef ref){
    dashboardPeakUsageApi(context, ref);
    mostRequestedStoreApi(context);
    navigationEfficiencyApi(context);
    dashboardWeekInteractionCountApi(context, ref);
    adsCountApi(context);
    navigationRequestApiCall(context);
    interactionApiCall(context);
  }


  /// destination dropdown
  DestinationNameData? selectedDestination;
  TextEditingController destinationSearchCtr = TextEditingController();

  void updateSelectedDestination(BuildContext context, WidgetRef ref, DestinationNameData? selectedDestination) {
    this.selectedDestination = selectedDestination;
    destinationSearchCtr.text = selectedDestination?.name??'';
    if(selectedDestination != null){
      robotDataListApi(context, ref, robotDataList: uptimeRobotList,);
      storeDataListApi(context, ref, storeDataList: efficiencyStoreList, initial: true,);
      allGraphApiCall(context, ref);
    }
    notifyListeners();
  }

  ///---Interaction

  String? selectedInteractionMonth;
  List<int> interactionDaysList =[1,2,3,4,5];
  String? selectedYearInteractionsIndex = DateTime.now().year.toString() ;
  List<String> xTitlesInteractionRequests = ['Jan', 'Feb', 'March', 'April', 'May', 'June', 'July','August','Sept','Oct','Nov','Dec'];
  int selectedYearInteractionsTotalIndex = 0 ;
  double maxInteractionsValue = 10000.0;
  List<String> xTitlesInteractionTotalRequests = ['Jan', 'Feb', 'March', 'April', 'May', 'June', 'July','August','Sept','Oct','Nov','Dec'];
  bool interactionInitialType = false; /// true = average, false= total

  updateInteractionsGraphValues(){
    interactionInitialType = !interactionInitialType;
    showLog('interactionInitialType $interactionInitialType');
    notifyListeners();
  }


  void updateInteractionMonthYear(String selectedMonth) {
    selectedInteractionMonth = selectedMonth;
    interactionDaysList =  getDaysList(selectedMonth);

    notifyListeners();
  }


  /// Function to update the year
  Future<void> updateYearInteractionsIndex(BuildContext context, String index) async {
    selectedYearInteractionsIndex = index;
    notifyListeners();
  }


  disposeInteractionValue(){
    selectedInteractionCategory = null;
    interactionCategoryList.clear();
    interactionCategoryList.addAll(commonCategoryList);
    interactionCategorySearchCtr.clear();
    selectedInteractionStore = null;
    interactionStoreList.clear();
    interactionStoreSearchCtr.clear();
    selectedYearInteractionsIndex=DateTime.now().year.toString();
    selectedInteractionMonth=null;
    interactionInitialType=false;
    notifyListeners();
  }



  ///-----------------------------------------Destination data list api --------------------------------------------------------------
  var destinationNameListState = UIState<DestinationNameDataResponseModel>();
  List<DestinationNameData> destinationList = [];

  Future<void> destinationDataListApi(BuildContext context, WidgetRef ref, {bool isForPagination = false}) async {
    int pageNo = 1;
    bool apiCall = true;

    if (!isForPagination) {
      ref.read(searchController).updateLoader(true);
      pageNo = 1;
      destinationList.clear();
      destinationNameListState.isLoading = true;
      destinationNameListState.success = null;
    } else if ((destinationNameListState.success?.hasNextPage == true) && !destinationNameListState.isLoadMore) {
      ref.read(searchController).updateLoadMore(true);
      pageNo = (destinationNameListState.success?.pageNumber ?? 0) + 1;
      destinationNameListState.isLoadMore = true;
      destinationNameListState.success = null;
    } else {
      apiCall = false;
    }

    notifyListeners();

    if (apiCall) {
      Map<String, dynamic> request = {
        'searchKeyword': destinationSearchCtr.text,
        'activeRecords': true,
      };

      final result = await dashboardRepository.destinationNameDataApi(jsonEncode(request), pageNo.toString());

      result.when(
        success: (data) async {
          destinationNameListState.success = data;
          destinationList.addAll(destinationNameListState.success?.data ?? []);
          if(destinationList.isNotEmpty) {
            updateSelectedDestination(context, ref, destinationList.first);
          }
        },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        },
      );

      destinationNameListState.isLoading = false;
      destinationNameListState.isLoadMore = false;
      ref.read(searchController).updateLoader(false);
      ref.read(searchController).updateLoadMore(false);
      notifyListeners();
    }
  }

  ///-----------------------------------------Category data list api --------------------------------------------------------------
  var categoryDataListState = UIState<CategoryDataListResponseModel>();
  List<CategoryDataListDto> commonCategoryList = [];
  Future categoryDataListApi(BuildContext context, WidgetRef ref, {bool isForPagination = false, required List<CategoryDataListDto> categoryList, String? searchKeyword, bool initial = false}) async {
    int pageNo = 1;
    bool apiCall = true;
    if(!isForPagination){
      ref.read(searchController).updateLoader(true);
      pageNo = 1;
      categoryList.clear();
      categoryDataListState.isLoading = true;
      categoryDataListState.success = null;
    }
    else if((categoryDataListState.success?.hasNextPage == true)  && !categoryDataListState.isLoadMore){
      ref.read(searchController).updateLoadMore(true);
      pageNo = (categoryDataListState.success?.pageNumber ?? 0) + 1;
      categoryDataListState.isLoadMore = true;
      categoryDataListState.success = null;
    }
    else{
      apiCall = false;
    }
    notifyListeners();

    if(apiCall) {
      Map<String,dynamic> request = {
        'searchKeyword': searchKeyword,
        'activeRecords': true,
        'isUnique' : true,
        'destinationUuid' : selectedDestination?.uuid
      };

      final result = await dashboardRepository.categoryDataListApi(jsonEncode(request), pageNo);

      result.when(success: (data) async {
        categoryDataListState.success = data;
        if(initial) {
          commonCategoryList.clear();
          commonCategoryList.addAll(categoryDataListState.success?.data ?? []);
          initialFillCategoryList();
        }else{
          categoryList.addAll(categoryDataListState.success?.data ?? []);
        }
      }, failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      });

      categoryDataListState.isLoading = false;
      categoryDataListState.isLoadMore = false;
      ref.read(searchController).updateLoader(false);
      ref.read(searchController).updateLoadMore(false);
      notifyListeners();
    }
  }

  void initialFillCategoryList(){
    peakUsageCategoryList.clear();
    peakUsageCategoryList.addAll(commonCategoryList);
    interactionCategoryList.clear();
    interactionCategoryList.addAll(commonCategoryList);
    mostRequestedCategoryList.clear();
    mostRequestedCategoryList.addAll(commonCategoryList);
    weekInteractionCountCategoryList.clear();
    weekInteractionCountCategoryList.addAll(commonCategoryList);
  }

  ///-----------------------------------------Store data list api --------------------------------------------------------------
  List<StoreDataListDto> commonStoreList = [];
  var storeDataListState = UIState<StoreDataListResponseModel>();
  Future<void> storeDataListApi(BuildContext context, WidgetRef ref, {bool isForPagination = false, required List<StoreDataListDto> storeDataList, String? searchKeyword, bool initial = false, String? categoryUuid}) async {
    int pageNo = 1;
    bool apiCall = true;

    if (!isForPagination) {
      ref.read(searchController).updateLoader(true);
      pageNo = 1;
      storeDataList.clear();
      storeDataListState.isLoading = true;
      storeDataListState.success = null;
    } else if ((storeDataListState.success?.hasNextPage == true) && !storeDataListState.isLoadMore) {
      ref.read(searchController).updateLoadMore(true);
      pageNo = (storeDataListState.success?.pageNumber ?? 0) + 1;
      storeDataListState.isLoadMore = true;
      storeDataListState.success = null;
    } else {
      apiCall = false;
    }

    notifyListeners();

    if (apiCall) {
      Map<String, dynamic> request = {
        'searchKeyword': searchKeyword,
        'activeRecords': true,
        'categoryUuids': categoryUuid!=null ? [categoryUuid] : null,
        'isUnique': true,
        'destinationUuid': ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)) ? null : selectedDestination?.uuid,
        // "isUnassigned": true
      };

      final result = await dashboardRepository.storeDataListApi(jsonEncode(request), pageNo);

      result.when(success: (data) async {
        storeDataListState.success = data;
        if(initial) {
          commonStoreList.clear();
          commonStoreList.addAll(storeDataListState.success?.data ?? []);
          initialFillStoreList();
        }else {
          storeDataList.addAll(storeDataListState.success?.data ?? []);
        }
      }, failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      });

      storeDataListState.isLoading = false;
      storeDataListState.isLoadMore = false;
      ref.read(searchController).updateLoader(false);
      ref.read(searchController).updateLoadMore(false);
      notifyListeners();
    }
  }

  void initialFillStoreList(){
    selectedEfficiencyStore = null;
    efficiencyStoreSearchCtr.clear();
    efficiencyStoreList.clear();
    efficiencyStoreList.addAll(commonStoreList);
    selectedNavigationRequestStore = null;
    navigationRequestStoreSearchCtr.clear();
    navigationRequestStoreList.clear();
    navigationRequestStoreList.addAll(commonStoreList);
  }

  ///----------------------------------------- Robot data list API --------------------------------------------------------------
  var robotDataListState = UIState<RobotDataListResponseModel>();

  Future<void> robotDataListApi(BuildContext context, WidgetRef ref, {bool isForPagination = false, required List<RobotDataListDto> robotDataList, String? searchKeyword, bool initial = false,}) async {
    int pageNo = 1;
    bool apiCall = true;

    if (!isForPagination) {
      ref.read(searchController).updateLoader(true);
      pageNo = 1;
      robotDataList.clear();
      robotDataListState.isLoading = true;
      robotDataListState.success = null;
    } else if ((robotDataListState.success?.hasNextPage == true) && !robotDataListState.isLoadMore) {
      ref.read(searchController).updateLoadMore(true);
      pageNo = (robotDataListState.success?.pageNumber ?? 0) + 1;
      robotDataListState.isLoadMore = true;
      robotDataListState.success = null;
    } else {
      apiCall = false;
    }

    notifyListeners();

    if (apiCall) {
      Map<String, dynamic> request = {
        'searchKeyword': searchKeyword,
        'activeRecords': true,
        'destinationUuid': ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)) ? null : selectedDestination?.uuid,
      };

      final result = await dashboardRepository.robotDataListApi(jsonEncode(request), pageNo);

      result.when(success: (data) async {
        robotDataListState.success = data;
        robotDataList.addAll(robotDataListState.success?.data ?? []);
        if(robotDataList.isNotEmpty) {
          updateUptimeSelectedRobot(context, ref, robotDataList.first);
        }
      }, failure: (NetworkExceptions error) {
        // Optional: Handle error
      });

      robotDataListState.isLoading = false;
      robotDataListState.isLoadMore = false;
      ref.read(searchController).updateLoader(false);
      ref.read(searchController).updateLoadMore(false);
      notifyListeners();
    }
  }



  ///-----------------------------------------Register device api --------------------------------------------------------------
  AuthRepository authRepository;

  UIState<CommonResponseModel> registerDeviceState = UIState<CommonResponseModel>();
  /// Register Device FCM token
  Future<void> registerDeviceFcmToken(BuildContext context) async {
    registerDeviceState.isLoading = true;
    registerDeviceState.success = null;
    notifyListeners();
    if(Session.deviceId.isEmpty){
      await getDeviceIdPlatformWise();
    }

    DeviceRegistrationRequestModel requestModel;

    requestModel = DeviceRegistrationRequestModel(
      deviceId: Session.fcmToken,
      deviceType: 'WEB',
      userType: 'USER',
      uniqueDeviceId:Session.deviceId,
    );

    String request = deviceRegistrationRequestModelToJson(requestModel);

    final result = await authRepository.registerDeviceApi(request);

    result.when(success: (data) async {
      registerDeviceState.success = data;
    }, failure: (NetworkExceptions error) {

    });

    registerDeviceState.isLoading = false;
    notifyListeners();
  }


  ///-----------------------------------------dashboard count api --------------------------------------------------------------
  var dashboardCountState = UIState<DashboardCountResponseModel>();

  Future<void> dashboardCountApi(BuildContext context) async {
    dashboardCountState.isLoading = true;
    dashboardCountState.success = null;
    notifyListeners();

    final result = await dashboardRepository.dashboardCountApi();

    result.when(success: (data) async {
      dashboardCountState.success = data;
    },
    failure: (NetworkExceptions error) {
      //String errorMsg = NetworkExceptions.getErrorMessage(error);
      //       showCommonErrorDialog(context: context, message: errorMsg);
    });

    dashboardCountState.isLoading = false;
    notifyListeners();
  }

  UIState<NavigationEfficiencyResponseModel> navigationEfficiencyState = UIState<NavigationEfficiencyResponseModel>();



  Future<void> navigationEfficiencyApi(context) async {

    navigationEfficiencyState.isLoading = true;
    navigationEfficiencyState.success = null;
    notifyListeners();
    TotalNavigationRequestModel requestModel = TotalNavigationRequestModel(
      destinationUuid: ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)) ? null : selectedDestination?.uuid,
      storeUuid: selectedEfficiencyStore?.uuid,
    );

    String request = totalNavigationRequestModelToJson(requestModel);


    final result = await dashboardRepository.navigationEfficiencyApi(request);

    result.when(success: (data) async {
      navigationEfficiencyState.success = data;
     // navigationEfficiencyState.success?.data = 20;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    navigationEfficiencyState.isLoading = false;
    notifyListeners();
  }

  UIState<MostRequestedStoreResponseModel> mostRequestedStoreListState = UIState<MostRequestedStoreResponseModel>();
  Future<void> mostRequestedStoreApi(context) async {

    mostRequestedStoreListState.isLoading = true;
    mostRequestedStoreListState.success = null;
    notifyListeners();
    MostRequestedStoreRequestModel requestModel = MostRequestedStoreRequestModel(
      categoryUuid: selectedMostRequestedStoreCategory?.uuid,
      destinationUuid: ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)) ? null : selectedDestination?.uuid,
      month: mostRequestedStoreMonth!=null ? monthMap[mostRequestedStoreMonth] ?? 1 : null ,
      year: mostRequestedStoreYear!=null ? int.parse(mostRequestedStoreYear??'2025'): null ,
      day: dayOfMonth !=null? int.parse(dayOfMonth??'1') : null
    );

    String request = mostRequestedStoreRequestModelToJson(requestModel);


    final result = await dashboardRepository.mostRequestedStore(request);

    result.when(success: (data) async {
      mostRequestedStoreListState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    mostRequestedStoreListState.isLoading = false;
    notifyListeners();
  }

  ///---------------------------------- dashboard uptime api & filters---------------------------------------------------------------------
  ///-------filters-------
  /// uptime robot dropdown
  List<RobotDataListDto> uptimeRobotList = [];
  RobotDataListDto? selectedUptimeRobot;
  TextEditingController uptimeRobotSearchCtr = TextEditingController();

  void updateUptimeSelectedRobot(BuildContext context, WidgetRef ref, RobotDataListDto? selectedRobot,) {
    selectedUptimeRobot = selectedRobot;
    uptimeRobotSearchCtr.text = selectedUptimeRobot?.hostName??'';
    dashboardUptimeApi(context);
  }

  /// date filter
  DateTime? uptimeSelectedDate = DateTime.now().subtract(Duration(days: 1));
  void updateUptimeSelectedDate(DateTime? date, BuildContext context, WidgetRef ref) {
    uptimeSelectedDate = date;
    dashboardUptimeApi(context);
  }

  /// reset filter
  void resetUptimeFilter(BuildContext context, WidgetRef ref) {
    selectedUptimeRobot = null;
    uptimeRobotSearchCtr.clear();
    uptimeSelectedDate = DateTime.now().subtract(Duration(days: 1));
    dashboardUptimeState.isLoading = false;
    dashboardUptimeState.success = null;
    notifyListeners();
  }

  ///-------Api-------
  UIState<UptimeResponseModel> dashboardUptimeState = UIState<UptimeResponseModel>();
  Future dashboardUptimeApi(BuildContext context) async {
    dashboardUptimeState.isLoading = true;
    dashboardUptimeState.success = null;
    notifyListeners();

    UptimeRequestModel requestModel = UptimeRequestModel(
        destinationUuid: selectedDestination?.uuid,
        robotUuid: selectedUptimeRobot?.uuid,
        requestDate: uptimeSelectedDate?.toUtc().toYMDString()
    );
    String request = uptimeRequestModelToJson(requestModel);

    final apiResult = await dashboardRepository.dashboardUptimeApi(request: request);
    apiResult.when(

      success: (data) async{
        dashboardUptimeState.success = data;
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );
    dashboardUptimeState.isLoading = false;
    notifyListeners();
  }


  ///---------------------------------- dashboard peak usage api & filters---------------------------------------------------------------------
  ///-------filters-------
  /// category dropdown
  List<CategoryDataListDto> peakUsageCategoryList = [];
  CategoryDataListDto? selectedPeakUsageCategory;
  TextEditingController peakUsageCategorySearchCtr = TextEditingController();

  void updatePeakUsageSelectedCategory(BuildContext context, WidgetRef ref, CategoryDataListDto? selectedCategory) {
    selectedPeakUsageCategory = selectedCategory;
    storeDataListApi(context, ref, storeDataList: peakUsageStoreList, categoryUuid: selectedPeakUsageCategory?.uuid);
    dashboardPeakUsageApi(context, ref);
  }

  /// Store filter
  List<StoreDataListDto> peakUsageStoreList = [];
  StoreDataListDto? selectedPeakUsageStore;
  TextEditingController peakUsageStoreSearchCtr = TextEditingController();

  void updatePeakUsageSelectedStore(BuildContext context, WidgetRef ref, StoreDataListDto? selectedStore) {
    selectedPeakUsageStore = selectedStore;
    dashboardPeakUsageApi(context, ref);
    notifyListeners();
  }


  List<StoreDataListDto> efficiencyStoreList = [];
  StoreDataListDto? selectedEfficiencyStore;
  TextEditingController efficiencyStoreSearchCtr = TextEditingController();

  void updateEfficiencySelectedStore(BuildContext context, WidgetRef ref, StoreDataListDto? selectedStore) {
    selectedEfficiencyStore = selectedStore;
    navigationEfficiencyApi(context);
    notifyListeners();
  }




  ///date filter
  DateTime? peakUsageSelectedDate = DateTime.now();  // Changed from selectedDate
  void updatePeakUsageSelectedDate(DateTime? date, BuildContext context, WidgetRef ref) {
    peakUsageSelectedDate = date;
    dashboardPeakUsageApi(context, ref);  // Calls the peak usage API
    notifyListeners();
  }

  List<String> xTitlesPeakUsage = ['10:00-12:00', '12:00-02:00', '02:00-04:00', '04:00-06:00'];
  List<double> monthGraphDataListPeakUsage = [
    // 430, 380, 450, 330,
    0,0,0,0,
  ];

  /// reset filter
  void resetPeakUsageFilter(BuildContext context, WidgetRef ref) {
    peakUsageCategoryList.clear();
    peakUsageCategoryList.addAll(commonCategoryList);
    selectedPeakUsageCategory = null;
    peakUsageCategorySearchCtr.clear();
    peakUsageStoreList.clear();
    selectedPeakUsageStore = null;
    peakUsageStoreSearchCtr.clear();
    peakUsageSelectedDate = DateTime.now();
    dashboardPeakUsageApi(context, ref);  // Calls the peak usage API
    notifyListeners();
  }

  ///-------Api-------
  UIState<DashboardPeakUsageResponseModel> dashboardPeakUsageState = UIState<DashboardPeakUsageResponseModel>();
  Future dashboardPeakUsageApi(BuildContext context, WidgetRef ref) async {
    dashboardPeakUsageState.isLoading = true;
    dashboardPeakUsageState.success = null;
    notifyListeners();

    DashboardPeakUsageRequestModel requestModel = DashboardPeakUsageRequestModel(
      destinationUuid: ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)) ? null : selectedDestination?.uuid,
      date: peakUsageSelectedDate?.toUtc().toYMDString(),
      interactionType: (selectedPeakUsageCategory == null) ? null : (selectedPeakUsageStore != null) ? 'STORE_SELECT' : 'CATEGORY_SELECT',
      interactionTypeUuid: (selectedPeakUsageCategory == null) ? null : (selectedPeakUsageStore != null) ? selectedPeakUsageStore?.uuid : selectedPeakUsageCategory?.uuid,
    );
    String request = dashboardPeakUsageRequestModelToJson(requestModel);

    final apiResult = await dashboardRepository.dashboardPeakUsageApi(request: request);
    apiResult.when(
      success: (data) async {
        dashboardPeakUsageState.success = data;
        if(dashboardPeakUsageState.success?.status == ApiEndPoints.apiStatus_200){
          if(dashboardPeakUsageState.success?.data?.peakUsageDtOs?.isNotEmpty ?? false){
            xTitlesPeakUsage.clear();
            monthGraphDataListPeakUsage.clear();
            for(PeakUsageDto item in dashboardPeakUsageState.success?.data?.peakUsageDtOs ?? []){
              xTitlesPeakUsage.add('${item.startHour?.toHHMM()}-${item.endHour?.toHHMM()}');
              monthGraphDataListPeakUsage.add(item.count?.toDouble() ?? 0);
            }
          }
          else{
            xTitlesPeakUsage = ['10:00-12:00', '12:00-02:00', '02:00-04:00', '04:00-06:00'];
            monthGraphDataListPeakUsage = [0, 0, 0, 0,];
          }
        }
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    dashboardPeakUsageState.isLoading = false;
    notifyListeners();
  }

///---------------------------------- dashboard week interaction count/ Weekdays and weekends api & filters---------------------------------------------------------------------
///-------filters-------
  /// category dropdown
  List<CategoryDataListDto> weekInteractionCountCategoryList = [];
  CategoryDataListDto? selectedWeekInteractionCountCategory;
  TextEditingController weekInteractionCountCategorySearchCtr = TextEditingController();

  void updateWeekInteractionCountSelectedCategory(BuildContext context, WidgetRef ref, CategoryDataListDto? selectedCategory) {
    selectedWeekInteractionCountCategory = selectedCategory;
    storeDataListApi(context, ref, storeDataList: weekInteractionCountStoreList, categoryUuid: selectedWeekInteractionCountCategory?.uuid);
    dashboardWeekInteractionCountApi(context, ref);
    notifyListeners();
  }

  /// Store filter
  List<StoreDataListDto> weekInteractionCountStoreList = [];
  StoreDataListDto? selectedWeekInteractionCountStore;
  TextEditingController weekInteractionCountStoreSearchCtr = TextEditingController();

  void updateWeekInteractionCountSelectedStore(BuildContext context, WidgetRef ref, StoreDataListDto? selectedStore) {
    selectedWeekInteractionCountStore = selectedStore;
    dashboardWeekInteractionCountApi(context, ref);
    notifyListeners();
  }

  /// date range filter
  DateTime? startDateWeekdays = DateTime.now().subtract(const Duration(days: 6));
  DateTime? endDateWeekdays = DateTime.now();
  TextEditingController weekInteractionCountDateController = TextEditingController();

  void changeWeekInteractionCountDateValue(BuildContext context, WidgetRef ref, List<DateTime?> value) {
    /// Set Start Date
    startDateWeekdays = value.first;

    /// Set End Date
    endDateWeekdays = value.last;

    /// Set value in controller to show in field like 13 Mar,2025 - 16 Mar,2025
    weekInteractionCountDateController.text = formatDateRange([
      startDateWeekdays,
      endDateWeekdays,
    ]);
    dashboardWeekInteractionCountApi(context, ref);
    notifyListeners();
  }

  /// Reset filter
  void resetWeekInteractionCountFilter(BuildContext context, WidgetRef ref) {
    weekInteractionCountCategoryList.clear();
    weekInteractionCountCategoryList.addAll(commonCategoryList);
    selectedWeekInteractionCountCategory = null;
    weekInteractionCountCategorySearchCtr.clear();
    weekInteractionCountStoreList.clear();
    selectedWeekInteractionCountStore = null;
    weekInteractionCountStoreSearchCtr.clear();
    startDateWeekdays = DateTime.now().subtract(const Duration(days: 6));
    endDateWeekdays = DateTime.now();
    weekInteractionCountDateController.text = formatDateRange([
      startDateWeekdays,
      endDateWeekdays,
    ]);
    dashboardWeekInteractionCountApi(context, ref);
    notifyListeners();
  }




  List<String> xTitlesWeekInteractionCount = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
  List<double> monthGraphDataListWeekInteractionCount = [
    // 430, 380, 450, 330, 250, 440, 390,
    0, 0, 0, 0, 0, 0, 0,
  ];

  ///-------Api-------
  UIState<DashboardWeekInteractionCountResponseModel> dashboardWeekInteractionCountState = UIState<DashboardWeekInteractionCountResponseModel>();
  Future dashboardWeekInteractionCountApi(BuildContext context, WidgetRef ref) async {
    dashboardWeekInteractionCountState.isLoading = true;
    dashboardWeekInteractionCountState.success = null;
    notifyListeners();


    DashboardWeekInteractionCountRequestModel requestModel = DashboardWeekInteractionCountRequestModel(
      destinationUuid: ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)) ? null : selectedDestination?.uuid,
      startDate: startDateWeekdays?.toUtc().toYMDString(),
      endDate: endDateWeekdays?.toUtc().toYMDString(),
      interactionType: (selectedWeekInteractionCountCategory == null) ? null : (selectedWeekInteractionCountStore != null) ? 'STORE_SELECT' : 'CATEGORY_SELECT',
      interactionTypeUuid: (selectedWeekInteractionCountCategory == null) ? null : (selectedWeekInteractionCountStore != null) ? selectedWeekInteractionCountStore?.uuid : selectedWeekInteractionCountCategory?.uuid,
    );
    String request = dashboardWeekInteractionCountRequestModelToJson(requestModel);

    final apiResult = await dashboardRepository.dashboardWeekInteractionCountApi(request: request);
    apiResult.when(
      success: (data) async{
        dashboardWeekInteractionCountState.success = data;
        if(dashboardWeekInteractionCountState.success?.status == ApiEndPoints.apiStatus_200){
          if(dashboardWeekInteractionCountState.success?.data?.weekWiseInteractionResponse != null){
            xTitlesWeekInteractionCount.clear();
            monthGraphDataListWeekInteractionCount.clear();

            // const weekdayOrder = {
            //   'Monday': 1,
            //   'Tuesday': 2,
            //   'Wednesday': 3,
            //   'Thursday': 4,
            //   'Friday': 5,
            //   'Saturday': 6,
            //   'Sunday': 7,
            // };
            //
            //
            // //-- sort responce by weekdayOrder
            // dashboardWeekInteractionCountState.success?.data?.weekWiseInteractionResponse!.sort((a, b) =>
            //     weekdayOrder[a.dayOfWeek]!.compareTo(weekdayOrder[b.dayOfWeek]!));


            for(WeekWiseInteractionResponse item in dashboardWeekInteractionCountState.success?.data?.weekWiseInteractionResponse ?? []){
              xTitlesWeekInteractionCount.add(getLocalizedWeekDays(item.dayOfWeek ?? ''));
              monthGraphDataListWeekInteractionCount.add((item.interactionCount ?? 0).toDouble());
            }
          }
        }
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );
    dashboardWeekInteractionCountState.isLoading = false;
    notifyListeners();
  }

///---------------------------------- dashboard navigation request count api & filters---------------------------------------------------------------------
///-------filters-------
  /// Store filter
  List<StoreDataListDto> navigationRequestStoreList = [];
  StoreDataListDto? selectedNavigationRequestStore;
  TextEditingController navigationRequestStoreSearchCtr = TextEditingController();

  void updateNavigationRequestSelectedStore(BuildContext context, WidgetRef ref, StoreDataListDto? selectedStore) {
    selectedNavigationRequestStore = selectedStore;
    navigationRequestApiCall(context);
  }

  /// month filter
  String? selectedNavigationMonth;
  void updateNavigationRequestMonthYear(BuildContext context, String selectedMonth) {
    selectedNavigationMonth = selectedMonth;
    // navigationRequestDaysList = getDaysList(selectedMonth);
    navigationRequestApiCall(context);
  }

  /// year filter
  String? selectedNavigationRequestYear = DateTime.now().year.toString();
  Future<void> updateNavigationRequestYearIndex(BuildContext context, String value) async {
    selectedNavigationRequestYear = value;
    navigationRequestApiCall(context);
  }

  /// Reset filter
  void resetNavigationRequestFilter(BuildContext context) {
    navigationRequestType = false;
    navigationRequestStoreList.clear();
    navigationRequestStoreList.addAll(commonStoreList);
    selectedNavigationRequestStore = null;
    navigationRequestStoreSearchCtr.clear();
    selectedNavigationMonth = null;
    selectedNavigationRequestYear = DateTime.now().year.toString();
    navigationRequestApiCall(context);
    notifyListeners();
  }



  List<String> xTitlesNavigationRequests = [];
  List<NavRequestData> monthGraphDataListNavigationRequest = [];
  double maxValue = 10000.0;
  bool navigationRequestType = false; /// true = average, false= total
  updateNavigationRequestType(BuildContext context){
    navigationRequestType = !navigationRequestType;
    navigationRequestApiCall(context);
  }
  
  void navigationRequestApiCall(BuildContext context){
    if (navigationRequestType) {
      averageNavigationRequestApi(context);
    } else {
      totalNavigationRequestApi(context);
    }
  }

  ///-------Api-------
  UIState<TotalNavigationResponseModel> totalNavigationRequestState = UIState<TotalNavigationResponseModel>();
  Future<void> totalNavigationRequestApi(BuildContext context) async {

    totalNavigationRequestState.isLoading = true;
    totalNavigationRequestState.success = null;
    notifyListeners();
    TotalNavigationRequestModel requestModel = TotalNavigationRequestModel(
        year: int.parse(selectedNavigationRequestYear??'${DateTime.now().year}'),
        month: selectedNavigationMonth != null ? getMonthNumber(selectedNavigationMonth!) : null,
        storeUuid: selectedNavigationRequestStore?.uuid,
        destinationUuid: ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)) ? null : selectedDestination?.uuid
    );
    String request = totalNavigationRequestModelToJson(requestModel);


    final result = await dashboardRepository.totalNavigationRequestApi(request);

    result.when(success: (data) async {
      totalNavigationRequestState.success = data;
      if (totalNavigationRequestState.success?.status == ApiEndPoints.apiStatus_200) {
        Map<String, NavRequestData>? i = totalNavigationRequestState.success?.data;

        showLog('API selectedMonth $selectedNavigationMonth');
        if (selectedNavigationMonth == null) {
          // xTitles = ['Jan', 'Feb', 'Mar', 'April', 'May', 'June', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          showLog('str xTitles');
          // showLog(i?.keys.map((e) => e,).toList().toString());
          if(i != null) {
            xTitlesNavigationRequests = i.keys.map((e) => e,).toList();
          }
          monthGraphDataListNavigationRequest = [
            NavRequestData(total:i?['jan']?.total ?? 0, failure: i?['jan']?.failure ?? 0,success: i?['jan']?.success ?? 0),
            NavRequestData(total:i?['feb']?.total ?? 0, failure: i?['feb']?.failure ?? 0,success: i?['feb']?.success ?? 0),
            NavRequestData(total:i?['mar']?.total ?? 0, failure: i?['mar']?.failure ?? 0,success: i?['mar']?.success ?? 0),
            NavRequestData(total:i?['apr']?.total ?? 0, failure: i?['apr']?.failure ?? 0,success: i?['apr']?.success ?? 0),
            NavRequestData(total:i?['may']?.total ?? 0, failure: i?['may']?.failure ?? 0,success: i?['may']?.success ?? 0),
            NavRequestData(total:i?['jun']?.total ?? 0, failure: i?['jun']?.failure ?? 0,success: i?['jun']?.success ?? 0),
            NavRequestData(total:i?['jul']?.total ?? 0, failure: i?['jul']?.failure ?? 0,success: i?['jul']?.success ?? 0),
            NavRequestData(total:i?['aug']?.total ?? 0, failure: i?['aug']?.failure ?? 0,success: i?['aug']?.success ?? 0),
            NavRequestData(total:i?['sep']?.total ?? 0, failure: i?['sep']?.failure ?? 0,success: i?['sep']?.success ?? 0),
            NavRequestData(total:i?['oct']?.total ?? 0, failure: i?['oct']?.failure ?? 0,success: i?['oct']?.success ?? 0),
            NavRequestData(total:i?['nov']?.total ?? 0, failure: i?['nov']?.failure ?? 0,success: i?['nov']?.success ?? 0),
            NavRequestData(total:i?['dec']?.total ?? 0, failure: i?['dec']?.failure ?? 0,success: i?['dec']?.success ?? 0),
          ];
        }
        else {


          showLog('selectedMonth \$selectedMonth');
          showLog('monthMap[selectedMonth] \${monthMap[selectedMonth]}');

          int currentYear = int.parse(selectedNavigationRequestYear??'${DateTime.now().year}');
          int daysInMonth = DateTime(currentYear, monthMap[selectedNavigationMonth]! + 1, 0).day;

          //leap year
          showLog('selectedMonthselectedMonth $selectedNavigationMonth');
          showLog('daysInMonth 11 : $daysInMonth');
          showLog('monthMap monthMap ${monthMap[selectedNavigationMonth]}');
          showLog('currentYear 11 : $currentYear | ${currentYear%4}');
          if (selectedNavigationMonth == 'Feb' && currentYear % 4 == 0 && (currentYear % 100 != 0 || currentYear % 400 == 0)) {
            daysInMonth = 29;
            showLog('daysInMonth $daysInMonth');
            showLog('currentYear $currentYear');

          }

          showLog('daysInMonth >> \$daysInMonth');

          monthGraphDataListNavigationRequest = List.generate(daysInMonth, (index) {
            switch (index + 1) {
              case 1: return NavRequestData(total: i?['first']?.total ?? 0,success: i?['first']?.success ?? 0,failure: i?['first']?.failure ?? 0);
              case 2: return NavRequestData(total: i?['second']?.total ?? 0,success: i?['second']?.success,failure: i?['second']?.failure);
              case 3: return NavRequestData(total: i?['third']?.total ?? 0,success: i?['third']?.success,failure: i?['third']?.failure);
              case 4: return NavRequestData(total: i?['fourth']?.total ?? 0,success: i?['fourth']?.success,failure: i?['fourth']?.failure);
              case 5: return NavRequestData(total: i?['fifth']?.total ?? 0,success: i?['fifth']?.success,failure: i?['fifth']?.failure);
              case 6: return NavRequestData(total: i?['sixth']?.total ?? 0,success: i?['sixth']?.success,failure: i?['sixth']?.failure);
              case 7: return NavRequestData(total: i?['seventh']?.total ?? 0,success: i?['seventh']?.success,failure: i?['seventh']?.failure);
              case 8: return NavRequestData(total: i?['eighth']?.total ?? 0,success: i?['eighth']?.success,failure: i?['eighth']?.failure);
              case 9: return NavRequestData(total: i?['ninth']?.total ?? 0,success: i?['ninth']?.success,failure: i?['ninth']?.failure);
              case 10: return NavRequestData(total: i?['tenth']?.total ?? 0,success: i?['tenth']?.success,failure: i?['tenth']?.failure);
              case 11: return NavRequestData(total: i?['eleventh']?.total ?? 0,success: i?['eleventh']?.success,failure: i?['eleventh']?.failure);
              case 12: return NavRequestData(total: i?['twelfth']?.total ?? 0,success: i?['twelfth']?.success,failure: i?['twelfth']?.failure);
              case 13: return NavRequestData(total: i?['thirteenth']?.total ?? 0,success: i?['thirteenth']?.success,failure: i?['thirteenth']?.failure);
              case 14: return NavRequestData(total: i?['fourteenth']?.total ?? 0,success: i?['fourteenth']?.success,failure: i?['fourteenth']?.failure);
              case 15: return NavRequestData(total: i?['fifteenth']?.total ?? 0,success: i?['fifteenth']?.success,failure: i?['fifteenth']?.failure);
              case 16: return NavRequestData(total: i?['sixteenth']?.total ?? 0,success: i?['sixteenth']?.success,failure: i?['sixteenth']?.failure);
              case 17: return NavRequestData(total: i?['seventeenth']?.total ?? 0,success: i?['seventeenth']?.success,failure: i?['seventeenth']?.failure);
              case 18: return NavRequestData(total: i?['eighteenth']?.total ?? 0,success: i?['eighteenth']?.success,failure: i?['eighteenth']?.failure);
              case 19: return NavRequestData(total: i?['nineteenth']?.total ?? 0,success: i?['nineteenth']?.success,failure: i?['nineteenth']?.failure);
              case 20: return NavRequestData(total: i?['twentieth']?.total ?? 0,success: i?['twentieth']?.success,failure: i?['twentieth']?.failure);
              case 21: return NavRequestData(total: i?['twentyFirst']?.total ?? 0,success: i?['twentyFirst']?.success,failure: i?['twentyFirst']?.failure);
              case 22: return NavRequestData(total: i?['twentySecond']?.total ?? 0,success: i?['twentySecond']?.success,failure: i?['twentySecond']?.failure);
              case 23: return NavRequestData(total: i?['twentyThird']?.total ?? 0,success: i?['twentyThird']?.success,failure: i?['twentyThird']?.failure);
              case 24: return NavRequestData(total: i?['twentyFourth']?.total ?? 0,success: i?['twentyFourth']?.success,failure: i?['twentyFourth']?.failure);
              case 25: return NavRequestData(total: i?['twentyFifth']?.total ?? 0,success: i?['twentyFifth']?.success,failure: i?['twentyFifth']?.failure);
              case 26: return NavRequestData(total: i?['twentySixth']?.total ?? 0,success: i?['twentySixth']?.success,failure: i?['twentySixth']?.failure);
              case 27: return NavRequestData(total: i?['twentySeventh']?.total ?? 0,success: i?['twentySeventh']?.success,failure: i?['twentySeventh']?.failure);
              case 28: return NavRequestData(total: i?['twentyEighth']?.total ?? 0,success: i?['twentyEighth']?.success,failure: i?['twentyEighth']?.failure);
              case 29: return NavRequestData(total: i?['twentyNinth']?.total ?? 0,success: i?['twentyNinth']?.success,failure: i?['twentyNinth']?.failure);
              case 30: return NavRequestData(total: i?['thirtieth']?.total ?? 0,success: i?['thirtieth']?.success,failure: i?['thirtieth']?.failure);
              case 31: return NavRequestData(total: i?['thirtyFirst']?.total ?? 0,success: i?['thirtyFirst']?.success,failure: i?['thirtyFirst']?.failure);
              default: return NavRequestData();
            }
          });

          xTitlesNavigationRequests = List.generate(daysInMonth, (index) => (index + 1).toString());

          showLog('monthGraphDataListNavigationRequest lst ${monthGraphDataListNavigationRequest.map((e) => e.success).toList().toString()}');
          showLog('monthGraphDataListNavigationRequest lst ${xTitlesNavigationRequests.map((e) => e).toList().toString()}');
        }
        maxValue = monthGraphDataListNavigationRequest.map((e) => e.total??0.0).reduce((a, b) => a > b ? a : b);
      }
      notifyListeners();

    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    totalNavigationRequestState.isLoading = false;
    notifyListeners();
  }


  UIState<TotalNavigationResponseModel> averageNavigationRequestState = UIState<TotalNavigationResponseModel>();
  Future<void> averageNavigationRequestApi(BuildContext context) async {
    averageNavigationRequestState.isLoading = true;
    averageNavigationRequestState.success = null;
    notifyListeners();

    TotalNavigationRequestModel requestModel = TotalNavigationRequestModel(
        year: int.parse(selectedNavigationRequestYear??'${DateTime.now().year}'),
        destinationUuid: ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)) ? null : selectedDestination?.uuid,
        storeUuid: selectedNavigationRequestStore?.uuid
    );
    String request = totalNavigationRequestModelToJson(requestModel);

    final result = await dashboardRepository.averageNavigationRequestApi(request);

    result.when(success: (data) async {
      averageNavigationRequestState.success = data;

      if (averageNavigationRequestState.success?.status == ApiEndPoints.apiStatus_200) {
        Map<String, NavRequestData>? i = averageNavigationRequestState.success?.data;

        if (selectedNavigationMonth == null) {
          // xTitles = ['Jan', 'Feb', 'Mar', 'April', 'May', 'June', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          showLog('str xTitles');
          // showLog(i?.keys.map((e) => e,).toList().toString());
          if(i != null) {
            xTitlesNavigationRequests = i.keys.map((e) => e,).toList();
          }
          monthGraphDataListNavigationRequest = [
            NavRequestData(total:i?['jan']?.total ?? 0, failure: i?['jan']?.failure ?? 0,success: i?['jan']?.success ?? 0),
            NavRequestData(total:i?['feb']?.total ?? 0, failure: i?['feb']?.failure ?? 0,success: i?['feb']?.success ?? 0),
            NavRequestData(total:i?['mar']?.total ?? 0, failure: i?['mar']?.failure ?? 0,success: i?['mar']?.success ?? 0),
            NavRequestData(total:i?['apr']?.total ?? 0, failure: i?['apr']?.failure ?? 0,success: i?['apr']?.success ?? 0),
            NavRequestData(total:i?['may']?.total ?? 0, failure: i?['may']?.failure ?? 0,success: i?['may']?.success ?? 0),
            NavRequestData(total:i?['jun']?.total ?? 0, failure: i?['jun']?.failure ?? 0,success: i?['jun']?.success ?? 0),
            NavRequestData(total:i?['jul']?.total ?? 0, failure: i?['jul']?.failure ?? 0,success: i?['jul']?.success ?? 0),
            NavRequestData(total:i?['aug']?.total ?? 0, failure: i?['aug']?.failure ?? 0,success: i?['aug']?.success ?? 0),
            NavRequestData(total:i?['sep']?.total ?? 0, failure: i?['sep']?.failure ?? 0,success: i?['sep']?.success ?? 0),
            NavRequestData(total:i?['oct']?.total ?? 0, failure: i?['oct']?.failure ?? 0,success: i?['oct']?.success ?? 0),
            NavRequestData(total:i?['nov']?.total ?? 0, failure: i?['nov']?.failure ?? 0,success: i?['nov']?.success ?? 0),
            NavRequestData(total:i?['dec']?.total ?? 0, failure: i?['dec']?.failure ?? 0,success: i?['dec']?.success ?? 0),
          ];


        }
        else {
          showLog('selectedMonth \$selectedMonth');
          showLog('monthMap[selectedMonth] \${monthMap[selectedMonth]}');

          int currentYear = int.parse(selectedNavigationRequestYear??'${DateTime.now().year}');
          int daysInMonth = DateTime(currentYear, monthMap[selectedNavigationMonth]! + 1, 0).day;

          //leap year
          showLog('selectedMonthselectedMonth $selectedNavigationMonth');
          showLog('daysInMonth 11 : $daysInMonth');
          showLog('monthMap monthMap ${monthMap[selectedNavigationMonth]}');
          showLog('currentYear 11 : $currentYear | ${currentYear%4}');
          if (selectedNavigationMonth == 'Feb' && currentYear % 4 == 0 && (currentYear % 100 != 0 || currentYear % 400 == 0)) {
            daysInMonth = 29;
            showLog('daysInMonth $daysInMonth');
            showLog('currentYear $currentYear');

          }

          showLog('daysInMonth >> \$daysInMonth');

          monthGraphDataListNavigationRequest = List.generate(daysInMonth, (index) {
            switch (index + 1) {
              case 1: return NavRequestData(total: i?['first']?.total ?? 0,success: i?['first']?.success ?? 0,failure: i?['first']?.failure ?? 0);
              case 2: return NavRequestData(total: i?['second']?.total ?? 0,success: i?['second']?.success,failure: i?['second']?.failure);
              case 3: return NavRequestData(total: i?['third']?.total ?? 0,success: i?['third']?.success,failure: i?['third']?.failure);
              case 4: return NavRequestData(total: i?['fourth']?.total ?? 0,success: i?['fourth']?.success,failure: i?['fourth']?.failure);
              case 5: return NavRequestData(total: i?['fifth']?.total ?? 0,success: i?['fifth']?.success,failure: i?['fifth']?.failure);
              case 6: return NavRequestData(total: i?['sixth']?.total ?? 0,success: i?['sixth']?.success,failure: i?['sixth']?.failure);
              case 7: return NavRequestData(total: i?['seventh']?.total ?? 0,success: i?['seventh']?.success,failure: i?['seventh']?.failure);
              case 8: return NavRequestData(total: i?['eighth']?.total ?? 0,success: i?['eighth']?.success,failure: i?['eighth']?.failure);
              case 9: return NavRequestData(total: i?['ninth']?.total ?? 0,success: i?['ninth']?.success,failure: i?['ninth']?.failure);
              case 10: return NavRequestData(total: i?['tenth']?.total ?? 0,success: i?['tenth']?.success,failure: i?['tenth']?.failure);
              case 11: return NavRequestData(total: i?['eleventh']?.total ?? 0,success: i?['eleventh']?.success,failure: i?['eleventh']?.failure);
              case 12: return NavRequestData(total: i?['twelfth']?.total ?? 0,success: i?['twelfth']?.success,failure: i?['twelfth']?.failure);
              case 13: return NavRequestData(total: i?['thirteenth']?.total ?? 0,success: i?['thirteenth']?.success,failure: i?['thirteenth']?.failure);
              case 14: return NavRequestData(total: i?['fourteenth']?.total ?? 0,success: i?['fourteenth']?.success,failure: i?['fourteenth']?.failure);
              case 15: return NavRequestData(total: i?['fifteenth']?.total ?? 0,success: i?['fifteenth']?.success,failure: i?['fifteenth']?.failure);
              case 16: return NavRequestData(total: i?['sixteenth']?.total ?? 0,success: i?['sixteenth']?.success,failure: i?['sixteenth']?.failure);
              case 17: return NavRequestData(total: i?['seventeenth']?.total ?? 0,success: i?['seventeenth']?.success,failure: i?['seventeenth']?.failure);
              case 18: return NavRequestData(total: i?['eighteenth']?.total ?? 0,success: i?['eighteenth']?.success,failure: i?['eighteenth']?.failure);
              case 19: return NavRequestData(total: i?['nineteenth']?.total ?? 0,success: i?['nineteenth']?.success,failure: i?['nineteenth']?.failure);
              case 20: return NavRequestData(total: i?['twentieth']?.total ?? 0,success: i?['twentieth']?.success,failure: i?['twentieth']?.failure);
              case 21: return NavRequestData(total: i?['twentyFirst']?.total ?? 0,success: i?['twentyFirst']?.success,failure: i?['twentyFirst']?.failure);
              case 22: return NavRequestData(total: i?['twentySecond']?.total ?? 0,success: i?['twentySecond']?.success,failure: i?['twentySecond']?.failure);
              case 23: return NavRequestData(total: i?['twentyThird']?.total ?? 0,success: i?['twentyThird']?.success,failure: i?['twentyThird']?.failure);
              case 24: return NavRequestData(total: i?['twentyFourth']?.total ?? 0,success: i?['twentyFourth']?.success,failure: i?['twentyFourth']?.failure);
              case 25: return NavRequestData(total: i?['twentyFifth']?.total ?? 0,success: i?['twentyFifth']?.success,failure: i?['twentyFifth']?.failure);
              case 26: return NavRequestData(total: i?['twentySixth']?.total ?? 0,success: i?['twentySixth']?.success,failure: i?['twentySixth']?.failure);
              case 27: return NavRequestData(total: i?['twentySeventh']?.total ?? 0,success: i?['twentySeventh']?.success,failure: i?['twentySeventh']?.failure);
              case 28: return NavRequestData(total: i?['twentyEighth']?.total ?? 0,success: i?['twentyEighth']?.success,failure: i?['twentyEighth']?.failure);
              case 29: return NavRequestData(total: i?['twentyNinth']?.total ?? 0,success: i?['twentyNinth']?.success,failure: i?['twentyNinth']?.failure);
              case 30: return NavRequestData(total: i?['thirtieth']?.total ?? 0,success: i?['thirtieth']?.success,failure: i?['thirtieth']?.failure);
              case 31: return NavRequestData(total: i?['thirtyFirst']?.total ?? 0,success: i?['thirtyFirst']?.success,failure: i?['thirtyFirst']?.failure);
              default: return NavRequestData();
            }
          });

          xTitlesNavigationRequests = List.generate(daysInMonth, (index) => (index + 1).toString());

          showLog('monthGraphDataListNavigationRequest lst ${monthGraphDataListNavigationRequest.map((e) => e.success).toList().toString()}');
          showLog('monthGraphDataListNavigationRequest lst ${xTitlesNavigationRequests.map((e) => e).toList().toString()}');
        }

        maxValue = monthGraphDataListNavigationRequest.map((e) => e.total??0.0).reduce((a, b) => a > b ? a : b);

      }

    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    averageNavigationRequestState.isLoading = false;
    notifyListeners();
  }


  ///------------------------------Ads-Count-Api------------------------------///

  List<double> adsCountMonthGraphDataList = [0,0,0,0,0,0,0,0,0,0,0,0];
  List<double> averageAdsYearDataList = [0,0,0,0,0,0,0,0,0,0,0,0];

  /// Average Time To Reach graph data api
  UIState<DashboardAdsCountResponseModel> adsCountState = UIState<DashboardAdsCountResponseModel>();

  Future adsCountApi(BuildContext context) async {
    adsCountState.isLoading = true;
    adsCountState.success = null;
    adsCountMonthGraphDataList.clear();
    averageAdsYearDataList.clear();
    notifyListeners();

    AdsCountRequestModel requestModel = AdsCountRequestModel(
      year: int.parse(selectedYearAdsCount??'${DateTime.now().year}'),
      month: selectedAdsCountMonth != null ? getMonthNumber(selectedAdsCountMonth!) : null,
      odigoClientUuid:selectedClient?.uuid??'',
      destinationUuid: ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)) ? null : (selectedDestination?.uuid ?? (destinationList.isNotEmpty ? destinationList.first.uuid : null)),

    );
    String request = adsCountRequestModelToJson(requestModel);

    ApiResult apiResult = await dashboardRepository.adsCountApi(request);
    apiResult.when(
      success: (data) async {
        showLog('globalRef?.watch(destinationController).destinationList.firstOrNull?.uuid----->> ${destinationList.firstOrNull?.uuid}');
        adsCountState.success = data;

        if (adsCountState.success?.status == ApiEndPoints.apiStatus_200) {
          DashboardAdsCountData? i = adsCountState.success?.data;

          if (selectedAdsCountMonth == null) {
            adsCountMonthGraphDataList = [
              i?.totalAdsCountMonthYearWise?.jan ?? 0,
              i?.totalAdsCountMonthYearWise?.feb ?? 0,
              i?.totalAdsCountMonthYearWise?.mar ?? 0,
              i?.totalAdsCountMonthYearWise?.apr ?? 0,
              i?.totalAdsCountMonthYearWise?.may ?? 0,
              i?.totalAdsCountMonthYearWise?.jun ?? 0,
              i?.totalAdsCountMonthYearWise?.jul ?? 0,
              i?.totalAdsCountMonthYearWise?.aug ?? 0,
              i?.totalAdsCountMonthYearWise?.sep ?? 0,
              i?.totalAdsCountMonthYearWise?.oct ?? 0,
              i?.totalAdsCountMonthYearWise?.nov ?? 0,
              i?.totalAdsCountMonthYearWise?.dec ?? 0,
            ];
            averageAdsYearDataList = [
              i?.averageAdsCountYearWise?.jan ?? 0,
              i?.averageAdsCountYearWise?.feb ?? 0,
              i?.averageAdsCountYearWise?.mar ?? 0,
              i?.averageAdsCountYearWise?.apr ?? 0,
              i?.averageAdsCountYearWise?.may ?? 0,
              i?.averageAdsCountYearWise?.jun ?? 0,
              i?.averageAdsCountYearWise?.jul ?? 0,
              i?.averageAdsCountYearWise?.aug ?? 0,
              i?.averageAdsCountYearWise?.sep ?? 0,
              i?.averageAdsCountYearWise?.oct ?? 0,
              i?.averageAdsCountYearWise?.nov ?? 0,
              i?.averageAdsCountYearWise?.dec ?? 0,
            ];

            xTitlesAdsCountRequests = ['Jan', 'Feb', 'Mar', 'April', 'May', 'June', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          } else {
            Map<String, int> monthMap = {'Jan': 1, 'Feb': 2, 'Mar': 3, 'April': 4, 'May': 5, 'June': 6, 'July': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12};

            showLog('selectedAdsCountMonth \$selectedAdsCountMonth');
            showLog('monthMap[selectedAdsCountMonth] \${monthMap[selectedAdsCountMonth]}');

            int currentYear = int.parse(selectedYearAdsCount??'${DateTime.now().year}');
            int daysInMonth = DateTime(currentYear, monthMap[selectedAdsCountMonth]! + 1, 0).day;

            //leap year
            showLog('selectedAdsCountMonth $selectedAdsCountMonth');
            showLog('daysInMonth 11 : $daysInMonth');
            showLog('currentYear 11 : $currentYear | ${currentYear % 4}');
            if (selectedAdsCountMonth == 'Feb' && currentYear % 4 == 0 && (currentYear % 100 != 0 || currentYear % 400 == 0)) {
              daysInMonth = 29;
              showLog('daysInMonth $daysInMonth');
              showLog('currentYear $currentYear');
            }

            showLog('daysInMonth >> \{$daysInMonth}');



            adsCountMonthGraphDataList = List.generate(daysInMonth, (index) {
              switch (index + 1) {
                case 1:
                  return i?.totalAdsCountMonthYearWise?.first ?? 0;
                case 2:
                  return i?.totalAdsCountMonthYearWise?.second ?? 0;
                case 3:
                  return i?.totalAdsCountMonthYearWise?.third ?? 0;
                case 4:
                  return i?.totalAdsCountMonthYearWise?.fourth ?? 0;
                case 5:
                  return i?.totalAdsCountMonthYearWise?.fifth ?? 0;
                case 6:
                  return i?.totalAdsCountMonthYearWise?.sixth ?? 0;
                case 7:
                  return i?.totalAdsCountMonthYearWise?.seventh ?? 0;
                case 8:
                  return i?.totalAdsCountMonthYearWise?.eighth ?? 0;
                case 9:
                  return i?.totalAdsCountMonthYearWise?.ninth ?? 0;
                case 10:
                  return i?.totalAdsCountMonthYearWise?.tenth ?? 0;
                case 11:
                  return i?.totalAdsCountMonthYearWise?.eleventh ?? 0;
                case 12:
                  return i?.totalAdsCountMonthYearWise?.twelfth ?? 0;
                case 13:
                  return i?.totalAdsCountMonthYearWise?.thirteenth ?? 0;
                case 14:
                  return i?.totalAdsCountMonthYearWise?.fourteenth ?? 0;
                case 15:
                  return i?.totalAdsCountMonthYearWise?.fifteenth ?? 0;
                case 16:
                  return i?.totalAdsCountMonthYearWise?.sixteenth ?? 0;
                case 17:
                  return i?.totalAdsCountMonthYearWise?.seventeenth ?? 0;
                case 18:
                  return i?.totalAdsCountMonthYearWise?.eighteenth ?? 0;
                case 19:
                  return i?.totalAdsCountMonthYearWise?.nineteenth ?? 0;
                case 20:
                  return i?.totalAdsCountMonthYearWise?.twentieth ?? 0;
                case 21:
                  return i?.totalAdsCountMonthYearWise?.twentyFirst ?? 0;
                case 22:
                  return i?.totalAdsCountMonthYearWise?.twentySecond ?? 0;
                case 23:
                  return i?.totalAdsCountMonthYearWise?.twentyThird ?? 0;
                case 24:
                  return i?.totalAdsCountMonthYearWise?.twentyFourth ?? 0;
                case 25:
                  return i?.totalAdsCountMonthYearWise?.twentyFifth ?? 0;
                case 26:
                  return i?.totalAdsCountMonthYearWise?.twentySixth ?? 0;
                case 27:
                  return i?.totalAdsCountMonthYearWise?.twentySeventh ?? 0;
                case 28:
                  return i?.totalAdsCountMonthYearWise?.twentyEighth ?? 0;
                case 29:
                  return i?.totalAdsCountMonthYearWise?.twentyNinth ?? 0;
                case 30:
                  return i?.totalAdsCountMonthYearWise?.thirtieth ?? 0;
                case 31:
                  return i?.totalAdsCountMonthYearWise?.thirtyFirst ?? 0;
                default:
                  return 0;
              }
            });

            xTitlesAdsCountRequests = List.generate(daysInMonth, (index) => (index + 1).toString());
          }
        }

        adsCountState.isLoading = false;
        notifyListeners();
      },
      failure: (NetworkExceptions error) {
        adsCountState.isLoading = false;
        //String errorMsg = NetworkExceptions.getErrorMessage(error);
        //       showCommonErrorDialog(context: context, message: errorMsg);
        notifyListeners();
      },
    );
  }

  ///---------------------------------- dashboard Interactions- api & filters---------------------------------------------------------------------
  ///------filters---------------
  /// category dropdown
  List<CategoryDataListDto> interactionCategoryList = [];
  CategoryDataListDto? selectedInteractionCategory;
  TextEditingController interactionCategorySearchCtr = TextEditingController();

  void updateInteractionSelectedCategory(BuildContext context, WidgetRef ref, CategoryDataListDto? selectedCategory) {
    selectedInteractionCategory = selectedCategory;
    storeDataListApi(context, ref, storeDataList: interactionStoreList, categoryUuid: selectedInteractionCategory?.uuid);
    interactionApiCall(context);
  }

  /// Store filter
  List<StoreDataListDto> interactionStoreList = [];
  StoreDataListDto? selectedInteractionStore;
  TextEditingController interactionStoreSearchCtr = TextEditingController();

  void updateInteractionSelectedStore(BuildContext context, WidgetRef ref, StoreDataListDto? selectedStore) {
    selectedInteractionStore = selectedStore;
    interactionApiCall(context);
  }


  void interactionApiCall(BuildContext context){
    if (interactionInitialType) {
      interactionsAverageApi(context);
    } else {
      interactionsTotalApi(context);
    }
  }

  ///------------------------------Interactions-Average-Api------------------------------///

  List<AverageInteractionData> interactionsAverageMonthGraphDataList = [AverageInteractionData(), AverageInteractionData(), AverageInteractionData(), AverageInteractionData(), AverageInteractionData(), AverageInteractionData(), AverageInteractionData(), AverageInteractionData(), AverageInteractionData(), AverageInteractionData(), AverageInteractionData(), AverageInteractionData()];

  /// Average Time To Reach graph data api
  UIState<AverageInteractionResponseModel> interactionsAverageState = UIState<AverageInteractionResponseModel>();

  Future interactionsAverageApi(BuildContext context) async {
    interactionsAverageState.isLoading = true;
    interactionsAverageState.success = null;
    interactionsAverageMonthGraphDataList.clear();
    notifyListeners();

    InteractionsRequestModel requestModel = InteractionsRequestModel(
      year: int.parse(selectedYearInteractionsIndex??'${DateTime.now().year}'),
      month: selectedInteractionMonth != null ? getMonthNumber(selectedInteractionMonth!) : null,
      destinationUuid: ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)) ? null : selectedDestination?.uuid,
      interactionTypeUuid: selectedInteractionStore?.uuid ?? selectedInteractionCategory?.uuid,
    );
    String request = interactionsRequestModelToJson(requestModel);

    ApiResult apiResult = await dashboardRepository.interactionsAverageApi(request);
    apiResult.when(
      success: (data) async {
        interactionsAverageState.success = data;

        if (interactionsAverageState.success?.status == ApiEndPoints.apiStatus_200) {
          Map<String, AverageInteractionData>? i = interactionsAverageState.success?.data;

          if (selectedInteractionMonth == null) {
            interactionsAverageMonthGraphDataList = [
              AverageInteractionData(count: i?['jan']?.count ?? 0),
              AverageInteractionData(count: i?['feb']?.count ?? 0),
              AverageInteractionData(count: i?['mar']?.count ?? 0),
              AverageInteractionData(count: i?['apr']?.count ?? 0),
              AverageInteractionData(count: i?['may']?.count ?? 0),
              AverageInteractionData(count: i?['jun']?.count ?? 0),
              AverageInteractionData(count: i?['jul']?.count ?? 0),
              AverageInteractionData(count: i?['aug']?.count ?? 0),
              AverageInteractionData(count: i?['sep']?.count ?? 0),
              AverageInteractionData(count: i?['oct']?.count ?? 0),
              AverageInteractionData(count: i?['nov']?.count ?? 0),
              AverageInteractionData(count: i?['dec']?.count ?? 0),
            ];

            if(i != null) {
              xTitlesInteractionRequests = i.keys.map((e) => e,).toList();
            }
            // xTitles = ['Jan', 'Feb', 'Mar', 'April', 'May', 'June', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          }
          else {
            Map<String, int> monthMap = {'Jan': 1, 'Feb': 2, 'Mar': 3, 'April': 4, 'May': 5, 'June': 6, 'July': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12};

            showLog('selectedMonth \$selectedMonth');
            showLog('monthMap[selectedMonth] \${monthMap[selectedMonth]}');

            int currentYear = int.parse(yearsDynamicList[int.parse(selectedYearInteractionsIndex??'${DateTime.now().year}')]);
            int daysInMonth = DateTime(currentYear, monthMap[selectedInteractionMonth]! + 1, 0).day;

            //leap year
            showLog('selectedMonthselectedMonth $selectedInteractionMonth');
            showLog('daysInMonth 11 : $daysInMonth');
            showLog('currentYear 11 : $currentYear | ${currentYear % 4}');
            if (selectedInteractionMonth == 'Feb' && currentYear % 4 == 0 && (currentYear % 100 != 0 || currentYear % 400 == 0)) {
              daysInMonth = 29;
              showLog('daysInMonth $daysInMonth');
              showLog('currentYear $currentYear');
            }

            showLog('daysInMonth >> \$daysInMonth');

            interactionsAverageMonthGraphDataList = List.generate(daysInMonth, (index) {
              switch (index + 1) {
                case 1:return AverageInteractionData(count: i?['first']?.count ?? 0);
                case 2:return AverageInteractionData(count: i?['second']?.count ?? 0);
                case 3:return AverageInteractionData(count: i?['third']?.count ?? 0);
                case 4:return AverageInteractionData(count: i?['fourth']?.count ?? 0);
                case 5:return AverageInteractionData(count: i?['fifth']?.count ?? 0);
                case 6:return AverageInteractionData(count: i?['sixth']?.count ?? 0);
                case 7:return AverageInteractionData(count: i?['seventh']?.count ?? 0);
                case 8:return AverageInteractionData(count: i?['eighth']?.count ?? 0);
                case 9:return AverageInteractionData(count: i?['ninth']?.count ?? 0);
                case 10:return AverageInteractionData(count: i?['tenth']?.count ?? 0);
                case 11:return AverageInteractionData(count: i?['eleventh']?.count ?? 0);
                case 12:return AverageInteractionData(count: i?['twelfth']?.count ?? 0);
                case 13:return AverageInteractionData(count: i?['thirteenth']?.count ?? 0);
                case 14:return AverageInteractionData(count: i?['fourteenth']?.count ?? 0);
                case 15:return AverageInteractionData(count: i?['fifteenth']?.count ?? 0);
                case 16:return AverageInteractionData(count: i?['sixteenth']?.count ?? 0);
                case 17:return AverageInteractionData(count: i?['seventeenth']?.count ?? 0);
                case 18:return AverageInteractionData(count: i?['eighteenth']?.count ?? 0);
                case 19:return AverageInteractionData(count: i?['nineteenth']?.count ?? 0);
                case 20:return AverageInteractionData(count: i?['twentieth']?.count ?? 0);
                case 21:return AverageInteractionData(count: i?['twentyFirst']?.count ?? 0);
                case 22:return AverageInteractionData(count: i?['twentySecond']?.count ?? 0);
                case 23:return AverageInteractionData(count: i?['twentyThird']?.count ?? 0);
                case 24:return AverageInteractionData(count: i?['twentyFourth']?.count ?? 0);
                case 25:return AverageInteractionData(count: i?['twentyFifth']?.count ?? 0);
                case 26:return AverageInteractionData(count: i?['twentySixth']?.count ?? 0);
                case 27:return AverageInteractionData(count: i?['twentySeventh']?.count ?? 0);
                case 28:return AverageInteractionData(count: i?['twentyEighth']?.count ?? 0);
                case 29:return AverageInteractionData(count: i?['twentyNinth']?.count ?? 0);
                case 30:return AverageInteractionData(count: i?['thirtieth']?.count ?? 0);
                case 31:return AverageInteractionData(count: i?['thirtyFirst']?.count ?? 0);
                default:return AverageInteractionData();
              }
            });

            xTitlesInteractionRequests = List.generate(daysInMonth, (index) => (index + 1).toString());

            showLog('xTitlesInteractionRequests >> ${xTitlesInteractionRequests.map((e) => e,).toList()}');
            showLog('xTitlesInteractionRequests >> ${interactionsAverageMonthGraphDataList.map((e) => e.count,).toList()}');
          }
        }
        maxInteractionsValue = interactionsAverageMonthGraphDataList.map((e) => e.count??0.0).reduce((a, b) => a > b ? a : b);


        interactionsAverageState.isLoading = false;
        notifyListeners();
      },
      failure: (NetworkExceptions error) {
        interactionsAverageState.isLoading = false;
        //String errorMsg = NetworkExceptions.getErrorMessage(error);
        //       showCommonErrorDialog(context: context, message: errorMsg);
        notifyListeners();
      },
    );
  }

  ///------------------------------Interactions-Total-Api------------------------------///

  UIState<AverageInteractionResponseModel> interactionsTotalState = UIState<AverageInteractionResponseModel>();

  Future interactionsTotalApi(BuildContext context) async {
    interactionsTotalState.isLoading = true;
    interactionsTotalState.success = null;
    interactionsAverageMonthGraphDataList.clear();
    notifyListeners();

    InteractionsRequestModel requestModel = InteractionsRequestModel(
      year: int.parse(selectedYearInteractionsIndex??'${DateTime.now().year}'),
      month: selectedInteractionMonth != null ? getMonthNumber(selectedInteractionMonth!) : null,
      destinationUuid: ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name)) ? null : selectedDestination?.uuid,
      interactionType: (selectedInteractionCategory == null) ? null : (selectedInteractionStore != null) ? 'STORE_SELECT' : 'CATEGORY_SELECT',
      interactionTypeUuid: (selectedInteractionCategory == null) ? null : (selectedInteractionStore != null) ? selectedInteractionStore?.uuid : selectedInteractionCategory?.uuid,
    );
    String request = interactionsRequestModelToJson(requestModel);

    ApiResult apiResult = await dashboardRepository.interactionsTotalApi(request);
    apiResult.when(
      success: (data) async {
        interactionsTotalState.success = data;

        if (interactionsTotalState.success?.status == ApiEndPoints.apiStatus_200) {
          Map<String, AverageInteractionData>? i = interactionsTotalState.success?.data;

          if (selectedInteractionMonth == null) {
            interactionsAverageMonthGraphDataList = [
              AverageInteractionData(count: i?['jan']?.count ?? 0),
              AverageInteractionData(count: i?['feb']?.count ?? 0),
              AverageInteractionData(count: i?['mar']?.count ?? 0),
              AverageInteractionData(count: i?['apr']?.count ?? 0),
              AverageInteractionData(count: i?['may']?.count ?? 0),
              AverageInteractionData(count: i?['jun']?.count ?? 0),
              AverageInteractionData(count: i?['jul']?.count ?? 0),
              AverageInteractionData(count: i?['aug']?.count ?? 0),
              AverageInteractionData(count: i?['sep']?.count ?? 0),
              AverageInteractionData(count: i?['oct']?.count ?? 0),
              AverageInteractionData(count: i?['nov']?.count ?? 0),
              AverageInteractionData(count: i?['dec']?.count ?? 0),
            ];

            if(i != null) {
              xTitlesInteractionTotalRequests = i.keys.map((e) => e,).toList();
            }
            // xTitles = ['Jan', 'Feb', 'Mar', 'April', 'May', 'June', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          }
          else {
            Map<String, int> monthMap = {'Jan': 1, 'Feb': 2, 'Mar': 3, 'April': 4, 'May': 5, 'June': 6, 'July': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12};

            showLog('selectedMonth \$selectedMonth');
            showLog('monthMap[selectedMonth] \${monthMap[selectedMonth]}');

            int currentYear = int.parse(yearsDynamicList[selectedYearInteractionsTotalIndex]);
            int daysInMonth = DateTime(currentYear, monthMap[selectedInteractionMonth]! + 1, 0).day;

            //leap year
            showLog('selectedMonthselectedMonth $selectedInteractionMonth');
            showLog('daysInMonth 11 : $daysInMonth');
            showLog('currentYear 11 : $currentYear | ${currentYear % 4}');
            if (selectedInteractionMonth == 'Feb' && currentYear % 4 == 0 && (currentYear % 100 != 0 || currentYear % 400 == 0)) {
              daysInMonth = 29;
              showLog('daysInMonth $daysInMonth');
              showLog('currentYear $currentYear');
            }

            showLog('daysInMonth >> \$daysInMonth');

            interactionsAverageMonthGraphDataList = List.generate(daysInMonth, (index) {
              switch (index + 1) {
                case 1:return AverageInteractionData(count: i?['first']?.count ?? 0);
                case 2:return AverageInteractionData(count: i?['second']?.count ?? 0);
                case 3:return AverageInteractionData(count: i?['third']?.count ?? 0);
                case 4:return AverageInteractionData(count: i?['fourth']?.count ?? 0);
                case 5:return AverageInteractionData(count: i?['fifth']?.count ?? 0);
                case 6:return AverageInteractionData(count: i?['sixth']?.count ?? 0);
                case 7:return AverageInteractionData(count: i?['seventh']?.count ?? 0);
                case 8:return AverageInteractionData(count: i?['eighth']?.count ?? 0);
                case 9:return AverageInteractionData(count: i?['ninth']?.count ?? 0);
                case 10:return AverageInteractionData(count: i?['tenth']?.count ?? 0);
                case 11:return AverageInteractionData(count: i?['eleventh']?.count ?? 0);
                case 12:return AverageInteractionData(count: i?['twelfth']?.count ?? 0);
                case 13:return AverageInteractionData(count: i?['thirteenth']?.count ?? 0);
                case 14:return AverageInteractionData(count: i?['fourteenth']?.count ?? 0);
                case 15:return AverageInteractionData(count: i?['fifteenth']?.count ?? 0);
                case 16:return AverageInteractionData(count: i?['sixteenth']?.count ?? 0);
                case 17:return AverageInteractionData(count: i?['seventeenth']?.count ?? 0);
                case 18:return AverageInteractionData(count: i?['eighteenth']?.count ?? 0);
                case 19:return AverageInteractionData(count: i?['nineteenth']?.count ?? 0);
                case 20:return AverageInteractionData(count: i?['twentieth']?.count ?? 0);
                case 21:return AverageInteractionData(count: i?['twentyFirst']?.count ?? 0);
                case 22:return AverageInteractionData(count: i?['twentySecond']?.count ?? 0);
                case 23:return AverageInteractionData(count: i?['twentyThird']?.count ?? 0);
                case 24:return AverageInteractionData(count: i?['twentyFourth']?.count ?? 0);
                case 25:return AverageInteractionData(count: i?['twentyFifth']?.count ?? 0);
                case 26:return AverageInteractionData(count: i?['twentySixth']?.count ?? 0);
                case 27:return AverageInteractionData(count: i?['twentySeventh']?.count ?? 0);
                case 28:return AverageInteractionData(count: i?['twentyEighth']?.count ?? 0);
                case 29:return AverageInteractionData(count: i?['twentyNinth']?.count ?? 0);
                case 30:return AverageInteractionData(count: i?['thirtieth']?.count ?? 0);
                case 31:return AverageInteractionData(count: i?['thirtyFirst']?.count ?? 0);
                default:return AverageInteractionData();
              }
            });

            xTitlesInteractionTotalRequests = List.generate(daysInMonth, (index) => (index + 1).toString());
            xTitlesInteractionRequests = List.generate(daysInMonth, (index) => (index + 1).toString());

            showLog('xTitlesInteractionTotalRequests >> ${xTitlesInteractionTotalRequests.map((e) => e,).toList()}');
            showLog('xTitlesInteractionTotalRequests >> ${interactionsAverageMonthGraphDataList.map((e) => e.count,).toList()}');
          }
        }
        maxInteractionsValue = interactionsAverageMonthGraphDataList.map((e) => e.count??0.0).reduce((a, b) => a > b ? a : b);


        interactionsTotalState.isLoading = false;
        notifyListeners();
      },
      failure: (NetworkExceptions error) {
        interactionsTotalState.isLoading = false;
        //String errorMsg = NetworkExceptions.getErrorMessage(error);
        //       showCommonErrorDialog(context: context, message: errorMsg);
        notifyListeners();
      },
    );
  }


}
