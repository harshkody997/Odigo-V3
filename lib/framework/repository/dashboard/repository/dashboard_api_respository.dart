import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/dio/dio_client.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/dashboard/contract/dashboard_repository.dart';
import 'package:odigov3/framework/repository/dashboard/model/category_data_list_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/dashboard_count_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/dashboard_peak_usage_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/dashboard_week_interaction_count_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/destination_name_data_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/most_requested_store_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/navigation_efficiency_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/response_model/interactions_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/robot_data_list_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/response_model/ads_count_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/store_data_list_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/total_navigation_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/uptime_response_model.dart';

@LazySingleton(as: DashboardRepository, env: [Env.debug, Env.production])
class DashboardApiRepository implements DashboardRepository {
  final DioClient apiClient;
  DashboardApiRepository(this.apiClient);

  @override
  Future sidebarApi() async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.sidebar);
      SidebarListResponseModel responseModel = sidebarListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<DestinationNameDataResponseModel>> destinationNameDataApi(String request, String pageNo) async {
      try {
        Response? response = await apiClient.postRequest(ApiEndPoints.destinationNameData(pageNo), request);
        DestinationNameDataResponseModel responseModel = destinationNameDataResponseModelFromJson(response.toString());
        return ApiResult.success(data: responseModel);
      } catch (err) {
        return ApiResult.failure(error: NetworkExceptions.getDioException(err));
      }
    }

  @override
  Future adsCountApi(String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.dashboardAdsCount,request);
      DashboardAdsCountResponseModel responseModel =  dashboardAdsCountResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future categoryDataListApi(String request, int pageNo, {int? pageSize}) async {
      try {
        Response? response = await apiClient.postRequest(ApiEndPoints.categoryDataList(pageNo, pageSize), request);
        CategoryDataListResponseModel responseModel = categoryDataListResponseModelFromJson(response.toString());
        return ApiResult.success(data: responseModel);
      } catch (err) {
        return ApiResult.failure(error: NetworkExceptions.getDioException(err));
      }
  }

  @override
  Future storeDataListApi(String request, int pageNo) async {
      try {
        Response? response = await apiClient.postRequest(ApiEndPoints.storeDataList(pageNo), request);
        StoreDataListResponseModel responseModel = storeDataListResponseModelFromJson(response.toString());
        return ApiResult.success(data: responseModel);
      } catch (err) {
        return ApiResult.failure(error: NetworkExceptions.getDioException(err));
      }
  }

  @override
  Future robotDataListApi(String request, int pageNo) async {
      try {
        Response? response = await apiClient.postRequest(ApiEndPoints.robotDataList(pageNo), request);
        RobotDataListResponseModel responseModel = robotDataListResponseModelFromJson(response.toString());
        return ApiResult.success(data: responseModel);
      } catch (err) {
        return ApiResult.failure(error: NetworkExceptions.getDioException(err));
      }
  }

  @override
  Future dashboardCountApi() async {
    try {
      Response? response = await apiClient.getRequest(
          ApiEndPoints.dashboardCount);
      DashboardCountResponseModel responseModel = dashboardCountResponseModelFromJson(
          response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<MostRequestedStoreResponseModel>> mostRequestedStore(String request)async  {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.mostRequestedStore, request);
      MostRequestedStoreResponseModel responseModel = mostRequestedStoreResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<NavigationEfficiencyResponseModel>> navigationEfficiencyApi(String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.navigationEfficiency, request);
      NavigationEfficiencyResponseModel responseModel = navigationEfficiencyResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future dashboardPeakUsageApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.dashboardPeakUsage, request);
      DashboardPeakUsageResponseModel responseModel = dashboardPeakUsageResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future dashboardWeekInteractionCountApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.dashboardWeekInteractionCount, request);
      DashboardWeekInteractionCountResponseModel responseModel = dashboardWeekInteractionCountResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  Future dashboardUptimeApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.dashboardUptime, request);
      UptimeResponseModel responseModel = uptimeResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future interactionsAverageApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.dashboardInteractionAverage, request);
      AverageInteractionResponseModel responseModel = averageInteractionResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future interactionsTotalApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.dashboardInteractionTotal, request);
      AverageInteractionResponseModel responseModel = averageInteractionResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future totalNavigationRequestApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.totalNavigationRequest,request);
      TotalNavigationResponseModel responseModel =  totalNavigationResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future averageNavigationRequestApi(String request)async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.averageNavigationRequest,request);
      TotalNavigationResponseModel responseModel =  totalNavigationResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }



}