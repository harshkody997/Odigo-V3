import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';

class Keys {
  Keys._();

  static Keys keys = Keys._();

  static String get splash => 'splash'.endPointEncrypt;

  static String get error => 'error'.endPointEncrypt;

  static String get login => 'login'.endPointEncrypt;

  static String get dashboard => 'dashboard'.endPointEncrypt;

  static String get master => 'master'.endPointEncrypt;

  static String get country => 'country'.endPointEncrypt;

  static String get state => 'state'.endPointEncrypt;

  static String get city => 'city'.endPointEncrypt;

  static String get destinationType => 'destinationType'.endPointEncrypt;

  static String get category => 'category'.endPointEncrypt;

  static String get currency => 'currency'.endPointEncrypt;

  static String get destination => 'destination'.endPointEncrypt;
  static String get destinationDetails => 'destinationDetails'.endPointEncrypt;
  static String get destinationDetailsInfo => 'destinationDetailsInfo'.endPointEncrypt;
  static String get assignStore => 'assignStore'.endPointEncrypt;
  static String get assignRobot => 'assignRobot'.endPointEncrypt;

  static String get manageDestination => 'manageDestination'.endPointEncrypt;

  static String get store => 'store'.endPointEncrypt;

  static String get agency => 'agency'.endPointEncrypt;

  static String get vendor => 'vendor'.endPointEncrypt;

  static String get package => 'package'.endPointEncrypt;

  static String get rolesAndPermission => 'rolesAndPermission'.endPointEncrypt;
  static String get rolesAndPermissionDetails => 'rolesAndPermissionDetails'.endPointEncrypt;

  static String get ticket => 'ticket'.endPointEncrypt;

  static String get ads => 'ads'.endPointEncrypt;
  static String get defaultAds => 'defaultAds'.endPointEncrypt;
  static String get clientAds => 'clientAds'.endPointEncrypt;
  static String get adsDetails => 'adsDetails'.endPointEncrypt;

  static String get createAdsDestination => 'createAdsDestination'.endPointEncrypt;
  static String get createAdsClient => 'createAdsClient'.endPointEncrypt;

  static String get faq => 'faq'.endPointEncrypt;

  static String get cms => 'cms'.endPointEncrypt;
  static String get showCms => 'showCms'.endPointEncrypt;

  static String get users => 'users'.endPointEncrypt;
  static String get addNewUser => 'addNewUser'.endPointEncrypt;
  static String get editUser => 'editUser'.endPointEncrypt;
  static String get userDetails => 'userDetails'.endPointEncrypt;
  static String get profile => 'profile'.endPointEncrypt;
  static String get ticketReason => 'TicketReason'.endPointEncrypt;
  static String get forgotPassword => 'forgotPassword'.endPointEncrypt;
  static String get resetPassword => 'resetPassword'.endPointEncrypt;
  static String get otpVerification => 'otpVerification'.endPointEncrypt;

  static String get device => 'device'.endPointEncrypt;

  static String get deviceDetails => 'deviceDetails'.endPointEncrypt;

  static String get addDevice => 'addDevice'.endPointEncrypt;
  static String get editDevice => 'editDevice'.endPointEncrypt;
  static String get addCountry => 'addCountry'.endPointEncrypt;
  static String get editCountry => 'editCountry'.endPointEncrypt;
  static String get addState => 'addState'.endPointEncrypt;
  static String get editState => 'editState'.endPointEncrypt;
  static String get addCity => 'addCity'.endPointEncrypt;
  static String get editCity => 'editCity'.endPointEncrypt;
  static String get addTicketReason => 'addTicketReason'.endPointEncrypt;
  static String get editTicketReason => 'editTicketReason'.endPointEncrypt;
  static String get addEditStore => 'addEditStore'.endPointEncrypt;
  static String get addStore => 'addstore'.endPointEncrypt;
  static String get editStore => 'editStore'.endPointEncrypt;
  static String get storeDetail => 'storeDetail'.endPointEncrypt;
  static String get settings => 'settings'.endPointEncrypt;
  static String get client => 'client'.endPointEncrypt;
  static String get addClient => 'addClient'.endPointEncrypt;
  static String get editClient => 'editClient'.endPointEncrypt;
  static String get clientDetails => 'clientDetails'.endPointEncrypt;
  static String get addCategory => 'addCategory'.endPointEncrypt;
  static String get editCategory => 'editCategory'.endPointEncrypt;
  static String get generalSupport => 'generalSupport'.endPointEncrypt;
  static String get addDestinationType => 'addDestinationType'.endPointEncrypt;
  static String get editDestinationType => 'editDestinationType'.endPointEncrypt;

  static String get company => 'company'.endPointEncrypt;
  static String get editCompany => 'editCompany'.endPointEncrypt;

