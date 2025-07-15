import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/purchase/contract/purchase_repository.dart';
import 'package:odigov3/framework/repository/purchase/model/request/purchase_cancel_request_model.dart';
import 'package:odigov3/framework/repository/purchase/model/request/purchase_list_request_model.dart';
import 'package:odigov3/framework/repository/purchase/model/request/purchase_refund_request_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_cancel_detail_response_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_refund_detail_response_model.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';

final purchaseListController = ChangeNotifierProvider((ref) => getIt<PurchaseListController>());

@injectable
class PurchaseListController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    purchaseListState.isLoading = true;
    purchaseListState.isLoadMore = true;
    purchaseListState.success = null;
    purchaseList.clear();
    pageNo = 1;
    purchaseSearchController.clear();
    remarkTextController.clear();
    refundedPriceTextController.clear();
    remarkCancelTextController.clear();
    refundedPriceTextController.clear();
    purchaseListState.isLoadMore = true;
    purchaseListState.success = null;
    purchaseRefundDetailState.isLoading = false;
    purchaseRefundDetailState.success = null;
    purchaseCancelDetailState.isLoading = false;
    purchaseCancelDetailState.success = null;
    purchaseRefundState.isLoading = false;
    purchaseRefundState.success = null;
    purchaseCancelState.isLoading = false;
    purchaseCancelState.success = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  /// Purchase list
  List<PurchaseData> purchaseList = [];

  /// Page no for pagination
  int pageNo = 1;

  SearchController purchaseSearchController = SearchController();
  Timer? debounce;

  /// Filter key
  GlobalKey filterKey = GlobalKey();

  /// Purchase Status Filter list
  List<CommonEnumTitleValueModel> purchaseStatusList = [
    CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null),
    CommonEnumTitleValueModel(title: LocaleKeys.keyUpcoming,value: StatusEnum.UPCOMING.name),
    CommonEnumTitleValueModel(title: LocaleKeys.keyOngoing, value: StatusEnum.ONGOING.name),
    CommonEnumTitleValueModel(title: LocaleKeys.keyCancelled, value: StatusEnum.CANCELLED.name),
    CommonEnumTitleValueModel(title: LocaleKeys.keyRefundCompleted, value: StatusEnum.REFUND_COMPLETED.name),
  ];

  /// Payment Type Filter list
  List<CommonEnumTitleValueModel> paymentTypeList = [
    CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null),
    CommonEnumTitleValueModel(title: LocaleKeys.keyPartial,value: StatusEnum.PARTIAL.name),
    CommonEnumTitleValueModel(title: LocaleKeys.keyFull, value: StatusEnum.FULL.name)
  ];

  /// Purchase Type Status Filter list
  List<CommonEnumTitleValueModel> purchaseTypeList = [
    CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null),
    CommonEnumTitleValueModel(title: LocaleKeys.keyPremium,value: PurchaseType.PREMIUM.name),
    CommonEnumTitleValueModel(title: LocaleKeys.keyFiller, value: PurchaseType.FILLER.name)
  ];

  /// Filter objects
  CommonEnumTitleValueModel selectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  CommonEnumTitleValueModel tempSelectedStatus =CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  CommonEnumTitleValueModel selectedPaymentType = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  CommonEnumTitleValueModel tempSelectedPaymentType =CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  CommonEnumTitleValueModel selectedPurchaseType = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  CommonEnumTitleValueModel tempSelectedPurchaseType =CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);

  /// update temp status filter
  void changeTempSelectedStatus(CommonEnumTitleValueModel value){
    tempSelectedStatus = value;
    notifyListeners();
  }

  /// update Purchase Type filter
  void changePurchaseTypeSelectedStatus(CommonEnumTitleValueModel value){
    tempSelectedPurchaseType = value;
    notifyListeners();
  }

  /// update Payment Type filter
  void changePaymentTypeSelectedStatus(CommonEnumTitleValueModel value){
    tempSelectedPaymentType = value;
    notifyListeners();
  }

  /// Apply filter
  void applyFilters(){
    selectedStatus = tempSelectedStatus;
    selectedStartDate = tempSelectedStartDate;
    selectedEndDate = tempSelectedEndDate;
    selectedPaymentType=tempSelectedPaymentType;
    selectedPurchaseType=tempSelectedPurchaseType;
    notifyListeners();
  }

  /// Prefill selected filters
  void prefillFilters(){
    dateController.clear();
    tempSelectedStatus = selectedStatus;
    tempSelectedStartDate = selectedStartDate;
    tempSelectedEndDate = selectedEndDate;
    tempSelectedPaymentType=selectedPaymentType;
    tempSelectedPurchaseType=selectedPurchaseType;
    dateController.text = formatDateRange([tempSelectedStartDate, tempSelectedEndDate]);
  }

  /// Clear filters
  void clearFilters(){
    tempSelectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    selectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    selectedPaymentType = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    tempSelectedPaymentType = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    selectedPurchaseType = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    tempSelectedPurchaseType = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    selectedStartDate = null;
    selectedEndDate = null;
    tempSelectedEndDate = null;
    tempSelectedStartDate = null;
    dateController.clear();
  }

  /// date filter controller
  TextEditingController dateController = TextEditingController();

  ///Start Date
  DateTime? selectedStartDate;
  DateTime? tempSelectedStartDate;

  ///End Date
  DateTime? selectedEndDate;
  DateTime? tempSelectedEndDate;

  ///Change Selected Date value
  changeDateValue(List<DateTime?> value) {
    ///Set Start Date
    tempSelectedStartDate = value.first;

    ///Set End Date
    tempSelectedEndDate = value.last;

    ///Set value in dateController to show in field like 13 Mar,2025 - 16 Mar,2025
    dateController.text = formatDateRange([tempSelectedStartDate, tempSelectedEndDate]);
    notifyListeners();
  }

  ///Refund Dialog
  final refundFormKey = GlobalKey<FormState>();
  GlobalKey refundDialogKey = GlobalKey();
  FocusNode remarkNode = FocusNode();
  TextEditingController remarkTextController = TextEditingController();
  FocusNode refundedPriceNode = FocusNode();
  TextEditingController refundedPriceTextController = TextEditingController();

  ///Clear Refund Dialog Value
  clearRefundDialogValue(){
    remarkTextController.text='';
    refundedPriceTextController.text='';
    notifyListeners();
  }

  ///Cancel Dialog
  final cancelFormKey = GlobalKey<FormState>();
  GlobalKey cancelDialogKey = GlobalKey();
  FocusNode remarkCancelNode = FocusNode();
  TextEditingController remarkCancelTextController = TextEditingController();
  FocusNode cancelledPriceNode = FocusNode();
  TextEditingController cancelledPriceTextController = TextEditingController();

  ///Clear Cancel Dialog Value
  clearCancelDialogValue(){
    remarkCancelTextController.text='';
    cancelledPriceTextController.text='';
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  PurchaseRepository purchaseRepository;

  PurchaseListController(this.purchaseRepository);

  /// Purchase List users api
  UIState<PurchaseListResponseModel> purchaseListState = UIState<PurchaseListResponseModel>();

  Future<void> purchaseListApi(bool pagination, {String? odigoClientUuid, String? destinationUuid}) async {
    if ((purchaseListState.success?.hasNextPage ?? false) && pagination) {
      pageNo = pageNo + 1;
    }

    if (!pagination) {
      pageNo = 1;
      purchaseListState.isLoading = true;
      purchaseList.clear();
    } else {
      purchaseListState.isLoadMore = true;
      purchaseListState.success = null;
    }
    notifyListeners();

    PurchaseListRequestModel requestModel = PurchaseListRequestModel(
      odigoClientUuid: odigoClientUuid,
      destinationUuid: destinationUuid,
      searchKeyword: purchaseSearchController.text,
      purchaseType: selectedPurchaseType.value,
      paymentType: selectedPaymentType.value,
        status: selectedStatus.value,
        fromDate:selectedStartDate != null?DateFormat('yyyy-MM-dd').format(selectedStartDate!).toString(): null ,
        toDate:selectedEndDate != null?DateFormat('yyyy-MM-dd').format(selectedEndDate!).toString(): null
    );
    String request = purchaseListRequestModelToJson(requestModel);

    final result = await purchaseRepository.purchaseListApi(request: request,pageNumber: pageNo);
    result.when(
      success: (data) async {
        purchaseListState.success = data;
        purchaseList.addAll(purchaseListState.success?.data ?? []);
      },
      failure: (NetworkExceptions error) {},
    );
    purchaseListState.isLoading = false;
    purchaseListState.isLoadMore = false;
    notifyListeners();
  }

  /// Purchase Refund Detail api
  UIState<PurchaseRefundDetailResponseModel> purchaseRefundDetailState = UIState<PurchaseRefundDetailResponseModel>();

  Future<void> purchaseRefundDetailApi({String? purchaseUuid}) async {
    purchaseRefundDetailState.isLoading = true;
    purchaseRefundDetailState.success = null;
    notifyListeners();

    final result = await purchaseRepository.purchaseRefundDetailApi(purchaseUuid??'');
    result.when(
      success: (data) async {
        purchaseRefundDetailState.success = data;
        refundedPriceTextController.text='${purchaseRefundDetailState.success?.data?.systemCalculatedRefundPrice??0}';
      },
      failure: (NetworkExceptions error) {},
    );
    purchaseRefundDetailState.isLoading = false;
    notifyListeners();
  }

  /// Purchase Cancel Detail api
  UIState<PurchaseCancelDetailResponseModel> purchaseCancelDetailState = UIState<PurchaseCancelDetailResponseModel>();

  Future<void> purchaseCancelDetailApi({String? purchaseUuid}) async {
    purchaseCancelDetailState.isLoading = true;
    purchaseCancelDetailState.success = null;
    notifyListeners();

    final result = await purchaseRepository.purchaseCancelDetailApi(purchaseUuid??'');
    result.when(
      success: (data) async {
        purchaseCancelDetailState.success = data;
        cancelledPriceTextController.text='${purchaseCancelDetailState.success?.data?.amount??0.0}';
      },
      failure: (NetworkExceptions error) {},
    );
    purchaseCancelDetailState.isLoading = false;
    notifyListeners();
  }

  ///Purchase Refund api
  UIState<CommonResponseModel> purchaseRefundState = UIState<CommonResponseModel>();

  Future<void> purchaseRefundApi({String? purchaseUuid}) async {
    purchaseRefundState.isLoading = true;
    purchaseRefundState.success = null;
    notifyListeners();

    PurchaseRefundRequestModel requestModel = PurchaseRefundRequestModel(
        uuid: purchaseUuid,
        refundedPrice: int.parse(refundedPriceTextController.text),
        remarks: remarkTextController.text
    );
    String request = purchaseRefundRequestModelToJson(requestModel);

    final result = await purchaseRepository.purchaseRefundApi(request);
    result.when(
      success: (data) async {
        purchaseRefundState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );
    purchaseRefundState.isLoading = false;
    notifyListeners();
  }


  ///Purchase Cancel api
  UIState<CommonResponseModel> purchaseCancelState = UIState<CommonResponseModel>();

  Future<void> purchaseCancelApi({String? purchaseUuid}) async {
    purchaseCancelState.isLoading = true;
    purchaseCancelState.success = null;
    notifyListeners();

    PurchaseCancelRequestModel requestModel = PurchaseCancelRequestModel(
        uuid: purchaseUuid,
        cancelledPrice: double.parse(cancelledPriceTextController.text),
        remarks: remarkCancelTextController.text
    );
    String request = purchaseCancelRequestModelToJson(requestModel);

    final result = await purchaseRepository.purchaseCancelApi(request);
    result.when(
      success: (data) async {
        purchaseCancelState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );
    purchaseCancelState.isLoading = false;
    notifyListeners();
  }
}
