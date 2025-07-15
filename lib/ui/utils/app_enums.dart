
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';

/// Page error
enum ErrorType { error403, error404, noInternet }

enum OrderType { all, order, services, favourite}

enum TicketStatus {ALL,PENDING,ACKNOWLEDGED,RESOLVED}

enum SampleItem { itemOne }

enum StatusEnum {
  ACTIVE,INACTIVE,PENDING,ACCEPTED,REJECTED,NEW,PAID,CANCELLED,ONGOING,COMPLETED,UPCOMING,APPROVED,ACKNOWLEDGED,REFUND,FAILED,INPROCESS,PARTIALY_FAILED,REFUND_COMPLETED,PARTIAL,FULL
}

final statusEnumValues = EnumValues({
  'ACTIVE': StatusEnum.ACTIVE,
  'INACTIVE': StatusEnum.INACTIVE,
  'PENDING': StatusEnum.PENDING,
  'ACCEPTED': StatusEnum.ACCEPTED,
  'REJECTED': StatusEnum.REJECTED,
  'NEW': StatusEnum.NEW,
  'PAID': StatusEnum.PAID,
  'CANCELLED': StatusEnum.CANCELLED,
  'ONGOING': StatusEnum.ONGOING,
  'COMPLETED': StatusEnum.COMPLETED,
  'UPCOMING': StatusEnum.UPCOMING,
  'APPROVED': StatusEnum.APPROVED,
  'ACKNOWLEDGED': StatusEnum.ACKNOWLEDGED,
  'CREDIT': TransactionsType.CREDIT,
  'DEBIT': TransactionsType.DEBIT,
  'REFUND': StatusEnum.REFUND,
  'PARTIALY_FAILED': StatusEnum.PARTIALY_FAILED,
  'INPROCESS': StatusEnum.INPROCESS,
  'FAILED': StatusEnum.FAILED,
  'RESOLVED': TicketStatus.RESOLVED,
});

///Order Statues
enum OrdersStatusEnum { RESOLVED, ACKNOWLEDGED, PENDING, ACCEPTED, PREPARED, DISPATCH, PARTIALLY_DELIVERED, DELIVERED, REJECTED, CANCELED, IN_TRAY, ROBOT_CANCELED }

/// Screen name
enum ScreenName {
  login,
  dashboard,
  error,
  master,
  destination,
  transactions,
  store,
  agency,
  package,
  robotList,
  ticket,
  ads,
  cms,
  user,
  country,
  state,
  city,
  category,
  destinationType,
  vendor,
  currency,
  rolePermission,
  TicketReason,
  faq,
  none,
  company,
  contactUs,
  resetPassword,
  forgotPassword,
  otpVerification,
  device,
  addEditStore,
  storeDetail,
  settings,
  client,
  addClient,
  editClient,
  clientDetails,
  profile,
  generalSupport,
  walletTransactions,
  purchaseTransactions,
  wallet,
  destinationUsers,
  defaultAds,
  clientAds,
  purchase,
  purchaseList,
  purchaseDetails,
  selectAds,
  changeAds,
  notificationList,
  adsSequence,
  adsShowTime,
  adsSequencePreview,
  history,
  preview
}

/// Dynamic form widget
enum WidgetPropertyEnum {
  widget,
  languageUuid,
  date,
  imageBytes,
  imageUrl,
  selectedValue,
  textEditingController,
  htmlValue,
  htmlEditorController,
}

/// Master enum
enum JsonType { country, state, city, business, destinationType,package,store,faq,cms,ticket }
enum EntityType { vendor, agency, client_master }
final List imageExt =  ['.jpeg', '.jpg', '.png',];
List<String> videoExtensions = ['.mp4', '.avi', '.mov', '.mkv', '.flv', '.webm', '.mpeg', '.mpg', '.ogv'];

enum MediaTypeEnum {image,video}
enum EventHistoryStatusEnum {PENDING, ONGOING, COMPLETED, UNSUCCESSFUL}

enum ContentLengthEnum {ten,fifteen,thirty}


class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }

}

enum ImportTypes{
  COUNTRY,
  TICKET_REASON,
  STORE,
  DESTINATION_TYPE,
  BUSINESS_CATEGORY
}

enum RoleType{
  SUPER_ADMIN,
  DESTINATION,
  DESTINATION_USER,
  USER
}
enum EntityTypes { VENDOR, AGENCY, CLIENT_MASTER }

enum TicketReasonPlatformType{
  DESTINATION(LocaleKeys.keyDestination),
  CLIENT(LocaleKeys.keyClient);

  final String key;
  const TicketReasonPlatformType(this.key);

  String get text => key.localized;
}

enum TicketStatusType{
  ALL(LocaleKeys.keyAll,null),
  ACKNOWLEDGED(LocaleKeys.keyAcknowledged,'ACKNOWLEDGED'),
  RESOLVED(LocaleKeys.keyResolved,'RESOLVED'),
  PENDING(LocaleKeys.keyPending,'PENDING');

  final String key;
  final String? value;
  const TicketStatusType(this.key,this.value);

  String get text => key.localized;
}



/// Dynamic form enum Based On LANGUAGE
enum DynamicFormEnum{
  COUNTRY,
  STATE,
  DESTINATION_NAME,
  CITY,
  TICKET_REASON,
  STORE,
  CATEGORY,
  DESTINATION_TYPE,
  COMPANY,
  ADDRESS,
  FAQ_QUESTION,
  FAQ_ANSWER,
}

