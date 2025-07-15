import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/repository/dashboard/model/destination_name_data_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/most_requested_store_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/navigation_efficiency_response_model.dart';

abstract class DashboardRepository {

  Future sidebarApi();

  ///Destination data list api
  Future<ApiResult<DestinationNameDataResponseModel>> destinationNameDataApi(String request, String pageNo);

  /// Ads Count Api
  Future adsCountApi(String request);

  Future categoryDataListApi(String request, int pageNo, {int? pageSize});

  Future storeDataListApi(String request, int pageNo);

  Future robotDataListApi(String request, int pageNo);

  Future<ApiResult<NavigationEfficiencyResponseModel>> navigationEfficiencyApi(String request);

  Future<ApiResult<MostRequestedStoreResponseModel>> mostRequestedStore(String request);

  Future dashboardCountApi();

  ///dashboard peak usage api
  Future dashboardPeakUsageApi({required String request});

  /// weekdays and weekend api
  Future dashboardWeekInteractionCountApi({required String request});

  ///dashboard uptime api
  Future dashboardUptimeApi({required String request});

  /// Interactions Average Api
  Future interactionsAverageApi(String request);

  /// Interactions Total Api
  Future interactionsTotalApi(String request);

  Future totalNavigationRequestApi(String request);

  Future averageNavigationRequestApi(String request);

}