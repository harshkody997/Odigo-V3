import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/device/contract/device_repositiry.dart';
import 'package:odigov3/framework/repository/device/model/device_details_reponse_model.dart';
import 'package:odigov3/framework/repository/device/model/device_list_model.dart';
import 'package:odigov3/framework/repository/wallet_transactions/contract/wallet_transaction_repository.dart';
import 'package:odigov3/framework/repository/wallet_transactions/model/wallet_transactions_list_response_model.dart';

@LazySingleton(as: WalletTransactionsRepository, env: [Env.production, Env.debug])
class WalletTransactionsApiRepository implements WalletTransactionsRepository{
  final DioClient apiClient;
  WalletTransactionsApiRepository(this.apiClient);


  @override
  Future walletListApi(String request, int pageNum,{int? pageSize}) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getWalletList(pageNum,pageSize: pageSize), request);
      WalletTransactionsListResponseModel responseModel = walletTransactionsListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future settleWalletApi(String request) async{
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.settleWallet, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}