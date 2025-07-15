
abstract class PurchaseRepository {
  ///Purchase List Api
  Future purchaseListApi({required String request, required int pageNumber, int? dataSize});

  ///Purchase Details Api
  Future purchaseDetailsApi(String purchaseUuid);

  ///Purchase Ads Api
  Future purchaseAdsApi(String purchaseUuid);

  ///Purchase Transaction List Api
  Future purchaseTransactionListApi({required String request, required int pageNumber, int? dataSize}) ;

  ///Update Purchase Ads
  Future updatePurchaseAdsApi(String request);

  ///Purchase Refund Detail
  Future purchaseRefundDetailApi(String purchaseUuid);

  ///Purchase Cancel Detail
  Future purchaseCancelDetailApi(String purchaseUuid);

  ///Purchase Refund Api
  Future purchaseRefundApi(String request);

  ///Purchase Cancel Api
  Future purchaseCancelApi(String request);

  ///Get Purchase Weeks
  Future purchaseWeeksApi(String destinationUuid);

  ///Create Purchase
  Future createPurchaseApi({required String request});
}
