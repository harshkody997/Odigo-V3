import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigov3/framework/repository/auth/model/login_request_model.dart';
import 'package:odigov3/framework/repository/auth/model/login_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_enums.dart';

final loginController = ChangeNotifierProvider((ref) => getIt<LoginController>());

@injectable
class LoginController extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();

  // FocusNode emailFocusNode = FocusNode();
  // FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  TextEditingController languageController = TextEditingController();
  bool isPasswordVisible = false;

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    if (isNotify) {
      emailController.clear();
      passwordController.clear();
      loginState.success = null;
      deleteDeviceIdState.success = null;
      logoutState.success = null;
      isEmailFocused = false;
      isPasswordFocused = false;
      isPasswordVisible = false;
      notifyListeners();
    }
  }

  void setLoginData(){
    emailController.text = 'kodytest.2020@gmail.com';
    passwordController.text = 'kody-password';
    notifyListeners();
  }

  updateIsPasswordVisible(bool isPasswordVisible) {
    this.isPasswordVisible = isPasswordVisible;
    notifyListeners();
  }
  void rebuildUI() {
    notifyListeners();
  }

  bool isEmailFocused = false;
  bool isPasswordFocused = false;

  updateEmailFocus(bool value) {
    isEmailFocused = value;
    notifyListeners();
  }

  updatePswFocus(bool value) {
    isPasswordFocused = value;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
  LanguageModel? languageData;

  /// Update App Language
  String? updateAppLanguage(String? languageUuid) {
    if((languageListState.success?.data??[]).isNotEmpty){
      languageData = languageListState.success?.data?.where((element) => element.uuid == languageUuid).firstOrNull;
      languageController.clear();
      languageController.text = languageData?.name ?? '';

      Session.saveLocalData(keyAppLanguage, languageData?.code);
      Session.saveLocalData(keyAppLanguageUuid, languageData?.uuid ?? '');
      Session.isRTL = languageData?.isRtl ?? false;
      notifyListeners();
      return languageData?.code;
    }
    return null;
  }
  ////////////-----------------------------Api integration ---------------------///////////

  AuthRepository loginRepository;

  LoginController(this.loginRepository);

  /// Login API
  var loginState = UIState<LoginResponseModel>();

  Future<void> loginApi(BuildContext context) async {
    loginState.isLoading = true;
    loginState.success = null;
    notifyListeners();
    LoginRequestModel requestModel = LoginRequestModel(email: emailController.text.trim(), password: passwordController.text.trim(), userType: 'USER');
    String request = loginRequestModelToJson(requestModel);

    final result = await loginRepository.loginApi(request);
    result.when(
      success: (data) async {
        loginState.success = data;
        if (loginState.success != null) {
          Session.saveLocalData(keyUserType, loginState.success?.data?.entityType ?? '');
          Session.userAccessToken = loginState.success?.data?.accessToken;
          Session.saveLocalData(keyAppLanguageUuid, loginState.success?.data?.languageUuid ?? '');
          Session.roleType = loginState.success?.data?.roleName ?? '';
          Session.roleUuid = loginState.success?.data?.roleUuid ?? '';
          Session.entityUuid = loginState.success?.data?.entityUuid ?? '';
          Session.userUuid = loginState.success?.data?.userUuid ?? '';
          Session.entityType = loginState.success?.data?.entityType ?? '';
          Session.email = loginState.success?.data?.email ?? '';
          Session.contactNumber = loginState.success?.data?.contactNumber ?? '';
          Session.currency = loginState.success?.data?.currencyName ?? '';
        }
      },
      failure: (NetworkExceptions error) {},
    );

    loginState.isLoading = false;
    notifyListeners();
  }



  UIState<GetLanguageListResponseModel> languageListState = UIState<GetLanguageListResponseModel>();
  List<LanguageModel> languageList = [];

  Future<void> getLanguageListAPI(BuildContext context, WidgetRef ref) async {
    languageListState.isLoading = true;
    languageListState.success = null;
    languageList.clear();
    notifyListeners();

    final result = await loginRepository.getLanguageListAPI();

    result.when(
      success: (data) async {
        languageListState.isLoading = false;
        languageListState.success = data;
        notifyListeners();

        if (languageListState.success?.status == ApiEndPoints.apiStatus_200) {
          if (languageListState.success?.data?.isNotEmpty ?? false) {
            languageList.addAll(languageListState.success?.data ?? []);
            var  languageData;
            if(Session.getAppLanguage()=='')
              {
                languageData  = languageListState.success?.data?.where((element) => element.code == LanguageType.en.name).firstOrNull;

              }
            else{
                languageData = languageListState.success?.data?.where((element) => element.code == Session.getAppLanguage()).firstOrNull;

            }
            Session.saveLocalData(keyAppLanguage, languageData?.code);


            notifyListeners();

            /// Store Language Model Into Session
            Session.languageModel = getLanguageListResponseModelToJson(data);
          }
        }
      },
      failure: (NetworkExceptions error) {
        languageListState.isLoading = false;
        String errorMsg = NetworkExceptions.getErrorMessage(error);
      },
    );
    languageListState.isLoading = false;
    notifyListeners();
  }

  /// Logout API
  UIState<CommonResponseModel> logoutState = UIState<CommonResponseModel>();

  Future<UIState<CommonResponseModel>> logoutApi(BuildContext context) async {
    logoutState.isLoading = true;
    logoutState.success = null;
    notifyListeners();

    final result = await loginRepository.logoutApi(Session.deviceId);

    result.when(success: (data) async {
      logoutState.success = data;
    }, failure: (NetworkExceptions error) {

    });

    logoutState.isLoading = false;
    notifyListeners();
    return logoutState;
  }


  UIState<CommonResponseModel> deleteDeviceIdState = UIState<CommonResponseModel>();
  /// delete Device FCM token
  Future<void> deleteDeviceTokenApi(context) async {
    deleteDeviceIdState.isLoading = true;
    deleteDeviceIdState.success = null;
    notifyListeners();

    final result = await loginRepository.deleteDeviceTokenApi(Session.deviceId);

    result.when(success: (data) async {
      deleteDeviceIdState.success = data;
    }, failure: (NetworkExceptions error) {

    });

    deleteDeviceIdState.isLoading = false;
    notifyListeners();
  }


}
