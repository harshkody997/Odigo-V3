import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/ticket_reason/model/ticket_reason_list_response_model.dart';
import 'package:odigov3/framework/repository/ticket_management/contract/ticket_repository.dart';
import 'package:odigov3/framework/repository/ticket_management/model/request/create_ticket_request_model.dart';
import 'package:odigov3/framework/repository/ticket_management/model/request/ticket_list_request_model.dart';
import 'package:odigov3/framework/repository/ticket_management/model/request/update_ticket_status_request_model.dart';
import 'package:odigov3/framework/repository/ticket_management/model/response/created_ticket_response_model.dart';
import 'package:odigov3/framework/repository/ticket_management/model/response/ticket_list_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';

final ticketManagementController = ChangeNotifierProvider(
  (ref) => getIt<TicketManagementController>(),
);

@injectable
class TicketManagementController extends ChangeNotifier {
  TicketManagementController(this.ticketRepository);
  final TicketRepository ticketRepository;

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    ticketListState.isLoading = true;
    ticketListState.success = null;
    ticketList.clear();
    isFilterApplied = false;
    ticketStatusCtr.text = '';
    ticketCommentCtr.text = '';
    dateController.text = '';
    ticketReasonController.text = '';
    createTicketState.success = null;
    selectedReason = null;
    createTicketFormKey.currentState?.reset();

    clearFilterValues(isNotify: isNotify);
    if (isNotify) {
      notifyListeners();
    }
  }

  clearStatusValue() {
    ticketStatusCtr.text = '';
    ticketCommentCtr.text = '';
    notifyListeners();
  }

  /// Search Controller
  TextEditingController searchCtr = TextEditingController();

  ///change status form key
  final formKey = GlobalKey<FormState>();
  final createTicketFormKey = GlobalKey<FormState>();

  ///change status fields text controllers
  TextEditingController ticketStatusCtr = TextEditingController();
  TextEditingController ticketCommentCtr = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController ticketReasonController = TextEditingController();

  ///create ticket reason
  TicketReasonModel? selectedReason;

  ///update reason
  updateReasonDropdown(TicketReasonModel? value) {
    selectedReason = value;
    notifyListeners();
  }

  ///Start Date
  DateTime? selectedStartDate;

  ///End Date
  DateTime? selectedEndDate;

  ///Change Selected Date value
  changeDateValue(List<DateTime?> value) {
    ///Set Start Date
    selectedStartDate = value.first;

    ///Set End Date
    selectedEndDate = value.last;

    ///Set value in dateController to show in field like 13 Mar,2025 - 16 Mar,2025
    dateController.text = formatDateRange([selectedStartDate, selectedEndDate]);
    notifyListeners();
  }

  ///is filter applied variable and function
  bool isFilterApplied = false;
  void updateFilterApplied(bool value) {
    isFilterApplied = value;
    notifyListeners();
  }



  ///Clear Filter Value
  clearFilterValues({bool isNotify = false}) {
    selectedStartDate = null;
    selectedEndDate = null;
    dateController.clear();
    selectedStatus = TicketStatusType.ALL;
    if (isNotify) {
      notifyListeners();
    }
  }

  ///selected status for update ticket status
  TicketStatusType? selectedStatusType;

  ///status list
  List<TicketStatusType> statusList = [
    TicketStatusType.ACKNOWLEDGED,
    TicketStatusType.RESOLVED,
  ];

  ///status list
  List<TicketStatusType> statusForAcknowledge = [
    TicketStatusType.RESOLVED,
  ];

  ///status list for filter
  List<TicketStatusType> statusOptions = [
    TicketStatusType.ALL,
    TicketStatusType.ACKNOWLEDGED,
    TicketStatusType.RESOLVED,
    TicketStatusType.PENDING,
  ];

  ///selected status for filter
  TicketStatusType selectedStatus = TicketStatusType.ALL;

  void changeSelectedStatus(TicketStatusType status) {
    selectedStatus = status;
    notifyListeners();
  }

  ///update status function
  updateStatusDropdown(TicketStatusType? value) {
    selectedStatusType = value;
    notifyListeners();
  }

  ///detail dialog key
  GlobalKey ticketDetailDialogKey = GlobalKey();
  GlobalKey ticketStatusDialogKey = GlobalKey();
  GlobalKey ticketFilterDialogKey = GlobalKey();

  /// ---------------------------- Api Integration ---------------------------------///
  var ticketListState = UIState<TicketListResponseModel>();
  List<TicketDetails?> ticketList = [];

  ///ticket list api
  Future<UIState<TicketListResponseModel>> ticketListApi(
    BuildContext context, {
    bool isForPagination = false,
    String? searchKeyword,
    int? pageSize,
  }) async {
    int pageNo = 1;
    bool apiCall = true;
    if (!isForPagination) {
      pageNo = 1;
      ticketList.clear();
      ticketListState.isLoading = true;
      ticketListState.success = null;
    } else if (ticketListState.success?.hasNextPage ?? false) {
      pageNo = (ticketListState.success?.pageNumber ?? 0) + 1;
      ticketListState.isLoadMore = true;
      ticketListState.success = null;
    } else {
      apiCall = false;
    }
    notifyListeners();

    if (apiCall) {
      String request = ticketListRequestModelToJson(
        TicketListRequestModel(
          searchKeyword: searchKeyword,
          status: selectedStatus.value,
          fromDate: selectedStartDate
              ?.add(Duration(days: 1))
              .millisecondsSinceEpoch,
          toDate: selectedEndDate
              ?.add(Duration(days: 1))
              .millisecondsSinceEpoch,
        ),
      );

      final result = await ticketRepository.ticketListApi(
        request: request,
        pageNumber: pageNo,
        dataSize: pageSize ?? AppConstants.pageSize,
      );

      result.when(
        success: (data) async {
          ticketListState.success = data;
          ticketList.addAll(ticketListState.success?.data ?? []);
        },
        failure: (NetworkExceptions error) {},
      );

      ticketListState.isLoading = false;
      ticketListState.isLoadMore = false;
      notifyListeners();
    }
    return ticketListState;
  }

  ///Update ticket status api
  UIState<CommonResponseModel> updateTicketStatusState =
      UIState<CommonResponseModel>();

  Future<void> updateTicketStatusApi(
    BuildContext context, {
    required String ticketUuid,
  }) async {
    updateTicketStatusState.isLoading = true;
    updateTicketStatusState.success = null;
    notifyListeners();

    String request = ticketStatusUpdateRequestModelToJson(
      TicketStatusUpdateRequestModel(
        ticketStatus: selectedStatusType?.value,
        comment: ticketCommentCtr.text,
      ),
    );

    final result = await ticketRepository.updateTicketStatusApi(
      request: request,
      uuid: ticketUuid,
    );

    result.when(
      success: (data) async {
        updateTicketStatusState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );

    updateTicketStatusState.isLoading = false;
    notifyListeners();
  }

  ///Create ticket api
  UIState<CreatedTicketResponseModel> createTicketState =
      UIState<CreatedTicketResponseModel>();

  Future<void> createTicketApi(BuildContext context) async {
    createTicketState.isLoading = true;
    createTicketState.success = null;
    notifyListeners();

    String request = createTicketRequestModelToJson(
      CreateTicketRequestModel(
        ticketReasonUuid: selectedReason?.uuid,
        description: ticketCommentCtr.text,
      ),
    );

    final result = await ticketRepository.createTicketApi(request: request);

    result.when(
      success: (data) async {
        createTicketState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );

    createTicketState.isLoading = false;
    notifyListeners();
  }
}
