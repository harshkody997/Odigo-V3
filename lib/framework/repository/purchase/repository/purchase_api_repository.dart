import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/purchase/contract/purchase_repository.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_ads_response_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_cancel_detail_response_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_details_response_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_refund_detail_response_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_response_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_transaction_list_response_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_weeks_response_model.dart';
import 'package:odigov3/ui/utils/app_constants.dart';

@LazySingleton(as: PurchaseRepository, env: Env.environments)
class PurchaseApiRepository implements PurchaseRepository {
  final DioClient apiClient;

  PurchaseApiRepository(this.apiClient);

  ///Purchase List Api
  @override
  Future purchaseListApi({required String request, required int pageNumber, int? dataSize}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.purchaseList(pageNumber, dataSize??pageSize), request);
      PurchaseListResponseModel responseModel = purchaseListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Purchase Details
  @override
  Future purchaseDetailsApi(String purchaseUuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.purchaseDetail(purchaseUuid));
      PurchaseDetailsResponseModel responseModel = purchaseDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Purchase Ads
  @override
  Future purchaseAdsApi(String purchaseUuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.purchaseAds(purchaseUuid));
      PurchaseAdsResponseModel responseModel = purchaseAdsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Purchase Transaction List Api
  @override
  Future purchaseTransactionListApi({required String request, required int pageNumber, int? dataSize}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.purchaseTransactionList(pageNumber, dataSize??pageSize ), request);
      PurchaseTransactionListResponseModel responseModel = purchaseTransactionListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Update Purchase Ads
  @override
  Future updatePurchaseAdsApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updatePurchaseAds,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Purchase Refund Detail
  @override
  Future purchaseRefundDetailApi(String purchaseUuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.purchaseRefundDetail(purchaseUuid));
      PurchaseRefundDetailResponseModel responseModel = purchaseRefundDetailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Purchase Cancel Detail
  @override
  Future purchaseCancelDetailApi(String purchaseUuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.purchaseCancelDetail(purchaseUuid));
      PurchaseCancelDetailResponseModel responseModel = purchaseCancelDetailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Purchase Refund Api
  @override
  Future purchaseRefundApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.purchaseRefund,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Purchase Cancel Api
  @override
  Future purchaseCancelApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.purchaseCancel,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Get Purchase Weeks
  @override
  Future purchaseWeeksApi(String destinationUuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.purchaseWeeks(destinationUuid));
      PurchaseWeeksResponseModel responseModel = purchaseWeeksResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Create Purchase Api
  @override
  Future createPurchaseApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.purchase, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}
