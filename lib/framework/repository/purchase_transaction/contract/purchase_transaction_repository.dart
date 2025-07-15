abstract class PurchaseTransactionRepository{

  /// Purchase transaction list api
  Future purchaseTransactionListApi(String request,int pageNo,{int pageSize});

  /// Settle purchase transaction api
  Future settlePurchaseInstallment(String request);

}