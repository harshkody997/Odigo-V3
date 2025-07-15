import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/settings/contract/settings_repository.dart';
import 'package:odigov3/framework/repository/settings/model/request_model/update_setting_request_model.dart';
import 'package:odigov3/framework/repository/settings/model/response_model/settings_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';


final settingsController = ChangeNotifierProvider(
      (ref) => getIt<SettingsController>(),
);

@injectable
class SettingsController extends ChangeNotifier {
  SettingsRepository settingsRepository;
  SettingsController(this.settingsRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    settingsListState.isLoading = true;
    settingsListState.success = null;
    keyController.clear();
    formKey.currentState?.reset();
    statusTapIndex = -1;
    if (isNotify) {
      notifyListeners();
    }
  }

  GlobalKey editKeyDialogKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController keyController = TextEditingController();

  void notify(){
    notifyListeners();
  }

  int statusTapIndex = -1;

  updateStatusIndex(int value){
    statusTapIndex = value;
    notifyListeners();
  }


  /// ---------------------------- Api Integration ---------------------------------///

  ///-----------------Settings List Api------------------------------->
  var settingsListState = UIState<SettingsListResponseModel>();

  Future<void> getSettingsList(BuildContext context) async {
    settingsListState.isLoading = true;
    settingsListState.success = null;
    notifyListeners();

    final result = await settingsRepository.getSettingsList(pageNo: 1, dataSize: AppConstants.pageSize);
    result.when(success: (data) async {
      settingsListState.success = data;
    }, failure: (NetworkExceptions error) {
      //String errorMsg = NetworkExceptions.getErrorMessage(error);
      //       showCommonErrorDialog(context: context, message: errorMsg);
    });
    settingsListState.isLoading = false;

    notifyListeners();
  }

  ///----------------- Update Settings Api------------------------------->
  var updateSettingsState = UIState<CommonResponseModel>();
  int? updateSettingIndex;

  Future<void> updateSettingsApi({BuildContext? context, required String uuid, required bool encrypted, required  String fieldName, required  String fieldValue}) async {
    updateSettingsState.isLoading = true;
    updateSettingsState.success = null;
    updateSettingIndex = settingsListState.success?.data?.indexWhere((element) => element.uuid == uuid);
    notifyListeners();

    UpdateSettingsRequestModel requestModel = UpdateSettingsRequestModel(
        encrypted: encrypted ,
        uuid: uuid,
        fieldName: fieldName.trimSpace,
        fieldValue :fieldValue
    );

    String request = updateSettingsRequestModelToJson(requestModel) ;

    final result = await settingsRepository.updateSetting(request);
    result.when(success: (data) async {
      updateSettingsState.success = data;
      settingsListState.success?.data?.where((element) => element.uuid == uuid).firstOrNull?.fieldValue = fieldValue;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context!, message: errorMsg);
    });
    updateSettingsState.isLoading = false;
    notifyListeners();
  }


}
