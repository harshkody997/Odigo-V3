// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i409;
import 'package:flutter_riverpod/flutter_riverpod.dart' as _i729;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:odigov3/framework/controller/ads_module/ads_module_controller.dart'
    as _i481;
import 'package:odigov3/framework/controller/ads_sequence_preview/ads_sequence_preview_controller.dart'
    as _i295;
import 'package:odigov3/framework/controller/ads_shown_time/ads_shown_time_controller.dart'
    as _i946;
import 'package:odigov3/framework/controller/ads_timline/history_listing_controller.dart'
    as _i160;
import 'package:odigov3/framework/controller/appbar/appbar_controller.dart'
    as _i607;
import 'package:odigov3/framework/controller/assign_new_robot/assign_new_robot_controller.dart'
    as _i949;
import 'package:odigov3/framework/controller/assign_new_store/assign_new_store_controller.dart'
    as _i530;
import 'package:odigov3/framework/controller/auth/forgot_password_controller.dart'
    as _i422;
import 'package:odigov3/framework/controller/auth/login_controller.dart'
    as _i640;
import 'package:odigov3/framework/controller/auth/otp_verification_controller.dart'
    as _i699;
import 'package:odigov3/framework/controller/auth/reset_password_controller.dart'
    as _i807;
import 'package:odigov3/framework/controller/client/add_update_client_controller.dart'
    as _i283;
import 'package:odigov3/framework/controller/client/client_details_controller.dart'
    as _i899;
import 'package:odigov3/framework/controller/client/client_list_controller.dart'
    as _i227;
import 'package:odigov3/framework/controller/client/settle_wallet_controller.dart'
    as _i438;
import 'package:odigov3/framework/controller/client_ads/client_ads_controller.dart'
    as _i1065;
import 'package:odigov3/framework/controller/cms/cms_controller.dart' as _i891;
import 'package:odigov3/framework/controller/company/company_controller.dart'
    as _i222;
import 'package:odigov3/framework/controller/create_ads/ads_details_controller.dart'
    as _i904;
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart'
    as _i486;
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart'
    as _i593;
import 'package:odigov3/framework/controller/deployment/deployment_controller.dart'
    as _i86;
import 'package:odigov3/framework/controller/destination/destination_controller.dart'
    as _i927;
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart'
    as _i89;
import 'package:odigov3/framework/controller/destination/manage_destination_controller.dart'
    as _i307;
import 'package:odigov3/framework/controller/destination/robot_mapping/robot_mapping_controller.dart'
    as _i648;
import 'package:odigov3/framework/controller/destination/store_mapping/store_mapping_controller.dart'
    as _i842;
import 'package:odigov3/framework/controller/destination_user_management/add_edit_destination_user_controller.dart'
    as _i885;
import 'package:odigov3/framework/controller/destination_user_management/destination_user_controller.dart'
    as _i819;
import 'package:odigov3/framework/controller/destination_user_management/destination_user_details_controller.dart'
    as _i817;
import 'package:odigov3/framework/controller/device/add_device_controller.dart'
    as _i495;
import 'package:odigov3/framework/controller/device/device_controller.dart'
    as _i555;
import 'package:odigov3/framework/controller/device/device_details_controller.dart'
    as _i680;
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart'
    as _i64;
import 'package:odigov3/framework/controller/faq/add_edit_faq_controller.dart'
    as _i410;
import 'package:odigov3/framework/controller/faq/faq_controller.dart' as _i466;
import 'package:odigov3/framework/controller/general_support/general_support_controller.dart'
    as _i964;
import 'package:odigov3/framework/controller/master/category/add_edit_category_controller.dart'
    as _i769;
import 'package:odigov3/framework/controller/master/category/category_list_controller.dart'
    as _i128;
import 'package:odigov3/framework/controller/master/city/add_edit_city_controller.dart'
    as _i295;
import 'package:odigov3/framework/controller/master/city/city_list_controller.dart'
    as _i286;
