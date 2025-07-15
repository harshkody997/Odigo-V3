import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/controller/ads_module/ads_module_controller.dart';
import 'package:odigov3/framework/controller/cms/cms_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/controller/profile/profile_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/navigation_stack_keys.dart';
import 'package:odigov3/ui/routing/route_manager.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';


@injectable
class MainRouterInformationParser extends RouteInformationParser<NavigationStack> {
  WidgetRef ref;
  BuildContext context;

  MainRouterInformationParser(@factoryParam this.ref, @factoryParam this.context);

  @override
  Future<NavigationStack> parseRouteInformation(RouteInformation routeInformation) async {
    List<String> queryParam = [];
    List<String> tempUrlList = routeInformation.uri.toString().split('/');
    tempUrlList.removeAt(0);
    List<String> tempPathList = [];
    for (var element in tempUrlList) {
      tempPathList.add(element.split('?').first);
      if (element.split('?').length > 1) {
        queryParam.add(element.split('?').last);
      }
    }
    String mainUrl = '/${tempPathList.join('/')}${queryParam.isNotEmpty ? '?${queryParam.join('&')}' : ''}';
    AppConstants.constant.showLog('........URL......$mainUrl');
    final Uri uri = Uri.parse(mainUrl);
    final queryParams = uri.queryParameters;

    AppConstants.constant.showLog('........queryParams....$queryParams');
    NavigationStackKeyMapper.mapper.keysList = uri.pathSegments;
    final items = <NavigationStackItem>[];
    AppConstants.constant.showLog('Path Segments-> ${uri.pathSegments}');

    ///Will remove all the empty path from segments
    RouteManager.route.removeEmptyPath(uri.pathSegments);

    ///To add error page at the end and return no widget if error is found
    bool hasError = false;

    ///To add error page at the end and return no widget if error is found
    bool isAuthenticated = true;

    ///Will check validation for routes
    var pathValidation = RouteManager.route.checkPathValidation();

    if (Session.userAccessToken.isNotEmpty) {
      await ref.read(profileController).getProfileDetail(context, ref, isNotify: false).then((value) async {
        if(ref.read(profileController).profileDetailState.success?.status == ApiEndPoints.apiStatus_200){
          await ref.read(drawerController).getSideMenuListAPI(context, isNotify: false);
        }
      });
    }

    for (var i = 0; i < uri.pathSegments.length; i = i + 1) {
      ///To add error page at the end and return no widget if error is found
      hasError = !pathValidation.isRouteValid;
      isAuthenticated = pathValidation.isAuthenticated;
      final key = uri.pathSegments[i];

      getKeysHandler(items, key, queryParams,uri.pathSegments);
    }

    if (items.isEmpty) {
      const fallback = NavigationStackItem.splash();
      if (items.isNotEmpty && items.first is NavigationStackItemSplashPage) {
        items[0] = fallback;
      } else {
        items.insert(0, fallback);
      }
    }

    return NavigationStack(items);
  }

