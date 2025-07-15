import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/controller/users_management/user_management_controller.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/user_management/contract/user_management_repository.dart';
import 'package:odigov3/framework/repository/user_management/model/request/update_user_request_model.dart';
import 'package:odigov3/framework/repository/user_management/model/response/add_user_response_model.dart';
import 'package:odigov3/framework/repository/user_management/model/response/get_assign_type_response_model.dart';
import 'package:odigov3/framework/repository/user_management/model/response/get_user_details_response_model.dart';
import 'package:odigov3/framework/repository/user_management/model/response/users_data.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';

final addNewUserController = ChangeNotifierProvider((ref) => getIt<AddNewUserController>());

@injectable
class AddNewUserController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    Future.delayed(const Duration(milliseconds: 10), () {
      addNewUserFormKey.currentState?.reset();
    });
    clearFormData();
    getUserDetailsApiState.success = null;
    getUserDetailsApiState.isLoading = false;
    addNewUserApiState.success = null;
    updateUserApiState.success = null;
    getAssignTypeApiState.success = null;
    addNewUserApiState.isLoading = false;
    updateUserApiState.isLoading = false;
    getAssignTypeApiState.isLoading = false;
    selectedAssignType = null;
    isPasswordHidden = false;
    isShowNewPassword = false;
    isConfirmPasswordHidden = false;
    isPasswordFieldsValid = false;
    searchTypeController.text = '';
    selectedAssignType = null;

    if (isNotify) {
      notifyListeners();
    }
  }

  disposeUserDetailsController() {
    getUserDetailsApiState.isLoading = true;
    getUserDetailsApiState.success = null;
    notifyListeners();
  }

  /// Focus Nodes
  FocusNode nameFocusNode = FocusNode();
  FocusNode contactNumberFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode createPasswordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  /// Text Editing Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController assignTypeController = TextEditingController();
  TextEditingController createPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ///show password variable
  bool isShowNewPassword = false;

  ///verify change password form
  bool isPasswordFieldsValid = false;

  bool isShowConfirmPassword = false;

  /// to change new password visibility
  void changeNewPasswordVisibility() {
    isShowNewPassword = !isShowNewPassword;
    notifyListeners();
  }

  /// to change confirm password visibility
  void changeConfirmPasswordVisibility() {
    isShowConfirmPassword = !isShowConfirmPassword;
    notifyListeners();
  }

  bool isPasswordHidden = false;
  bool isConfirmPasswordHidden = false;

  ///change visibility of the password
  void changePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }

  ///Check Validity of change Email Form
  void checkIfPasswordValid() {
    isPasswordFieldsValid =
        ((createPasswordController.text.length >= 8 && createPasswordController.text.length <= 16) &&
        RegExp(r'[a-z]').hasMatch(createPasswordController.text) &&
        RegExp(r'[A-Z]').hasMatch(createPasswordController.text) &&
        RegExp(r'[0-9]').hasMatch(createPasswordController.text) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(createPasswordController.text) &&
        createPasswordController.text == confirmPasswordController.text);
    notifyListeners();
  }

  UserData? userData;

  /// Initialize User Data
  void initializeUserData(WidgetRef ref) {
    userData = UserData(
      uuid: '',
      name: nameController.text,
      contactNumber: contactNumberController.text,
      email: emailController.text,
      roleName: assignTypeController.text,
      userLoginUuid: 'userUuid',
      active: true,
    );
    ref.read(userManagementController).addToUserList(userData);
    // updateDropdownValue(ref.read(masterController).countryListByAcceptLanguageState.success?.data.where((element) => element.uuid == usersData.address.countryUuid).firstOrNull);
    notifyListeners();
  }

  /// Initialize User Data
  void onEditUsersData(UserData user) {
    nameController.text = user.name ?? '';
    contactNumberController.text = user.contactNumber ?? '';
    emailController.text = user.email ?? '';
    assignTypeController.text = assignTypeList.firstWhere((element) => (element.uuid ?? '') == (user.roleUuid ?? '')).name ?? '';
    assignTypeValue(assignTypeList.firstWhere((element) => (element.uuid ?? '') == (user.roleUuid ?? '')).name ?? '');
    notifyListeners();
  }

  /// Clear Form Data
  void clearFormData() {
    nameController.clear();
    contactNumberController.clear();
    emailController.clear();
    assignTypeController.clear();
    createPasswordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

  final addNewUserFormKey = GlobalKey<FormState>();

  /// Assign type List
  List<AssignType> assignTypeList = [];

  TextEditingController searchTypeController = TextEditingController();
  final ScrollController assignTypeScrollController = ScrollController();

  AssignType? selectedAssignType;

  /// Assign Value
  void assignTypeValue(String value) {
    assignTypeController.text = value;
    if (assignTypeController.text != '') {
      final resultedList = assignTypeList.firstWhere((element) {
        return element.name == assignTypeController.text;
      });
      selectedAssignType = resultedList;
      searchTypeController = TextEditingController(text: selectedAssignType?.name ?? '');
    }
    log('selectedAssignType ${selectedAssignType?.name}');
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  UserManagementRepository userManagementRepository;

  AddNewUserController(this.userManagementRepository);

  /// Add New User Api
  UIState<CommonResponseModel> addNewUserApiState = UIState<CommonResponseModel>();

  Future<void> addNewUserApi(BuildContext context) async {
    addNewUserApiState.isLoading = true;
    addNewUserApiState.success = null;
    notifyListeners();

    /// get Selected Assign Type Object and pass to

    final addUserRequestModel = AddUserRequestModel(
      name: nameController.text.trimSpace,
      contactNumber: contactNumberController.text.trimSpace,
      email: emailController.text.trimSpace,
      roleUuid: selectedAssignType?.uuid?.trimSpace,
      password: createPasswordController.text.trimSpace,
    );

    final result = await userManagementRepository.addUserApi(addUserRequestModelToJson(addUserRequestModel));
    result.when(
      success: (data) async {
        addNewUserApiState.success = data;
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );
    addNewUserApiState.isLoading = false;
    notifyListeners();
  }

  /// Update User Api
  var updateUserApiState = UIState<CommonResponseModel>();

  Future<void> updateUserApi(BuildContext context, String uuid) async {
    updateUserApiState.isLoading = true;
    updateUserApiState.success = null;
    notifyListeners();

    final updateUserRequestModel = UpdateUserRequestModel(
      name: nameController.text.trimSpace,
      contactNumber: contactNumberController.text.trimSpace,
      email: emailController.text.trimSpace,
      roleUuid: selectedAssignType?.uuid?.trimSpace,
      uuid: uuid.trimSpace,
    );

    final result = await userManagementRepository.updateUserApi(updateUserRequestModelToJson(updateUserRequestModel));
    result.when(
      success: (data) async {
        updateUserApiState.success = data;
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    updateUserApiState.isLoading = false;
    notifyListeners();
  }

  // int pageNo = 1;
  //
  // resetPage()
  // {
  //   pageNo =1;
  //   notifyListeners();
  // }

  /// call api on search
  Timer? debounce;

  void onSearchChanged(String value, BuildContext context) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      getAssignTypeApi(context, searchText: value);
    });
    notifyListeners();
  }

  ///Clear Search
  clearSearch(BuildContext context) async {
    searchTypeController.clear();
    selectedAssignType = null;
    Future.delayed(const Duration(microseconds: 10), () {
      addNewUserFormKey.currentState?.reset();
    });
    getAssignTypeApi(context, searchText: '');
    notifyListeners();
  }

  /// Get Assign Type Api Call
  var getAssignTypeApiState = UIState<GetAssignTypeResponseModel>();

  Future<void> getAssignTypeApi(BuildContext context, {String? searchText, bool isForPagination = false}) async {
    int pageNo = 1;
    bool apiCall = true;
    notifyListeners();
    if (!isForPagination) {
      pageNo = 1;
      assignTypeList.clear();
      getAssignTypeApiState.isLoading = true;
      getAssignTypeApiState.success = null;
    } else if (getAssignTypeApiState.success?.hasNextPage ?? false) {
      pageNo = (getAssignTypeApiState.success?.pageNumber ?? 0) + 1;
      getAssignTypeApiState.isLoadMore = true;
      getAssignTypeApiState.success = null;
    } else {
      apiCall = false;
    }
    notifyListeners();

    if (apiCall) {
      Map<String, dynamic> request = {"isDefault": false, "searchedKeyword": searchText};

      final result = await userManagementRepository.getAssignTypeApi(jsonEncode(request), pageNo, isActive: true);
      result.when(
        success: (data) async {
          if (pageNo == 1) {
            assignTypeList = [];
          }
          getAssignTypeApiState.success = data;
          assignTypeList.addAll(getAssignTypeApiState.success?.data ?? []);

          getAssignTypeApiState.isLoading = false;
          getAssignTypeApiState.isLoadMore = false;
        },
        failure: (NetworkExceptions error) {
          getAssignTypeApiState.isLoadMore = false;
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        },
      );

      getAssignTypeApiState.isLoading = false;
      getAssignTypeApiState.isLoadMore = false;
      notifyListeners();
    }
  }

  /// Get User Details Api
  var getUserDetailsApiState = UIState<UserDetailsResponseModel>();

  Future<void> getUserDetailsApi(BuildContext context, String uuid) async {
    getUserDetailsApiState.isLoading = true;
    getUserDetailsApiState.success = null;
    notifyListeners();

    final result = await userManagementRepository.getUserDetailsApi(uuid);
    result.when(
      success: (data) async {
        getUserDetailsApiState.success = data;

        if (getUserDetailsApiState.success?.data != null) {
          onEditUsersData((getUserDetailsApiState.success?.data)!);
        }
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    getUserDetailsApiState.isLoading = false;
    notifyListeners();
  }
}