import 'package:odigov3/framework/controller/master/country/add_edit_country_controller.dart'
    as _i881;
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart'
    as _i192;
import 'package:odigov3/framework/controller/master/destination_type/add_edit_destination_type_controller.dart'
    as _i247;
import 'package:odigov3/framework/controller/master/destination_type/destination_type_list_controller.dart'
    as _i652;
import 'package:odigov3/framework/controller/master/state/add_edit_state_controller.dart'
    as _i357;
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart'
    as _i731;
import 'package:odigov3/framework/controller/master/ticket_reason/add_edit_ticket_reason_controller.dart'
    as _i306;
import 'package:odigov3/framework/controller/master/ticket_reason/ticket_reason_list_controller.dart'
    as _i199;
import 'package:odigov3/framework/controller/notification_list/notification_controller.dart'
    as _i347;
import 'package:odigov3/framework/controller/profile/profile_controller.dart'
    as _i534;
import 'package:odigov3/framework/controller/purchase/add_purchase_controller.dart'
    as _i68;
import 'package:odigov3/framework/controller/purchase/change_ads_controller.dart'
    as _i933;
import 'package:odigov3/framework/controller/purchase/create_purchase_controller.dart'
    as _i956;
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart'
    as _i589;
import 'package:odigov3/framework/controller/purchase/purchase_list_controller.dart'
    as _i867;
import 'package:odigov3/framework/controller/purchase/select_ads_controller.dart'
    as _i218;
import 'package:odigov3/framework/controller/purchase_transaction/purchase_transaction_controller.dart'
    as _i68;
import 'package:odigov3/framework/controller/roles_permission/add_edit_role_controller.dart'
    as _i389;
import 'package:odigov3/framework/controller/roles_permission/role_permission_details_controller.dart'
    as _i326;
import 'package:odigov3/framework/controller/roles_permission/roles_permission_controller.dart'
    as _i1002;
import 'package:odigov3/framework/controller/settings/settings_controller.dart'
    as _i411;
import 'package:odigov3/framework/controller/store/add_edit_store_controller.dart'
    as _i310;
import 'package:odigov3/framework/controller/store/store_controller.dart'
    as _i640;
import 'package:odigov3/framework/controller/store/store_detail_controller.dart'
    as _i23;
import 'package:odigov3/framework/controller/table_controller.dart' as _i1031;
import 'package:odigov3/framework/controller/ticket_management/ticket_management_controller.dart'
    as _i735;
import 'package:odigov3/framework/controller/users_management/add_new_user_controller.dart'
    as _i340;
import 'package:odigov3/framework/controller/users_management/user_details_controller.dart'
    as _i268;
import 'package:odigov3/framework/controller/users_management/user_management_controller.dart'
    as _i896;
import 'package:odigov3/framework/controller/wallet_transactions/wallet_transactions_controller.dart'
    as _i898;
import 'package:odigov3/framework/dependency_injection/modules/dio_api_client.dart'
    as _i378;
import 'package:odigov3/framework/dependency_injection/modules/dio_logger_module.dart'
    as _i144;
import 'package:odigov3/framework/provider/network/dio/dio_client.dart'
    as _i967;
import 'package:odigov3/framework/provider/network/dio/dio_logger.dart'
    as _i732;
import 'package:odigov3/framework/provider/network/network.dart' as _i642;
import 'package:odigov3/framework/repository/ads_sequence/contract/ads_sequence_repository.dart'
    as _i490;
import 'package:odigov3/framework/repository/ads_sequence/repository/ads_sequence_api_repository.dart'
    as _i910;
import 'package:odigov3/framework/repository/ads_shown_time/contract/ads_show_time_repository.dart'
    as _i438;
import 'package:odigov3/framework/repository/ads_shown_time/repository/ads_show_time_api_repository.dart'
    as _i802;
import 'package:odigov3/framework/repository/auth/contract/auth_repository.dart'
    as _i780;
