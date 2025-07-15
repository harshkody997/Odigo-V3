
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/client/model/response/client_list_response_model.dart';
import 'package:odigov3/framework/repository/client_ads/contract/client_ads_repository.dart';
import 'package:odigov3/framework/repository/client_ads/model/client_ads_list_response_model.dart';
import 'package:odigov3/framework/repository/client_ads/model/request_model/accept_reject_ad_request_model.dart';
import 'package:odigov3/framework/repository/client_ads/model/request_model/client_ads_list_request_model.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';


final clientAdsController = ChangeNotifierProvider(
      (ref) => getIt<ClientAdsController>(),
);

@injectable
class ClientAdsController extends ChangeNotifier {
  ClientAdsController(this.clientAdsRepository);
  ClientAdsRepository clientAdsRepository;

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    statusTapIndex = -1;
    clientAdsListState.success = null;
    clientAdsListState.isLoading = true;
    clientAdsList.clear();
    changeClientAdsStatusState.success = null;
    changeClientAdsStatusState.isLoading = false;
    deleteClientAdsState.success = null;
    deleteClientAdsState.isLoading = false;
    acceptRejectAdsState.success = null;
    acceptRejectAdsState.isLoading = false;
    rejectReasonCtr.clear();
    searchCtr.clear();
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    selectedClientFilter = null;
    selectedClientTempFilter = null;
    clientFilterCtr.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  /// Search Controller
  TextEditingController searchCtr = TextEditingController();

  int statusTapIndex = -1;

  updateStatusIndex(int value){
    statusTapIndex = value;
    notifyListeners();
  }

  TextEditingController rejectReasonCtr = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey reasonDialogKey = GlobalKey();
  GlobalKey editAdNameDialogKey = GlobalKey();


  /// Filter key
  GlobalKey filterKey = GlobalKey();
  TextEditingController clientFilterCtr = TextEditingController();

  CommonEnumTitleValueModel? selectedFilter = commonActiveDeActiveList[0];
  CommonEnumTitleValueModel? selectedTempFilter = commonActiveDeActiveList[0];
  updateTempSelectedStatus(CommonEnumTitleValueModel? value){
    selectedTempFilter = value;
    notifyListeners();
  }

  updateSelectedStatus(CommonEnumTitleValueModel? value){
    selectedFilter = value;
    notifyListeners();
  }

  ClientData? selectedClientFilter = null;
  ClientData? selectedClientTempFilter = null;
  updateTempSelectedClient(ClientData? value){
    selectedClientTempFilter = value;
    clientFilterCtr.text = selectedClientTempFilter?.name ?? '';
    notifyListeners();
  }

  updateSelectedClient(ClientData? value){
    selectedClientFilter = value;
    notifyListeners();
  }

  resetFilter(){
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    selectedClientFilter = null;
    selectedClientTempFilter = null;
    clientFilterCtr.clear();
    notifyListeners();
  }

  bool get isFilterSelected => selectedFilter != selectedTempFilter || selectedClientFilter != selectedClientTempFilter;

  bool get isClearFilterCall => (selectedFilter == selectedTempFilter && selectedTempFilter != commonActiveDeActiveList[0]) || (selectedClientFilter == selectedClientTempFilter) ;



  /// ----------------------------------------------- Api Integration ----------------------------------------------------///

  ///-----------------Client ads List Api------------------------------->
  var clientAdsListState = UIState<ClientAdsListResponseModel>();
  List<ClientAdsListDto?> clientAdsList =[];

