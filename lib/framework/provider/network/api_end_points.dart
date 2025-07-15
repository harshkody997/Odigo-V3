import 'package:odigov3/ui/utils/app_constants.dart';

class ApiEndPoints {
  /*
  * ----- Api status
  * */
  static const int apiStatus_200 = 200; //success
  static const int apiStatus_201 = 201; //success
  static const int apiStatus_202 = 202; //success for static page
  static const int apiStatus_203 = 203; //success
  static const int apiStatus_205 = 205; // for remaining step 2
  static const int apiStatus_400 = 400; //Invalid data
  static const int apiStatus_401 = 401; //Invalid data
  static const int apiStatus_404 = 404; //Invalid data
  static const int apiStatus_403 = 403; // Access Denied
  static const int apiStatus_406 = 406; //Not Acceptable
  static const int apiStatus_500 = 500; // Internal Server Error




  static const String getLanguageList = '/language?activeRecords=true';
  static String changeLanguage(String languageUuid) => '/login/language?languageUuid=$languageUuid';



  /// Auth
  static String login = '/login';
  static String forgotPassword = '/login/forgot/password';
  static String verifyOtp = '/otp/verify/app';
  static String resetPassword = '/login/reset/password';
  static String resendOtp = '/otp';

  ///Dashboard
  static String dashboardAdsCount = '/dashboard/ads/count';
  static String navigationEfficiency = '/dashboard/navigation/efficiency';
  static String mostRequestedStore = '/dashboard/store';
  static String dashboardCount = '/dashboard/count';
  static String dashboardPeakUsage = '/dashboard/peak/usage';
  static String dashboardWeekInteractionCount = '/dashboard/interaction/week/count';
  static String dashboardUptime = '/dashboard/uptime';
  static String dashboardInteractionTotal = '/dashboard/interaction/total';
  static String dashboardInteractionAverage = '/dashboard/interaction/average';
  static String totalNavigationRequest = '/dashboard/navigation/total';
  static String averageNavigationRequest = '/dashboard/navigation/average';


  ///Destination
  static String destinationDetails(String destinationUuid) => '/destination/language/$destinationUuid';
  static String destinationDetailsMultiLanguage(String destinationUuid) => '/destination/$destinationUuid';
  static String assignDeAssignRobot = '/robot/destination/mapping';
  static String assignDeAssignStore = '/destination/store/mapping';
  static String destinationList(String pageNo) => '/destination/list?pageNumber=$pageNo&pageSize=${AppConstants.pageSize}';
  static String destinationTypeList(String pageNo) => '/destination/type/list?pageNumber=$pageNo&pageSize=${AppConstants.pageSize}';
  static String manageDestination = '/destination';
  static String uploadDestinationImage(String destinationUuid) => '/destination/image/upload/$destinationUuid';

  static String updateDestinationPasscode = '/destination/password';
  static String changeDestinationStatus(String uuid,bool status) => '/destination/status/$uuid?active=$status';

  static String floorList = '/destination/floor';
  static String updateFloor = '/destination/floor';
  static String floorDetails(String uuid) => '/destination/floor/$uuid';

  ///Destination name data
  static String destinationNameData(String pageNo) => '/destination/data/list?pageNumber=$pageNo&pageSize=${AppConstants.pageSize}';
  static String categoryDataList(int pageNo, int? pageSize) => '/category/data/list?pageNumber=$pageNo&pageSize=${pageSize ?? AppConstants.pageSize}';
  static String storeDataList(int pageNo) => '/store/data/list?pageNumber=$pageNo&pageSize=${AppConstants.pageSize}';
  static String robotDataList(int pageNo) => '/robot/data/list?pageNumber=$pageNo&pageSize=${AppConstants.pageSize}';

  ///Profile
  static String profileDetail = '/login/basic';
  static String changeName = '/login/profile';
  static String changeContactNumber = '/login/change/contact';
  static String changePassword = '/login/update/password';
  static String checkPassword= '/login/check/password';
  static String updateEmail = '/login/email';





  /// country
  static String getCountryList(int pageNo,int pageSize) => '/country/list?pageNumber=$pageNo&pageSize=$pageSize';
  static String getCountryTimeZone = '/country/zones';

