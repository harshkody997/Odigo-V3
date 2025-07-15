import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/routing/delegate.dart';
import 'package:odigov3/ui/routing/navigation_stack_keys.dart';

class RouteManager {
  ///Singleton Class for [RouteManger]
  RouteManager._();

  ///Instance [route] to call methods for [RouteManager]
  static RouteManager route = RouteManager._();

  ///Path Segments to display a path after removing empty paths
  List<String> pathSegments = [];

  ///To remove any empty path after [/] in Path Segments
  void removeEmptyPath(List<String> segments) {
    pathSegments = segments.toList();
    pathSegments.removeWhere((element) => element.trim().isEmpty);
  }

  ///To check if the current route is valid
  RouteValidator checkPathValidation() {
    ///If mobile then always return true
    if (globalNavigatorKey.currentContext?.isMobileScreen ?? false) {
      return const RouteValidator(isAuthenticated: true, isRouteValid: true);
    }

    ///If empty then always return true
    if (pathSegments.isEmpty) {
      return const RouteValidator(isAuthenticated: true, isRouteValid: true);
    }

    ///Create a path without any parameters
    String path = pathSegments.join('/');

    ///Will check authentication
    bool isAuthenticated = Session.userAccessToken.isNotEmpty;

    ///Will check validation and return accordingly

    return getPathValidator(path, isAuthenticated, pathSegments.last);
  }

