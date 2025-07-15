abstract class WalletTransactionsRepository{

  /// Wallet list api
  Future walletListApi(String request,int pageNo);

  /// Settle wallet api
  Future settleWalletApi(String request);

}