  /// state
  static String getStateList(int pageNo,int pageSize) => '/state/list?pageNumber=$pageNo&pageSize=$pageSize';
  static String addEditState = '/state';
  static String changeStateStatus(String uuid,bool status) => '/state/status/$uuid?active=$status';
  static String stateDetails(String uuid) => '/state/$uuid';

  /// city
  static String getCityList(int pageNo,int pageSize) => '/city/list?pageNumber=$pageNo&pageSize=$pageSize';
  static String addEditCity = '/city';
  static String changeCityStatus(String uuid,bool status) => '/city/status/$uuid?active=$status';
  static String cityDetails(String uuid) => '/city/$uuid';

  /// ticket reason
  static String getTicketReasonList(int pageNo,int pageSize) => '/ticket/reason/list?pageNumber=$pageNo&pageSize=$pageSize';
  static String addEditTicketReason = '/ticket/reason';
  static String changeTicketReasonStatus(String uuid,bool status) => '/ticket/reason/status/$uuid?active=$status';
  static String ticketReasonDetails(String uuid) => '/ticket/reason/$uuid';

  /// category
  static String getCategoryList(int pageNo,int pageSize) => '/category/list?pageNumber=$pageNo&pageSize=$pageSize';
  static String addEditCategory = '/category';
  static String changeCategoryStatus(String uuid,bool status) => '/category/status/$uuid?active=$status';
  static String categoryDetails(String uuid) => '/category/$uuid';
  static String uploadCategoryImage(String uuid) => '/category/image/upload/$uuid';

  ///Store
  static String storeList(int pageNo, int dataSize) => '/store/list?pageNumber=$pageNo&pageSize=$dataSize';
  static String storeListDestination(String destinationId,int pageNo, int dataSize,bool active) => '/store/list/destination/${destinationId}?pageNumber=$pageNo&pageSize=$dataSize&activeRecords=$active';
  static String addUpdateStore = '/store';
  static String storeDetail(String storeUuid) => '/store/$storeUuid';
  static String storeLanguageDetail(String storeUuid) => '/store/language/$storeUuid';
  static String changeStoreStatus(String storeUuid, isActive) => '/store/status/$storeUuid?active=$isActive';
  static String storeUploadImage(String storeUuid) => '/store/image/upload/$storeUuid';

  /// settings
  static String settingsList(int pageNo, int dataSize) => '/settings?pageNumber=$pageNo&pageSize=$dataSize';
  static String updateSetting = '/settings';

  ///contact us
  static String contactUsList(int pageNo, int dataSize) => '/contactus?pageNumber=$pageNo&pageSize=$dataSize';

  /// Client Module
  static String addClient = '/client';
  static String updateClient = '/client';
  static String clientList(int pageNumber) => '/client/list?pageNumber=$pageNumber&pageSize=$pageSize';
  static String clientDetails(String clientUuid) => '/client/$clientUuid';
  static String changeClientStatus(String uuid,bool status) => '/client/status/$uuid?active=$status';

  /// Client Documents
  static String uploadDocument = '/client/documents/upload';
  static String updateDocument = '/client/documents';
  static String getDocumentByUuid(String clientUuid) => '/client/documents/list/$clientUuid';
  static String deleteDocument = '/client/documents';


  /// Device
  static String getDeviceList(int pageNo,{int? pageSize}) =>'/robot/list?pageNumber=$pageNo&pageSize=${pageSize??AppConstants.pageSize}';
  static String addUpdateDevice = '/robot';
  static String getDeviceDetails(String deviceUuid) => '/robot/$deviceUuid';
  static String updateDeviceStatus(String deviceUuid, bool status)=>'/robot/status/$deviceUuid?active=$status';
  static String deleteDevice(String deviceUuid) => '/robot/delete/$deviceUuid';
  static String exportDevices = '/robot/export';



  ///Import-Export
  static String sampleTicketReason = '/digital_asset/downloadFile/ticket_reason.xlsx?subDir=/sample';
  static String importTicketReason = '/ticket/reason/import';
  static String exportTicketReason = '/ticket/reason/export/list';

  static String sampleCategory = '/digital_asset/downloadFile/businessCategory.xlsx?subDir=/sample';
  static String categoryImport = '/category/import';
  static String categoryExport = '/category/export';

  static String sampleState = '/digital_asset/downloadFile/state_import.xlsx?subDir=/sample';
  static String stateImport = '/state/import';
  static String stateExport = '/state/export';

