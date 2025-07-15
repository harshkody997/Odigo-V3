
abstract class LoginRepository {
  /// LogIn Api
  Future loginApi(String request);

  /// forgotPassword Api
  Future forgotPasswordApi(String request);

  /// verifyOtp Api
  Future verifyOtpApi(String request);

  /// resetPassword Api
  Future resetPasswordApi(String request);

  /// resendOtp Api
  Future resendOtpApi(String request);


  Future getLanguageListAPI();

}
