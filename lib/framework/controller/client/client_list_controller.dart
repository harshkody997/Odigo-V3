import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/client/contract/client_repository.dart';
import 'package:odigov3/framework/repository/client/model/request/client_list_request_model.dart';
import 'package:odigov3/framework/repository/client/model/response/client_list_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';

final clientListController = ChangeNotifierProvider((ref) => getIt<ClientListController>());

@injectable
class ClientListController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    clientListState.isLoading = true;
    clientListState.success = null;
    statusTapIndex = -1;
    changeClientStatusState.isLoading = true;
    changeClientStatusState.success = null;
    clientList.clear();
    clientPageNo = 1;
    searchController.clear();
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    if (isNotify) {
      notifyListeners();
    }
  }

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  /// Filter key
  GlobalKey filterKey = GlobalKey();

  /// update loading
  void updateLoadingStatus(value) {
    clientListState.isLoading = value;
    notifyListeners();
  }

  /// Manage status index
  int statusTapIndex = -1;
  bool statusValue = false;

  updateStatusIndex(int value){
    statusTapIndex = value;
    notifyListeners();
  }
  // updateStatusIndex(int value) {
  //   statusTapIndex = value;
  //   statusValue = !statusValue;
  //   clientList[value].active = statusValue;
  //   notifyListeners();
  // }

  Timer? debounce;

  ///CLear Client List
  clearClientList() {
    clientList.clear();
    clientListState.success = null;
    clientListState.isLoading = false;
    clientListState.isLoadMore = false;
    clientPageNo = 1;
    notifyListeners();
  }

  /// On Search Changed
  void onSearchChanged(BuildContext context) async {
    if (debounce?.isActive ?? false) {
      debounce?.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 500), () async {
      clearClientList();
      await getClientApi(context, activeRecords: selectedFilter?.value);
    });
  }

  void addToClientList(ClientData? clientData) {
    if (clientData != null) {
      clientList.add(clientData);
    }
    notifyListeners();
  }

  List<ClientData> clientList = [];
  bool isHasMorePage = false;

  Future<void> getClientListWithPaginationApiCall(BuildContext context) async {
    await getClientApi(context);

    scrollController.addListener(() async {
      if (clientListState.success?.hasNextPage == true) {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
          if (!clientListState.isLoadMore) {
            await getClientApi(context, pagination: true);
          }
        }
      }
    });
  }

  /// To format full address
  String formatFullAddress(dynamic item) {
    final parts = [item.houseNumber, item.streetName, item.addressLine1, item.addressLine2, item.landmark, item.cityName, item.stateName, item.postalCode];

    return parts.where((part) => part != null && part.toString().trim().isNotEmpty).join(', ');
  }

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

  resetFilter(){
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    notifyListeners();
  }

  bool get isFilterSelected => selectedFilter != selectedTempFilter;

  bool get isClearFilterCall => (selectedFilter == selectedTempFilter && selectedTempFilter != commonActiveDeActiveList[0]);

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  ClientRepository clientRepository;

  ClientListController(this.clientRepository);

  var clientListState = UIState<ClientListResponseModel>();

  int clientPageNo = 1; // Define this globally in your class to maintain state across calls

  Future<void> getClientApi(BuildContext context, {bool pagination = false, bool? activeRecords}) async {
    if ((clientListState.success?.hasNextPage ?? false) && pagination) {
      clientPageNo += 1;
    } else {
      clientPageNo = 1;
    }

    if (clientPageNo == 1) {
      clientListState.isLoading = true;
      clientList.clear();
    } else {
      clientListState.isLoadMore = true;
    }

    clientListState.success = null;
    notifyListeners();

    ClientListRequestModel requestData = ClientListRequestModel(searchKeyword: searchController.text.trimSpace, activeRecords: activeRecords);

    final request = clientListRequestModelToJson(requestData);

    if (context.mounted) {
      final apiResult = await clientRepository.getClientListApi(clientPageNo, request);

      apiResult.when(
        success: (data) async {
          clientListState.success = data;
          clientList.addAll(clientListState.success?.data ?? []);
          clientListState.isLoading = false;
          clientListState.isLoadMore = false;
        },
        failure: (NetworkExceptions error) {
          clientListState.isLoading = false;
          clientListState.isLoadMore = false;
        },
      );

      notifyListeners();
    }
  }

  /// Change Client Status Active/InActive Api
  UIState<CommonResponseModel> changeClientStatusState = UIState<CommonResponseModel>();
  
  Future changeClientStatusAPI(BuildContext context,String uuid,bool status,int index) async {
    changeClientStatusState.isLoading = true;
    changeClientStatusState.success = null;
    notifyListeners();

    final result = await clientRepository.activeDeActiveClientApi(uuid, status);

    result.when(
      success: (data) async {
        notifyListeners();
        changeClientStatusState.isLoading = false;
        changeClientStatusState.success = data;
        if(changeClientStatusState.success?.status == ApiEndPoints.apiStatus_200){
          clientList[index].active = status;
        }
      },
      failure: (NetworkExceptions error) {
        changeClientStatusState.isLoading = false;
      },
    );
    changeClientStatusState.isLoading = false;
    notifyListeners();
  }
}