  /// destination type
  static String getDestinationTypeList(int pageNo,int? pageSize,String? destinationUuid) => '/destination/type/list?pageNumber=$pageNo&pageSize=$pageSize&destinationUuid=$destinationUuid}';
  static String addEditDestinationType = '/destination/type';
  static String changeDestinationTypeStatus(String uuid,bool status) => '/destination/type/status/$uuid?active=$status';
  static String destinationTypeDetails(String uuid) => '/destination/type/$uuid';

  static String sampleStore = '/digital_asset/downloadFile/odgio_store.xlsx?subDir=/sample';
  static String importStore = '/store/import';
  static String exportStore = '/store/export';

  static String sampleDestinationType = '/digital_asset/downloadFile/destinationType.xlsx?subDir=/sample';
  static String importDestinationType = '/destination/type/import';
  static String exportDestinationType = '/destination/type/export';


  ///company
  static String companyDetail = '/company';
  static String companyUploadImage(String companyUuid) => '/company/image/upload/$companyUuid';


  /// role and permission
  static String roleList(int pageNo, int dataSize,bool? activeRecords) => '/role/list?pageNumber=$pageNo&pageSize=$pageSize${activeRecords != null ? '&activeRecords=$activeRecords': ''}';
  static String rolePermissionDetails(String uuid) => '/role/permission/$uuid';
  static String addEditRolePermission = '/role/permission';
  static String modulesList = '/modules/list';
  static String changeRoleStatus(String uuid, isActive) => '/role/status/$uuid?active=$isActive';

  ///cms
  static String addCms = '/cms';
  static String updateCms = '/cms';
  static String getCmsListApi = '/cms/list?pageNumber=1&pageSize=$pageSize&activeRecords=true';
  static String getCmsTypeApi(String cmsType,String platformType) => '/cms?cmsType=$cmsType&platformType=$platformType';
  static String getCmsApi(String cmsType,String platformType) => '/cms/language?cmsType=$cmsType&platformType=$platformType';

  /// faqs
  static String faqList(int pageNo, int dataSize) => '/faq/list?pageNumber=$pageNo&pageSize=$dataSize';
  static String changeFaqStatus(String uuid, isActive) => '/faq/status/$uuid?active=$isActive';
  static String faqDetails(String uuid) => '/faq/$uuid';
  static String addEditFaq = '/faq';

  /// Admin Users
  static String addUser = '/users';
  static String updateUser = '/users';
  static String activeDeActiveUser(String userID,bool isActive) => '/users/status/$userID?active=$isActive';
  static String getUsersDetails(String userID) => '/users/$userID';
  static String getUsersList(int pageNumber, String searchKeyword) => '/users?pageNumber=$pageNumber&pageSize=$pageSize&searchKeyword=$searchKeyword';
  static String getAssignType(int pageNumber, bool? isActive) => '/role/list?pageNumber=$pageNumber&pageSize=$pageSizeTwenty&activeRecords=$isActive';


  /// Destination User
  static String getDestinationUserList(int pageNo,{int? pageSize,String? searchText,bool? isActive}) =>'/destination/user/list?pageNumber=$pageNo&pageSize=${pageSize??AppConstants.pageSize}${searchText?.isNotEmpty??false?'&searchKeyword=$searchText':''}${isActive!=null?'&activeRecords=$isActive':''}';
  static String destinationUserDetails(String userId) =>'/destination/user/$userId';
  static String changeDestinationUserPassword ='/destination/user/password';
  static String updateDestinationUserStatus(String userId,bool status) =>'/destination/user/status/$userId?active=$status';
  static String addUpdateDestinationUser ='/destination/user';

  /// side menu
  static String sidebar = '/role/sidebar';

  ///ticket Management
  static String ticketList(int pageNo, int dataSize) => '/ticket/list?pageNumber=$pageNo&pageSize=$dataSize';
  static String ticketStatus(String uuid) => '/ticket/$uuid';
  static String createTicket = '/ticket';