  static String get addFaq => 'addFaq'.endPointEncrypt;
  static String get editFaq => 'editFaq'.endPointEncrypt;
  static String get destinationUsers => 'destinationUser'.endPointEncrypt;
  static String get addDestinationUser => 'addDestinationUser'.endPointEncrypt;
  static String get editDestinationUser => 'editDestinationUser'.endPointEncrypt;
  static String get destinationUserDetails => 'destinationUserDetails'.endPointEncrypt;
  static String get ticketList => 'ticketList'.endPointEncrypt;
  static String get createTicket => 'createTicket'.endPointEncrypt;
  static String get addRolePermission => 'addRolePermission'.endPointEncrypt;
  static String get editRolePermission => 'editRolePermission'.endPointEncrypt;
  static String get walletTransactions => 'walletTransactions'.endPointEncrypt;
  static String get purchaseTransactions => 'purchaseTransactions'.endPointEncrypt;
  static String get wallet => 'wallet'.endPointEncrypt;
  static String get purchase => 'purchase'.endPointEncrypt;
  static String get purchaseList => 'purchaseList'.endPointEncrypt;
  static String get purchaseDetails => 'purchaseDetails'.endPointEncrypt;
  static String get selectAds => 'selectAds'.endPointEncrypt;
  static String get changeAds => 'changeAds'.endPointEncrypt;
  static String get uploadDocument => 'uploadDocument'.endPointEncrypt;
  static String get notification => 'notification'.endPointEncrypt;
  static String get deploymentList => 'deploymentList'.endPointEncrypt;
  static String get addDeployment => 'addDeployment'.endPointEncrypt;
  static String get addPurchase => 'addPurchase'.endPointEncrypt;
  static String get settleWallet => 'settleWallet'.endPointEncrypt;
  static String get adsShowTime => 'adsShowTime'.endPointEncrypt;
  static String get adsSequencePreview => 'adsSequencePreview'.endPointEncrypt;
  static String get adsSequence => 'adsSequence'.endPointEncrypt;
  static String get history => 'history'.endPointEncrypt;
}

class QueryParam {
  QueryParam._();

  static QueryParam queryParam = QueryParam._();

  static String get id => 'id'.endPointEncrypt;

  static String get deviceId => 'deviceId'.endPointEncrypt;

  static String get storeId => 'storeId'.endPointEncrypt;

  static String get email => 'email'.endPointEncrypt;

  static String get clientUuid => 'clientUuid'.endPointEncrypt;

  static String get userUuid => 'userUuid'.endPointEncrypt;

  static String get destinationUuid => 'destinationUuid'.endPointEncrypt;

  static String get otp => 'otp'.endPointEncrypt;
  static String get stateUuid => 'uuid'.endPointEncrypt;
  static String get cityUuid => 'uuid'.endPointEncrypt;
  static String get ticketReasonUuid => 'uuid'.endPointEncrypt;
  static String get categoryUuid => 'uuid'.endPointEncrypt;
  static String get destinationTypeUuid => 'uuid'.endPointEncrypt;
  static String get faqUuid => 'faqUuid'.endPointEncrypt;
  static String get roleUuid => 'roleUuid'.endPointEncrypt;
  static String get rolePermissionUuid => 'uuid'.endPointEncrypt;
  static String get adsDetailUuid => 'adsDetailUuid'.endPointEncrypt;
  static String get adsDetailType => 'adsDetailType'.endPointEncrypt;
  static String get purchaseUuid => 'purchaseUuid'.endPointEncrypt;
  static String get notificationList => 'notificationList'.endPointEncrypt;
  static String get cmsType => 'cmsType'.endPointEncrypt;
  static String get documentUuid => 'documentUuid'.endPointEncrypt;


}

class NavigationStackKeyMapper {
  NavigationStackKeyMapper._();

  List<String> keysList = [];
  String currentKey = '';

  static NavigationStackKeyMapper mapper = NavigationStackKeyMapper._();