  Map<String, RouteValidator Function()> routeHandlers(String path, bool isAuthenticated) => <String, RouteValidator Function()>{
    Keys.splash: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.splash),
    Keys.dashboard: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.dashboard),
    Keys.login: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.login),
    Keys.country: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.country}'),
    Keys.state: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.state}'),
    Keys.city: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.city}'),
    Keys.destinationType: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.destinationType}'),
    Keys.category: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.category}'),
    Keys.currency: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.currency}'),
    Keys.ticketReason: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.ticketReason}'),
    Keys.destination: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.destination),
    Keys.destinationDetails: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.destinationDetails),
    Keys.destinationDetailsInfo: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.destinationDetailsInfo),
    Keys.assignRobot: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.assignRobot),
    Keys.assignStore: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.assignStore),
    Keys.manageDestination: () {
      bool path1 = path == '${Keys.destination}/${Keys.manageDestination}';
      bool path2 = path == '${Keys.destination}/${Keys.destinationDetails}/${Keys.manageDestination}';
      return RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path1 || path2);
    },
    Keys.store: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.store),
    Keys.agency: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.agency),
    Keys.package: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.package),
    Keys.rolesAndPermission: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.rolesAndPermission),
    Keys.ticket: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.ticket),
    Keys.defaultAds: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.ads}/${Keys.defaultAds}'),
    Keys.clientAds: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.ads}/${Keys.clientAds}'),
    Keys.createAdsDestination: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.createAdsDestination),
    Keys.createAdsClient: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.createAdsClient),
    Keys.adsDetails: () {
      bool path1 = path == '${Keys.ads}/${Keys.defaultAds}/${Keys.adsDetails}';
      bool path2 = path == '${Keys.ads}/${Keys.clientAds}/${Keys.adsDetails}';
      return RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == path1 || path2);
    },
    Keys.faq: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.faq),
    Keys.cms: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.cms),
    Keys.users: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.users),
    Keys.addCountry: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.country}/${Keys.addCountry}'),
    Keys.editCountry: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.country}/${Keys.editCountry}'),
    Keys.addState: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.state}/${Keys.addState}'),
    Keys.editState: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.state}/${Keys.editState}'),
    Keys.addCity: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.city}/${Keys.addCity}'),
    Keys.editCity: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.city}/${Keys.editCity}'),
    Keys.addTicketReason: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.ticketReason}/${Keys.addTicketReason}'),
    Keys.device: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.device),
    Keys.deviceDetails: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path =='${Keys.device}/${Keys.deviceDetails}'),
    Keys.addDevice: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path =='${Keys.device}/${Keys.addDevice}'),
    Keys.editDevice: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path =='${Keys.device}/${Keys.editDevice}'),
    Keys.editTicketReason: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.ticketReason}/${Keys.editTicketReason}'),
    Keys.addStore: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.store}/${Keys.addStore}'),
    Keys.editStore: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.store}/${Keys.editStore}'),
    Keys.storeDetail: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.store}/${Keys.storeDetail}'),
    Keys.settings: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.dashboard}/${Keys.settings}'),
    Keys.client: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.client),
    Keys.addClient: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.addClient || path == '${Keys.client}/${path == Keys.addClient}'),
    Keys.editClient: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.editClient || path == '${Keys.client}/${path == Keys.editClient}'),
    Keys.clientDetails: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.clientDetails || path == '${Keys.client}/${Keys.clientDetails}'),
    Keys.addPurchase: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.addPurchase || path == '${Keys.client}/${Keys.clientDetails}/${Keys.addPurchase}'),
    Keys.clientDetails: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.clientDetails || path == '${Keys.client}/${path == Keys.clientDetails}'),
    Keys.addCategory: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.destinationType}/${Keys.addCategory}'),
    Keys.editCategory: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.destinationType}/${Keys.editCategory}'),
    Keys.addDestinationType: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.destinationType}/${Keys.addDestinationType}'),
    Keys.editDestinationType: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.master}/${Keys.destinationType}/${Keys.editDestinationType}'),
    Keys.destinationUsers: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.destinationUsers),
    Keys.destinationUserDetails: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path =='${Keys.destinationUsers}/${Keys.destinationUserDetails}'),
    Keys.addDestinationUser: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path =='${Keys.destinationUsers}/${Keys.addDestinationUser}'),
    Keys.editDestinationUser: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path =='${Keys.destinationUsers}/${Keys.editDestinationUser}'),
    Keys.addFaq: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.faq}/${Keys.addFaq}'),
    Keys.editFaq: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.faq}/${Keys.editFaq}'),

    /// User Management
    Keys.users: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.users),
    Keys.addNewUser: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.addNewUser || path == '${Keys.users}/${path == Keys.addNewUser}'),
    Keys.editUser: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.editUser || path == '${Keys.users}/${path == Keys.editUser}'),
    Keys.userDetails: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.userDetails || path == '${Keys.users}/${path == Keys.userDetails}'),

    Keys.addRolePermission: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path =='${Keys.rolesAndPermission}/${Keys.addRolePermission}'),
    Keys.editRolePermission: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path =='${Keys.rolesAndPermission}/${Keys.editRolePermission}'),

    /// Purchase
    Keys.purchase: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.purchase || path == '${Keys.client}/${Keys.clientDetails}/${Keys.purchase}'),
    Keys.purchaseList: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.purchaseList),
    Keys.purchaseDetails: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.purchaseDetails || path == '${Keys.purchase}/${Keys.purchaseDetails}' || path == '${Keys.adsSequencePreview}/${Keys.purchaseDetails}'),
    Keys.selectAds: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.selectAds || path == '${Keys.client}/${Keys.clientDetails}/${Keys.purchase}/${Keys.selectAds}' ),
    Keys.changeAds: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.changeAds || path =='${Keys.purchase}/${Keys.purchaseDetails}/${Keys.changeAds}'),

    Keys.walletTransactions: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.walletTransactions),
    Keys.purchaseTransactions: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.purchaseTransactions),
    Keys.showCms: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == '${Keys.profile}/${Keys.showCms}'),

    /// Purchase
    Keys.addPurchase: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.addPurchase || path == '${Keys.client}/${Keys.clientDetails}/${Keys.addPurchase}'),
    Keys.purchase: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.purchase || path == '${Keys.client}/${Keys.clientDetails}/${Keys.purchase}'),
    Keys.purchaseList: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.purchaseList),
    Keys.purchaseDetails: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.purchaseDetails || path == '${Keys.purchase}/${Keys.purchaseDetails}'),
    Keys.selectAds: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.selectAds || path == '${Keys.client}/${Keys.clientDetails}/${Keys.purchase}/${Keys.selectAds}' ),
    Keys.changeAds: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.changeAds || path =='${Keys.purchase}/${Keys.purchaseDetails}/${Keys.changeAds}'),
    Keys.settleWallet: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.settleWallet || path == '${Keys.client}/${Keys.clientDetails}/${Keys.settleWallet}'),
    Keys.adsSequencePreview: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.adsSequencePreview),
    Keys.history: () => RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: path == Keys.history),
  };

  RouteValidator getPathValidator(String path, bool isAuthenticated, String route) {
    final handler = routeHandlers(path, isAuthenticated)[route];
    return handler != null ? handler() : RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: false);
  }
}

class RouteValidator {
  final bool isRouteValid;
  final bool isAuthenticated;

  const RouteValidator({this.isRouteValid = false, this.isAuthenticated = false});
}
