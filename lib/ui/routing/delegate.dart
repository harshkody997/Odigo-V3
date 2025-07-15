import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/ui/ads_create/ads_details.dart';
import 'package:odigov3/ui/ads_create/create_ads.dart';
import 'package:odigov3/ui/ads_show_time/ads_show_time.dart';
import 'package:odigov3/ui/ads_sequence_preview/ads_sequence_preview.dart';
import 'package:odigov3/ui/ads_timeline/history_listing.dart';
import 'package:odigov3/ui/assign_new_robot/assign_new_robot.dart';
import 'package:odigov3/ui/assign_new_store/assign_new_store.dart';
import 'package:odigov3/ui/auth/forgot_password.dart';
import 'package:odigov3/ui/ads_module/ads_module.dart';
import 'package:odigov3/ui/auth/login.dart';
import 'package:odigov3/ui/client/settle_wallet.dart';
import 'package:odigov3/ui/client/upload_document.dart';
import 'package:odigov3/ui/cms/show_cms.dart';
import 'package:odigov3/ui/company/company_details.dart';
import 'package:odigov3/ui/company/edit_company_details.dart';
import 'package:odigov3/ui/cms/cms.dart';
import 'package:odigov3/ui/client_ads/client_ads.dart';
import 'package:odigov3/ui/dashboard/dashboard.dart';
import 'package:odigov3/ui/deployment/add_deployment.dart';
import 'package:odigov3/ui/deployment/deployment_list.dart';
import 'package:odigov3/ui/destination/destination.dart';
import 'package:odigov3/ui/destination_details/destination_details.dart';
import 'package:odigov3/ui/destination_details/more_info.dart';
import 'package:odigov3/ui/destination/manange_destination.dart';
import 'package:odigov3/ui/auth/otp_verification.dart';
import 'package:odigov3/ui/auth/reset_password.dart';
import 'package:odigov3/ui/destination_user_management/add_edit_destination_user.dart';
import 'package:odigov3/ui/destination_user_management/destination_user.dart';
import 'package:odigov3/ui/destination_user_management/destination_user_details.dart';
import 'package:odigov3/ui/device/add_edit_device.dart';
import 'package:odigov3/ui/client/add_update_client.dart';
import 'package:odigov3/ui/client/client_details.dart';
import 'package:odigov3/ui/client/client_list.dart';
import 'package:odigov3/ui/device/device.dart';
import 'package:odigov3/ui/device/device_details.dart';
import 'package:odigov3/ui/dummy_page.dart';
import 'package:odigov3/ui/error/error_404.dart';
import 'package:odigov3/ui/faq/add_edit_faq.dart';
import 'package:odigov3/ui/faq/faq.dart';
import 'package:odigov3/ui/master/category/add_edit_category.dart';
import 'package:odigov3/ui/general_support/general_support.dart';
import 'package:odigov3/ui/master/category/category_list.dart';
import 'package:odigov3/ui/master/destination_type/add_edit_destination_type.dart';
import 'package:odigov3/ui/master/destination_type/destination_type_list.dart';
import 'package:odigov3/ui/notification_list/notification_list.dart';
import 'package:odigov3/ui/profile/profile.dart';
import 'package:odigov3/ui/master/city/add_edit_city.dart';
import 'package:odigov3/ui/master/city/city_list.dart';
import 'package:odigov3/ui/master/country/add_edit_country.dart';
import 'package:odigov3/ui/master/country/country_list.dart';
import 'package:odigov3/ui/master/state/add_edit_state.dart';
import 'package:odigov3/ui/master/state/state_list.dart';
import 'package:odigov3/ui/master/ticket_reason/add_edit_ticket_reason.dart';
import 'package:odigov3/ui/master/ticket_reason/ticket_reason_list.dart';
import 'package:odigov3/ui/purchase_transaction/purchase_transaction.dart';
import 'package:odigov3/ui/purchase/add_purchase.dart';
import 'package:odigov3/ui/purchase/change_ads.dart';
import 'package:odigov3/ui/purchase/purchase.dart';
import 'package:odigov3/ui/purchase/purchase_details.dart';
import 'package:odigov3/ui/purchase/purchase_list.dart';
import 'package:odigov3/ui/purchase/select_ads.dart';
import 'package:odigov3/ui/roles_permission/add_edit_role.dart';
import 'package:odigov3/ui/roles_permission/role_permission_details.dart';
import 'package:odigov3/ui/roles_permission/roles_permission.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/navigation_stack_keys.dart';
import 'package:odigov3/ui/routing/no_animation_route.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/settings/settings.dart';
import 'package:odigov3/ui/splash/splash.dart';
import 'package:odigov3/ui/store/add_edit_store.dart';
import 'package:odigov3/ui/store/store.dart';
import 'package:odigov3/ui/store/store_detail.dart';
import 'package:odigov3/ui/ticket_management/create_ticket.dart';
import 'package:odigov3/ui/ticket_management/ticket_list.dart';
import 'package:odigov3/ui/user_management/add_new_user.dart';
import 'package:odigov3/ui/user_management/user_details.dart';
import 'package:odigov3/ui/user_management/user_management.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/wallet_transactions/wallet_transactions.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