  Map<String, Function()> keysHandler(List<NavigationStackItem> items, Map<String, String> queryParams) => <String, Function()>{
    Keys.splash: () => items.add(const NavigationStackItem.splash()),
    Keys.error: () {
      showLog("Keys.error Keys.error}");
      items.add(const NavigationStackItem.error());
    },
    Keys.login: () {
      queryParams[QueryParam.id];
      items.add(const NavigationStackItem.login());
    },

    Keys.dashboard: () => items.add(const NavigationStackItem.dashboard()),
    Keys.country: () => items.add(const NavigationStackItem.country()),
    Keys.state: () => items.add(const NavigationStackItem.state()),
    Keys.city: () => items.add(const NavigationStackItem.city()),
    Keys.destinationType: () => items.add(const NavigationStackItem.destinationType()),
    Keys.category: () => items.add(const NavigationStackItem.category()),
    Keys.currency: () => items.add(const NavigationStackItem.currency()),
    Keys.destination: () => items.add(const NavigationStackItem.destination()),
    Keys.manageDestination: () {
      String? destinationUuid = queryParams[QueryParam.destinationUuid];
      items.add(NavigationStackItem.manageDestination(destinationUuid: destinationUuid));
    },
    Keys.destinationDetails: () {
      String? destinationUuid = queryParams[QueryParam.destinationUuid];
      items.add(NavigationStackItem.destinationDetails(destinationUuid: destinationUuid ?? ''));
    },
    Keys.destinationDetailsInfo: () {
      items.add(NavigationStackItem.destinationDetailsInfo());
    },
    Keys.assignRobot: () => items.add(const NavigationStackItem.assignRobot()),
    Keys.assignStore: () => items.add(const NavigationStackItem.assignStore()),
    Keys.store: () => items.add(const NavigationStackItem.store()),
    Keys.agency: () => items.add(const NavigationStackItem.agency()),
    Keys.vendor: () => items.add(const NavigationStackItem.vendor()),
    Keys.package: () => items.add(const NavigationStackItem.package()),
    Keys.rolesAndPermission: () => items.add(const NavigationStackItem.rolesAndPermission()),
    Keys.rolesAndPermissionDetails: () {
      String? rolePermissionUuid = queryParams[QueryParam.rolePermissionUuid];
      items.add(NavigationStackItem.rolesAndPermissionDetails(roleUuid: rolePermissionUuid ?? ''));
    },
    Keys.ticket: () => items.add(const NavigationStackItem.ticket()),
    Keys.defaultAds: () => items.add(const NavigationStackItem.defaultAds()),
    Keys.clientAds: () => items.add(const NavigationStackItem.clientAds()),
    Keys.createAdsDestination: () {
      String? destinationUuid = queryParams[QueryParam.destinationUuid];
      items.add(NavigationStackItem.createAdsDestination(destinationUUid: destinationUuid ?? ''));
    },
    Keys.createAdsClient: () {
      String? clientUuid = queryParams[QueryParam.clientUuid];
      items.add( NavigationStackItem.createAdsClient(clientUUid: clientUuid ?? '', isFromDetailsScreen: false));
    },
    Keys.adsDetails: () {
      String? adsDetailUuid = queryParams[QueryParam.adsDetailUuid];
      String? adsDetailType = queryParams[QueryParam.adsDetailType];
      items.add(NavigationStackItem.adsDetails(adsType: adsDetailType ?? '', uuid: adsDetailUuid ?? ''));
    },
    Keys.faq: () => items.add(const NavigationStackItem.faqs()),
    Keys.cms: () => items.add(const NavigationStackItem.cms()),
    Keys.users: () => items.add(const NavigationStackItem.user()),
    Keys.addNewUser: () {
      String? userUuid = queryParams[QueryParam.userUuid];
      items.add(NavigationStackItem.addUser(userUuid: userUuid));
    },
    Keys.editUser: () {
      String? userUuid = queryParams[QueryParam.userUuid];
      items.add(NavigationStackItem.addUser(userUuid: userUuid));
    },
    Keys.userDetails: () {
      String? userUuid = queryParams[QueryParam.userUuid];
      items.add(NavigationStackItem.userDetails(userUuid: userUuid));
    },
    Keys.profile: () => items.add(const NavigationStackItem.profile()),
    Keys.ticketReason: () => items.add(const NavigationStackItem.ticketReason()),
    Keys.forgotPassword: () => items.add(const NavigationStackItem.forgotPassword()),
    Keys.resetPassword: () {
      String? email = queryParams[QueryParam.email];
      String? otp = queryParams[QueryParam.otp];
      items.add(NavigationStackItem.resetPassword(email: email ?? '', otp: otp ?? ''));
    },
    Keys.otpVerification: () {
      String? email = queryParams[QueryParam.email];
      items.add(NavigationStackItem.otpVerification(email: email ?? ''));
    },
    Keys.device: () => items.add(const NavigationStackItem.devices()),
    Keys.addDevice: () => items.add(const NavigationStackItem.addEditDevice()),
    Keys.editDevice: () {
      String? deviceId = queryParams[QueryParam.deviceId];
      items.add(NavigationStackItem.addEditDevice(deviceId: deviceId));
    },
    Keys.deviceDetails: () {
      String? deviceId = queryParams[QueryParam.deviceId];
      items.add(NavigationStackItem.deviceDetails(deviceId: deviceId ?? ''));
    },
    Keys.addCountry: () => items.add(const NavigationStackItem.addCountry()),
    Keys.editCountry: () => items.add(const NavigationStackItem.editCountry()),
    Keys.addState: () => items.add(const NavigationStackItem.addState()),
    Keys.editState: () {
      String? stateUuid = queryParams[QueryParam.stateUuid];
      items.add(NavigationStackItem.editState(uuid: stateUuid ?? ''));
    },
    Keys.addCity: () => items.add(const NavigationStackItem.addCity()),
    Keys.editCity: () {
      String? cityUuid = queryParams[QueryParam.cityUuid];
      items.add(NavigationStackItem.editCity(uuid: cityUuid ?? ''));
    },
    Keys.addTicketReason: () => items.add(const NavigationStackItem.addTicketReason()),
    Keys.editTicketReason: () {
      String? ticketReasonUuid = queryParams[QueryParam.ticketReasonUuid];
      items.add(NavigationStackItem.editTicketReason(uuid: ticketReasonUuid ?? ''));
    },
    Keys.addStore: () => items.add(const NavigationStackItem.addEditStore()),
    Keys.editStore: () {
      String? storeUuid = queryParams[QueryParam.storeId];
      items.add(NavigationStackItem.addEditStore(storeUuid: storeUuid));
    },
    Keys.storeDetail: () {
      String? storeUuid = queryParams[QueryParam.storeId];
      items.add(NavigationStackItem.storeDetail(storeUuid: storeUuid ?? ''));
    },
    Keys.settings: () => items.add(const NavigationStackItem.settings()),
    Keys.client: () => items.add(const NavigationStackItem.client()),
    Keys.addClient: () {
      String? clientUuid = queryParams[QueryParam.clientUuid];
      items.add(NavigationStackItem.addClient(hasError: false, clientUUid: clientUuid));
    },
    Keys.editClient: () {
      String? clientUuid = queryParams[QueryParam.clientUuid];
      items.add(NavigationStackItem.addClient(hasError: false, clientUUid: clientUuid));
    },
    Keys.clientDetails: () {
      String? clientUuid = queryParams[QueryParam.clientUuid];
      items.add(NavigationStackItem.clientDetails(hasError: false, clientUuid: clientUuid));
    },
    Keys.addCategory: () => items.add(const NavigationStackItem.addCategory()),
    Keys.generalSupport: () => items.add(const NavigationStackItem.generalSupport()),
    Keys.editCategory: () {
      String? categoryUuid = queryParams[QueryParam.categoryUuid];
      items.add(NavigationStackItem.editCategory(uuid: categoryUuid ?? ''));
    },
    Keys.addDestinationType: () => items.add(const NavigationStackItem.addEditDestinationType()),
    Keys.editDestinationType: () {
      String? destinationTypeUuid = queryParams[QueryParam.destinationTypeUuid];
      items.add(NavigationStackItem.addEditDestinationType(uuid: destinationTypeUuid ?? ''));
    },
    Keys.addFaq: () => items.add(const NavigationStackItem.addEditFaq()),
    Keys.editFaq: () {
      String? faqUuid = queryParams[QueryParam.faqUuid];
      items.add(NavigationStackItem.addEditFaq(faqUuid: faqUuid));
    },
    Keys.company: () => items.add(const NavigationStackItem.company()),
    Keys.editCompany: () => items.add(const NavigationStackItem.editCompany()),

    Keys.destinationUsers: () => items.add(const NavigationStackItem.destinationUser()),
    Keys.destinationUserDetails: () {
      String? userUuid = queryParams[QueryParam.userUuid];
      items.add(NavigationStackItem.destinationUserDetails(userUuid: userUuid ?? ''));
    },
    Keys.addDestinationUser: () => items.add(const NavigationStackItem.addEditDestinationUser()),
    Keys.ticketList: () => items.add(const NavigationStackItem.ticketList()),
    Keys.createTicket: () => items.add(const NavigationStackItem.createTicket()),
    Keys.editDestinationUser: () {
      String? userUuid = queryParams[QueryParam.userUuid];
      items.add(NavigationStackItem.addEditDestinationUser(userUuid: userUuid));
    },
    Keys.addRolePermission: () => items.add(const NavigationStackItem.addEditRolePermission()),
    Keys.editRolePermission: () {
      String? roleUuid = queryParams[QueryParam.roleUuid];
      items.add(NavigationStackItem.addEditRolePermission(roleId: roleUuid));
    },
    Keys.purchaseTransactions: () => items.add(const NavigationStackItem.purchaseTransactions()),
    Keys.walletTransactions: () => items.add(const NavigationStackItem.walletTransactions()),
   // Keys.wallet: () => items.add(const NavigationStackItem.wallet()),
    Keys.notification: () => items.add(const NavigationStackItem.notificationList()),

    Keys.purchase: () => items.add(const NavigationStackItem.purchase()),
    Keys.purchaseList: () => items.add(const NavigationStackItem.purchaseList()),
    Keys.purchaseDetails: () {
      String? purchaseUuid = queryParams[QueryParam.purchaseUuid];
      items.add(NavigationStackItem.purchaseDetails(purchaseUuid: purchaseUuid));
    },
    Keys.changeAds: () {
      String? purchaseUuid = queryParams[QueryParam.purchaseUuid];
      items.add(NavigationStackItem.changeAds(purchaseUuid: purchaseUuid));
    },
    Keys.uploadDocument: () {
      String? clientUuid = queryParams[QueryParam.clientUuid];
      String? documentUuid = queryParams[QueryParam.documentUuid];
      items.add(NavigationStackItem.uploadDocument(clientUuid: clientUuid,documentUuid: documentUuid));
    },
    Keys.showCms:  () {
      String? cmsType = queryParams[QueryParam.cmsType];
      items.add(NavigationStackItem.showCms(title:cmsType??''));
    },
    Keys.deploymentList: () => items.add(const NavigationStackItem.deploymentList()),
    Keys.addDeployment: () => items.add(const NavigationStackItem.addDeployment()),

    Keys.addPurchase: () {
      String? clientUuid = queryParams[QueryParam.clientUuid];
      items.add(NavigationStackItem.addPurchase(clientUuid:clientUuid));
    },
    Keys.purchase: () => items.add(const NavigationStackItem.purchase()),
    Keys.purchaseList: () => items.add(const NavigationStackItem.purchaseList()),
    Keys.purchaseDetails: () {
      String? purchaseUuid = queryParams[QueryParam.purchaseUuid];
      items.add(NavigationStackItem.purchaseDetails(purchaseUuid: purchaseUuid));
    },
    Keys.selectAds: () {
      String? clientUuid = queryParams[QueryParam.clientUuid];
      items.add(NavigationStackItem.selectAds(clientUuid: clientUuid));
    },
    Keys.changeAds: () {
      String? purchaseUuid = queryParams[QueryParam.purchaseUuid];
      String? clientUuid = queryParams[QueryParam.clientUuid];
      items.add(NavigationStackItem.changeAds(purchaseUuid: purchaseUuid,clientUuid: clientUuid));
    },
    Keys.settleWallet: () {
      String? clientUuid = queryParams[QueryParam.clientUuid];
      items.add(NavigationStackItem.settleClientWallet(clientUuid: clientUuid));
    },
    Keys.adsShowTime: () {
      items.add(NavigationStackItem.adsShowTime());
    },
    Keys.adsSequencePreview: () => items.add(const NavigationStackItem.adsSequencePreview()),
    Keys.history: () => items.add(const NavigationStackItem.history()),
  };

