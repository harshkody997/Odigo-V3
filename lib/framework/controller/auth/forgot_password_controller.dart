import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigov3/framework/repository/auth/model/forgot_password_request_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import '../../dependency_injection/inject.dart';


final forgotPasswordController = ChangeNotifierProvider((ref) => getIt<ForgotPasswordController>(),);

@injectable
class ForgotPasswordController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    if (isNotify) {
      forgotPasswordState.success =null;
      emailController.clear();
      notifyListeners();
    }
  }

  bool isAllFieldsValid = false;
  void checkIfAllFieldsValid() {
    isAllFieldsValid = (validateEmail(emailController.text) == null);
    notifyListeners();
  }

  TextEditingController emailController = TextEditingController();



  AuthRepository loginRepository;

  ForgotPasswordController(this.loginRepository);

  /// Login API
  var forgotPasswordState = UIState<CommonResponseModel>();

  Future<void> forgotPasswordApi(BuildContext context) async {
    forgotPasswordState.isLoading = true;
    forgotPasswordState.success = null;
    notifyListeners();
    ForgotPasswordRequestModel requestModel = ForgotPasswordRequestModel(email: emailController.text.trim(), type: 'EMAIL',sendingType: 'OTP', userType: 'USER');
    String request = forgotPasswordRequestModelToJson(requestModel);

    final result = await loginRepository.forgotPasswordApi(request);
    result.when(
      success: (data) async {
        forgotPasswordState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );

    forgotPasswordState.isLoading = false;
    notifyListeners();
  }




}
