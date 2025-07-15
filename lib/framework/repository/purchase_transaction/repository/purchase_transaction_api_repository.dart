import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/purchase_transaction/contract/purchase_transaction_repository.dart';
import 'package:odigov3/framework/repository/purchase_transaction/model/purchase_transaction_list_response_model.dart';

@LazySingleton(as: PurchaseTransactionRepository, env: [Env.production, Env.debug])
class PurchaseTransactionsApiRepository implements PurchaseTransactionRepository{
  final DioClient apiClient;
  PurchaseTransactionsApiRepository(this.apiClient);


  @override
  Future purchaseTransactionListApi(String request, int pageNum,{int? pageSize}) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getPurchaseTransactionList(pageNum,pageSize: pageSize), request);
      PurchaseTransactionsListResponseModel responseModel = purchaseTransactionsListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future settlePurchaseInstallment(String request) async{
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.settleInstallment, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}