  static Map<String, String> keyValueMapper = {
    Keys.splash: 'Splash',
    Keys.error: 'Error',
    Keys.login: 'Login',
    Keys.dashboard: LocaleKeys.keyDashboard,
    Keys.otpVerification: 'Otp Verification',
    Keys.master: LocaleKeys.keyMaster,
    Keys.country: LocaleKeys.keyCountryMaster,
    Keys.state: LocaleKeys.keyStateMaster,
    Keys.city: LocaleKeys.keyCityMaster,
    Keys.destinationType: LocaleKeys.keyDestinationTypeMaster,
    Keys.category: LocaleKeys.keyCategoriesMaster,
    Keys.currency: 'Currency',
    Keys.destination: LocaleKeys.keyDestination,
    Keys.destinationDetails: LocaleKeys.keyDestinationDetails,
    Keys.destinationDetailsInfo: LocaleKeys.keyMoreInformation,
    Keys.assignRobot: LocaleKeys.keyAssignNewRobot,
    Keys.assignStore: LocaleKeys.keyAssignNewStore,
    Keys.manageDestination:LocaleKeys.keyManageDestination,
    Keys.store: LocaleKeys.keyStore,
    Keys.agency: 'Agency',
    Keys.vendor: 'Vendor',
    Keys.package: 'Package',
    Keys.rolesAndPermission:LocaleKeys.keyRolesPermission,
    Keys.rolesAndPermissionDetails: LocaleKeys.keyRolesPermissionDetails,
    Keys.ticket: LocaleKeys.keyTicket,
    Keys.ads: LocaleKeys.keyAds,
    Keys.defaultAds: LocaleKeys.keyDefaultAds,
    Keys.clientAds: LocaleKeys.keyClientAds,
    Keys.createAdsDestination: LocaleKeys.keyDestinationAds,
    Keys.createAdsClient: LocaleKeys.keyAddClientAds,
    Keys.adsDetails: LocaleKeys.keyAdsDetails,
    Keys.faq:  LocaleKeys.keyFaqs,
    Keys.cms:  LocaleKeys.keyCMSManagement,
    Keys.users:  LocaleKeys.keyUsers,
    Keys.addNewUser: LocaleKeys.keyAddNewUser,
    Keys.editUser:  LocaleKeys.keyEditUser,
    Keys.userDetails:  LocaleKeys.keyUserDetails,
    Keys.device:  LocaleKeys.keyDevices,
    Keys.deviceDetails:  LocaleKeys.keyDeviceDetails,
    Keys.addDevice:  LocaleKeys.keyAddDevice,
    Keys.editDevice:  LocaleKeys.keyEditDevice,
    Keys.addState:  LocaleKeys.keyAddState,
    Keys.addCity:  LocaleKeys.keyAddCity,
    Keys.addTicketReason: LocaleKeys.keyAddTicketReason,
    Keys.ticketReason: LocaleKeys.keyTicketReason,
    Keys.editState: LocaleKeys.keyEditState,
    Keys.editCity: LocaleKeys.keyEditCity,
    Keys.editTicketReason:LocaleKeys.keyEditTicketReason,
    Keys.addStore: LocaleKeys.keyAddStore,
    Keys.editStore: LocaleKeys.keyEditStore,
    Keys.storeDetail: LocaleKeys.keyStoreDetails,
    Keys.client: LocaleKeys.keyClient,
    Keys.addClient: LocaleKeys.keyAddNewClient,
    Keys.editClient: LocaleKeys.keyEditClient,
    Keys.clientDetails: LocaleKeys.keyClientDetails,
    Keys.generalSupport: LocaleKeys.keyGeneralSupport,
    Keys.addCategory: LocaleKeys.keyAddCategory,
    Keys.editCategory:  LocaleKeys.keyEditCategory,
    Keys.settings: LocaleKeys.keySetting,
    Keys.addDestinationType: LocaleKeys.keyAddDestinationType,
    Keys.editDestinationType: LocaleKeys.keyEditDestinationType,
    Keys.company: LocaleKeys.keyCompany,
    Keys.editCompany: LocaleKeys.keyEditCompany,
    Keys.addFaq: LocaleKeys.keyAddFAQ,
    Keys.editFaq: LocaleKeys.keyEditFAQ,
    Keys.destinationUsers: LocaleKeys.keyDestinationUsers,
    Keys.destinationUserDetails:  LocaleKeys.keyUserDetails,
    Keys.addDestinationUser:  LocaleKeys.keyAddNewUser,
    Keys.editDestinationUser:  LocaleKeys.keyEditUser,
    Keys.ticketList:  LocaleKeys.keyTickets,
    Keys.createTicket: LocaleKeys.keyCreateTicket,
    Keys.addRolePermission: LocaleKeys.keyAddNewRole,
    Keys.editRolePermission: LocaleKeys.keyEditRole,
    Keys.walletTransactions: LocaleKeys.keyWalletTransactions,
    Keys.purchaseTransactions: LocaleKeys.keyPurchaseTransaction,
    Keys.wallet: LocaleKeys.keyWallet,
    Keys.notification: LocaleKeys.keyNotification,
    Keys.deploymentList: LocaleKeys.keyDeployment,
    Keys.addDeployment: LocaleKeys.keyAddNewDeployment,
    Keys.profile: LocaleKeys.keyProfile,
    Keys.showCms: cmsPage,
    Keys.purchaseList: LocaleKeys.keyPurchase,
    Keys.uploadDocument: LocaleKeys.keyUploadDocuments,
    Keys.addPurchase: LocaleKeys.keyPurchase,
    Keys.purchase: LocaleKeys.keyPurchase,
    Keys.purchaseList: LocaleKeys.keyPurchase,
    Keys.purchaseDetails: LocaleKeys.keyPurchaseDetails,
    Keys.selectAds: LocaleKeys.keySelectAds,
    Keys.changeAds: LocaleKeys.keyChangeAds,
    Keys.settleWallet: LocaleKeys.keySettleWallet,
    Keys.adsShowTime: LocaleKeys.keyAdsShowTime,
    Keys.adsSequencePreview: LocaleKeys.keyPreview,
    Keys.adsSequence: LocaleKeys.keyAdsSequence,
    Keys.history: LocaleKeys.keyHistory,

  };

  static value(String key) => keyValueMapper[key] ?? '';
}
