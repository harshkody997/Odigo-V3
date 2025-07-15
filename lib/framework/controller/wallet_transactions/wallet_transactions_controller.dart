import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/wallet_transactions/contract/wallet_transaction_repository.dart';
import 'package:odigov3/framework/repository/wallet_transactions/model/wallet_transactions_list_response_model.dart';
import 'package:odigov3/framework/repository/wallet_transactions/model/wallet_transactions_request_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';


final walletTransactionsController = ChangeNotifierProvider(
      (ref) => getIt<WalletTransactionsController>(),
);

@injectable
class WalletTransactionsController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool? isNotify }) {
    walletListState.isLoading = true;
    walletListState.isLoadMore = false;
    walletListState.success = null;
    clearFilters();
    walletList.clear();
    if (isNotify??false) {
      notifyListeners();
    }
  }

  /// Wallet list
  List<WalletData>  walletList= [];
  // List<WalletData>  walletList= [
  //   WalletData(uuid: 'xnhd-dskds-ndjsnd',odigoClientName: 'Hafiza',status: 'PAID',createdAt: 1750403049000,transactionType: 'CREDIT',originalPrice: 10.0),
  //   WalletData(uuid: 'xnhd-dskds-ndjsnd',odigoClientName: 'Bhumit',status: 'CANCELLED',createdAt: 1750439049000,transactionType: 'CREDIT',originalPrice: 10.0),
  //   WalletData(uuid: 'xnhd-dskds-ndjsnd',odigoClientName: 'Hafiza',status: 'PENDING',createdAt: 1750403049000,transactionType: 'DEBIT',originalPrice: 10.0),
  //   WalletData(uuid: 'xnhd-dskds-ndjsnd',odigoClientName: 'Hafiza',status: 'CANCELLED',createdAt: 1750403049000,transactionType: 'CREDIT',originalPrice: 10.0),
  //   WalletData(uuid: 'xnhd-dskds-ndjsnd',odigoClientName: 'Muskan',status: 'PENDING',createdAt: 1750439049000,transactionType: 'DEBIT',originalPrice: 10.0),
  //   WalletData(uuid: 'xnhd-dskds-ndjsnd',odigoClientName: 'Hafiza',status: 'CANCELLED',createdAt: 1750403049000,transactionType: 'CREDIT',originalPrice: 10.0),
  //   WalletData(uuid: 'xnhd-dskds-ndjsnd',odigoClientName: 'Krishna',status: 'PAID',createdAt: 1750403049000,transactionType: 'CREDIT',originalPrice: 10.0),
  //   WalletData(uuid: 'xnhd-dskds-ndjsnd',odigoClientName: 'Hafiza',status: 'PENDING',createdAt: 1750403049000,transactionType: 'DEBIT',originalPrice: 10.0),
  //   WalletData(uuid: 'xnhd-dskds-ndjsnd',odigoClientName: 'Bhumit',status: 'CANCELLED',createdAt: 1750439049000,transactionType: 'DEBIT',originalPrice: 10.0),
  // ];

  /// Page no for pagination
  int pageNo = 1;

  /// Transactions Type Filter list
  List<CommonEnumTitleValueModel> transactionsTypeList = [
    CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null),
    CommonEnumTitleValueModel(title: LocaleKeys.keyCredit,value: 'CREDIT'),
    CommonEnumTitleValueModel(title: LocaleKeys.keyDebit, value: 'DEBIT'),
  ];

  /// Filter key
  GlobalKey filterKey = GlobalKey();

  /// Filter objects
  CommonEnumTitleValueModel selectedType = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  CommonEnumTitleValueModel tempSelectedType =CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);

  /// update temp status filter
  void changeTempSelectedType(CommonEnumTitleValueModel value){
    tempSelectedType = value;
    notifyListeners();
  }

  /// Apply filters
  void applyFilters(){
    selectedType = tempSelectedType;
    selectedStartDate = tempSelectedStartDate;
    selectedEndDate = tempSelectedEndDate;
    notifyListeners();
  }

  /// Prefill selected filters
  void prefillFilters(){
    dateController.clear();
    tempSelectedType = selectedType;
    tempSelectedStartDate = selectedStartDate;
    tempSelectedEndDate = selectedEndDate;
    dateController.text = formatDateRange([tempSelectedStartDate, tempSelectedEndDate]);
  }

  /// Clear filters
  void clearFilters(){
    tempSelectedType = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    selectedType = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
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


  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  WalletTransactionsRepository walletTransactionsRepository;
  WalletTransactionsController(this.walletTransactionsRepository);

  /// wallet List API
  UIState<WalletTransactionsListResponseModel> walletListState = UIState<WalletTransactionsListResponseModel>();
  Future<void> walletListApi(bool pagination, {String? clientUuid, String? purchaseId, }) async {

    if ((walletListState.success?.hasNextPage ?? false) && pagination) {
      pageNo = pageNo + 1;
    }

    if (!pagination) {
      pageNo = 1;
      walletListState.isLoading = true;
      walletList.clear();
    } else {
      walletListState.isLoadMore = true;
      walletListState.success = null;
    }

    notifyListeners();

    String request = walletTransactionsRequestModelToJson(WalletTransactionsRequestModel(
      purchaseUuid: purchaseId,
      odigoClientUuid: clientUuid,
      transactionType: selectedType.value,
      fromDate: selectedStartDate?.toIso8601String(),
          //?.add(Duration(days: 1))

      toDate: selectedEndDate?.toIso8601String(),
         // ?.add(Duration(days: 1))

    ));

    final result = await walletTransactionsRepository.walletListApi(request,pageNo);
    result.when(success: (data) async {
      walletListState.success = data;
      walletList.addAll(walletListState.success?.data ?? []);
    }, failure: (NetworkExceptions error) {
    });
    walletListState.isLoading = false;
    walletListState.isLoadMore = false;
    notifyListeners();
  }
}
