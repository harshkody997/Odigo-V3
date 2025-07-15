import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigov3/framework/repository/auth/model/reset_password_request_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import '../../dependency_injection/inject.dart';


final resetPasswordController = ChangeNotifierProvider(
      (ref) => getIt<ResetPasswordController>(),
);

@injectable
class ResetPasswordController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    if (isNotify) {
      resetPasswordState.success =null;
      confirmPasswordController.clear();
      newPasswordController.clear();
      notifyListeners();
    }
  }

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode newPasswordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  AuthRepository loginRepository;

  ResetPasswordController(this.loginRepository);

  /// reset password API
  var resetPasswordState = UIState<CommonResponseModel>();

  Future<void> resetPasswordApi(BuildContext context,String? email,String? otp) async {
    resetPasswordState.isLoading = true;
    resetPasswordState.success = null;
    notifyListeners();
    ResetPasswordRequestModel requestModel = ResetPasswordRequestModel(email: email??'', type: 'EMAIL', userType: 'USER',password: newPasswordController.text,otp: otp);
    String request = resetPasswordRequestModelToJson(requestModel);

    final result = await loginRepository.resetPasswordApi(request);
    result.when(
      success: (data) async {
        resetPasswordState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );

    resetPasswordState.isLoading = false;
    notifyListeners();
  }


}
