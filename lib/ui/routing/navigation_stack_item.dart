import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:odigov3/ui/utils/app_enums.dart';

part 'navigation_stack_item.freezed.dart';

@freezed
class NavigationStackItem with _$NavigationStackItem {
  const factory NavigationStackItem.splash() = NavigationStackItemSplashPage;
  const factory NavigationStackItem.error() = NavigationStackItemErrorPage;
  const factory NavigationStackItem.dashboard() = NavigationStackItemDashboardPage;
  const factory NavigationStackItem.country() = NavigationStackItemCountryPage;
  const factory NavigationStackItem.state() = NavigationStackItemStatePage;
  const factory NavigationStackItem.city() = NavigationStackItemCityPage;
  const factory NavigationStackItem.destinationType() = NavigationStackItemDestinationTypePage;
  const factory NavigationStackItem.category() = NavigationStackItemCategoryPage;
  const factory NavigationStackItem.currency() = NavigationStackItemCurrencyPage;
  const factory NavigationStackItem.destination() = NavigationStackItemDestinationPage;
  const factory NavigationStackItem.manageDestination({String? destinationUuid}) = NavigationStackItemManageDestinationPage;
  const factory NavigationStackItem.destinationDetails({required String destinationUuid}) = NavigationStackItemDestinationDetailsPage;
  const factory NavigationStackItem.destinationDetailsInfo() = NavigationStackItemdestinationDetailsInfoPage;
  const factory NavigationStackItem.assignRobot() = NavigationStackItemAssignRobotPage;
  const factory NavigationStackItem.assignStore() = NavigationStackItemAssignStorePage;
  const factory NavigationStackItem.store() = NavigationStackItemStorePage;
  const factory NavigationStackItem.agency() = NavigationStackItemAgencyPage;
  const factory NavigationStackItem.vendor() = NavigationStackItemVendorPage;
  const factory NavigationStackItem.package() = NavigationStackItemPackagePage;
  const factory NavigationStackItem.rolesAndPermission() = NavigationStackItemRolesAndPermissionPage;
  const factory NavigationStackItem.rolesAndPermissionDetails({required String roleUuid}) = NavigationStackItemRolesAndPermissionDetailsPage;
  const factory NavigationStackItem.ticket() = NavigationStackItemTicketPage;
  const factory NavigationStackItem.walletTransactions() = NavigationStackItemWalletTransactionsPage;
  const factory NavigationStackItem.purchaseTransactions() = NavigationStackItemPurchaseTransactionsPage;

  ///Ads----
  const factory NavigationStackItem.defaultAds() = NavigationStackItemDefaultAdsPage;
  const factory NavigationStackItem.clientAds() = NavigationStackItemClientAdsPage;
  const factory NavigationStackItem.createAdsDestination({String? destinationUUid}) = NavigationStackItemCreateAdsDestinationPage;
  const factory NavigationStackItem.createAdsClient({String? clientUUid, bool? isFromDetailsScreen}) = NavigationStackItemCreateAdsClientPage;
  const factory NavigationStackItem.adsDetails({required String adsType, required String uuid}) = NavigationStackItemAdsDetailsPage;




  const factory NavigationStackItem.faqs() = NavigationStackItemFaqsPage;
  const factory NavigationStackItem.cms() = NavigationStackItemCmsPage;
  const factory NavigationStackItem.user() = NavigationStackItemUserPage;
  const factory NavigationStackItem.addUser({String? userUuid}) = NavigationStackItemAddUser;
  const factory NavigationStackItem.userDetails({String? userUuid}) = NavigationStackItemUserDetails;
  const factory NavigationStackItem.profile() = NavigationStackItemProfile;


