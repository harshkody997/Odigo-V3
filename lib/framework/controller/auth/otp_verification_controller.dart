import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigov3/framework/repository/auth/model/reset_password_request_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';
import '../../dependency_injection/inject.dart';


final otpVerificationController = ChangeNotifierProvider(
      (ref) => getIt<OtpVerificationController>(),
);

@injectable
class OtpVerificationController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    if (isNotify) {
      otpController.clear();
      counterSeconds = 60;
      otpController.clear();
      resendOtpState.success =null;
      startCounter();
      notifyListeners();
    }
  }
  FocusNode otpFocus = FocusNode();


  TextEditingController otpController = TextEditingController();

  ///For Counter
  int counterSeconds = 60;
  Timer? counter;

  ///Start Counter
  void startCounter() {
    counterSeconds = 60;
    const oneSec = Duration(seconds: 1);
    counter = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (counterSeconds == 0) {
          timer.cancel();
        } else {
          counterSeconds = counterSeconds - 1;
        }
        notifyListeners();
      },
    );
  }

  ///Set Counter Seconds
  String getCounterSeconds() {
    int minutes = (counterSeconds ~/ 60);
    int seconds = counterSeconds - (minutes * 60);
    if (seconds < 10) {
      return '0$minutes:0$seconds';
    }
    return '0$minutes:$seconds';
  }



  ///Check Validity of all fields
  bool isAllFieldsValid = false;

  ///Update the value of is all fields valid
  void checkIfAllFieldsValid() {
    isAllFieldsValid = (validateOtp(otpController.text) == null);
    notifyListeners();
  }


  AuthRepository loginRepository;

  OtpVerificationController(this.loginRepository);

  /// Verify otp  API
  var otpVerifyState = UIState<CommonResponseModel>();

  Future<void> otpVerifyApi(BuildContext context,String email) async {
    otpVerifyState.isLoading = true;
    otpVerifyState.success = null;
    notifyListeners();
    ResetPasswordRequestModel requestModel = ResetPasswordRequestModel(email: email, type: 'EMAIL',sendingType: 'OTP', userType: 'USER', otp: otpController.text);
    String request = resetPasswordRequestModelToJson(requestModel);

    final result = await loginRepository.verifyOtpApi(request);
    result.when(
      success: (data) async {
        otpVerifyState.success = data;
      },
      failure: (NetworkExceptions error) {},
    );

    otpVerifyState.isLoading = false;
    notifyListeners();
  }

  var resendOtpState = UIState<CommonResponseModel>();

  Future<void> resendOtpApi(BuildContext context,String email) async {
    resendOtpState.isLoading = true;
    resendOtpState.success = null;
    notifyListeners();
    ResetPasswordRequestModel requestModel = ResetPasswordRequestModel(email: email, type: 'EMAIL',sendingType: 'OTP', userType: 'USER', verifyBeforeGenerate: false, );
    String request = resetPasswordRequestModelToJson(requestModel);

    final result = await loginRepository.resendOtpApi(request);
    result.when(
      success: (data) async {
        resendOtpState.success = data;
        // if(resendOtpState.success?.status ==ApiEndPoints.apiStatus_200)
        //   {
        //     showSuccessDialogue(
        //         width: context.width * 0.4,
        //         height: context.height * 0.55,
        //         context:context,
        //         dismissble: true,
        //         animation: Assets.anim.animSucess.keyName,
        //         successMessage: resendOtpState.success?.message??'',
        //         buttonText: LocaleKeys.keyBackToLogin.localized,
        //         onTap: (){
        //
        //         }
        //     );
        //   }
      },
      failure: (NetworkExceptions error) {},
    );

    resendOtpState.isLoading = false;
    notifyListeners();
  }




}
