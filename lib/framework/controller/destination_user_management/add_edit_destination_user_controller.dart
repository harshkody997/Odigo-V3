import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/repository/destination_user_management/contract/destination_user_repository.dart';
import 'package:odigov3/framework/repository/destination_user_management/model/add_update_destination_user_request_model.dart';
import 'package:odigov3/framework/repository/destination_user_management/model/destination_user_list_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';


final addEditDestinationUserController = ChangeNotifierProvider(
      (ref) => getIt<AddEditDestinationUserController>(),
);

@injectable
class AddEditDestinationUserController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = true}) {
    clearForm();
    if (isNotify) {
      notifyListeners();
    }
  }


  /// Text Editing Controllers
  TextEditingController nameCtr= TextEditingController();
  TextEditingController contactCtr= TextEditingController();
  TextEditingController emailCtr= TextEditingController();
  TextEditingController confirmPasswordCtr= TextEditingController();
  TextEditingController newPasswordCtr = TextEditingController();
  TextEditingController selectDestinationCtr = TextEditingController();

  /// Focus nodes
  FocusNode nameFocus = FocusNode();
  FocusNode contactFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode destinationFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();

  /// Form key
  GlobalKey<FormState> formKey =GlobalKey<FormState>();

  ///show password variable
  bool isShowNewPassword = false;
  bool isShowConfirmPassword = false;

  ///  Change password visibility
  void changePasswordVisibility() {
    isShowNewPassword = !isShowNewPassword;
    notifyListeners();
  }

  /// Change confirm password visibility
  void changeConfirmPasswordVisibility() {
    isShowConfirmPassword = !isShowConfirmPassword;
    notifyListeners();
  }

  /// Clear Form
  void clearForm(){
    nameCtr.clear();
    contactCtr.clear();
    emailCtr.clear();
    confirmPasswordCtr.clear();
    newPasswordCtr.clear();
    selectDestinationCtr.clear();
    addUpdateUserState.success = null;
    addUpdateUserState.isLoading = false;
    isShowConfirmPassword = false;
    isShowNewPassword = false;
    Future.delayed(const Duration(milliseconds: 50), () {
      formKey.currentState?.reset();
    });
  }

  /// Fill data on edit
  void fillFormOnUpdate(DestinationUserData userData){
    nameCtr.text = userData.name??'';
    selectDestinationCtr.text = userData.destinationName??'';
    contactCtr.text = userData.contactNumber??'';
    emailCtr.text = userData.email??'';
    notifyListeners();
  }

  /// Selected destination
  DestinationData? selectedDestination;

  updateSelectedDestination(DestinationData? selectedDestination) {
    this.selectedDestination = selectedDestination;
    selectDestinationCtr.text = selectedDestination?.name ?? '';
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  DestinationUserRepository destinationUserRepository;
  AddEditDestinationUserController(this.destinationUserRepository);

  /// Add/Edit User api
  UIState<CommonResponseModel> addUpdateUserState = UIState<CommonResponseModel>();
  Future<void> addUpdateDestinationUserApi({String? userId }) async {
    addUpdateUserState.isLoading = true;
    addUpdateUserState.success = null;
    notifyListeners();
    String request = addUpdateDestinationUserRequestModelToJson(
        !(userId != null)? AddUpdateDestinationUserRequestModel(
          password: confirmPasswordCtr.text,
          name: nameCtr.text,
          contactNumber: contactCtr.text,
          email: emailCtr.text,
          destinationUuid: selectedDestination?.uuid,
        ):
        AddUpdateDestinationUserRequestModel(
          uuid: userId,
          name: nameCtr.text,
          contactNumber: contactCtr.text,
          email: emailCtr.text,
        ));
    final result = await destinationUserRepository.addUpdateDestinationUserApi(request,isUpdate: userId!=null);
    result.when(success: (data) async {
      addUpdateUserState.success = data;
    }, failure: (NetworkExceptions error) {});
    addUpdateUserState.isLoading = false;
    notifyListeners();
  }
}