import 'package:odigov3/framework/repository/auth/contract/login_repository.dart'
    as _i140;
import 'package:odigov3/framework/repository/auth/repository/auth_api_repository.dart'
    as _i377;
import 'package:odigov3/framework/repository/auth/repository/login_api_repository.dart'
    as _i862;
import 'package:odigov3/framework/repository/client/contract/client_repository.dart'
    as _i561;
import 'package:odigov3/framework/repository/client/repository/client_api_repository.dart'
    as _i501;
import 'package:odigov3/framework/repository/client_ads/contract/client_ads_repository.dart'
    as _i66;
import 'package:odigov3/framework/repository/client_ads/repository/client_ads_api_repository.dart'
    as _i651;
import 'package:odigov3/framework/repository/cms/contract/cms_repository.dart'
    as _i10;
import 'package:odigov3/framework/repository/cms/repository/cms_api_repository.dart'
    as _i503;
import 'package:odigov3/framework/repository/company/contract/company_repository.dart'
    as _i545;
import 'package:odigov3/framework/repository/company/repository/company_api_repository.dart'
    as _i726;
import 'package:odigov3/framework/repository/dashboard/contract/dashboard_repository.dart'
    as _i1002;
import 'package:odigov3/framework/repository/dashboard/repository/dashboard_api_respository.dart'
    as _i678;
import 'package:odigov3/framework/repository/default_ads/contract/default_ads_repository.dart'
    as _i647;
import 'package:odigov3/framework/repository/default_ads/repository/default_ads_api_repository.dart'
    as _i6;
import 'package:odigov3/framework/repository/deployment/contract/deployment_repository.dart'
    as _i235;
import 'package:odigov3/framework/repository/deployment/repository/deployment_api_repository.dart'
    as _i649;
import 'package:odigov3/framework/repository/destination/contract/destination_details_repository.dart'
    as _i517;
import 'package:odigov3/framework/repository/destination/repository/destination_details_api_repository.dart'
    as _i460;
import 'package:odigov3/framework/repository/destination_user_management/contract/destination_user_repository.dart'
    as _i389;
import 'package:odigov3/framework/repository/destination_user_management/repository/destination_user_api_repository.dart'
    as _i462;
import 'package:odigov3/framework/repository/device/contract/device_repositiry.dart'
    as _i443;
import 'package:odigov3/framework/repository/device/repository/device_api_repository.dart'
    as _i502;
import 'package:odigov3/framework/repository/faq/contract/faq_repository.dart'
    as _i880;
import 'package:odigov3/framework/repository/faq/repository/faq_api%20_repository.dart'
    as _i129;
import 'package:odigov3/framework/repository/general_support/contract/general_support_repository.dart'
    as _i54;
import 'package:odigov3/framework/repository/general_support/repository/general_support_api_repository.dart'
    as _i115;
import 'package:odigov3/framework/repository/import_export/contract/import_export_repository.dart'
    as _i635;
import 'package:odigov3/framework/repository/import_export/repository/import_export_api_repository.dart'
    as _i0;
import 'package:odigov3/framework/repository/master/category/contract/category_repository.dart'
    as _i428;
import 'package:odigov3/framework/repository/master/category/repository/category_api_repository.dart'
    as _i578;
import 'package:odigov3/framework/repository/master/city/contract/city_repository.dart'
    as _i1001;
import 'package:odigov3/framework/repository/master/city/repository/city_api_repository.dart'
    as _i663;
import 'package:odigov3/framework/repository/master/contract/master_repository.dart'
    as _i92;
import 'package:odigov3/framework/repository/master/country/contract/country_repository.dart'
    as _i869;
import 'package:odigov3/framework/repository/master/country/repository/country_api_repository.dart'
    as _i182;
import 'package:odigov3/framework/repository/master/destination_type/contract/destination_type_repository.dart'
    as _i438;
import 'package:odigov3/framework/repository/master/destination_type/repository/destination_type_api_repository.dart'
    as _i14;
