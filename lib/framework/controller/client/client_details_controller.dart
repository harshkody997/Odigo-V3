import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/client/contract/client_repository.dart';
import 'package:odigov3/framework/repository/client/model/request/settle_wallet_request_model.dart';
import 'package:odigov3/framework/repository/client/model/response/client_details_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/wallet_transactions/contract/wallet_transaction_repository.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';

final clientDetailsController = ChangeNotifierProvider((ref) => getIt<ClientDetailsController>());

@injectable
class ClientDetailsController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    clientDetailsState.isLoading = true;
    clientDetailsState.success = null;
    selectedTab = 0;
    isWalletBalanceVisible = false;
    if (isNotify) {
      notifyListeners();
    }
  }

  /// Manage Ads status index
  int statusAdsTapIndex = -1;

  updateAdsListStatusIndex(int value) {
    statusAdsTapIndex = value;
    notifyListeners();
  }

  int selectedTab = 0;

  updateSelectedTab(int value) {
    selectedTab = value;
    notifyListeners();
  }

  String formatFullAddressFromClient(ClientDetailsData? client) {
    final parts = [
      client?.houseNumber,
      client?.streetName,
      client?.addressLine1,
      client?.addressLine2,
      client?.landmark,
      client?.cityName,
      client?.stateName,
      client?.postalCode,
    ];

    return parts.where((part) => part != null && part.toString().trim().isNotEmpty).join(', ');
  }

  bool isWalletBalanceVisible = false;
  updateWalletBalanceVisible(){
    isWalletBalanceVisible = !isWalletBalanceVisible;
    notifyListeners();
  }

  /// Settle wallet transaction type
  CommonEnumTitleValueModel? selectedSettleTransactionType;

  /// Settle wallet controllers
  TextEditingController amountCtr = TextEditingController();
  TextEditingController remarksCtr = TextEditingController();
  TextEditingController selectedTransactionCtr = TextEditingController();

  /// Clear form of settle wallet
  void clearSettleWalletFormData(){
    amountCtr.clear();
    remarksCtr.clear();
    selectedTransactionCtr.clear();
    selectedSettleTransactionType = null;
    updateStaticLoader(true);
  }

  /// Settle wallet transaction type list
  List<CommonEnumTitleValueModel> settleWalletTransactionsTypeList = [
    CommonEnumTitleValueModel(title: LocaleKeys.keyCredit,value: 'CREDIT'),
    CommonEnumTitleValueModel(title: LocaleKeys.keyDebit, value: 'DEBIT'),
  ];

  /// Settle wallet form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey settleWalletDialogKey = GlobalKey();

  /// Focus nodes.
  FocusNode remarksFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();

  /// Update selected transaction type
  void updateSelectedTransactionType(CommonEnumTitleValueModel value){
    selectedSettleTransactionType = value;
    notifyListeners();
  }

  bool staticLoader = false;
  void updateStaticLoader(bool value,{bool? isNotify}){
    staticLoader = value;
    if(isNotify ??false){
      notifyListeners();
    }
  }
  //--------------------------------------Api Integration --------------------------------//

  ClientRepository clientRepository;
  WalletTransactionsRepository walletTransactionsRepository;
  ClientDetailsController(this.clientRepository,this.walletTransactionsRepository);
  

  /// client details API
  UIState<ClientDetailsResponseModel> clientDetailsState = UIState<ClientDetailsResponseModel>();
  Future<void> clientDetailsApi(BuildContext context, String clientUuid) async {
    clientDetailsState.isLoading = true;
    clientDetailsState.success = null;
    notifyListeners();

    final result = await clientRepository.getClientDetailsApi(clientUuid);
    result.when(
      success: (data) async {
        clientDetailsState.success = data;
        Session.clientUuid = clientDetailsState.success?.data?.uuid ?? '';
      },
      failure: (NetworkExceptions error) {},
    );

    clientDetailsState.isLoading = false;
    /// Update static loader
    updateStaticLoader(false,isNotify: true);
    notifyListeners();
  }

  /// Settle wallet API
  UIState<CommonResponseModel> settleWalletState = UIState<CommonResponseModel>();
  Future<void> settleWalletApi({required clientUuid}) async {
    settleWalletState.isLoading = true;
    settleWalletState.success = null;
    notifyListeners();

    String request = settleWalletRequestModelToJson(SettleWalletRequestModel(
      odigoClientUuid: clientUuid,
      transactionType: selectedSettleTransactionType?.value,
      amount: int.parse(amountCtr.text),
      remarks: remarksCtr.text,
    ));

    final result = await walletTransactionsRepository.settleWalletApi(request);
    result.when(success: (data) async {
      settleWalletState.success = data;
    }, failure: (NetworkExceptions error) {});
    settleWalletState.isLoading = false;
    notifyListeners();
  }
}