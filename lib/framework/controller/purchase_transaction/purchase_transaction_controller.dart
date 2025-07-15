import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/purchase_transaction/contract/purchase_transaction_repository.dart';
import 'package:odigov3/framework/repository/purchase_transaction/model/purchase_transaction_list_response_model.dart';
import 'package:odigov3/framework/repository/purchase_transaction/model/purchase_transaction_request_model.dart';
import 'package:odigov3/framework/repository/purchase_transaction/model/settle_purchase_transaction_request_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import '../../dependency_injection/inject.dart';


final purchaseTransactionController = ChangeNotifierProvider(
      (ref) => getIt<PurchaseTransactionController>(),
);

@injectable
class PurchaseTransactionController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    purchaseTransactionListState.isLoading = true;
    purchaseTransactionList.clear();
    pageNo = 1;
    purchaseTransactionListState.success = null;
    clearFilters();
    clearFormData();
    if (isNotify) {
      notifyListeners();
    }
  }

  /// Purchase Transaction list
  List<PurchaseTransactionData> purchaseTransactionList = [];

  /// Page no for pagination 
  int pageNo = 1;

  /// Transactions Status Filter list
  List<CommonEnumTitleValueModel> transactionsStatusList = [
    CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null),
    CommonEnumTitleValueModel(title: LocaleKeys.keyPending,value: StatusEnum.PENDING.name),
    CommonEnumTitleValueModel(title: LocaleKeys.keyPaid, value: StatusEnum.PAID.name),
    CommonEnumTitleValueModel(title: LocaleKeys.keyCancelled, value: StatusEnum.CANCELLED.name),
  ];

  /// Filter key
  GlobalKey filterKey = GlobalKey();

  /// Filter objects
  CommonEnumTitleValueModel selectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  CommonEnumTitleValueModel tempSelectedStatus =CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);

  /// update temp status filter
  void changeTempSelectedStatus(CommonEnumTitleValueModel value){
    tempSelectedStatus = value;
    notifyListeners();
  }

  /// Apply filter
  void applyFilters(){
    selectedStatus = tempSelectedStatus;
    selectedStartDate = tempSelectedStartDate;
    selectedEndDate = tempSelectedEndDate;
    notifyListeners();
  }

  /// Prefill selected filters
  void prefillFilters(){
    dateController.clear();
    tempSelectedStatus = selectedStatus;
    tempSelectedStartDate = selectedStartDate;
    tempSelectedEndDate = selectedEndDate;
    dateController.text = formatDateRange([tempSelectedStartDate, tempSelectedEndDate]);
  }

  /// Clear filters
  void clearFilters(){
    tempSelectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    selectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
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
  changeDateValue(List<DateTime?>? value) {
    ///Set Start Date
    tempSelectedStartDate = value?.first;

    ///Set End Date
    tempSelectedEndDate = value?.last;

    ///Set value in dateController to show in field like 13 Mar,2025 - 16 Mar,2025
    dateController.text = formatDateRange([tempSelectedStartDate, tempSelectedEndDate]);
    notifyListeners();
  }

  /// Settlement selected date
  DateTime? selectedSettleDate;

  /// Settlement remarks controller and date controller
  TextEditingController settlementRemarksCtr = TextEditingController();
  TextEditingController settlementDateCtr = TextEditingController();


  /// Form Key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Clear settle form
  clearFormData(){
    selectedSettleDate = null;
    settlementRemarksCtr.clear();
    settlementDateCtr.clear();
    settleTransactionState.success = null;
    settleTransactionState.isLoading = false;
    Future.delayed(const Duration(milliseconds: 50), () {
      formKey.currentState?.reset();
    });
  }

  /// Settle transaction dialog key
  GlobalKey settleTransactionKey = GlobalKey();


  ///Change settle transaction Selected Date value
  changeSettleTransactionDateValue(List<DateTime?> value) {
    ///Set Start Date
    selectedSettleDate = value.first;

    if(selectedSettleDate != null){
      ///Set value in settlementDate controller to show in field like 13 Mar,2025 - 16 Mar,2025
      settlementDateCtr.text = DateFormat('dd/MM/yyyy').format(selectedSettleDate!);
    }
    notifyListeners();
  }
  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */
  PurchaseTransactionRepository purchaseTransactionRepository;
  PurchaseTransactionController(this.purchaseTransactionRepository);

  /// Purchase transaction list api
  UIState<PurchaseTransactionsListResponseModel> purchaseTransactionListState = UIState<PurchaseTransactionsListResponseModel>();
  Future<void> purchaseTransactionListApi(bool pagination, {String? clientUuid, String? purchaseId, String? destinationId}) async {

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

    String request = purchaseTransactionsRequestModelToJson(PurchaseTransactionsRequestModel(
      purchaseUuid: purchaseId,
      odigoClientUuid: clientUuid,
      destinationUuid: destinationId,
      status: selectedStatus.value,
      fromInstallmentDate:selectedStartDate != null?DateFormat('yyyy-MM-dd').format(selectedStartDate!).toString(): null ,
      toInstallmentDate:selectedEndDate != null?DateFormat('yyyy-MM-dd').format(selectedEndDate!).toString(): null ,
    ));

    final result = await purchaseTransactionRepository.purchaseTransactionListApi(request,pageNo);
    result.when(success: (data) async {
      purchaseTransactionListState.success = data;
      purchaseTransactionList.addAll(purchaseTransactionListState.success?.data ?? []);
    }, failure: (NetworkExceptions error) {
    });
    purchaseTransactionListState.isLoading = false;
    purchaseTransactionListState.isLoadMore = false;
    notifyListeners();
  }

  /// Settle installment transaction api
  UIState<CommonResponseModel> settleTransactionState = UIState<CommonResponseModel>();
  Future<void> settleTransactionApi({required String uuid}) async {
    settleTransactionState.isLoading = true;
    settleTransactionState.success = null;
    notifyListeners();

    String request = settlePurchaseTransactionRequestModelToJson(SettlePurchaseTransactionRequestModel(
      uuid: uuid,
      paymentStatus: 'PAID',
      installmentDate: selectedSettleDate,
      remarks: settlementRemarksCtr.text,
    ));

    final result = await purchaseTransactionRepository.settlePurchaseInstallment(request);
    result.when(success: (data) async {
      settleTransactionState.success = data;
    }, failure: (NetworkExceptions error) {
    });
    settleTransactionState.isLoading = false;
    notifyListeners();
  }

}