  ///default ads
  static String defaultAdsList(int pageNo, int dataSize) => '/default/ads/list?pageNumber=$pageNo&pageSize=$dataSize';
  static String changeDefaultAdsStatus(String uuid, isActive) => '/default/ads/status/$uuid?active=$isActive';
  static String deleteDefaultAds(String uuid) => '/default/ads/archive/$uuid';
  static String addDefaultAds = '/default/ads';
  static String updateDefaultAds = '/default/ads';
  static String addDefaultAdsContent(String defaultAdsUuid) => '/default/ads/content/$defaultAdsUuid';
  static String defaultAdsDetails(String defaultAdsUuid) => '/default/ads/$defaultAdsUuid';

  ///client ads
  static String clientAdsList(int pageNo, int dataSize) => '/ads/list?pageNumber=$pageNo&pageSize=$dataSize';
  static String changeClientAdsStatus(String uuid, isActive) => '/ads/status/$uuid?active=$isActive';
  static String deleteClientAds(String uuid) => '/ads/archive/$uuid';
  static String addClientAds = '/ads';
  static String updateClientAds = '/ads';
  static String addClientAdsContent(String clientAdUuid) => '/ads/content/$clientAdUuid';
  static String clientAdsDetails(String clientAdsUuid) => '/ads/$clientAdsUuid';
  static String validateAdsContent(String mediaType) => '/ads/validate/content?mediaType=$mediaType';
  static String acceptRejectAds = '/ads/verify';

  /// Purchase
  static String purchaseList(int pageNo, int dataSize) => '/purchase/list?pageNumber=$pageNo&pageSize=$dataSize';
  static String purchaseTransactionList(int pageNo, int dataSize) => '/purchase/transactions/list?pageNumber=$pageNo&pageSize=$dataSize';
  static String purchaseDetail(String purchaseUuid) => '/purchase/basic/$purchaseUuid';
  static String purchaseAds(String purchaseUuid) => '/purchase/ads/$purchaseUuid';

  ///device details apis
  static String deviceDetail = '/device/detail';
  static String deleteDeviceDetail(String uniqueId) => '/device/detail/$uniqueId';

  ///notification apis
  static String notificationList(int pageNumber) => '/push/notification/list?pageNumber=$pageNumber&pageSize=$pageSize';
  static String notificationUnReadCount =  '/push/notification/count';
  static String notificationReadAll =  '/push/notification/read/all';
  static String notificationListDeleteAll =  '/push/notification';
  static String notificationListDeleteNotification(String notificationId) =>  '/push/notification/$notificationId';

  /// logout
  static String logout = '/login/logout';

  ///deployment
  static String deploymentList(int page) => '/deployment/list?pageNumber=$page&pageSize=$pageSize';
  static String deployment = '/deployment';

  /// Purchase
  static String updatePurchaseAds = '/purchase/ads';
  static String purchaseRefundDetail(String purchaseUuid) => '/purchase/refund/$purchaseUuid';
  static String purchaseCancelDetail(String purchaseUuid) => '/purchase/cancel/$purchaseUuid';
  static String purchaseWeeks(String destinationUuid) => '/purchase/weeks/$destinationUuid';
  static String purchaseRefund = '/purchase/refund';
  static String purchaseCancel = '/purchase/cancel';
  static String purchase = '/purchase';

  /// Wallet Transactions
  static String getWalletList(int pageNo,{int? pageSize}) =>'/wallet/list?pageNumber=$pageNo&pageSize=${pageSize??AppConstants.pageSize}';
  static String settleWallet ='/wallet/settlement';

  /// Purchase Transactions
  static String getPurchaseTransactionList(int pageNo,{int? pageSize}) =>'/purchase/transactions/list?pageNumber=$pageNo&pageSize=${pageSize??AppConstants.pageSize}';
  static String settleInstallment ='/purchase/installments';

  /// Ads Sequence
  static String getAdsSequencePreview({required String destinationUuid}) => '/sequence/preview?destinationUuid=$destinationUuid';
  static String updateAdsSequence = '/sequence/preview';
  static String sequenceHistoryList = '/sequence/history/list';

  ///Ads show time
  static String adsShowTimeList(int pageNo) => '/ads/show/time/list?pageNumber=$pageNo&pageSize=${AppConstants.pageSize}';
  static String exportAdsShownTime = '/ads/show/time/export/list';

  static String destinationPriceHistory(int pageNo, {int? pageSize, String? destinationUuid}) => '/destination/history/list?pageNumber=$pageNo&pageSize=${pageSize ?? AppConstants.pageSize}&destinationUuid=$destinationUuid';
}
