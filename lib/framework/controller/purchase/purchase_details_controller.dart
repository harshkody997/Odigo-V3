import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/client_ads/model/client_ads_list_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/purchase/contract/purchase_repository.dart';
import 'package:odigov3/framework/repository/purchase/model/request/purchase_transaction_list_request_model.dart';
import 'package:odigov3/framework/repository/purchase/model/request/update_purchase_ads_request_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_ads_response_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_details_response_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_transaction_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

final purchaseDetailsController = ChangeNotifierProvider((ref) => getIt<PurchaseDetailsController>());

@injectable
class PurchaseDetailsController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    selectedTab=0;
    purchaseTransactionList = [];
    pageNo = 1;

    if (isNotify) {
      notifyListeners();
    }
  }


  ///Selected Tab
  int selectedTab = 0;

  ///Update Tab Index
  void updateSelectedTab(int value) {
    selectedTab = value;
    notifyListeners();
  }

  ///Fill value on initial time
  void fillValueOnInitial(List<ClientAdsListDto?> clientAdsList) {
    final purchaseUuids = purchaseAdsState.success?.data?.map((e) => e.uuid).toSet() ?? {};
    for (var client in clientAdsList) {
      if (purchaseUuids.contains(client?.uuid)) {
        client?.isSelected = true;
      }
    }
    notifyListeners();
  }

  ///Update Selected Ads
  void updateSelectedAds(List<ClientAdsListDto?> clientAdsList,int index, BuildContext context, String errorMsg) {
    final ad = clientAdsList[index];
    if (ad == null) return;

    if (ad.isSelected == true) {
      ad.isSelected = false;
    } else {
      final selectedCount = clientAdsList.where((e) => e?.isSelected == true).length;
      if (selectedCount < 3) {
        ad.isSelected = true;
      } else {
        showToast(context: context, isSuccess: false, message: errorMsg);
      }
    }
    notifyListeners();
  }


  GlobalKey settlePaymentDialogKey = GlobalKey();

  final settleFormKey = GlobalKey<FormState>();
  FocusNode dateNode = FocusNode();
  TextEditingController dateTextController = TextEditingController();
  FocusNode remarkNode = FocusNode();
  TextEditingController remarkTextController = TextEditingController();

  DateTime? uptimeSettleDateValue;

  ///Update Date
  void updateSettleDate(DateTime uptimeSettleDate) {
    this.uptimeSettleDateValue = uptimeSettleDate;
    dateTextController.text = formatDateToDDMMYYYY(uptimeSettleDate);
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  PurchaseRepository purchaseRepository;

  PurchaseDetailsController(this.purchaseRepository);

  ///Purchase Detail api
  UIState<PurchaseDetailsResponseModel> purchaseDetailState = UIState<PurchaseDetailsResponseModel>();

  Future<void> purchaseDetailApi({String? purchaseUuid}) async {
    purchaseDetailState.isLoading=true;
    purchaseDetailState.success=null;
    notifyListeners();

    final result = await purchaseRepository.purchaseDetailsApi(purchaseUuid??'');
    result.when(
      success: (data) async {
        purchaseDetailState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );
    purchaseDetailState.isLoading = false;
    notifyListeners();
  }

  ///Purchase Ads api
  UIState<PurchaseAdsResponseModel> purchaseAdsState = UIState<PurchaseAdsResponseModel>();

  Future<void> purchaseAdsApi({String? purchaseUuid,List<ClientAdsListDto?>? clientAdsList,bool? isOnChangeAds}) async {
    purchaseAdsState.isLoading=true;
    purchaseAdsState.success=null;
    notifyListeners();

    final result = await purchaseRepository.purchaseAdsApi(purchaseUuid??'');
    result.when(
      success: (data) async {
        purchaseAdsState.success = data;
        if(isOnChangeAds==true){
          fillValueOnInitial(clientAdsList??[]);
        }
      },
      failure: (NetworkExceptions error) {},
    );
    purchaseAdsState.isLoading = false;
    notifyListeners();
  }

  /// Purchase Transaction List users api
  UIState<PurchaseTransactionListResponseModel> purchaseTransactionListState = UIState<PurchaseTransactionListResponseModel>();

  /// Page no for pagination
  int pageNo = 1;
  /// Purchase transaction list
  List<PurchaseTransactionListData> purchaseTransactionList = [];

  Future<void> purchaseTransactionListApi(bool pagination, {String? purchaseUuid}) async {
    if ((purchaseTransactionListState.success?.hasNextPage ?? false) && pagination) {
      pageNo = pageNo + 1;
    }

    if (!pagination) {
      pageNo = 1;
      purchaseTransactionListState.isLoading = true;
      purchaseTransactionList.clear();
    } else {
      purchaseTransactionListState.isLoadMore = true;
      purchaseTransactionListState.success = null;
    }
    notifyListeners();

    PurchaseTransactionListRequestModel requestModel = PurchaseTransactionListRequestModel(
        purchaseUuid: purchaseUuid
    );
    String request = purchaseTransactionListRequestModelToJson(requestModel);

    final result = await purchaseRepository.purchaseTransactionListApi(request: request,pageNumber: pageNo);
    result.when(
      success: (data) async {
        purchaseTransactionListState.success = data;
        purchaseTransactionList.addAll(purchaseTransactionListState.success?.data ?? []);
      },
      failure: (NetworkExceptions error) {},
    );
    purchaseTransactionListState.isLoading = false;
    purchaseTransactionListState.isLoadMore = false;
    notifyListeners();
  }


  ///Update Purchase Ads api
  UIState<CommonResponseModel> updatePurchaseAdsState = UIState<CommonResponseModel>();

  Future<void> updatePurchaseAdsApi({String? purchaseUuid,required List<ClientAdsListDto?> clientAdsList}) async {
    updatePurchaseAdsState.isLoading = true;
    updatePurchaseAdsState.success = null;
    notifyListeners();

    List<String> adsUuid = [];

    ///Selected Ads Count
    clientAdsList.forEach((element){
      if(element?.isSelected==true){
        adsUuid.add(element?.uuid??'');
      }
    });

    UpdatePurchaseAdsRequestModel requestModel = UpdatePurchaseAdsRequestModel(
        uuid: purchaseUuid,
      adsUuids: adsUuid
    );
    String request = updatePurchaseAdsRequestModelToJson(requestModel);

    final result = await purchaseRepository.updatePurchaseAdsApi(request);
    result.when(
      success: (data) async {
        updatePurchaseAdsState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );
    updatePurchaseAdsState.isLoading = false;
    notifyListeners();
  }
}
