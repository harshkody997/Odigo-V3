
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/dashboard/contract/dashboard_repository.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/repository/drawer/model/drawer_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';

final drawerController = ChangeNotifierProvider((ref) => getIt<DrawerController>());

@injectable
class DrawerController extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  SidebarModel? selectedMainScreen;
  SubSidebarData? selectedSubScreen;

  updateSelectedMainScreen(ScreenName? screenName, {bool isNotify = false}) async {
    selectedMainScreen = sidebarMenuList.where((sidebarModel) => sidebarModel.drawerMenuModel?.screenName == screenName).firstOrNull;
    AppConstants.constant.showLog('updateSelectedMainScreen selectedMainScreen ${selectedMainScreen?.modulesNameEnglish}');
    selectedSubScreen = null;
    // drawerList = drawerList.map((e) => e..isExpanded = false).toList();
    if (isNotify) notifyListeners();
  }

  updateSelectedSubScreen(ScreenName? screenName, {bool isNotify = false}) {
    print("asdfadsfadsfdfdfdsf ${screenName}");
    selectedSubScreen = sidebarMenuList.expand((mainScreen) => mainScreen.children ?? []).firstWhere((subScreen) => subScreen.drawerMenuModel?.screenName == screenName, orElse: () => null);
    selectedMainScreen = sidebarMenuList.where((mainScreen) {
      final match = mainScreen.children?.any((subScreen) => subScreen.drawerMenuModel?.screenName == screenName) ?? false;
      if (match) mainScreen.drawerMenuModel?.isExpanded = true;
      return match;
    }).firstOrNull;
    AppConstants.constant.showLog('updateSelectedSubScreen selectedMainScreen ${selectedMainScreen?.modulesNameEnglish}');
    AppConstants.constant.showLog('updateSelectedSubScreen selectedSubScreen ${selectedSubScreen?.modulesNameEnglish}');
    if (isNotify) notifyListeners();
  }

  /// for menu screen
  bool get isMainScreenCanViewSidebar => (selectedMainScreen?.canViewSidebar??false);
  bool get isMainScreenCanView => (selectedMainScreen?.canView??false);
  bool get isMainScreenCanEdit => (selectedMainScreen?.canEdit??false);
  bool get isMainScreenCanDelete => (selectedMainScreen?.canDelete??false);
  bool get isMainScreenCanAdd => (selectedMainScreen?.canAdd??false);
  bool get isMainScreenCanViewSidebarAndCanView => ((selectedMainScreen?.canViewSidebar??false) && (selectedMainScreen?.canView??false));


  /// for sub menu screen
  bool get isSubScreenCanViewSidebar => (selectedSubScreen?.canViewSidebar??false);
  bool get isSubScreenCanView => (selectedSubScreen?.canView??false);
  bool get isSubScreenCanEdit => (selectedSubScreen?.canEdit??false);
  bool get isSubScreenCanDelete => (selectedSubScreen?.canDelete??false);
  bool get isSubScreenCanAdd => (selectedSubScreen?.canAdd??false);
  bool get isSubScreenCanViewSidebarAndCanView => ((selectedSubScreen?.canViewSidebar??false) && (selectedSubScreen?.canView??false));

  // List<DrawerModel> drawerList = [
  //   DrawerModel(menuName: LocaleKeys.keyDashboard, strIcon: Assets.anim.animDashboard.path, screenName: ScreenName.dashboard, item: NavigationStackItem.dashboard()),
  //   DrawerModel(
  //     menuName: LocaleKeys.keyMaster,
  //     strIcon: Assets.anim.animMaster.path,
  //     screenName: ScreenName.master,
  //
  //     dropDownList: [
  //       DashboardSubScreen(screenName: ScreenName.country, item: NavigationStackItem.country(), title: LocaleKeys.keyCountry),
  //       DashboardSubScreen(screenName: ScreenName.state, item: NavigationStackItem.state(), title: LocaleKeys.keyState),
  //       DashboardSubScreen(screenName: ScreenName.city, item: NavigationStackItem.city(), title: LocaleKeys.keyCity),
  //       DashboardSubScreen(screenName: ScreenName.destinationType, item: NavigationStackItem.destinationType(), title: LocaleKeys.keyDestinationType),
  //       DashboardSubScreen(screenName: ScreenName.category, item: NavigationStackItem.category(), title: LocaleKeys.keyCategory),
  //       DashboardSubScreen(screenName: ScreenName.currency, item: NavigationStackItem.currency(), title: LocaleKeys.keyCurrency),
  //       DashboardSubScreen(screenName: ScreenName.ticketReason, item: NavigationStackItem.ticketReason(), title: LocaleKeys.keyTicketReason),
  //     ],
  //   ),
  //
  //   DrawerModel(menuName: LocaleKeys.keyDestination, strIcon: Assets.anim.animDestination.path, screenName: ScreenName.destination, item: NavigationStackItem.destination()),
  //   DrawerModel(menuName: LocaleKeys.keyStores, strIcon: Assets.anim.animStore.path, screenName: ScreenName.store, item: NavigationStackItem.store()),
  //   DrawerModel(menuName: LocaleKeys.keyDevices, strIcon: Assets.anim.animDevice.path, screenName: ScreenName.device, item: NavigationStackItem.devices()),
  //   DrawerModel(menuName: LocaleKeys.keyVendor, strIcon: Assets.anim.animUserManagement.path, screenName: ScreenName.vendor, item: NavigationStackItem.vendor()),
  //   DrawerModel(menuName: LocaleKeys.keyPackage, strIcon: Assets.anim.animPurchase.path, screenName: ScreenName.package, item: NavigationStackItem.package()),
  //   DrawerModel(menuName: LocaleKeys.keyRolesPermission, strIcon: Assets.anim.animRolesAndPermissions.path, screenName: ScreenName.rolePermission, item: NavigationStackItem.rolesAndPermission()),
  //   DrawerModel(menuName: LocaleKeys.keyTicket, strIcon: Assets.anim.animTicket.path, screenName: ScreenName.ticket, item: NavigationStackItem.ticket()),
  //   DrawerModel(menuName: LocaleKeys.keyAds, strIcon: Assets.anim.animAds.path, screenName: ScreenName.ads, item: NavigationStackItem.ads()),
  //   DrawerModel(menuName: LocaleKeys.keyFaqs, strIcon: Assets.anim.animFaq.path, screenName: ScreenName.faq, item: NavigationStackItem.faqs()),
  //   DrawerModel(menuName: LocaleKeys.keyCMS, strIcon: Assets.anim.animCms.path, screenName: ScreenName.cms, item: NavigationStackItem.cms()),
  //   DrawerModel(menuName: LocaleKeys.keyUsers, strIcon: Assets.anim.animUserManagement.path, screenName: ScreenName.user, item: NavigationStackItem.user()),
  //   DrawerModel(menuName: LocaleKeys.keyClients, strIcon: Assets.anim.animClient.path, screenName: ScreenName.client, item: NavigationStackItem.client()),
  //   DrawerModel(menuName: LocaleKeys.keyProfile, strIcon: Assets.anim.animClient.path, screenName: ScreenName.profile, item: NavigationStackItem.profile()),
  //   DrawerModel(menuName: LocaleKeys.keyGeneralSupport, strIcon: Assets.anim.animContactUs.path, screenName: ScreenName.generalSupport, item: NavigationStackItem.generalSupport()),
  //
  // ];

  // updateIsExpanded(int index, {bool? isExpanded}) {
  //   bool expandValue = isExpanded ?? !drawerList[index].isExpanded;
  //   drawerList[index].isExpanded = expandValue;
  //   notifyListeners();
  // }

  manageScrollContentDrawer(List<GlobalKey> _tileKeys, ScrollController _scrollController) {
    final selectedIndex = sidebarMenuList.indexWhere((item) => item.drawerMenuModel?.screenName == selectedMainScreen?.drawerMenuModel?.screenName);
    double height = ZoomAware.zoomAware.fixedHeight * 0.055;
    if (selectedSubScreen != null) {
      height += (ZoomAware.zoomAware.fixedHeight * 0.02);
      height += ZoomAware.zoomAware.fixedHeight * 0.015 * (selectedMainScreen?.children?.length ?? 0);
    }
    if (selectedIndex != -1 && _tileKeys[selectedIndex].currentContext != null) {
      final selectedContext = _tileKeys[selectedIndex].currentContext!;
      final RenderBox? selectedBox = selectedContext.findRenderObject() as RenderBox?;
      final RenderBox? scrollBox = _scrollController.position.context.notificationContext?.findRenderObject() as RenderBox?;

      if (selectedBox != null && scrollBox != null) {
        final itemOffset = selectedBox.localToGlobal(Offset.zero, ancestor: scrollBox).dy;
        final itemHeight = selectedBox.size.height;
        final viewportHeight = _scrollController.position.viewportDimension;

        final itemBottom = itemOffset + itemHeight;
        final needsScrollDown = itemBottom > viewportHeight;

        if (itemOffset < 0 || needsScrollDown) {
          _scrollController.jumpTo(min(height * selectedIndex, _scrollController.position.maxScrollExtent));
        }
      }
    } else {
      _scrollController.jumpTo(min(height * selectedIndex, _scrollController.position.maxScrollExtent));
    }
  }


