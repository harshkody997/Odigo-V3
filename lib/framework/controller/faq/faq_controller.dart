
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/faq/contract/faq_repository.dart';
import 'package:odigov3/framework/repository/faq/model/request/faq_list_request_model.dart';
import 'package:odigov3/framework/repository/faq/model/response/faq_list_response_model.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';

final faqController = ChangeNotifierProvider(
      (ref) => getIt<FaqController>(),
);

@injectable
class FaqController extends ChangeNotifier {
  FaqController(this.faqRepository);
  FaqRepository faqRepository;

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    faqListState.isLoading = true;
    faqListState.success = null;
    changeFaqStatusState.isLoading = false;
    changeFaqStatusState.success = null;
    faqList.clear();
    if(Session.getRoleType() == 'CLIENT'){
      selectedFaqType = FaqType.Clients;
    }
    else {
      selectedFaqType = FaqType.Destinations;
    }
    statusTapIndex = -1;
    searchCtr.clear();
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    if (isNotify) {
      notifyListeners();
    }
  }

  FaqType selectedFaqType = FaqType.Destinations;

  void updateFaqType(FaqType faqType){
    selectedFaqType = faqType;
    searchCtr.clear();
    resetFilter();
    notifyListeners();
  }

  int statusTapIndex = -1;

  updateStatusIndex(int value){
    statusTapIndex = value;
    notifyListeners();
  }

  ScrollController faqListScrollCtr = ScrollController();
  TextEditingController searchCtr = TextEditingController();

  /// Filter key
  GlobalKey filterKey = GlobalKey();

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


  /// ----------------------------------------------- Api Integration ----------------------------------------------------///

  ///-----------------Faq List Api------------------------------->
  var faqListState = UIState<FaqListResponseModel>();
  List<FaqData?> faqList =[];

  Future<void> faqListApi(BuildContext context, {bool isForPagination = false, String? searchKeyword, int? pageSize}) async {
    int pageNo = 1;
    bool apiCall = true;
    if(!isForPagination){
      pageNo = 1;
      faqList.clear();
      faqListState.isLoading = true;
      faqListState.success = null;
    }
    else if(faqListState.success?.hasNextPage ?? false){
      pageNo = (faqListState.success?.pageNumber ?? 0) + 1;
      faqListState.isLoadMore = true;
      faqListState.success = null;
    }
    else{
      apiCall = false;
    }
    notifyListeners();

    if(apiCall) {
      String request = faqListRequestModelToJson(FaqListRequestModel(
        searchKeyword: searchKeyword,
        activeRecords: selectedFilter?.value,
        platformType: (selectedFaqType == FaqType.Destinations) ? 'DESTINATION' : (selectedFaqType == FaqType.Clients) ? 'CLIENT' : null
      ));

      final result = await faqRepository.faqListApi(request: request, pageNumber: pageNo, dataSize: pageSize ?? AppConstants.pageSize);

      result.when(success: (data) async {
        faqListState.success = data;
        faqList.addAll(faqListState.success?.data ?? []);
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      });

      faqListState.isLoading = false;
      faqListState.isLoadMore = false;
      notifyListeners();
    }
  }

  ///-----------------Change Faq Status Api------------------------------->
  var changeFaqStatusState = UIState<CommonResponseModel>();

  Future<void> changeFaqStatusApi(BuildContext context, {required String faqUuid, required bool isActive, required int index}) async {
    changeFaqStatusState.isLoading = true;
    changeFaqStatusState.success = null;
    statusTapIndex = index;
    notifyListeners();

    final result = await faqRepository.updateFaqStatusApi(uuid: faqUuid, isActive: isActive);

    result.when(success: (data) async {
      changeFaqStatusState.success = data;
      if(changeFaqStatusState.success?.status == ApiEndPoints.apiStatus_200) {
        faqList[index]?.active = isActive;
      }
    },
        failure: (NetworkExceptions error) {
          //String errorMsg = NetworkExceptions.getErrorMessage(error);
          //       showCommonErrorDialog(context: context, message: errorMsg);
        });

    changeFaqStatusState.isLoading = false;
    notifyListeners();
  }

}

