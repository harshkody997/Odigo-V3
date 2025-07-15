
abstract class AuthRepository {
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

  /// language  Api
  Future getLanguageListAPI();

  /// register firebase token
  Future registerDeviceApi(String request);

  /// delete firebase token
  Future deleteDeviceTokenApi(String deviceId);

  /// Logout API
  Future logoutApi(String uniqueDeviceId);

}