/*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  DashboardRepository dashboardRepository;
  DrawerController(this.dashboardRepository);

  List<SidebarModel> sidebarMenuList = [];

  /// side bar list api
  UIState<SidebarListResponseModel> sideMenuListState = UIState<SidebarListResponseModel>();
  Future getSideMenuListAPI(BuildContext context, {bool isNotify = true}) async {
    sideMenuListState.isLoading = true;
    sideMenuListState.success = null;
    sidebarMenuList.clear();
    if (isNotify) notifyListeners();

    final result = await dashboardRepository.sidebarApi();

    result.when(
      success: (data) async {
        sideMenuListState.isLoading = false;
        sideMenuListState.success = data;
        if (isNotify) notifyListeners();
        sidebarMenuList.clear();
        if(sideMenuListState.success?.status == ApiEndPoints.apiStatus_200){
          for (int i = 0; i < (sideMenuListState.success?.data?.length ?? 0); i++) {
            final item = sideMenuListState.success?.data?[i];
            if(item?.canView == true && item?.modulesNameEnglish != null){
              sidebarMenuList.add(SidebarModel(
                  canAdd: item?.canAdd,
                  modulesName: item?.modulesName,
                  modulesNameEnglish: item?.modulesNameEnglish,
                  modulesUuid: item?.modulesUuid,
                  canDelete: item?.canDelete,
                  canEdit: item?.canEdit,
                  canView: item?.canView,
                  canViewSidebar: item?.canViewSidebar,
                  children: setDrawerSubMenu(item?.children), /// set Fill sub menu model
                  drawerMenuModel: setDrawerMenuModel(item!))); /// set Fill drawer model
            }
          }
        }
      },
      failure: (NetworkExceptions error) {
        sideMenuListState.isLoading = false;
      },
    );
    sideMenuListState.isLoading = false;
    if (isNotify) notifyListeners();
    return sideMenuListState;
  }

  DrawerModel setDrawerMenuModel(SidebarModel sidebarModel){
    /// convert string to Enum
    DrawerMenuEnum? menuEnum = DrawerMenuEnumHelper.fromStringToEnum(sidebarModel.modulesNameEnglish ?? '');
    switch(menuEnum){
      case DrawerMenuEnum.DASHBOARD : {
        return DrawerModel(
            menuName: LocaleKeys.keyDashboard.localized,
            strIcon: Assets.anim.animDashboard.path,
            isExpanded: false,
            screenName: ScreenName.dashboard,
            item: const NavigationStackItem.dashboard(),
        );
      }
      case DrawerMenuEnum.MASTER:
        return DrawerModel(
            menuName: LocaleKeys.keyMaster.localized,
            strIcon: Assets.anim.animMaster.path,
            isExpanded: true,
            screenName: ScreenName.master,
            item: null,
        );
      case DrawerMenuEnum.DEVICE:
        return DrawerModel(
            menuName: LocaleKeys.keyDevices.localized,
            strIcon: Assets.anim.animDevice.path,
            isExpanded: false,
            screenName: ScreenName.device,
            item: const NavigationStackItem.devices(),
        );
      case DrawerMenuEnum.STORE:
        return DrawerModel(
          menuName: LocaleKeys.keyStores.localized,
          strIcon: Assets.anim.animStore.path,
          isExpanded: false,
          screenName: ScreenName.store,
          item: const NavigationStackItem.store(),
        );
      case DrawerMenuEnum.DESTINATION:
        return DrawerModel(
          menuName: LocaleKeys.keyDestination.localized,
          strIcon: Assets.anim.animDestination.path,
          isExpanded: false,
          screenName: ScreenName.destination,
          item: const NavigationStackItem.destination(),
        );
      case DrawerMenuEnum.DESTINATION_USER:
        return DrawerModel(
          menuName: LocaleKeys.keyDestination.localized,
          strIcon: Assets.anim.animUserManagement.path,
          isExpanded: false,
          screenName: ScreenName.destinationUsers,
          item: const NavigationStackItem.destinationUser(),
        );
      case DrawerMenuEnum.ADS:
        return DrawerModel(
          menuName: LocaleKeys.keyAds.localized,
          strIcon: Assets.anim.animAds.path,
          isExpanded: true,
          screenName: ScreenName.clientAds,
          item: null,
        );
      case DrawerMenuEnum.CLIENT:
        return DrawerModel(
          menuName: LocaleKeys.keyClients.localized,
          strIcon: Assets.anim.animClient.path,
          isExpanded: false,
          screenName: ScreenName.client,
          item: const NavigationStackItem.client(),
        );
      case DrawerMenuEnum.PURCHASE:
        return DrawerModel(
          menuName: LocaleKeys.keyPurchase.localized,
          strIcon: Assets.anim.animPurchase.path,
          isExpanded: false,
          screenName: ScreenName.purchaseList,
          item: const NavigationStackItem.purchaseList(),
        );
      case DrawerMenuEnum.WALLET:
        return DrawerModel(
          menuName: LocaleKeys.keyClients.localized,
          strIcon: Assets.anim.animClient.path,
          isExpanded: false,
          screenName: ScreenName.wallet,
          item: const NavigationStackItem.walletTransactions(),
        );
      case DrawerMenuEnum.ROLE_AND_PERMISSION:
        return DrawerModel(
          menuName: LocaleKeys.keyRolesPermission.localized,
          strIcon: Assets.anim.animRolesAndPermissions.path,
          isExpanded: false,
          screenName: ScreenName.rolePermission,
          item: const NavigationStackItem.rolesAndPermission(),
        );
      case DrawerMenuEnum.CMS:
        return DrawerModel(
          menuName: LocaleKeys.keyCMS.localized,
          strIcon: Assets.anim.animCms.path,
          isExpanded: false,
          screenName: ScreenName.cms,
          item: const NavigationStackItem.cms(),
        );
      case DrawerMenuEnum.FAQ:
        return DrawerModel(
          menuName: LocaleKeys.keyFaqs.localized,
          strIcon: Assets.anim.animFaq.path,
          isExpanded: false,
          screenName: ScreenName.faq,
          item: const NavigationStackItem.faqs(),
        );
      case DrawerMenuEnum.TICKET:
        return DrawerModel(
          menuName: LocaleKeys.keyTicket.localized,
          strIcon: Assets.anim.animTicket.path,
          isExpanded: false,
          screenName: ScreenName.ticket,
          item: const NavigationStackItem.ticketList(),
        );
      case DrawerMenuEnum.CONTACTUS:
        return DrawerModel(
          menuName: LocaleKeys.keyGeneralSupport.localized,
          strIcon: Assets.anim.animContactUs.path,
          isExpanded: false,
          screenName: ScreenName.generalSupport,
          item: const NavigationStackItem.generalSupport(),
        );
      case DrawerMenuEnum.COMPANY:
        return DrawerModel(
          menuName: LocaleKeys.keyCompany.localized,
          strIcon: Assets.anim.animCompany.path,
          isExpanded: false,
          screenName: ScreenName.company,
          item: const NavigationStackItem.company(),
        );
      case DrawerMenuEnum.USERS:
        return DrawerModel(
          menuName: LocaleKeys.keyUsers.localized,
          strIcon: Assets.anim.animUserManagement.path,
          isExpanded: false,
          screenName: ScreenName.user,
          item: const NavigationStackItem.user(),
        );
      case DrawerMenuEnum.PURCHASE_TRANSACTIONS:
        return DrawerModel(
          menuName: LocaleKeys.keyPurchase.localized,
          strIcon: Assets.anim.animPurchase.path,
          isExpanded: false,
          screenName: ScreenName.purchaseTransactions,
          item: const NavigationStackItem.purchaseTransactions(),
        );
      case DrawerMenuEnum.WALLET_TRANSACTIONS:
        return DrawerModel(
          menuName: LocaleKeys.keyWalletTransactions.localized,
          strIcon: Assets.anim.animWalllet.path,
          isExpanded: false,
          screenName: ScreenName.walletTransactions,
          item: const NavigationStackItem.walletTransactions(),
        );
      case DrawerMenuEnum.ADS_SEQUENCE:
        return DrawerModel(
          menuName: LocaleKeys.keyAdsSequence.localized,
          strIcon: Assets.anim.animAdsSequence.path,
          isExpanded: true,
          screenName: ScreenName.adsSequence,
          item: null,
        );
      case DrawerMenuEnum.ADS_SHOW_TIME:
        return DrawerModel(
          menuName: LocaleKeys.keyAdsShowTime.localized,
          strIcon: Assets.anim.animAdsShowTime.path,
          isExpanded: false,
          screenName: ScreenName.adsShowTime,
          item: const NavigationStackItem.adsShowTime(),
        );
      case null:
        return DrawerModel(
          menuName: '',
          strIcon: Assets.anim.animDashboard.path,
          isExpanded: false,
          screenName: ScreenName.dashboard,
          // item: const NavigationStackItem.dashboard(),
        );
    }
  }

  List<SubSidebarData> setDrawerSubMenu(List<SubSidebarData>? sidebarList){
    if (sidebarList?.isNotEmpty ?? false) {
      List<SubSidebarData> suvSideBarList = [];
      for (int i = 0; i < (sidebarList?.length ?? 0); i++) {
        final subItem = sidebarList?[i];
        if(subItem?.canView == true  && subItem?.modulesNameEnglish != null){
          suvSideBarList.add(SubSidebarData(
              modulesUuid: subItem?.modulesUuid,
              modulesName: subItem?.modulesName,
              modulesNameEnglish: subItem?.modulesNameEnglish,
              canView: subItem?.canView,
              canEdit: subItem?.canEdit,
              canAdd: subItem?.canAdd,
              canDelete: subItem?.canDelete,
              canViewSidebar: subItem?.canViewSidebar,
              drawerMenuModel:setSubMenuDrawerModel(subItem?.modulesNameEnglish??'') /// fill sub drawer menu model
          ));
        }
      }
      return suvSideBarList;
    }else{
      return [];
    }
  }

  /// Sub Menu SideBar
  DrawerModel setSubMenuDrawerModel(String name) {
    /// convert string to Enum
    DrawerSubMenuEnum? subMenuEnum = DrawerSubMenuEnumHelper.fromStringToEnum(name);
    switch (subMenuEnum) {
      case DrawerSubMenuEnum.COUNTRY:
        return DrawerModel(
          screenName: ScreenName.country,
          item: const NavigationStackItem.country(),
          menuName: LocaleKeys.keyCountry,
          strIcon: '',
        );

      case DrawerSubMenuEnum.STATE:
        return DrawerModel(
          screenName: ScreenName.state,
          item: const NavigationStackItem.state(),
          menuName: LocaleKeys.keyState,
          strIcon: '',
        );

      case DrawerSubMenuEnum.CITY:
        return DrawerModel(
          screenName: ScreenName.city,
          item: const NavigationStackItem.city(),
          menuName: LocaleKeys.keyCity,
          strIcon: '',
        );

      case DrawerSubMenuEnum.DESTINATION_TYPE:
        return DrawerModel(
          screenName: ScreenName.destinationType,
          item: const NavigationStackItem.destinationType(),
          menuName: LocaleKeys.keyDestinationType,
          strIcon: '',
        );

      case DrawerSubMenuEnum.CATEGORY:
        return DrawerModel(
          screenName: ScreenName.category,
          item: const NavigationStackItem.category(),
          menuName: LocaleKeys.keyCategory,
          strIcon: '',
        );

      case DrawerSubMenuEnum.TICKET_REASON:
        return DrawerModel(
          screenName: ScreenName.TicketReason,
          item: const NavigationStackItem.ticketReason(),
          menuName: LocaleKeys.keyTicketReason,
          strIcon: '',
        );

      case DrawerSubMenuEnum.CLIENT_ADS:
        return DrawerModel(
          screenName: ScreenName.clientAds,
          item: const NavigationStackItem.clientAds(),
          menuName: LocaleKeys.keyClientAds,
          strIcon: '',
        );

      case DrawerSubMenuEnum.DEFAULT_ADS:
        return DrawerModel(
          screenName: ScreenName.defaultAds,
          item: const NavigationStackItem.defaultAds(),
          menuName: LocaleKeys.keyDefaultAds,
          strIcon: '',
        );

      case DrawerSubMenuEnum.ADS_SEQUENCE_PREVIEW:
        return DrawerModel(
          screenName: ScreenName.adsSequencePreview,
          item: const NavigationStackItem.adsSequencePreview(),
          menuName: LocaleKeys.keyPreview,
          strIcon: '',
        );

      case DrawerSubMenuEnum.HISTORY:
        return DrawerModel(
          screenName: ScreenName.history,
          item: const NavigationStackItem.history(),
          menuName: LocaleKeys.keyHistory,
          strIcon: '',
        );

      case DrawerSubMenuEnum.PREVIEW:
        return DrawerModel(
          screenName: ScreenName.preview,
          item: const NavigationStackItem.history(),
          menuName: LocaleKeys.keyPreview,
          strIcon: '',
        );

      case null:
        return DrawerModel(
          menuName: LocaleKeys.keyTicketReason,
          item: const NavigationStackItem.dashboard(),
          screenName: ScreenName.dashboard,
          strIcon: '',
        );
    }
  }
}
