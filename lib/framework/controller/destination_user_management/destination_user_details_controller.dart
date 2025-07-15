import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/destination/contract/destination_details_repository.dart';
import 'package:odigov3/framework/repository/destination_user_management/contract/destination_user_repository.dart';
import 'package:odigov3/framework/repository/destination_user_management/model/destination-user_details_response_model.dart';
import 'package:odigov3/framework/repository/destination_user_management/model/update_destination-user_password_request_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import '../../dependency_injection/inject.dart';


final destinationUserDetailsController = ChangeNotifierProvider(
      (ref) => getIt<DestinationUserDetailsController>(),
);

@injectable
class DestinationUserDetailsController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool? isNotify}) {
    destinationUserDetailsState.isLoading = true;
    destinationUserDetailsState.success = null;

    if (isNotify??false) {
      notifyListeners();
    }
  }

  /// Clear form
  void clearFormData(){
    confirmPasswordController.clear();
    newPasswordController.clear();
    isShowNewPassword = false;
    isShowConfirmPassword = false;
    updateUserPasswordState.isLoading = false;
    Future.delayed(const Duration(milliseconds: 50), () {
      formKey.currentState?.reset();
    });
  }

  /// Change Password key
  GlobalKey changePasswordDialogKey = GlobalKey();

  /// Text Editing Controllers
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  /// Focus nodes
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
  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  DestinationUserRepository destinationUserRepository;
  DestinationUserDetailsController(this.destinationUserRepository);

  /// Device details
  UIState<DestinationUserDetailsResponseModel> destinationUserDetailsState = UIState<DestinationUserDetailsResponseModel>();
  Future<UIState<DestinationUserDetailsResponseModel>> destinationUserDetailsApi({required String userUuid}) async {
    destinationUserDetailsState.isLoading = true;
    destinationUserDetailsState.success = null;
    notifyListeners();
    final result = await destinationUserRepository.getDestinationUserDetails(userUuid);
    result.when(success: (data) async {
      destinationUserDetailsState.success = data;
    }, failure: (NetworkExceptions error) {});
    destinationUserDetailsState.isLoading = false;
    notifyListeners();
    return destinationUserDetailsState;
  }

  /// Change password
  UIState<CommonResponseModel> updateUserPasswordState = UIState<CommonResponseModel>();
  Future<void> updateDestinationUserPasswordApi() async {
    updateUserPasswordState.isLoading = true;
    updateUserPasswordState.success = null;
    notifyListeners();
    final request = updateDestinationUserPasswordRequestModelToJson(UpdateDestinationUserPasswordRequestModel(
      uuid: destinationUserDetailsState.success?.data?.uuid,
      password: confirmPasswordController.text
    ));
    final result = await destinationUserRepository.changeDestinationUserPassword(request);
    result.when(success: (data) async {
      updateUserPasswordState.success = data;
    }, failure: (NetworkExceptions error) {});
    updateUserPasswordState.isLoading = false;
    notifyListeners();
  }
}