  void getKeysHandler(List<NavigationStackItem> items, String key, Map<String, String> queryParams, List<String> pathSegments) {
    NavigationStackKeyMapper.mapper.currentKey = key;
    showLog("kokok NavigationStackKeyMapper.mapper.currentKey ${NavigationStackKeyMapper.mapper.currentKey} || KEY ${key}");
    final isExemptedPage = key == Keys.splash || key == Keys.login || key == Keys.otpVerification || key ==  Keys.forgotPassword;
    final handler = keysHandler(items, queryParams)[key];
    if (!isExemptedPage) {
      SidebarModel? value = ref.read(drawerController).selectedMainScreen;
      final keyLabel = getLabelForKey(key);
      print("sdadsfasdfdsaf ${keyLabel}");
      if(value == null) {
        value = findSidebarModuleByName(ref.read(drawerController).sideMenuListState.success?.data ?? [], keyLabel);
        print("sdadsfasdfdsaf value ${value?.modulesNameEnglish}");
      }
      // // Log current state
      showLog("isExemptedPage $key");
      // showLog("queryParams: $queryParams");
      // if (value == null) {
      //   value = ref.read(drawerController).sideMenuListState.success
      //       ?.data
      //       ?.firstWhereOrNull(
      //         (element) => element.modulesName?.toLowerCase() == key.replaceAllMapped(
      //       RegExp(r'(?<!^)([A-Z])'),
      //           (match) => ' ${match.group(0)}',
      //     ).toLowerCase(),
      //   );
      // }
      //
      // // If children are present, use the first child (converted to SidebarModel)
      // if ((value?.children?.isNotEmpty ?? false)) {
      //   showLog("Using child module:Using child module:Using child module: ${value?.children?.map((e) => e.modulesName).toList()}");
      //   final child = value?.children?.firstWhereOrNull((element) => element.modulesName?.toLowerCase() == key.replaceAllMapped(
      //     RegExp(r'(?<!^)([A-Z])'),
      //         (match) => ' ${match.group(0)}',
      //   ).toLowerCase(),);
      //
      //   showLog("Using child module: ${child?.modulesName}");
      //
      //   value = SidebarModel(
      //     canAdd: child?.canAdd,
      //     canDelete: child?.canDelete,
      //     canEdit: child?.canEdit,
      //     canView: child?.canView,
      //     canViewSidebar: child?.canViewSidebar,
      //     drawerMenuModel: value?.drawerMenuModel,
      //     modulesName: child?.modulesName,
      //     modulesNameEnglish: child?.modulesNameEnglish,
      //     modulesUuid: child?.modulesUuid,
      //   );
      // } else {
      //   showLog("Using parent module: ${value?.modulesName}");
      // }

      // Debug logs
      showLog("value.modulesName >>> ${value?.modulesName}");
      showLog(
        "Permissions => canAdd: ${value?.canAdd}, canEdit: ${value?.canEdit}, canView: ${value?.canView}, canViewSidebar: ${value?.canViewSidebar}",
      );

      final handler = keysHandler(items, queryParams)[key];
      final currentPage = NavigationStackKeyMapper.mapper.currentKey.decrypt.toLowerCase();
      const viewOnlyRoutes = ['details', 'changeads'];
      // bool isDetails = currentPage.contains('details') || currentPage.contains('changeads');
      final isDetails = viewOnlyRoutes.any((segment) => currentPage.contains(segment));
      final bool isQueryParamNotEmptyIsAndLastPath = (queryParams.isNotEmpty && key == pathSegments.last);

      // === Permission Checks ===

      if (value == null) {
        showLog("ERROR: value is null");
        items.add(const NavigationStackItem.error());
        // handler!();

      } else if (!(value.canViewSidebar ?? true) || !(value.canView ?? true)) {
        showLog("ERROR: No permission to view or view sidebar");
        items.add(const NavigationStackItem.error());
      }
      else if ((isQueryParamNotEmptyIsAndLastPath) && !(value.canEdit ?? true) && !isDetails) {
        showLog("ERROR: Trying to edit but edit permission is false");
        items.add(const NavigationStackItem.error());
      // } else if (!(value.canAdd ?? true) && !(value.canEdit ?? true)) {
      }
      else if ((isQueryParamNotEmptyIsAndLastPath) && !(value.canEdit ?? true) && !(value.canView ?? true)) {
        showLog("ERROR: No add or edit permission");
        items.add(const NavigationStackItem.error());
      }
      //       else if (!(value.canAdd ?? true) && queryParams.isEmpty) {
      //         showLog("ERROR: Add not allowed");
      //         items.add(const NavigationStackItem.error());
      //       }
      // === Route Handling ===
      else if (handler != null) {
        handler();
      } else {
        showLog("INFO: No specific handler found, falling back to splash");
        items.add(const NavigationStackItem.splash());
      }
    }
    else if(handler != null) {
        handler();
      showLog("kokokkokokkokokkokokkokok MOHIT");
      // items.add(const NavigationStackItem.splash());
    }else{
      showLog("kokokkokokkokokkokokkokok KhADILKAR");
      items.add(const NavigationStackItem.splash());

    }
  }