import 'package:odigov3/framework/repository/master/repository/master_api_repository.dart'
    as _i88;
import 'package:odigov3/framework/repository/master/state/contract/state_repository.dart'
    as _i403;
import 'package:odigov3/framework/repository/master/state/repository/state_api_respository.dart'
    as _i887;
import 'package:odigov3/framework/repository/master/ticket_reason/contract/ticket_reason_repository.dart'
    as _i345;
import 'package:odigov3/framework/repository/master/ticket_reason/repository/ticket_reason_api_repository.dart'
    as _i414;
import 'package:odigov3/framework/repository/notification/contract/notification_repository.dart'
    as _i416;
import 'package:odigov3/framework/repository/notification/repository/notification_api_repository.dart'
    as _i959;
import 'package:odigov3/framework/repository/profile/contract/profile_repository.dart'
    as _i1043;
import 'package:odigov3/framework/repository/profile/repository/profile_api_repository.dart'
    as _i714;
import 'package:odigov3/framework/repository/purchase/contract/purchase_repository.dart'
    as _i223;
import 'package:odigov3/framework/repository/purchase/repository/purchase_api_repository.dart'
    as _i430;
import 'package:odigov3/framework/repository/purchase_transaction/contract/purchase_transaction_repository.dart'
    as _i207;
import 'package:odigov3/framework/repository/purchase_transaction/repository/purchase_transaction_api_repository.dart'
    as _i215;
import 'package:odigov3/framework/repository/role_permission/contract/role_permission_repository.dart'
    as _i114;
import 'package:odigov3/framework/repository/role_permission/repository/role_permission_api_repository.dart'
    as _i773;
import 'package:odigov3/framework/repository/settings/contract/settings_repository.dart'
    as _i591;
import 'package:odigov3/framework/repository/settings/repository/settings_api_repository.dart'
    as _i753;
import 'package:odigov3/framework/repository/store/contract/store_repository.dart'
    as _i754;
import 'package:odigov3/framework/repository/store/repository/store_api_repository.dart'
    as _i992;
import 'package:odigov3/framework/repository/ticket_management/contract/ticket_repository.dart'
    as _i388;
import 'package:odigov3/framework/repository/ticket_management/repository/ticket_api_repository.dart'
    as _i42;
import 'package:odigov3/framework/repository/user_management/contract/user_management_repository.dart'
    as _i73;
import 'package:odigov3/framework/repository/user_management/repository/user_management_api_repository.dart'
    as _i192;
import 'package:odigov3/framework/repository/wallet_transactions/contract/wallet_transaction_repository.dart'
    as _i414;
import 'package:odigov3/framework/repository/wallet_transactions/repository/wallet_transactions_api_repository.dart'
    as _i291;
import 'package:odigov3/ui/routing/delegate.dart' as _i55;
import 'package:odigov3/ui/routing/navigation_stack_item.dart' as _i456;
import 'package:odigov3/ui/routing/parser.dart' as _i808;
import 'package:odigov3/ui/routing/stack.dart' as _i825;
import 'package:odigov3/ui/utils/anim/custom_animation_controller.dart' as _i64;