@injectable
class MainRouterDelegate extends RouterDelegate<NavigationStack> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final NavigationStack stack;

  @override
  void dispose() {
    stack.removeListener(notifyListeners);
    super.dispose();
  }

  MainRouterDelegate(@factoryParam this.stack) : super() {
    stack.addListener(notifyListeners);
  }

  @override
  final navigatorKey = globalNavigatorKey;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Navigator(
          key: navigatorKey,
          pages: _pages(ref),

          /// callback when a page is popped.
          onPopPage: (route, result) {
            /// let the OS handle the back press if there was nothing to pop
            if (!route.didPop(result)) {
              return false;
            }

            /// if we are on root, let OS close app
            if (stack.items.length == 1) return false;

            /// if we are on root, let OS close app
            if (stack.items.isEmpty) return false;

            /// otherwise, pop the stack and consume the event
            stack.pop();
            return true;
          },
        );
      },
    );
  }

  List<Page> _pages(WidgetRef ref) => stack.items.mapIndexed((e, i) {
//     final key = NavigationStackKeyMapper.mapper.currentKey;
//     showLog("MOHIT MOHIT key ${key}");
//     final isExemptedPage = key == Keys.splash || key == Keys.login || key == Keys.otpVerification || key == Keys.forgotPassword;
//     if (!isExemptedPage && key.isNotEmpty) {
//       var value = ref.read(drawerController).selectedMainScreen;
//
// // If it has children, switch to sub screen
//       if ((value?.children?.isNotEmpty ?? false)) {
//         showLog("MANSI KHATRI: Using subScreen instead of mainScreen");
//         value = SidebarModel(
//           canAdd: ref.read(drawerController).selectedSubScreen?.canAdd,
//           canDelete: ref.read(drawerController).selectedSubScreen?.canDelete,
//           canEdit: ref.read(drawerController).selectedSubScreen?.canEdit,
//           canView: ref.read(drawerController).selectedSubScreen?.canView,
//           canViewSidebar: ref.read(drawerController).selectedSubScreen?.canViewSidebar,
//           drawerMenuModel: ref.read(drawerController).selectedSubScreen?.drawerMenuModel,
//           modulesName: ref.read(drawerController).selectedSubScreen?.modulesName,
//           modulesNameEnglish: ref.read(drawerController).selectedSubScreen?.modulesNameEnglish,
//           modulesUuid: ref.read(drawerController).selectedSubScreen?.modulesUuid,
//         );
//       }
//
// // === PERMISSION CHECKS (no queryParams) ===
//
//       if (value == null) {
//         showLog("GORT ERROR: value is null for key: $key");
//         return NoAnimationPage(child: Error404());
//       }
//
//       if (!(value.canView ?? true)) {
//         showLog("GORT ERROR: canView is false for key: $key");
//         return NoAnimationPage(child: Error404());
//       }
//
//       // if (!(value.canAdd ?? true) && !(value.canEdit ?? true)) {
//       //   showLog("GORT ERROR: No add or edit permission for key: $key");
//       //   return NoAnimationPage(child: Error404());
//       // }
//
// // // 4. Add attempt not allowed (assuming this is an add screen)
// //       if (!(value.canAdd ?? true)) {
// //         showLog("GORT ERROR: Add not allowed for key: $key");
// //         return NoAnimationPage(child: Error404());
// //       }
//
//       showLog("GORT: All permission checks passed for key: $key");
//       return buildPageFromNavigationItem(e);
//
//     } else {
//       showLog("JSJSJSJSJ");
      return buildPageFromNavigationItem(e);
    // }
  }).toList();

  Page buildPageFromNavigationItem(NavigationStackItem item) {
    return item.when(
      splash: () => NoAnimationPage(child: Splash(), key: ValueKey(Keys.splash)),
      error: () => NoAnimationPage(child: Error404(errorType: ErrorType.error404,), /*key: ValueKey(Keys.error)*/),
      login: () => NoAnimationPage(child: Login(), key: ValueKey(Keys.login)),
      dashboard: () => NoAnimationPage(child: Dashboard(), key: ValueKey(Keys.dashboard)),
      country: () => NoAnimationPage(child: CountryList(), key: ValueKey(Keys.country)),
      state: () => NoAnimationPage(child: StateList(), key: ValueKey(Keys.state)),
      city: () => NoAnimationPage(child: CityList(), key: ValueKey(Keys.city)),
      destinationType: () => NoAnimationPage(child: DestinationTypeList(), key: ValueKey(Keys.destinationType)),
      manageDestination: (destinationUuid) => NoAnimationPage(
        child: ManageDestination(destinationUuid: destinationUuid),
        key: ValueKey(Keys.manageDestination),
      ),
      category: () => NoAnimationPage(child: CategoryList(), key: ValueKey(Keys.category)),
      currency: () => NoAnimationPage(child: DummyPage(), key: ValueKey(Keys.currency)),
      destination: () => NoAnimationPage(child: Destination(), key: ValueKey(Keys.destination)),
      destinationDetails: (destinationUuid) => NoAnimationPage(
        child: DestinationDetails(destinationUuid: destinationUuid),
        key: ValueKey(Keys.destinationDetails),
      ),
      destinationDetailsInfo: () => NoAnimationPage(child: MoreInfo(), key: ValueKey(Keys.destinationDetailsInfo)),
      assignStore: () => NoAnimationPage(child: AssignNewStore(), key: ValueKey(Keys.assignStore)),
      assignRobot: () => NoAnimationPage(child: AssignNewRobot(), key: ValueKey(Keys.assignRobot)),
      store: () => NoAnimationPage(child: Store(), key: ValueKey(Keys.store)),
      agency: () => NoAnimationPage(child: DummyPage(), key: ValueKey(Keys.agency)),
      vendor: () => NoAnimationPage(child: DummyPage(), key: ValueKey(Keys.vendor)),
      package: () => NoAnimationPage(child: DummyPage(), key: ValueKey(Keys.package)),
      rolesAndPermission: () => NoAnimationPage(child: RolesPermission(), key: ValueKey(Keys.rolesAndPermission)),
      rolesAndPermissionDetails: (uuid) => NoAnimationPage(
        child: RolePermissionDetails(uuid: uuid),
        key: ValueKey(Keys.rolesAndPermissionDetails),
      ),
      ticket: () => NoAnimationPage(child: DummyPage(), key: ValueKey(Keys.ticket)),
      defaultAds: () => NoAnimationPage(child: AdsModule(), key: ValueKey(Keys.defaultAds)),
      clientAds: () => NoAnimationPage(child: ClientAds(), key: ValueKey(Keys.clientAds)),
      createAdsDestination: (destinationUUid) => NoAnimationPage(child: CreateAds(uuid: destinationUUid), key: ValueKey(Keys.createAdsDestination)),
      createAdsClient: (clientUUid, isFromDetailsScreen) => NoAnimationPage(child: CreateAds(uuid: clientUUid, isFromDetailsScreen: isFromDetailsScreen ?? false), key: ValueKey(Keys.createAdsClient)),
      adsDetails: (adsType, uuid) => NoAnimationPage(
        child: AdsDetails(adsType: adsType, uuid: uuid),
        key: ValueKey(Keys.adsDetails),
      ),
      faqs: () => NoAnimationPage(child: Faq(), key: ValueKey(Keys.faq)),
      cms: () => NoAnimationPage(child: Cms(), key: ValueKey(Keys.cms)),
      user: () => NoAnimationPage(child: UserManagement(), key: ValueKey(Keys.users)),
      addUser: (userUuid) => NoAnimationPage(
        child: AddNewUser(userUuid: userUuid),
        key: ValueKey(Keys.addNewUser),
      ),
      userDetails: (userUuid) => NoAnimationPage(
        child: UserDetails(userUuid: userUuid),
        key: ValueKey(Keys.userDetails),
      ),
      profile: () => NoAnimationPage(child: Profile(), key: ValueKey(Keys.profile)),
      ticketReason: () => NoAnimationPage(child: TicketReasonList(), key: ValueKey(Keys.ticketReason)),
      resetPassword: (email, otp) => NoAnimationPage(
        child: ResetPassword(email: email, otp: otp),
        key: ValueKey(Keys.resetPassword),
      ),
      forgotPassword: () => NoAnimationPage(child: ForgotPassword(), key: ValueKey(Keys.forgotPassword)),
      otpVerification: (email) => NoAnimationPage(
        child: OtpVerification(email: email),
        key: ValueKey(Keys.otpVerification),
      ),
      devices: () => NoAnimationPage(child: Device(), key: ValueKey(Keys.device)),
      deviceDetails: (deviceId) => NoAnimationPage(
        child: DeviceDetails(deviceId: deviceId),
        key: ValueKey(Keys.deviceDetails),
      ),
      addEditDevice: (deviceId) => NoAnimationPage(
        child: AddEditDevice(deviceUuid: deviceId),
        key: ValueKey(Keys.addDevice),
      ),
      addCountry: () => NoAnimationPage(child: AddEditCountry(), key: ValueKey(Keys.addCountry)),
      editCountry: () => NoAnimationPage(child: AddEditCountry(isEdit: true), key: ValueKey(Keys.editCountry)),
      addState: () => NoAnimationPage(child: AddEditState(), key: ValueKey(Keys.addState)),
      editState: (uuid) => NoAnimationPage(
        child: AddEditState(isEdit: true, uuid: uuid),
        key: ValueKey(Keys.editState),
      ),
      addCity: () => NoAnimationPage(child: AddEditCity(), key: ValueKey(Keys.addCity)),
      editCity: (uuid) => NoAnimationPage(
        child: AddEditCity(isEdit: true, uuid: uuid),
        key: ValueKey(Keys.editCity),
      ),
      addTicketReason: () => NoAnimationPage(child: AddEditTicketReason(), key: ValueKey(Keys.addTicketReason)),
      editTicketReason: (uuid) => NoAnimationPage(
        child: AddEditTicketReason(isEdit: true, uuid: uuid),
        key: ValueKey(Keys.editTicketReason),
      ),
      addEditStore: (storeUuid) => NoAnimationPage(
        child: AddEditStore(storeUuid: storeUuid),
        key: ValueKey(Keys.addEditStore),
      ),
      storeDetail: (storeUuid) => NoAnimationPage(
        child: StoreDetail(storeUuid: storeUuid),
        key: ValueKey(Keys.storeDetail),
      ),
      settings: () => NoAnimationPage(child: Settings(), key: ValueKey(Keys.settings)),
      client: () => NoAnimationPage(child: ClientList(), key: ValueKey(Keys.client)),
      addClient: (hasError, popCallBack, clientUUid) => (hasError ?? false)
          ? const MaterialPage(child: Offstage())
          : NoAnimationPage(
              child: AddUpdateClient(popCallBack: popCallBack, clientUUid: clientUUid),
              key: ValueKey(Keys.addClient),
            ),
      clientDetails: (hasError, clientUuid) => (hasError ?? false)
          ? const MaterialPage(child: Offstage())
          : NoAnimationPage(
              child: ClientDetails(clientUuid: clientUuid),
              key: ValueKey(Keys.clientDetails),
            ),
      generalSupport: (hasError) => NoAnimationPage(child: GeneralSupport(), key: ValueKey(Keys.addCategory)),
      addCategory: () => NoAnimationPage(child: AddEditCategory(), key: ValueKey(Keys.addCategory)),
      editCategory: (uuid) => NoAnimationPage(
        child: AddEditCategory(isEdit: true, uuid: uuid),
        key: ValueKey(Keys.editCategory),
      ),
      addEditDestinationType: (uuid) => NoAnimationPage(
        child: AddEditDestinationType(uuid: uuid),
        key: ValueKey(Keys.addDestinationType),
      ),
      company: () => NoAnimationPage(child: CompanyDetails(), key: ValueKey(Keys.company)),
      editCompany: () => NoAnimationPage(child: EditCompanyDetails(), key: ValueKey(Keys.editCompany)),
      addEditFaq: (faqUuid) => NoAnimationPage(
        child: AddEditFaq(faqUuid: faqUuid),
        key: ValueKey(Keys.addFaq),
      ),
      destinationUser: () => NoAnimationPage(child: DestinationUser(), key: ValueKey(Keys.destinationUsers)),
      ticketList: () => NoAnimationPage(child: TicketList(), key: ValueKey(Keys.ticketList)),
      createTicket: () => NoAnimationPage(child: CreateTicket(), key: ValueKey(Keys.createTicket)),
      destinationUserDetails: (userUuid) => NoAnimationPage(
        child: DestinationUserDetails(userUuid: userUuid),
        key: ValueKey(Keys.destinationUserDetails),
      ),
      addEditDestinationUser: (userUuid) => NoAnimationPage(
        child: AddEditDestinationUser(userUuid: userUuid),
        key: ValueKey(Keys.addDestinationUser),
      ),
      addEditRolePermission: (roleUuid) => NoAnimationPage(
        child: AddEditRole(roleUuid: roleUuid),
        key: ValueKey(Keys.addDestinationUser),
      ),
      purchaseTransactions: () => NoAnimationPage(child: PurchaseTransaction(), key: ValueKey(Keys.purchaseTransactions)),
      walletTransactions: () => NoAnimationPage(child: WalletTransactions(), key: ValueKey(Keys.walletTransactions)),
      notificationList: () => NoAnimationPage(child: NotificationList(), key: ValueKey(Keys.notification)),
      deploymentList: () => NoAnimationPage(child: DeploymentList(), key: ValueKey(Keys.deploymentList)),
      addDeployment: () => NoAnimationPage(child: AddDeployment(), key: ValueKey(Keys.addDeployment)),
      showCms: (title) => NoAnimationPage(child: ShowCms(title: title), key: ValueKey(Keys.showCms)),
      purchase: () => NoAnimationPage(child: Purchase(), key: ValueKey(Keys.purchase)),
      purchaseList: () => NoAnimationPage(child: PurchaseList(), key: ValueKey(Keys.purchaseList)),
      purchaseDetails: (purchaseUuid) => NoAnimationPage(child: PurchaseDetails(purchaseUuid: purchaseUuid), key: ValueKey(Keys.purchaseDetails)),
      uploadDocument: (clientUuid,documentUuid)=> NoAnimationPage(child: UploadDocument(clientUuid: clientUuid,documentUuid: documentUuid), key: ValueKey(Keys.uploadDocument)),
      addPurchase: (clientUuid) => NoAnimationPage(child: AddPurchase(clientUuid: clientUuid), key: ValueKey(Keys.addPurchase)),
      selectAds: (clientUuid) => NoAnimationPage(child: SelectAds(clientUuid: clientUuid), key: ValueKey(Keys.selectAds)),
      changeAds: (purchaseUuid,clientUuid) => NoAnimationPage(child: ChangeAds(purchaseUuid: purchaseUuid,clientUuid: clientUuid), key: ValueKey(Keys.changeAds)),
      settleClientWallet: (clientUuid) => NoAnimationPage(child: SettleWallet(clientUuid:clientUuid??''), key: ValueKey(Keys.settleWallet)),
      adsShowTime: () => NoAnimationPage(child: AdsShowTime(), key: ValueKey(Keys.adsShowTime)),
      adsSequencePreview: () => NoAnimationPage(child: AdsSequencePreview(), key: ValueKey(Keys.adsSequencePreview)),
      history: () => NoAnimationPage(child: HistoryListing(), key: ValueKey(Keys.history)),
    );
  }

  @override
  NavigationStack get currentConfiguration => stack;

  @override
  Future<void> setNewRoutePath(NavigationStack configuration) async {
    stack.items = configuration.items;
  }
}

extension _IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