  ///-------------------Auth---------------/////
  const factory NavigationStackItem.login() = NavigationStackItemLoginPage;
  const factory NavigationStackItem.forgotPassword() = NavigationStackItemForgotPasswordPage;
  const factory NavigationStackItem.resetPassword({required String email,required String otp}) = NavigationStackItemResetPasswordPage;
  const factory NavigationStackItem.otpVerification({required String email}) = NavigationStackItemOtpVerificationPage;
  const factory NavigationStackItem.devices() = NavigationStackItemDevicesPage;
  const factory NavigationStackItem.addEditDevice({String? deviceId}) = NavigationStackItemAddDevicePage;
  const factory NavigationStackItem.deviceDetails({required String deviceId}) = NavigationStackItemDeviceDetailsPage;
  const factory NavigationStackItem.ticketReason() = NavigationStackItemTicketReasonPage;
  const factory NavigationStackItem.addCountry() = NavigationStackItemAddCountryPage;
  const factory NavigationStackItem.editCountry() = NavigationStackItemEditCountryPage;
  const factory NavigationStackItem.addState() = NavigationStackItemAddStatePage;
  const factory NavigationStackItem.editState({required String uuid}) = NavigationStackItemEditStatePage;
  const factory NavigationStackItem.addCity() = NavigationStackItemAddCityPage;
  const factory NavigationStackItem.editCity({required String uuid}) = NavigationStackItemEditCityPage;
  const factory NavigationStackItem.addTicketReason() = NavigationStackItemAddTicketReasonPage;
  const factory NavigationStackItem.editTicketReason({required String uuid}) = NavigationStackItemEditTicketReasonPage;
  const factory NavigationStackItem.addCategory() = NavigationStackItemAddCategoryPage;
  const factory NavigationStackItem.addEditStore({String? storeUuid}) = NavigationStackItemAddEditStore;
  const factory NavigationStackItem.storeDetail({required String storeUuid}) = NavigationStackItemStoreDetail;
  const factory NavigationStackItem.settings() = NavigationStackItemSettings;
  const factory NavigationStackItem.client() = NavigationStackItemClient;
  const factory NavigationStackItem.addClient({bool? hasError, Function? popCallBack, String? clientUUid}) = NavigationStackItemAddClient;
  const factory NavigationStackItem.clientDetails({bool? hasError, String? clientUuid}) = NavigationStackItemClientDetails;
  const factory NavigationStackItem.editCategory({required String uuid}) = NavigationStackItemEditCategoryPage;
  const factory NavigationStackItem.generalSupport({bool? hasError}) = NavigationStackItemGeneralSupport;
  const factory NavigationStackItem.addEditDestinationType({String? uuid}) = NavigationStackItemAddEditDestinationTypePage;
  const factory NavigationStackItem.company() = NavigationStackItemCompanyDetails;
  const factory NavigationStackItem.editCompany() = NavigationStackItemEditCompanyDetails;

  const factory NavigationStackItem.addEditFaq({String? faqUuid}) = NavigationStackItemAddEditFaq;
  const factory NavigationStackItem.destinationUser() = NavigationStackItemDestinationUser;
  const factory NavigationStackItem.addEditDestinationUser({String? userUuid}) = NavigationStackItemAddEditDestinationUsere;
  const factory NavigationStackItem.destinationUserDetails({required String userUuid}) = NavigationStackItemDestinationUserDetails;
  const factory NavigationStackItem.ticketList() = NavigationStackItemTicketList;
  const factory NavigationStackItem.createTicket() = NavigationStackItemCreateTicket;
  const factory NavigationStackItem.addEditRolePermission({String? roleId}) = NavigationStackItemAddEditRolePermission;
  const factory NavigationStackItem.deploymentList() = NavigationStackItemDeploymentList;
  const factory NavigationStackItem.addDeployment() = NavigationStackItemAddDeployment;
  const factory NavigationStackItem.showCms({required String title}) = NavigationStackItemShowCms;

  const factory NavigationStackItem.addPurchase({String? clientUuid}) = NavigationStackItemAddPurchase;
  const factory NavigationStackItem.purchase() = NavigationStackItemPurchase;
  const factory NavigationStackItem.purchaseList() = NavigationStackItemPurchaseList;
  const factory NavigationStackItem.purchaseDetails({String? purchaseUuid}) = NavigationStackItemPurchaseDetails;
  const factory NavigationStackItem.uploadDocument({String? clientUuid,String? documentUuid}) = NavigationStackItemUploadDocument;
  const factory NavigationStackItem.selectAds({String? clientUuid}) = NavigationStackItemSelectAds;
  const factory NavigationStackItem.changeAds({String? purchaseUuid,String? clientUuid}) = NavigationStackItemChangeAds;

  const factory NavigationStackItem.notificationList() = NavigationStackItemNotificationList;
  const factory NavigationStackItem.settleClientWallet({String? clientUuid}) = NavigationStackItemSettleClientWallet;
  const factory NavigationStackItem.adsShowTime() = NavigationStackItemAdsShowTime;
  const factory NavigationStackItem.adsSequencePreview() = NavigationStackItemAdsSequencePreview;
  const factory NavigationStackItem.history() = NavigationStackItemHistoryPage;


}