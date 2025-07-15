import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/destination/contract/destination_details_repository.dart';
import 'package:odigov3/framework/repository/destination/model/destiantion_list_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/request/destination_list_request_model.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/destination_type_list_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/ui/utils/app_constants.dart';

final destinationController = ChangeNotifierProvider((ref) => getIt<DestinationController>());

@injectable
class DestinationController extends ChangeNotifier {
  DestinationDetailsRepository destinationDetailsRepository;

  DestinationController(this.destinationDetailsRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    statusTapIndex = -1;
    changeDestinationStatusState.isLoading = false;
    changeDestinationStatusState.success = null;
    destinationList.clear();
    pageNo = 1;
    destinationListState.success = null;
    destinationListState.isLoading = false;
    destinationListState.isLoadMore = false;
    totalCount = null;
    selectedFilter = null;
    selectedTempFilter = null;
    selectedDestinationTypeFilter = null;
    selectedDestinationTypeTempFilter = null;
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    destinationTypeCtr.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  clearDestinationList(){
    destinationList.clear();
    pageNo = 1;
    destinationListState.success = null;
    destinationListState.isLoading = false;
    destinationListState.isLoadMore = false;
    totalCount = null;
    notifyListeners();
  }

  TextEditingController searchCtr = TextEditingController();
  TextEditingController destinationTypeCtr = TextEditingController();
  int statusTapIndex = -1;
  /// Filter key
  GlobalKey filterKey = GlobalKey();
  updateStatusIndex(int value) {
    statusTapIndex = value;
    notifyListeners();
  }

  /// Dispose destination list for other modules usage
  void disposeDestinationListForOtherModules({bool? isNotify}){
    destinationListState.isLoading = true;
    destinationListState.success = null;
    destinationList.clear();
    pageNo =1;
    if(isNotify??false){
      notifyListeners();
    }
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

  DestinationType? selectedDestinationTypeFilter = null;
  DestinationType? selectedDestinationTypeTempFilter = null;
  updateTempSelectedDestinationType(DestinationType? value){
    selectedDestinationTypeTempFilter = value;
    destinationTypeCtr.text = selectedDestinationTypeTempFilter?.name ?? '';
    notifyListeners();
  }

  updateSelectedDestinationType(DestinationType? value){
    selectedDestinationTypeFilter = value;
    notifyListeners();
  }

  resetFilter(){
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    selectedDestinationTypeFilter = null;
    selectedDestinationTypeTempFilter = null;
    destinationTypeCtr.clear();
    notifyListeners();
  }

  bool get isFilterSelected => selectedFilter != selectedTempFilter || selectedDestinationTypeFilter != selectedDestinationTypeTempFilter;

  bool get isClearFilterCall => (selectedFilter == selectedTempFilter && selectedTempFilter != commonActiveDeActiveList[0]) || (selectedDestinationTypeFilter == selectedDestinationTypeTempFilter) ;

  bool get isFilterApplied => (selectedFilter != null && selectedFilter != commonActiveDeActiveList[0] || selectedDestinationTypeFilter != null);

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  int pageNo = 1;
  int? totalCount;
  List<DestinationData> destinationList = [];

  /// Destination List API
  var destinationListState = UIState<DestinationListResponseModel>();

  Future<void> getDestinationListApi(BuildContext context, {bool isReset = false, String? storeUuid,bool pagination = false,String? destinationTypeUuid,bool? activeRecords, String? searchKeyword}) async {
    if((destinationListState.success?.hasNextPage ?? false) && pagination){
      pageNo = pageNo + 1;
    }

    if (pageNo == 1) {
      destinationListState.isLoading = true;
      destinationList.clear();
    } else {
      destinationListState.isLoadMore = true;
    }
    destinationListState.success = null;
    notifyListeners();

    DestinationListRequestModel destinationListRequestModel = DestinationListRequestModel(
      storeUuid: storeUuid,
      searchKeyword: searchKeyword ?? searchCtr.text,
      destinationTypeUuid:destinationTypeUuid,
      activeRecords: activeRecords
    );

    final result = await destinationDetailsRepository.getDestinationListApi(destinationListRequestModel.toJson(), pageNo.toString());
    result.when(
      success: (data) async {
        destinationListState.success = data;
        if (destinationListState.success?.status == ApiEndPoints.apiStatus_200) {
          destinationList.addAll(destinationListState.success?.data ?? []);
          totalCount = destinationListState.success?.totalCount;
        }
        destinationListState.isLoading = false;
        destinationListState.isLoadMore = false;
      },
      failure: (NetworkExceptions error) {
        destinationListState.isLoading = false;
        destinationListState.isLoadMore = false;
      },
    );
    destinationListState.isLoading = false;
    destinationListState.isLoadMore = false;
    notifyListeners();
  }

  /// change destinationType status api
  UIState<CommonResponseModel> changeDestinationStatusState = UIState<CommonResponseModel>();
  Future changeDestinationStatusAPI(BuildContext context, String uuid, bool status, int index) async {
    changeDestinationStatusState.isLoading = true;
    changeDestinationStatusState.success = null;
    notifyListeners();

    final result = await destinationDetailsRepository.changeDestinationStatusApi(uuid, status);

    result.when(
      success: (data) async {
        notifyListeners();
        changeDestinationStatusState.isLoading = false;
        changeDestinationStatusState.success = data;
        if (changeDestinationStatusState.success?.status == ApiEndPoints.apiStatus_200) {
          destinationList[index].active = status;
        }
      },
      failure: (NetworkExceptions error) {
        changeDestinationStatusState.isLoading = false;
      },
    );
    changeDestinationStatusState.isLoading = false;
    notifyListeners();
  }
}
