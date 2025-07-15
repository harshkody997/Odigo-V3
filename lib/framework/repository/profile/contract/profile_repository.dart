
abstract class ProfileRepository{

  ///get profile detail of admin
   Future getProfileDetail();

   ///change Name
   Future changeName(String request);

   ///change Contact Number
   Future changeContactNumber(String request);

   ///change password
   Future changePassword(String request);

   /// Check Password
   Future checkPassword(String request);

   /// Update Email
   Future updateEmail(String request);


   ///Send OTP Api
   Future sendOtpApi(String request);

   ///change language Api
   Future changeLanguageApi();

}