  Future<UIState<ClientAdsListResponseModel>> clientAdsListApi(BuildContext context, {bool isForPagination = false, int? pageSize, String? odigoClientUuid,bool? activeRecords,String? status}) async {
    int pageNo = 1;
    bool apiCall = true;
    if(!isForPagination){
      pageNo = 1;
      clientAdsList.clear();
      clientAdsListState.isLoading = true;
      clientAdsListState.success = null;
    }
    else if(clientAdsListState.success?.hasNextPage ?? false){
      pageNo = (clientAdsListState.success?.pageNumber ?? 0) + 1;
      clientAdsListState.isLoadMore = true;
      clientAdsListState.success = null;
    }
    else{
      apiCall = false;
    }
    notifyListeners();

    if(apiCall) {
      String request = clientAdsListRequestModelToJson(ClientAdsListRequestModel(
          odigoCilentUuid: odigoClientUuid ?? selectedClientFilter?.uuid,
          searchKeyword: searchCtr.text,
          isArchive: false,
        activeRecords: activeRecords ?? selectedFilter?.value,
        status: status
      ));

      final result = await clientAdsRepository.clientAdsListApi(request: request, pageNumber: pageNo, dataSize: pageSize ?? AppConstants.pageSize);

      result.when(success: (data) async {
        clientAdsListState.success = data;
        clientAdsList.addAll(clientAdsListState.success?.data ?? []);
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      });

      clientAdsListState.isLoading = false;
      clientAdsListState.isLoadMore = false;
      notifyListeners();
    }
    return clientAdsListState;

  }

  ///-----------------Change ClientAds Status Api------------------------------->
  var changeClientAdsStatusState = UIState<CommonResponseModel>();

  Future<void> changeClientAdsStatusApi(BuildContext context, {required String uuid, required bool isActive, required int index}) async {
    changeClientAdsStatusState.isLoading = true;
    changeClientAdsStatusState.success = null;
    notifyListeners();

    final result = await clientAdsRepository.changeClientAdsStatusApi(adsUuid: uuid, isActive: isActive);

    result.when(success: (data) async {
      changeClientAdsStatusState.success = data;
      if(changeClientAdsStatusState.success?.status == ApiEndPoints.apiStatus_200) {
        clientAdsList[index]?.active = isActive;
        clientAdsList[index]?.status = isActive ? 'ACTIVE' : 'INACTIVE';
      }
    },
        failure: (NetworkExceptions error) {
          //String errorMsg = NetworkExceptions.getErrorMessage(error);
          //       showCommonErrorDialog(context: context, message: errorMsg);
        });

    changeClientAdsStatusState.isLoading = false;
    notifyListeners();
  }

  ///-----------------ClientAds delete Api------------------------------->
  var deleteClientAdsState = UIState<CommonResponseModel>();

  Future<void> deleteClientAdsApi(BuildContext context, {required String uuid, required int index}) async {
    deleteClientAdsState.isLoading = true;
    deleteClientAdsState.success = null;
    notifyListeners();

    final result = await clientAdsRepository.deleteClientAdsApi(adsUuid: uuid);

    result.when(success: (data) async {
      deleteClientAdsState.success = data;
      if(deleteClientAdsState.success?.status == ApiEndPoints.apiStatus_200) {
        clientAdsList.removeAt(index);
      }
    },
        failure: (NetworkExceptions error) {
          //String errorMsg = NetworkExceptions.getErrorMessage(error);
          //       showCommonErrorDialog(context: context, message: errorMsg);
        });

    deleteClientAdsState.isLoading = false;
    notifyListeners();
  }

  ///-----------------accept Reject Ads Api------------------------------->
  var acceptRejectAdsState = UIState<CommonResponseModel>();

  Future<void> acceptRejectAdsApi(BuildContext context, {required String uuid, required String status}) async {
    acceptRejectAdsState.isLoading = true;
    acceptRejectAdsState.success = null;
    notifyListeners();

    String request = acceptRejectAdRequestModelToJson(AcceptRejectAdRequestModel(
      adsUuid: uuid,
      verificationResultStatus: status,
      rejectReason: (status == 'REJECTED') ? rejectReasonCtr.text : null
    ));

    final result = await clientAdsRepository.acceptRejectAdsApi(request);

    result.when(success: (data) async {
      acceptRejectAdsState.success = data;
    },
        failure: (NetworkExceptions error) {
          //String errorMsg = NetworkExceptions.getErrorMessage(error);
          //       showCommonErrorDialog(context: context, message: errorMsg);
        });

    acceptRejectAdsState.isLoading = false;
    notifyListeners();
  }


}