  ///THIS IS IMPORTANT: Here we restore the web history
  @override
  RouteInformation? restoreRouteInformation(NavigationStack configuration) {
    final location = configuration.items.fold<String>('', (previousValue, element) {
      return previousValue +
          element.when(
            splash: () => '/',
            error: () => '/${Keys.error}',
            login: () => '/${Keys.login}',
            dashboard: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.dashboard);
              return '/${Keys.dashboard}';
            },
            country: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.master);
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.country);
              return '/${Keys.country}';
            },
            state: () {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.state);
              return '/${Keys.state}';
            },
            city: () {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.city);
              return '/${Keys.city}';
            },
            destinationType: () {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.destinationType);
              return '/${Keys.destinationType}';
            },
            category: () {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.category);
              return '/${Keys.category}';
            },
            currency: () {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.currency);
              return '/${Keys.currency}';
            },
            destination: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.destination);
              return '/${Keys.destination}';
            },
            destinationDetails: (destinationUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.destination);
              return '/${Keys.destinationDetails}?${QueryParam.destinationUuid}=$destinationUuid';
            },
            destinationDetailsInfo: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.destination);
              return '/${Keys.destinationDetailsInfo}';
            },
            assignRobot: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.destination);
              return '/${Keys.assignRobot}';
            },
            assignStore: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.destination);
              return '/${Keys.assignStore}';
            },
            manageDestination: (destinationUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.destination);
              return '/${Keys.manageDestination}${destinationUuid != null ? '?${QueryParam.destinationUuid}=$destinationUuid' : ''}';
            },
            store: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.store);
              return '/${Keys.store}';
            },
            agency: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.agency);
              return '/${Keys.agency}';
            },
            vendor: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.vendor);
              return '/${Keys.vendor}';
            },
            package: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.package);
              return '/${Keys.package}';
            },
            rolesAndPermission: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.rolePermission);
              return '/${Keys.rolesAndPermission}';
            },
            rolesAndPermissionDetails: (uuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.rolePermission);
              return '/${Keys.rolesAndPermissionDetails}?${QueryParam.rolePermissionUuid}=$uuid';
            },
            ticket: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.ticket);
              return '/${Keys.ticket}';
            },
            defaultAds: () {
              ref.read(adsModuleController).updateSelectedTab(1);
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.defaultAds);
              return '/${Keys.defaultAds}';
            },
            clientAds: () {
              ref.read(adsModuleController).updateSelectedTab(0);
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.clientAds);
              return '/${Keys.clientAds}';
            },
            adsDetails: (adsType, uuid) {
              if (adsType == AdsType.Client.name) {
                ref.read(drawerController).updateSelectedSubScreen(ScreenName.clientAds);
              } else {
                ref.read(drawerController).updateSelectedSubScreen(ScreenName.defaultAds);
              }
              return '/${Keys.adsDetails}?${QueryParam.adsDetailType}=$adsType&${QueryParam.adsDetailUuid}=$uuid';
            },
            createAdsDestination: (destinationUuid) {
              ref.read(adsModuleController).updateSelectedTab(1);
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.defaultAds);
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.defaultAds);
              return '/${Keys.createAdsDestination}${destinationUuid != null ? '?${QueryParam.destinationUuid}=$destinationUuid' : ''}';
            },
            createAdsClient: (clientUuid, isFromDetailsScreen) {
              ref.read(adsModuleController).updateSelectedTab(0);
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.clientAds);
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.clientAds);
              return '/${Keys.createAdsClient}${clientUuid != null ? '?${QueryParam.clientUuid}=$clientUuid' : ''}';
            },
            faqs: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.faq);
              return '/${Keys.faq}';
            },
            cms: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.cms);
              return '/${Keys.cms}';
            },
            user: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.user);
              return '/${Keys.users}';
            },
            addUser: (userUuid) {
              return '/${(userUuid != null) ? "${Keys.editUser}?${QueryParam.userUuid}=$userUuid" : Keys.addNewUser}';
            },
            userDetails: (userUuid) {
              return '/${Keys.userDetails}${userUuid != null ? '?${QueryParam.userUuid}=$userUuid' : ''}';
            },
            profile: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.dashboard);
              // ref.read(drawerController).updateSelectedMainScreen(ScreenName.profile);
              return '/${Keys.profile}';
            },

            forgotPassword: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.forgotPassword);
              return '/${Keys.forgotPassword}';
            },
            resetPassword: (email, otp) {
              // ref.read(drawerController).updateSelectedMainScreen(ScreenName.resetPassword);
              return '';
            },

            otpVerification: (email) {
              // ref.read(drawerController).updateSelectedMainScreen(ScreenName.otpVerification);
              //return email==''? '' : '/${Keys.otpVerification}';
              return '';
            },

            ticketReason: () {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.TicketReason);
              return '/${Keys.ticketReason}';
            },
            addCountry: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.master);
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.country);
              return '/${Keys.addCountry}';
            },
            editCountry: () {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.country);
              return '/${Keys.editCountry}';
            },
            addState: () {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.state);
              return '/${Keys.addState}';
            },
            editState: (uuid) {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.state);
              return '/${Keys.editState}?${QueryParam.stateUuid}=$uuid';
            },
            devices: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.device);
              return '/${Keys.device}';
            },
            deviceDetails: (deviceId) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.device);
              return '/${Keys.deviceDetails}?${QueryParam.deviceId}=$deviceId';
            },
            addEditDevice: (deviceId) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.device);
              return deviceId != null ? '/${Keys.editDevice}?${QueryParam.deviceId}=$deviceId' : '/${Keys.addDevice}';
            },
            addCity: () {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.city);
              return '/${Keys.addCity}';
            },
            editCity: (uuid) {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.city);
              return '/${Keys.editCity}?${QueryParam.cityUuid}=$uuid';
            },
            addTicketReason: () {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.TicketReason);
              return '/${Keys.addTicketReason}';
            },
            editTicketReason: (uuid) {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.TicketReason);
              return '/${Keys.editTicketReason}?${QueryParam.ticketReasonUuid}=$uuid';
            },
            addCategory: () {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.category);
              return '/${Keys.addCategory}';
            },

            client: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.client);
              return '/${Keys.client}';
            },
            addClient: (hasError, popCallBack, clientUUid) {
              return '/${(clientUUid != null) ? "${Keys.editClient}?${QueryParam.clientUuid}=$clientUUid" : Keys.addClient}';
            },
            clientDetails: (hasError, clientUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.client);
              return '/${Keys.clientDetails}${clientUuid != null ? '?${QueryParam.clientUuid}=$clientUuid' : ''}';
            },
            addEditStore: (storeUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.store);
              return '/${storeUuid != null ? '${Keys.editStore}?${QueryParam.storeId}=$storeUuid' : Keys.addStore}';
            },
            storeDetail: (storeUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.store);
              return '/${Keys.storeDetail}?${QueryParam.storeId}=$storeUuid';
            },
            settings: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.dashboard);
              return '/${Keys.settings}';
            },
            generalSupport: (hasError) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.generalSupport);
              return '/${Keys.generalSupport}';
            },

            editCategory: (uuid) {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.category);
              return '/${Keys.editCategory}?${QueryParam.categoryUuid}=$uuid';
            },

            addEditDestinationType: (uuid) {
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.destinationType);
              return uuid != null ? '/${Keys.editDestinationType}?${QueryParam.destinationTypeUuid}=${uuid}' : '/${Keys.addDestinationType}';
            },
            company: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.company);
              return '/${Keys.company}';
            },
            editCompany: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.company);
              return '/${Keys.editCompany}';
            },

            addEditFaq: (faqUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.faq);
              return '/${faqUuid != null ? '${Keys.editFaq}?${QueryParam.faqUuid}=$faqUuid' : Keys.addFaq}';
            },
            destinationUser: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.destinationUsers);
              return '/${Keys.destinationUsers}';
            },
            destinationUserDetails: (userUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.destinationUsers);
              return '/${Keys.destinationUserDetails}?${QueryParam.userUuid}=$userUuid';
            },
            addEditDestinationUser: (userUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.destinationUsers);
              return userUuid != null ? '/${Keys.editDestinationUser}?${QueryParam.userUuid}=$userUuid' : '/${Keys.addDestinationUser}';
            },
            ticketList: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.ticket);
              return '/${Keys.ticketList}';
            },
            createTicket: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.ticket);
              return '/${Keys.createTicket}';
            },
            addEditRolePermission: (roleUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.rolePermission);
              return roleUuid != null ? '/${Keys.editRolePermission}?${QueryParam.roleUuid}=$roleUuid' : '/${Keys.addRolePermission}';
            },
            purchaseTransactions: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.purchaseTransactions);
              return '/${Keys.purchaseTransactions}';
            },
            walletTransactions: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.walletTransactions);
              return '/${Keys.walletTransactions}';
            },
            purchase: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.purchase);
              return '/${Keys.purchase}';
            },
            purchaseList: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.purchaseList);
              return '/${Keys.purchaseList}';
            },
            purchaseDetails: (purchaseUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.purchaseList);
              return '/${Keys.purchaseDetails}?${QueryParam.purchaseUuid}=$purchaseUuid';
            },
            selectAds: (purchaseUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.client);
              return '/${Keys.selectAds}?${QueryParam.purchaseUuid}=$purchaseUuid';
            },
            uploadDocument: (clientUuid,documentUuid) {
              return '/${Keys.uploadDocument}${clientUuid != null ? '?${QueryParam.clientUuid}=$clientUuid' : ''}${documentUuid != null ? '?${QueryParam.documentUuid}=$documentUuid' : ''}';
            },
            // wallet: () {
            //   ref.read(drawerController).updateSelectedMainScreen(ScreenName.wallet);
            //   return '/${Keys.wallet}';
            // },
            notificationList: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.dashboard);
              //ref.read(drawerController).updateSelectedMainScreen(ScreenName.notificationList);
              return '/${Keys.notification}';
            },
            deploymentList: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.dashboard);
              return '/${Keys.deploymentList}';
            },
            addDeployment: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.dashboard);
              return '/${Keys.addDeployment}';
            },
            showCms: (title) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(cmsController).setCmsPage(title);
              });
              return '/${Keys.showCms}?${QueryParam.cmsType}=$title';
            },
            addPurchase: (clientUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.client);
              return '/${Keys.addPurchase}?${QueryParam.clientUuid}=$clientUuid';
            },
            changeAds: (purchaseUuid,clientUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.purchaseList);
              return '/${Keys.changeAds}?${QueryParam.purchaseUuid}=$purchaseUuid&${QueryParam.clientUuid}=$clientUuid';
            },
            settleClientWallet: (clientUuid) {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.client);
              return '/${Keys.settleWallet}';
            },
            adsShowTime: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.adsShowTime);
              return '/${Keys.adsShowTime}';
            },

            adsSequencePreview: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.adsSequence);
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.adsSequencePreview);
              return '/${Keys.adsSequencePreview}';
            },
            history: () {
              ref.read(drawerController).updateSelectedMainScreen(ScreenName.adsSequence);
              ref.read(drawerController).updateSelectedSubScreen(ScreenName.history);
              return '/${Keys.history}';
            },
          );
    });

    List<String> queryParam = [];
    List<String> tempUrlList = location.toString().split('/');
    tempUrlList.removeAt(0);
    List<String> tempPathList = [];
    for (var element in tempUrlList) {
      tempPathList.add(element.split('?').first);
      if (element.split('?').length > 1) {
        queryParam.add(element.split('?').last);
      }
    }
    NavigationStackKeyMapper.mapper.keysList = tempPathList;
    NavigationStackKeyMapper.mapper.currentKey = tempPathList.last;
    tempPathList = tempPathList.toSet().toList();
    queryParam = queryParam.toSet().toList();
    String mainUrl = '/${tempPathList.join('/')}${queryParam.isNotEmpty ? '?${queryParam.join('&')}' : ''}';
    Uri routeUrl = Uri.parse(mainUrl);
    showLog("NavigationStackKeyMapper.mapper.keysList ${NavigationStackKeyMapper.mapper.keysList}");
    showLog("NavigationStackKeyMapper.mapper.currentKey ${NavigationStackKeyMapper.mapper.currentKey}");
    showLog("routeUrlrouteUrl >> ${routeUrl}");
    showLog("tempPathList >> ${tempPathList}");
    showLog("queryParam >> ${queryParam}");
    NavigationStackKeyMapper.mapper.currentKey = tempPathList.toString().replaceAll('[', '').replaceAll(']', '').split(',').last.trim();
    // updateSelectedMainScreenParser
    final key = NavigationStackKeyMapper.mapper.currentKey;
    showLog("keykeykeykeykeykey >>> ${key}");
    SidebarModel? value = ref.read(drawerController).selectedMainScreen;
    final keyLabel = getLabelForKey(key);

    if(value == null) {
      value = findSidebarModuleByName(ref.read(drawerController).sideMenuListState.success?.data??[], keyLabel);
    }

    // showLog('SidebarModelSidebarModel ${value?.modulesName}');
    // // Log current state
    // showLog("isExemptedPage ${key.replaceAllMapped(RegExp(r'(?<!^)([A-Z])'), (match) => ' ${match.group(0)}',)}");
    // showLog("queryParams: $queryParam");
    // // Fallback: find value by key if null
    // if (value == null) {
    //   value = ref.read(drawerController).sideMenuListState.success
    //       ?.data
    //       ?.firstWhereOrNull(
    //         (element) => element.modulesName?.toLowerCase() == key.replaceAllMapped(
    //           RegExp(r'(?<!^)([A-Z])'),
    //               (match) => ' ${match.group(0)}',
    //         ).toLowerCase(),
    //       );
    // }
    //
    // // If children are present, use the first child (converted to SidebarModel)
    // if ((value?.children?.isNotEmpty ?? false)) {
    //   showLog("Using child module:Using child module:Using child module: ${value?.children?.map((e) => e.modulesName).toList()}");
    //   final child = value?.children?.firstWhereOrNull((element) => element.modulesName?.toLowerCase() == key.replaceAllMapped(
    //     RegExp(r'(?<!^)([A-Z])'),
    //         (match) => ' ${match.group(0)}',
    //   ).toLowerCase(),);
    //
    //   showLog("Using child module: ${child?.modulesName}");
    //
    //   // Convert child to SidebarModel if needed
    //   value = SidebarModel(
    //     canAdd: child?.canAdd,
    //     canDelete: child?.canDelete,
    //     canEdit: child?.canEdit,
    //     canView: child?.canView,
    //     canViewSidebar: child?.canViewSidebar,
    //     drawerMenuModel: value?.drawerMenuModel,
    //     modulesName: child?.modulesName,
    //     modulesNameEnglish: child?.modulesNameEnglish,
    //     modulesUuid: child?.modulesUuid,
    //   );
    // } else {
    //   showLog("Using parent module: ${value?.modulesName}");
    // }

    showLog("valuevaluevalue>>> ${value?.modulesName}");
    showLog("value?.modulesNamevalue?.modulesName jakas${value?.canAdd} || ${value?.canEdit} $key");
    final isExemptedPage = (key == Keys.splash || key == Keys.login || key == Keys.otpVerification || key == Keys.forgotPassword);

    if (!isExemptedPage) {
      if (value == null) {
        showLog("MOHIT: value is null for $key");
        // return RouteInformation(uri: Uri.parse("/${ValueKey(Keys.error).value}"));
        return RouteInformation(uri: routeUrl); /// pass routeUrl instead of error to fix : when page refresh showing \error in url for some seconds
      }

      if (!(value.canView ?? true)) {
        showLog("MOHIT: No view permission for $key");
        return RouteInformation(uri: Uri.parse("/${ValueKey(Keys.error).value}"));
      }

      if (queryParam.isNotEmpty && !(value.canEdit ?? true) && !(value.canView ?? true)) {
        showLog("MOHIT: Editing not allowed for $key");
        return RouteInformation(uri: Uri.parse("/${ValueKey(Keys.error).value}"));
      }

      //       if (!(value.canAdd ?? true) && !(value.canEdit ?? true)) {
      //         showLog("MOHIT: No add/edit permission for $key");
      //         return RouteInformation(uri: Uri.parse("/${ValueKey(Keys.error).value}"));
      //       }

      // 4. Add attempt without permission (non-edit page)
      //       if (!(value.canAdd ?? true) && queryParam.isEmpty) {
      //         showLog("MOHIT: Add not allowed for $key");
      //         return RouteInformation(uri: Uri.parse("/${ValueKey(Keys.error).value}"));
      //       }

      return RouteInformation(uri: routeUrl);
    } else {
      return RouteInformation(uri: routeUrl);
    }
  }
}
