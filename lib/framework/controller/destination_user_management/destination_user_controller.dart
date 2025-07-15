import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/destination_user_management/contract/destination_user_repository.dart';
import 'package:odigov3/framework/repository/destination_user_management/model/destination_user_list_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';


final destinationUserController = ChangeNotifierProvider(
      (ref) => getIt<DestinationUserController>(),
);

@injectable
class DestinationUserController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool? isNotify }) {
    destinationUserListState.isLoading = true;
    destinationUserList.clear();
    destinationUserListState.success = null;
    pageNo = 1;
    searchCtr.clear();
    selectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null) ;
    tempSelectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null) ;
    if (isNotify??false) {
      notifyListeners();
    }
  }

  /// Destination user list
  List<DestinationUserData> destinationUserList = [];

  /// Page no for pagination
  int pageNo = 1;

  /// TextEditing Controllers
  TextEditingController searchCtr = TextEditingController();

  /// Filter key
  GlobalKey filterKey = GlobalKey();

  /// Filter
  CommonEnumTitleValueModel tempSelectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  CommonEnumTitleValueModel selectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);

  /// update temp status filter
  void changeTempSelectedStatus(CommonEnumTitleValueModel value){
    tempSelectedStatus = value;
    notifyListeners();
  }

  /// Apply filters
  void applyFilters(){
    selectedStatus = tempSelectedStatus;
    notifyListeners();
  }

  /// Prefill selected filters
  void prefillFilters(){
    tempSelectedStatus = selectedStatus;;
  }

  /// Clear filters
  void clearFilters(){
    tempSelectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    selectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  }
  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  DestinationUserRepository destinationUserRepository;
  DestinationUserController(this.destinationUserRepository);

  /// Destination users api
  UIState<DestinationUserListResponseModel> destinationUserListState = UIState<DestinationUserListResponseModel>();
  Future<void> destinationUserListApi(bool pagination, {bool? isActive,String? destinationUuid}) async {

    if ((destinationUserListState.success?.hasNextPage ?? false) && pagination) {
      pageNo = pageNo + 1;
    }

    if (!pagination) {
      pageNo = 1;
      destinationUserListState.isLoading = true;
      destinationUserList.clear();
    } else {
      destinationUserListState.isLoadMore = true;
      destinationUserListState.success = null;
    }
    notifyListeners();

    final result = await destinationUserRepository.destinationUserListApi(searchCtr.text,pageNo,isActive: selectedStatus.value);
    result.when(success: (data) async {
      destinationUserListState.success = data;
      destinationUserList.addAll(destinationUserListState.success?.data ?? []);
    }, failure: (NetworkExceptions error) {
    });
    destinationUserListState.isLoading = false;
    destinationUserListState.isLoadMore = false;
    notifyListeners();
  }

  ///Update destination user  Status
  UIState<CommonResponseModel> updateUserState = UIState<CommonResponseModel>();
  int userUpdatingIndex = -1;
  Future<void> updateDeviceStatusApi({required String userId, required bool status}) async {
    updateUserState.success = null;
    updateUserState.isLoading = true;
    userUpdatingIndex = destinationUserList.indexWhere((element) => element.uuid == userId);
    notifyListeners();
    final result = await destinationUserRepository.updateDestinationUserStatusApi(userId,status);
    result.when(success: (data) async {
      updateUserState.success = data;
      destinationUserList.where((element) => element.uuid == userId).firstOrNull?.active = status;
    }, failure: (NetworkExceptions error) {
    });
    updateUserState.isLoading = false;
    notifyListeners();
  }
}
