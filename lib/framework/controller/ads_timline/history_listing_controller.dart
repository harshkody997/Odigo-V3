import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/ads_sequence/contract/ads_sequence_repository.dart';
import 'package:odigov3/framework/repository/ads_sequence/model/ads_sequence_history_response_model.dart';
import 'package:odigov3/framework/repository/ads_sequence/model/request/sequence_history_list_request_model.dart';
import 'package:odigov3/framework/repository/client/model/response/client_list_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';

final historyListingController = ChangeNotifierProvider(
  (ref) => getIt<HistoryListingController>(),
);

@injectable
class HistoryListingController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    historyList.clear();
    adsSequenceHistoryListState.success = null;
    adsSequenceHistoryListState.isLoading = false;
    adsSequenceHistoryListState.isLoadMore = false;
    pageNo = 1;
    selectedDestination = null;
    selectedDestinationUuid = null;
    searchDestinationController.clear();
    dateController.clear();
    clientCtr.clear();

    if (isNotify) {
      notifyListeners();
    }
  }

  /// Filter key
  GlobalKey filterKey = GlobalKey();
  TextEditingController searchDestinationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  GlobalKey ticketFilterDialogKey = GlobalKey();

  /// Selected date
  DateTime? selectedDate;

  ///Change Selected Date value
  changeSelectedDateValue(List<DateTime?> value) {
    /// Set Selected Date
    selectedDate = value.first;

    if (selectedDate != null) {
      ///Set value in Date controller to show in field like 13 Mar,2025 - 16 Mar,2025
      dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
    }
    notifyListeners();
  }

  String? selectedDestination;
  String? selectedDestinationUuid;

  void updateDestinationDropdown(String value, String uuid) {
    selectedDestination = value;
    selectedDestinationUuid = uuid;
    notifyListeners();
  }

  /// Ads Sequence History List
  List<AdsSequenceHistoryData> historyList = [];

  /// Clear Ads Sequence History List
  clearAdsSequenceHistoryList() {
    historyList.clear();
    adsSequenceHistoryListState.success = null;
    adsSequenceHistoryListState.isLoading = false;
    adsSequenceHistoryListState.isLoadMore = false;
    pageNo = 1;
    notifyListeners();
  }

  TextEditingController clientCtr = TextEditingController();

  CommonEnumTitleValueModel? selectedFilter = commonActiveDeActiveList[0];
  CommonEnumTitleValueModel? selectedTempFilter = commonActiveDeActiveList[0];

  updateTempSelectedStatus(CommonEnumTitleValueModel? value) {
    selectedTempFilter = value;
    notifyListeners();
  }

  updateSelectedStatus(CommonEnumTitleValueModel? value) {
    selectedFilter = value;
    notifyListeners();
  }

  ClientData? selectedClientFilter = null;
  ClientData? selectedClientTempFilter = null;

  updateTempSelectedClient(ClientData? value) {
    selectedClientTempFilter = value;
    clientCtr.text = selectedClientTempFilter?.name ?? '';
    notifyListeners();
  }

  updateSelectedClient(ClientData? value) {
    selectedClientFilter = value;
    notifyListeners();
  }

  resetFilter() {
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    selectedClientFilter = null;
    selectedClientTempFilter = null;
    clientCtr.clear();
    notifyListeners();
  }

  bool get isFilterSelected => selectedFilter != selectedTempFilter || selectedClientFilter != selectedClientTempFilter;

  bool get isClearFilterCall => (selectedFilter == selectedTempFilter && selectedTempFilter != commonActiveDeActiveList[0]) || (selectedClientFilter == selectedClientTempFilter);

  bool get isFilterApplied => (selectedFilter != null && selectedFilter != commonActiveDeActiveList[0] || selectedClientFilter != null);

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  AdsSequenceRepository adsSequenceRepository;

  HistoryListingController(this.adsSequenceRepository);

  UIState<SequenceHistoryListResponseModel> adsSequenceHistoryListState = UIState<SequenceHistoryListResponseModel>();

  int pageNo = 1;

  Future<void> getAdsSequenceHistoryApi(BuildContext context, {bool pagination = false, bool? activeRecords, String? destinationUuid, String? odigoClientUuid}) async {
    if ((adsSequenceHistoryListState.success?.hasNextPage ?? false) && pagination) {
      pageNo += 1;
    } else {
      pageNo = 1;
    }

    if (pageNo == 1) {
      adsSequenceHistoryListState.isLoading = true;
      historyList.clear();
    } else {
      adsSequenceHistoryListState.isLoadMore = true;
    }

    adsSequenceHistoryListState.success = null;
    notifyListeners();

    SequenceHistoryListRequestModel requestData = SequenceHistoryListRequestModel(
      destinationUuid: destinationUuid ?? '',
      odigoClientUuid: odigoClientUuid ?? '',
      // purchaseUuid: '',
      // adsUuid: '',
      // defaultAdsUuid: '',
      date: selectedDate ?? null,
    );

    final request = sequenceHistoryListRequestModelToJson(requestData);

    if (context.mounted) {
      final apiResult = await adsSequenceRepository.adsSequenceHistoryListApi(request);

      apiResult.when(
        success: (data) async {
          adsSequenceHistoryListState.success = data;
          historyList.addAll(adsSequenceHistoryListState.success?.data ?? []);
          adsSequenceHistoryListState.isLoading = false;
          adsSequenceHistoryListState.isLoadMore = false;
        },
        failure: (NetworkExceptions error) {
          adsSequenceHistoryListState.isLoading = false;
          adsSequenceHistoryListState.isLoadMore = false;
        },
      );

      notifyListeners();
    }
  }
}
