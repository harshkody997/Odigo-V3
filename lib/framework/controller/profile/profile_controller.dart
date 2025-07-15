import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/controller/auth/login_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/repository/profile/contract/profile_repository.dart';
import 'package:odigov3/framework/repository/profile/model/request/change_mobile_number_request_model.dart';
import 'package:odigov3/framework/repository/profile/model/request/change_password_request_model.dart';
import 'package:odigov3/framework/repository/profile/model/request/check_password_request_model.dart';
import 'package:odigov3/framework/repository/profile/model/request/profile_name_change_request_model.dart';
import 'package:odigov3/framework/repository/profile/model/request/send_otp_request_model.dart';
import 'package:odigov3/framework/repository/profile/model/request/update_email_request_model.dart';
import 'package:odigov3/framework/repository/profile/model/response/change_password_response_model.dart';
import 'package:odigov3/framework/repository/profile/model/response/profile_detail_response.dart';
import 'package:odigov3/framework/repository/profile/model/response/update_email_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/cms/cms.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';

final profileController = ChangeNotifierProvider(
  (ref) => getIt<ProfileController>(),
);

@injectable
class ProfileController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    profileDetailState.success = null;
    profileDetailState.isLoading = true;
    updateEmailState.success = null;
    sendOtpState.success = null;
    checkPasswordState.success = null;
    changePasswordState.success = null;
    changeContactNumberState.success = null;
    changeNameState.success = null;
    changeLanguageState.success = null;

    if (isNotify) {
      notifyListeners();
    }
  }
  void rebuildUI() {
    notifyListeners();
  }

  /// Change Email Form Key
  final GlobalKey<FormState> changeEmailKey = GlobalKey<FormState>();

  /// Change Phone Form Key
  final GlobalKey<FormState> changeMobileKey = GlobalKey<FormState>();

  /// Change Email Verify Otp Form Key
  final GlobalKey<FormState> emailVerifyOtpKey = GlobalKey<FormState>();

  /// Change Password Form Key
  final GlobalKey<FormState> changePasswordKey = GlobalKey<FormState>();

  ///key for dialog
  GlobalKey changeEmailDialogKey = GlobalKey();
  GlobalKey sendOtpDialogKey = GlobalKey();
  GlobalKey successDialogKey = GlobalKey();

  ///dispose key
  void disposeKeys() {
    Future.delayed(const Duration(milliseconds: 100), () {
      changeEmailKey.currentState?.reset();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      changeMobileKey.currentState?.reset();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      emailVerifyOtpKey.currentState?.reset();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      changePasswordKey.currentState?.reset();
    });
  }

  ///Clear all form controllers
  void clearFormData() {
    newNameController.clear();
    newEmailController.clear();
    oldPasswordController.clear();
    newPasswordController.clear();
    emailPasswordController.clear();
    confirmNewPasswordController.clear();
    changeEmailOrMobileOtpController.clear();
    newMobileController.clear();
    isShowCurrentPassword = false;
    isShowNewPassword = false;
    isShowConfirmPassword = false;
    isEmailFieldsValid = false;
    isPasswordFieldsValid = false;
    isEmailVerifyOtpValid = false;
    checkPasswordState.isLoading=false;
    sendOtpState.isLoading=false;
    updateEmailState.isLoading=false;
    changePasswordState.isLoading=false;
    tempPassword = '';

    notifyListeners();
  }

  /// Focus nodes
  FocusNode passwordFocus = FocusNode();
  FocusNode oldPasswordFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  /// New Email Text Field Controller
  TextEditingController newEmailController = TextEditingController();

  /// Email Password Controller
  TextEditingController emailPasswordController = TextEditingController();

  /// Controller for the new mobile no
  TextEditingController newMobileController = TextEditingController();

  /// Controller for the new name
  TextEditingController newNameController = TextEditingController();

  /// Old Password Text Field Controller
  TextEditingController oldPasswordController = TextEditingController();

  /// New Password Text Field Controller
  TextEditingController newPasswordController = TextEditingController();

  /// Confirm New Password Text Field Controller
  TextEditingController confirmNewPasswordController = TextEditingController();

  ///verify change email form
  bool isEmailFieldsValid = false;

  /// For mobile Number
  bool isNewMobileValid = false;

  ///for new name
  bool isNewNameValid = false;

  ///show password variable
  bool isShowNewPassword = false;

  ///show current password variable
  bool isShowCurrentPassword = false;

  ///verify change password form
  bool isPasswordFieldsValid = false;

  ///verify change email otp form
  bool isEmailVerifyOtpValid = false;
  bool isShowConfirmPassword = false;

  ///Store new password temporarily before verification
  String tempPassword = '';

  /// Account password
  String password = '123456789';

  ///Check Validity of change Email Form
  void checkIfEmailValid() {
    isEmailFieldsValid =
        (validateEmail(newEmailController.text) == null &&
        validatePassword(emailPasswordController.text) == null);
    notifyListeners();
  }

  ///Check Validity of change mobile function
  void validateNewMobile() {
    isNewMobileValid =
        (newMobileController.text != '' &&
        validateMobile(newMobileController.text) == null);
    notifyListeners();
  }

  ///Check Validity of change name function
  void validateNewName() {
    isNewNameValid =
        (newNameController.text != '' &&
        validateText(
              newNameController.text,
              LocaleKeys.keyNameIsRequired.localized,
            ) ==
            null);
    notifyListeners();
  }

  ///Check Validity of change Email Form
  void checkIfPasswordValid() {
    isPasswordFieldsValid = ((newPasswordController.text.length>=8 && newPasswordController.text.length<=16 ) &&
        RegExp(r'[a-z]').hasMatch(newPasswordController.text) &&
        RegExp(r'[A-Z]').hasMatch(newPasswordController.text) &&
        RegExp(r'[0-9]').hasMatch(newPasswordController.text) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(newPasswordController.text) &&
        newPasswordController.text==confirmNewPasswordController.text);

    notifyListeners();
  }

  /// validate old password field
  String? verifyOldPassword() {
    if (password == oldPasswordController.text) {
      return null;
    }
    return LocaleKeys.keyEnteredPasswordMustBeSame.localized;
  }

  /// to change  password visibility
  void changePasswordVisibility() {
    isShowNewPassword = !isShowNewPassword;
    notifyListeners();
  }

  /// to change current password visibility
  void changeCurrentPasswordVisibility() {
    isShowCurrentPassword = !isShowCurrentPassword;
    notifyListeners();
  }

  ///check if  new and confirm password are same
  bool checkIfNewPasswordIsSameAsConfirmPassword() {
    return newPasswordController.text == confirmNewPasswordController.text;
  }

  ///check if new password is not same as old password
  String? checkIfNewPasswordIsNotSameAsOldPassword() {
    if (password != newPasswordController.text) {
      return null;
    }
    return LocaleKeys.keyNewPasswordNotSameAsOld.localized;
  }

  ///Update Temporary Email
  void updateTempPassword() {
    tempPassword = newPasswordController.text;
    notifyListeners();
  }

  ///Update Email after OTP Verification
  void updatePassword() {
    password = tempPassword;
    notifyListeners();
  }

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

  /// Email Verify OTP Text Field Controller
  TextEditingController changeEmailOrMobileOtpController =
      TextEditingController();

  ///For OTP Verification Counter
  int counterSeconds = 119;
  Timer? counter;

  ///Start Counter function
  void startCounter() {
    counterSeconds = 60;
    const oneSec = Duration(seconds: 1);
    counter = Timer.periodic(oneSec, (Timer timer) {
      if (counterSeconds == 0) {
        timer.cancel();
      } else {
        counterSeconds = counterSeconds - 1;
      }
      notifyListeners();
    });
  }

  /// Return Counter Seconds as String
  String getCounterSeconds() {
    int minutes = (counterSeconds ~/ 60);
    int seconds = counterSeconds - (minutes * 60);
    if (seconds < 10) {
      return '0$minutes:0$seconds';
    }
    return '0$minutes:$seconds';
  }

  ///Check if Change Email OTP is valid or not
  void checkIfOtpValid() {
    isEmailVerifyOtpValid =
        (validateOtp(changeEmailOrMobileOtpController.text) == null);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  ///CMS List
  List<CmsListModel> cmsList = [
    CmsListModel(title: LocaleKeys.keyPrivacyPolicy, value: CmsValueEnum.PRIVACY_POLICY.name),
    CmsListModel(title: LocaleKeys.keyAboutUs, value: CmsValueEnum.ABOUT_US.name),
    CmsListModel(title: LocaleKeys.keyRefund, value: CmsValueEnum.REFUND.name),
    CmsListModel(title: LocaleKeys.keyTermsConditions, value: CmsValueEnum.TERMS_AND_CONDITION.name),
  ];


  //--------------------- Api integration -------------------------//

  ProfileRepository profileRepository;

  ProfileController(this.profileRepository);

  var profileDetailState = UIState<ProfileDetailResponseModel>();


  ///get profile detail api
  Future<void> getProfileDetail(BuildContext context, WidgetRef ref, {bool isNotify = true}) async {
    profileDetailState.isLoading = true;
    profileDetailState.success = null;
    if (isNotify) notifyListeners();

    final result = await profileRepository.getProfileDetail();
    result.when(success: (data) async {
      profileDetailState.success = data;
      if(profileDetailState.success?.status == ApiEndPoints.apiStatus_200){
        ///call api and set locale only when language get changed
        if(profileDetailState.success?.data?.languageUuid!=Session.sessionBox.get(keyAppLanguageUuid)){
          Session.saveLocalData(keyAppLanguage, profileDetailState.success?.data?.languageCode);
          Session.saveLocalData(keyAppLanguageUuid, profileDetailState.success?.data?.languageUuid);
          Session.isRTL = profileDetailState.success?.data?.languageCode==LanguageType.en.name ? false: true;
          final newLocale = Locale(profileDetailState.success?.data?.languageCode??'');
          await context.setLocale(newLocale);
          await ref.read(drawerController).getSideMenuListAPI(context);
          ref.read(loginController).updateAppLanguage(profileDetailState.success?.data?.languageUuid);
          ref.read(loginController).rebuildUI();
          ref.read(profileController).rebuildUI();
        }
      }
    }, failure: (NetworkExceptions error) {
    });
    profileDetailState.isLoading = false;
    if (isNotify) notifyListeners();
  }

  ///change name state
  var changeNameState = UIState<CommonResponseModel>();


  ///change name api
  Future<void> changeName(BuildContext context) async {
    changeNameState.isLoading = true;
    changeNameState.success = null;
    notifyListeners();

    String request = profileNameChangeRequestModelToJson(ProfileNameChangeRequestModel(name: newNameController.text));

    final result = await profileRepository.changeName(request);
    result.when(success: (data) async {
      changeNameState.success = data;
    }, failure: (NetworkExceptions error) {
    });
    changeNameState.isLoading = false;
    notifyListeners();
  }

  ///change contact number state
  var changeContactNumberState = UIState<CommonResponseModel>();


  ///change contact number api
  Future<void> changeContactNumber(BuildContext context) async {
    changeContactNumberState.isLoading = true;
    changeContactNumberState.success = null;
    notifyListeners();

    String request = changeMobileNumberRequestModelToJson(ChangeMobileNumberRequestModel(contactNumber: newMobileController.text));

    final result = await profileRepository.changeContactNumber(request);
    result.when(success: (data) async {
      changeContactNumberState.success = data;
    }, failure: (NetworkExceptions error) {
    });
    changeContactNumberState.isLoading = false;
    notifyListeners();
  }

  ///change password state
  var changePasswordState = UIState<ChangePasswordResponseModel>();


  ///change password api
  Future<void> changePassword(BuildContext context) async {
    changePasswordState.isLoading = true;
    changePasswordState.success = null;
    notifyListeners();

    String request = changePasswordRequestModelToJson(ChangePasswordRequestModel(oldPassword: oldPasswordController.text,newPassword: newPasswordController.text));

    final result = await profileRepository.changePassword(request);
    result.when(success: (data) async {
      changePasswordState.success = data;
      if(changePasswordState.success?.status == ApiEndPoints.apiStatus_200) {
        Session.userAccessToken = changePasswordState.success?.data?.accessToken;
      }
    }, failure: (NetworkExceptions error) {
    });
    changePasswordState.isLoading = false;
    notifyListeners();
  }


  var checkPasswordState = UIState<CommonResponseModel>();

  ///Check password API
  Future<void> checkPassword(BuildContext context, String value) async {
    checkPasswordState.isLoading = true;
    checkPasswordState.success = null;
    notifyListeners();

    CheckPasswordRequestModel checkPasswordRequestModel = CheckPasswordRequestModel(
      password: value.trim(),
    );
    String request = checkPasswordRequestModelToJson(checkPasswordRequestModel);

    final result = await profileRepository.checkPassword(request);
    result.when(success: (data) async {
      checkPasswordState.success = data;
      counter?.cancel();

    }, failure: (NetworkExceptions error) {
    });

    checkPasswordState.isLoading = false;
    notifyListeners();
  }

  var sendOtpState = UIState<CommonResponseModel>();

  /// Send Otp API
  Future<void> sendOtpApi(BuildContext context, {String? email, String? mobileNo}) async {
    sendOtpState.isLoading = true;
    sendOtpState.success = null;
    notifyListeners();

    SendOtpRequestModel requestModel = SendOtpRequestModel(
        uuid: Session.getUserUuid().toString(), email: (email ?? '').trimSpace, contactNumber: (mobileNo ?? '').trimSpace, userType: Session.getUserType(), type: 'EMAIL', sendingType: 'OTP', verifyBeforeGenerate: false);
    String request = sendOtpRequestModelToJson(requestModel);

    final result = await profileRepository.sendOtpApi(request);

    result.when(success: (data) async {
      sendOtpState.success = data;
    }, failure: (NetworkExceptions error) {
    });

    sendOtpState.isLoading = false;
    notifyListeners();
  }

  var updateEmailState = UIState<UpdateEmailResponseModel>();

  ///Change email api
  Future<void> updateEmailApi({BuildContext? context, bool? isEmail, String? mobileNo, String? email, required String otp, required String password}) async {
    updateEmailState.isLoading = true;
    updateEmailState.success = null;
    notifyListeners();

    UpdateEmailRequestModel requestModelEmail = UpdateEmailRequestModel(
      email: (email ?? newEmailController.text).trimSpace,
      otp: otp,
      password: password,
    );

    String request =  updateEmailRequestModelToJson(requestModelEmail);

    final result = await profileRepository.updateEmail(request);
    result.when(success: (data) async {
      updateEmailState.success = data;

      if(updateEmailState.success?.status == ApiEndPoints.apiStatus_200) {

          profileDetailState.success?.data?.email = email ?? newEmailController.text;
          Session.userAccessToken = updateEmailState.success?.data?.accessToken;

      }
    }, failure: (NetworkExceptions error) {
    });
    updateEmailState.isLoading = false;
    notifyListeners();
  }

  var changeLanguageState = UIState<CommonResponseModel>();


  ///change language api
  Future<void> changeLanguageApi(BuildContext context) async {
    changeLanguageState.isLoading = true;
    changeLanguageState.success = null;
    notifyListeners();

    final result = await profileRepository.changeLanguageApi();
    result.when(success: (data) async {
      changeLanguageState.success = data;
    }, failure: (NetworkExceptions error) {
    });
    changeLanguageState.isLoading = false;
    notifyListeners();
  }


}

class CmsListModel{
  String? title;
  String? value;

  CmsListModel({required this.title,required this.value});
}