enum SettingEnum{
  PURCHASE_START_DAY_OF_WEEK, DYNAMIC_IP, FTP_SERVER_URL, SEND_NOTIFICATION, SEND_EMAIL, SEND_SMS
}

enum LanguageType{
  en, ar
}

enum DrawerMenuEnum{
  DASHBOARD('Dashboard'),
  MASTER('Master'),
  DEVICE('Device'),
  STORE('Store'),
  DESTINATION('Destination'),
  DESTINATION_USER('Destination User'),
  ADS('Ads'),
  CLIENT('Client'),
  PURCHASE('Purchase'),
  WALLET('Wallet'),
  ROLE_AND_PERMISSION('Role & Permission'),
  CMS('CMS'),
  FAQ('FAQ'),
  TICKET('Ticket'),
  CONTACTUS('Contact Us'),
  COMPANY('Company'),
  USERS('Users'),
  PURCHASE_TRANSACTIONS('Purchase Transactions'),
  WALLET_TRANSACTIONS('Wallet Transactions'),
  ADS_SEQUENCE('Ads Sequence'),
  ADS_SHOW_TIME('Ads Shown Time');

  final String moduleName;
  const DrawerMenuEnum(this.moduleName);

  String get text => moduleName;
}

enum DrawerSubMenuEnum{
  COUNTRY('Country'),
  STATE('State'),
  CITY('City'),
  TICKET_REASON('Ticket Reason'),
  CATEGORY('Category'),
  DESTINATION_TYPE('Destination Type'),
  CLIENT_ADS('Client Ads'),
  DEFAULT_ADS('Default Ads'),
  ADS_SEQUENCE_PREVIEW('Preview'),
  HISTORY('History'),
  PREVIEW('Preview');

  final String moduleName;
  const DrawerSubMenuEnum(this.moduleName);

  String get text => moduleName;
}

extension DrawerMenuEnumHelper on DrawerMenuEnum {
  static DrawerMenuEnum? fromStringToEnum(String key) {
    try {
      return DrawerMenuEnum.values.firstWhere(
            (e) => e.moduleName.toLowerCase() == key.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}

extension DrawerSubMenuEnumHelper on DrawerSubMenuEnum {
  static DrawerSubMenuEnum? fromStringToEnum(String key) {
    try {
      return DrawerSubMenuEnum.values.firstWhere(
            (e) => e.moduleName.toLowerCase() == key.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}

enum FaqType{
  Destinations,
  Clients
}
enum PlatFormType{
  Destination,
  Client
}
// extension PlatformTypeExtension on PlatFormType {
//   String get label {
//     switch (this) {
//       case PlatFormType.Destination:
//         return LocaleKeys.keyDestination.localized;
//       case PlatFormType.Client:
//         return LocaleKeys.keyClient.localized;
//     }
//   }
// }

enum CmsType {
  aboutUs,
  termsAndCondition,
  privacyPolicy,
  refund,
  cancel,
}

enum PurchaseType {
  PREMIUM,
  FILLER
}

enum CmsValueEnum{
  ABOUT_US,PRIVACY_POLICY,TERMS_AND_CONDITION,REFUND
}

extension PlatFormTypeExtension on PlatFormType {
  String label(BuildContext context) {
    switch (this) {
      case PlatFormType.Destination:
        return LocaleKeys.keyDestination.tr(context: context);
      case PlatFormType.Client:
        return LocaleKeys.keyClient.tr(context: context);
    }
  }
}

extension CmsTypeExtension on CmsType {
  String get key {
        switch (this) {
      case CmsType.aboutUs:
        return 'ABOUT_US';
      case CmsType.termsAndCondition:
        return 'TERMS_AND_CONDITION';
      case CmsType.privacyPolicy:
        return 'PRIVACY_POLICY';
      case CmsType.refund:
        return 'REFUND';
      case CmsType.cancel:
        return 'CANCEL';
    }
  }

  String label(BuildContext context) {
    switch (this) {

      case CmsType.aboutUs:
        return LocaleKeys.keyAboutUs.localized;
      case CmsType.termsAndCondition:
        return LocaleKeys.keyTermsAndConditions.localized;
      case CmsType.privacyPolicy:
        return LocaleKeys.keyPrivacyPolicy.localized;
      case CmsType.refund:
        return LocaleKeys.keyRefund.localized;
      case CmsType.cancel:
        return LocaleKeys.keyCancel.localized;

    }
  }
}


enum TransactionsType{
  DEBIT,
  CREDIT
}


enum AdsType{
  Default,
  Client,
}
enum DestinationDaysEnum{
  MONDAY(LocaleKeys.keyMonday),
  TUESDAY(LocaleKeys.keyTuesday),
  WEDNESDAY(LocaleKeys.keyWednesday),
  THURSDAY(LocaleKeys.keyThursday),
  FRIDAY(LocaleKeys.keyFriday),
  SATURDAY(LocaleKeys.keySaturday),
  SUNDAY(LocaleKeys.keySunday);

  final String key;
  const DestinationDaysEnum(this.key);

  String get text => key.localized;

}

DestinationDaysEnum? getDestinationDayEnum(String day) {
  try {
    return DestinationDaysEnum.values.firstWhere(
          (e) => e.name.toLowerCase() == day.toLowerCase(),
    );
  } catch (_) {
    return null;
  }
}

enum PaymentType{
  PARTIAL,
  FULL
}
enum SlotType{
  PURCHASE,
  DEFAULT
}

enum MonthEnum {
  Jan,Feb,Mar,April,May,June,July,Aug,Sep,Oct,Nov,Dec
}