const String _production = 'production';
const String _debug = 'debug';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioLoggerModule = _$DioLoggerModule();
    final networkModule = _$NetworkModule();
    gh.factory<_i64.CustomAnimationController>(
      () => _i64.CustomAnimationController(),
    );
    gh.factory<_i607.AppbarController>(() => _i607.AppbarController());
    gh.factory<_i268.UserDetailsController>(
      () => _i268.UserDetailsController(),
    );
    gh.factory<_i842.StoreMappingController>(
      () => _i842.StoreMappingController(),
    );
    gh.factory<_i648.RobotMappingController>(
      () => _i648.RobotMappingController(),
    );
    gh.factory<_i881.AddEditCountryController>(
      () => _i881.AddEditCountryController(),
    );
    gh.factory<_i1031.TableController>(() => _i1031.TableController());
    gh.factory<_i218.SelectAdsController>(() => _i218.SelectAdsController());
    gh.factory<_i933.ChangeAdsController>(() => _i933.ChangeAdsController());
    gh.factory<_i956.CreatePurchaseController>(
      () => _i956.CreatePurchaseController(),
    );
    gh.factory<_i438.SettleWalletController>(
      () => _i438.SettleWalletController(),
    );
    gh.factoryParam<
      _i825.NavigationStack,
      List<_i456.NavigationStackItem>,
      dynamic
    >((items, _) => _i825.NavigationStack(items));
    gh.lazySingleton<_i732.DioLogger>(
      () => dioLoggerModule.getDioLogger(),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i642.DioClient>(
      () => networkModule.getProductionDioClient(gh<_i732.DioLogger>()),
      registerFor: {_production},
    );
    gh.lazySingleton<_i438.DestinationTypeRepository>(
      () => _i14.DestinationTypeApiRepository(gh<_i967.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i443.DeviceRepository>(
      () => _i502.DeviceApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i10.CmsRepository>(
      () => _i503.CmsApiRepository(gh<_i967.DioClient>()),
      registerFor: {_debug, _production},
    );
    gh.lazySingleton<_i754.StoreRepository>(
      () => _i992.StoreApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i490.AdsSequenceRepository>(
      () => _i910.AdsSequenceApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i780.AuthRepository>(
      () => _i377.AuthApiRepository(gh<_i967.DioClient>()),
      registerFor: {_debug, _production},
    );
    gh.lazySingleton<_i591.SettingsRepository>(
      () => _i753.SettingsApiRepository(gh<_i967.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i403.StateRepository>(
      () => _i887.StateApiRepository(gh<_i967.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.factoryParam<_i55.MainRouterDelegate, _i825.NavigationStack, dynamic>(
      (stack, _) => _i55.MainRouterDelegate(stack),
    );
    gh.factory<_i295.AdsSequencePreviewController>(
      () =>
          _i295.AdsSequencePreviewController(gh<_i490.AdsSequenceRepository>()),
    );
    gh.factory<_i160.HistoryListingController>(
      () => _i160.HistoryListingController(gh<_i490.AdsSequenceRepository>()),
    );
    gh.factory<_i640.LoginController>(
      () => _i640.LoginController(gh<_i780.AuthRepository>()),
    );
    gh.factory<_i807.ResetPasswordController>(
      () => _i807.ResetPasswordController(gh<_i780.AuthRepository>()),
    );
    gh.factory<_i422.ForgotPasswordController>(
      () => _i422.ForgotPasswordController(gh<_i780.AuthRepository>()),
    );
    gh.factory<_i699.OtpVerificationController>(
      () => _i699.OtpVerificationController(gh<_i780.AuthRepository>()),
    );
    gh.factory<_i247.AddEditDestinationTypeController>(
      () => _i247.AddEditDestinationTypeController(
        gh<_i438.DestinationTypeRepository>(),
      ),
    );
    gh.factory<_i23.StoreDetailController>(
      () => _i23.StoreDetailController(gh<_i754.StoreRepository>()),
    );
    gh.factory<_i495.AddDeviceController>(
      () => _i495.AddDeviceController(gh<_i443.DeviceRepository>()),
    );
    gh.factory<_i680.DeviceDetailsController>(
      () => _i680.DeviceDetailsController(gh<_i443.DeviceRepository>()),
    );
    gh.factoryParam<
      _i808.MainRouterInformationParser,
      _i729.WidgetRef,
      _i409.BuildContext
    >((ref, context) => _i808.MainRouterInformationParser(ref, context));
    gh.lazySingleton<_i880.FaqRepository>(
      () => _i129.FaqApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i561.ClientRepository>(
      () => _i501.ClientApiRepository(gh<_i642.DioClient>()),
      registerFor: {_debug, _production},
    );
    gh.lazySingleton<_i869.CountryRepository>(
      () => _i182.CountryApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i428.CategoryRepository>(
      () => _i578.CategoryApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i438.AdsShowTimeRepository>(
      () => _i802.AdsShowTimeApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i1043.ProfileRepository>(
      () => _i714.ProfileApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i207.PurchaseTransactionRepository>(
      () => _i215.PurchaseTransactionsApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.factory<_i891.CmsController>(
      () => _i891.CmsController(
        gh<_i780.AuthRepository>(),
        gh<_i10.CmsRepository>(),
      ),
    );
    gh.lazySingleton<_i388.TicketRepository>(
      () => _i42.TicketApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i642.DioClient>(
      () => networkModule.getDebugDioClient(gh<_i732.DioLogger>()),
      registerFor: {_debug},
    );
    gh.lazySingleton<_i73.UserManagementRepository>(
      () => _i192.UserManagementApiRepository(gh<_i967.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i223.PurchaseRepository>(
      () => _i430.PurchaseApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i416.NotificationRepository>(
      () => _i959.NotificationApiRepository(gh<_i967.DioClient>()),
      registerFor: {_debug, _production},
    );
    gh.lazySingleton<_i414.WalletTransactionsRepository>(
      () => _i291.WalletTransactionsApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i647.DefaultAdsRepository>(
      () => _i6.DefaultAdsApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i114.RolePermissionRepository>(
      () => _i773.RolePermissionApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i389.DestinationUserRepository>(
      () => _i462.DestinationUserApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.factory<_i481.AdsModuleController>(
      () => _i481.AdsModuleController(gh<_i647.DefaultAdsRepository>()),
    );
    gh.lazySingleton<_i54.GeneralSupportRepository>(
      () => _i115.GeneralSupportApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.factory<_i899.ClientDetailsController>(
      () => _i899.ClientDetailsController(
        gh<_i561.ClientRepository>(),
        gh<_i414.WalletTransactionsRepository>(),
      ),
    );
    gh.factory<_i964.GeneralSupport>(
      () => _i964.GeneralSupport(gh<_i54.GeneralSupportRepository>()),
    );
    gh.lazySingleton<_i345.TicketReasonRepository>(
      () => _i414.TicketReasonApiRepository(gh<_i967.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i92.MasterRepository>(
      () => _i88.StorageApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i1001.CityRepository>(
      () => _i663.CityApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.factory<_i735.TicketManagementController>(
      () => _i735.TicketManagementController(gh<_i388.TicketRepository>()),
    );
    gh.factory<_i192.CountryListController>(
      () => _i192.CountryListController(
        gh<_i92.MasterRepository>(),
        gh<_i869.CountryRepository>(),
      ),
    );
    gh.lazySingleton<_i140.LoginRepository>(
      () => _i862.LoginApiRepository(gh<_i967.DioClient>()),
      registerFor: {_debug, _production},
    );
    gh.lazySingleton<_i545.CompanyRepository>(
      () => _i726.CompanyApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.lazySingleton<_i66.ClientAdsRepository>(
      () => _i651.ClientAdsApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.factory<_i357.AddEditStateController>(
      () => _i357.AddEditStateController(gh<_i403.StateRepository>()),
    );
    gh.lazySingleton<_i635.ImportExportRepository>(
      () => _i0.ImportExportApiRepository(gh<_i967.DioClient>()),
      registerFor: {_debug, _production},
    );
    gh.lazySingleton<_i1002.DashboardRepository>(
      () => _i678.DashboardApiRepository(gh<_i967.DioClient>()),
      registerFor: {_debug, _production},
    );
    gh.factory<_i411.SettingsController>(
      () => _i411.SettingsController(gh<_i591.SettingsRepository>()),
    );
    gh.lazySingleton<_i517.DestinationDetailsRepository>(
      () => _i460.DestinationDetailsApiRepository(gh<_i642.DioClient>()),
      registerFor: {_debug, _production},
    );
    gh.factory<_i295.AddEditCityController>(
      () => _i295.AddEditCityController(gh<_i1001.CityRepository>()),
    );
    gh.factory<_i286.CityListController>(
      () => _i286.CityListController(gh<_i1001.CityRepository>()),
    );
    gh.lazySingleton<_i235.DeploymentRepository>(
      () => _i649.DeploymentApiRepository(gh<_i642.DioClient>()),
      registerFor: {_production, _debug},
    );
    gh.factory<_i222.CompanyController>(
      () => _i222.CompanyController(gh<_i545.CompanyRepository>()),
    );
    gh.factory<_i534.ProfileController>(
      () => _i534.ProfileController(gh<_i1043.ProfileRepository>()),
    );
    gh.factory<_i1065.ClientAdsController>(
      () => _i1065.ClientAdsController(gh<_i66.ClientAdsRepository>()),
    );
    gh.factory<_i819.DestinationUserController>(
      () => _i819.DestinationUserController(
        gh<_i389.DestinationUserRepository>(),
      ),
    );
    gh.factory<_i885.AddEditDestinationUserController>(
      () => _i885.AddEditDestinationUserController(
        gh<_i389.DestinationUserRepository>(),
      ),
    );
    gh.factory<_i817.DestinationUserDetailsController>(
      () => _i817.DestinationUserDetailsController(
        gh<_i389.DestinationUserRepository>(),
      ),
    );
    gh.factory<_i306.AddEditTicketReasonController>(
      () => _i306.AddEditTicketReasonController(
        gh<_i345.TicketReasonRepository>(),
      ),
    );
    gh.factory<_i410.AddEditFaqController>(
      () => _i410.AddEditFaqController(gh<_i880.FaqRepository>()),
    );
    gh.factory<_i466.FaqController>(
      () => _i466.FaqController(gh<_i880.FaqRepository>()),
    );
    gh.factory<_i769.AddEditCategoryController>(
      () => _i769.AddEditCategoryController(gh<_i428.CategoryRepository>()),
    );
    gh.factory<_i340.AddNewUserController>(
      () => _i340.AddNewUserController(gh<_i73.UserManagementRepository>()),
    );
    gh.factory<_i896.UserManagementController>(
      () => _i896.UserManagementController(gh<_i73.UserManagementRepository>()),
    );
    gh.factory<_i530.AssignNewStoreController>(
      () => _i530.AssignNewStoreController(
        gh<_i517.DestinationDetailsRepository>(),
      ),
    );
    gh.factory<_i927.DestinationController>(
      () =>
          _i927.DestinationController(gh<_i517.DestinationDetailsRepository>()),
    );
    gh.factory<_i89.DestinationDetailsController>(
      () => _i89.DestinationDetailsController(
        gh<_i517.DestinationDetailsRepository>(),
      ),
    );
    gh.factory<_i307.ManageDestinationController>(
      () => _i307.ManageDestinationController(
        gh<_i517.DestinationDetailsRepository>(),
      ),
    );
    gh.factory<_i227.ClientListController>(
      () => _i227.ClientListController(gh<_i561.ClientRepository>()),
    );
    gh.factory<_i283.AddUpdateClientController>(
      () => _i283.AddUpdateClientController(gh<_i561.ClientRepository>()),
    );
    gh.factory<_i68.PurchaseTransactionController>(
      () => _i68.PurchaseTransactionController(
        gh<_i207.PurchaseTransactionRepository>(),
      ),
    );
    gh.factory<_i555.DeviceController>(
      () => _i555.DeviceController(
        gh<_i443.DeviceRepository>(),
        gh<_i635.ImportExportRepository>(),
      ),
    );
    gh.factory<_i486.CreateAdsController>(
      () => _i486.CreateAdsController(
        gh<_i647.DefaultAdsRepository>(),
        gh<_i66.ClientAdsRepository>(),
      ),
    );
    gh.factory<_i64.DrawerController>(
      () => _i64.DrawerController(gh<_i1002.DashboardRepository>()),
    );
    gh.factory<_i589.PurchaseDetailsController>(
      () => _i589.PurchaseDetailsController(gh<_i223.PurchaseRepository>()),
    );
    gh.factory<_i867.PurchaseListController>(
      () => _i867.PurchaseListController(gh<_i223.PurchaseRepository>()),
    );
    gh.factory<_i68.AddPurchaseController>(
      () => _i68.AddPurchaseController(gh<_i223.PurchaseRepository>()),
    );
    gh.factory<_i326.RolePermissionDetailsController>(
      () => _i326.RolePermissionDetailsController(
        gh<_i114.RolePermissionRepository>(),
      ),
    );
    gh.factory<_i389.AddEditRoleController>(
      () => _i389.AddEditRoleController(gh<_i114.RolePermissionRepository>()),
    );
    gh.factory<_i1002.RolesPermissionController>(
      () => _i1002.RolesPermissionController(
        gh<_i114.RolePermissionRepository>(),
      ),
    );
    gh.factory<_i904.DefaultDetailsController>(
      () => _i904.DefaultDetailsController(
        gh<_i647.DefaultAdsRepository>(),
        gh<_i66.ClientAdsRepository>(),
      ),
    );
    gh.factory<_i898.WalletTransactionsController>(
      () => _i898.WalletTransactionsController(
        gh<_i414.WalletTransactionsRepository>(),
      ),
    );
    gh.factory<_i593.DashboardController>(
      () => _i593.DashboardController(
        gh<_i1002.DashboardRepository>(),
        gh<_i780.AuthRepository>(),
      ),
    );
    gh.factory<_i128.CategoryListController>(
      () => _i128.CategoryListController(
        gh<_i428.CategoryRepository>(),
        gh<_i635.ImportExportRepository>(),
      ),
    );
    gh.factory<_i347.NotificationController>(
      () => _i347.NotificationController(gh<_i416.NotificationRepository>()),
    );
    gh.factory<_i946.AdsShownTimeController>(
      () => _i946.AdsShownTimeController(
        gh<_i438.AdsShowTimeRepository>(),
        gh<_i635.ImportExportRepository>(),
      ),
    );
    gh.factory<_i652.DestinationTypeListController>(
      () => _i652.DestinationTypeListController(
        gh<_i438.DestinationTypeRepository>(),
        gh<_i635.ImportExportRepository>(),
      ),
    );
    gh.factory<_i310.AddEditStoreController>(
      () => _i310.AddEditStoreController(
        gh<_i754.StoreRepository>(),
        gh<_i1002.DashboardRepository>(),
      ),
    );
    gh.factory<_i199.TicketReasonListController>(
      () => _i199.TicketReasonListController(
        gh<_i345.TicketReasonRepository>(),
        gh<_i635.ImportExportRepository>(),
      ),
    );
    gh.factory<_i86.DeploymentController>(
      () => _i86.DeploymentController(gh<_i235.DeploymentRepository>()),
    );
    gh.factory<_i640.StoreController>(
      () => _i640.StoreController(
        gh<_i754.StoreRepository>(),
        gh<_i635.ImportExportRepository>(),
      ),
    );
    gh.factory<_i731.StateListController>(
      () => _i731.StateListController(
        gh<_i403.StateRepository>(),
        gh<_i635.ImportExportRepository>(),
      ),
    );
    gh.factory<_i949.AssignNewRobotController>(
      () => _i949.AssignNewRobotController(
        gh<_i443.DeviceRepository>(),
        gh<_i517.DestinationDetailsRepository>(),
      ),
    );
    return this;
  }
}

class _$DioLoggerModule extends _i144.DioLoggerModule {}

class _$NetworkModule extends _i378.NetworkModule {}
