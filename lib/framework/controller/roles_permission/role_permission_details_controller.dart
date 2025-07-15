import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/role_permission/contract/role_permission_repository.dart';
import 'package:odigov3/framework/repository/role_permission/model/role_permission_details_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';


final rolePermissionDetailsController = ChangeNotifierProvider(
      (ref) => getIt<RolePermissionDetailsController>(),
);

@injectable
class RolePermissionDetailsController extends ChangeNotifier {

  RolePermissionRepository rolePermissionRepository;
  RolePermissionDetailsController(this.rolePermissionRepository);

  ///Dispose Controller
  void disposeController({bool? isNotify}) {
    rolePermissionDetailsState.isLoading = true;
    rolePermissionDetailsState.success = null;
    if (isNotify??false) {
      notifyListeners();
    }
  }

  RolePermissionModel? get rolePermissionDetails => rolePermissionDetailsState.success?.data;

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  /// role permission details api
  UIState<RolePermissionDetailsResponseModel> rolePermissionDetailsState = UIState<RolePermissionDetailsResponseModel>();
  Future<UIState<RolePermissionDetailsResponseModel>> rolePermissionDetailsAPI(BuildContext context,String uuid) async {
    rolePermissionDetailsState.isLoading = true;
    rolePermissionDetailsState.success = null;
    notifyListeners();

    final result = await rolePermissionRepository.rolePermissionDetailsApi(uuid);

    result.when(
      success: (data) async {
        rolePermissionDetailsState.isLoading = false;
        rolePermissionDetailsState.success = data;
        notifyListeners();
      },
      failure: (NetworkExceptions error) {
        rolePermissionDetailsState.isLoading = false;
      },
    );
    rolePermissionDetailsState.isLoading = false;
    notifyListeners();
    return rolePermissionDetailsState;
  }

}
