import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/user_management/contract/user_management_repository.dart';
import 'package:odigov3/framework/repository/user_management/model/response/get_user_details_response_model.dart';
import 'package:odigov3/framework/repository/user_management/model/response/get_users_response_model.dart';
import 'package:odigov3/framework/repository/user_management/model/response/users_data.dart';
import 'package:odigov3/framework/utils/ui_state.dart';

final userManagementController = ChangeNotifierProvider((ref) => getIt<UserManagementController>());

@injectable
class UserManagementController extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  int pageNo = 1;

  TextEditingController searchController = TextEditingController();

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    getUserDetailsApiState.success = null;
    getUserListApiState.success = null;
    usersList.clear();
    pageNo = 1;
    isHasMorePage = false;
    searchController.clear();

    if (isNotify) {
      notifyListeners();
    }
  }

  GlobalKey userDialogKey = GlobalKey();

  /// Users List
  List<UserData> usersList = [];

  void addToUserList(UserData? usersData) {
    if (usersData != null) {
      usersList.add(usersData);
    }
    notifyListeners();
  }

  /// On Search Changed
  void onSearchChanged(BuildContext context, {String? value, bool? isClearSearch}) async {
    isHasMorePage = false;
    if (isClearSearch ?? false) {
      searchController.clear();
      clearUserList();
      await getUserListApi(context);
    } else {
      await getUserListApi(context);
    }

    notifyListeners();
  }

  ///Clear Users List
  clearUserList(){
    usersList.clear();
    getUserListApiState.success = null;
    getUserListApiState.isLoading = false;
    getUserListApiState.isLoadMore = false;
    pageNo = 1;
    notifyListeners();
  }

  /// Update User Switch Status
  updateUserSwitchStatus({required String? userUuid, required bool? status}) {
    usersList.where((element) => element.uuid == userUuid).firstOrNull?.active = status ?? false;
    notifyListeners();
  }

  /// Remove User
  void removeUser({required int userIndex}) {
    usersList.removeAt(userIndex);
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  UserManagementRepository userManagementRepository;

  UserManagementController(this.userManagementRepository);

  ///Get Users List Api
  var getUserListApiState = UIState<GetUserListResponseModel>();
  bool isHasMorePage = false;

  Future<void> getUserListApi(BuildContext context) async {
    int pageNo = 1;
    notifyListeners();

    if (isHasMorePage) {
      pageNo = (getUserListApiState.success?.pageNumber ?? 1) + 1;
    } else {
      pageNo = 1;
      getUserListApiState.success = GetUserListResponseModel();
    }
    (pageNo > 1) ? getUserListApiState.isLoadMore = true : getUserListApiState.isLoading = true;

    if (pageNo == 1) {
      getUserListApiState.success?.data?.clear();
      usersList.clear();
    }

    if (context.mounted) {
      final apiResult = await userManagementRepository.getUsersListApi(pageNo, searchController.text);

      apiResult.when(
        success: (data) async {
          getUserListApiState.isLoading = false;
          getUserListApiState.success = data;
          if (getUserListApiState.success != null && getUserListApiState.success?.status == ApiEndPoints.apiStatus_200) {
            if ((getUserListApiState.success?.pageNumber ?? 0) < (getUserListApiState.success?.totalPages ?? 0)) {
              isHasMorePage = true;
            } else {
              isHasMorePage = false;
            }
            usersList.addAll(getUserListApiState.success?.data ?? []);
            (pageNo > 0) ? getUserListApiState.isLoadMore = false : getUserListApiState.isLoading = false;
          }
        },
        failure: (NetworkExceptions error) {
          (pageNo > 1) ? getUserListApiState.isLoadMore = false : getUserListApiState.isLoading = false;
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        },
      );

      getUserListApiState.isLoading = false;
      getUserListApiState.isLoadMore = false;
      notifyListeners();
    }
  }

  /// Get User Details Api
  final getUserDetailsApiState = UIState<UserDetailsResponseModel>();

  Future<void> getUserDetailsApi(BuildContext context, String userId) async {
    getUserDetailsApiState.isLoading = true;
    getUserDetailsApiState.success = null;
    notifyListeners();
    final result = await userManagementRepository.getUserDetailsApi(userId);
    result.when(
      success: (data) async {
        getUserDetailsApiState.success = data;
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    getUserDetailsApiState.isLoading = false;
    notifyListeners();
  }

  /// Toggle Active/InActive User Api
  final toggleActiveDeActiveUserState = UIState<CommonResponseModel>();
  int? updatingUserIndex;

  Future<void> toggleActiveDeActiveUserApi(BuildContext context, UserData? userData, int index) async {
    toggleActiveDeActiveUserState.isLoading = true;
    toggleActiveDeActiveUserState.success = null;
    updatingUserIndex = index;

    notifyListeners();
    final result = await userManagementRepository.activeDeActiveUserApi(userData?.uuid ?? '', !(userData?.active ?? false));
    result.when(
      success: (data) async {
        toggleActiveDeActiveUserState.success = data;
        if (toggleActiveDeActiveUserState.success?.status == ApiEndPoints.apiStatus_200) {
          await updateUserSwitchStatus(userUuid: userData?.uuid ?? '', status: !(userData?.active ?? false));
        }
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    toggleActiveDeActiveUserState.isLoading = false;
    notifyListeners();
  }
}
