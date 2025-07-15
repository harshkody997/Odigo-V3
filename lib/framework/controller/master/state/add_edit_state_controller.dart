import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/master/country/model/country_list_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/repository/master/state/contract/state_repository.dart';
import 'package:odigov3/framework/repository/master/state/model/add_edit_state_response_model.dart';
import 'package:odigov3/framework/repository/master/state/model/state_details_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';

final addEditStateController = ChangeNotifierProvider(
  (ref) => getIt<AddEditStateController>(),
);

@injectable
class AddEditStateController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    formKey.currentState?.reset();
    listForTextField.clear();
    stateDetailsState.success = null;
    stateDetailsState.isLoading = false;
    addStateState.success = null;
    addStateState.isLoading = false;
    editStateState.success = null;
    editStateState.isLoading = false;
    countryCtr.clear();
    selectedCountry = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  final formKey = GlobalKey<FormState>();

  CountryModel? selectedCountry;
  TextEditingController countryCtr = TextEditingController();

  updateCountryDropdown(CountryModel? value){
    selectedCountry = value;
    notifyListeners();
  }

  setPreFilCountryDropdown(List<CountryModel?> countryList,String? countryUuid){
    try{
      CountryModel? countryModel = countryList.where((state) => state?.uuid == countryUuid).firstOrNull;
      countryCtr.text = countryModel?.name ?? '';
      updateCountryDropdown(countryModel);
    }catch(e){
      AppConstants.constant.showLog('Exception in country prefill $e');
    }
  }

  List<LanguageModel> listForTextField = [];
  /// Get LanguageList Model
  void getLanguageListModel() {
    listForTextField = DynamicLangFormManager.instance.getLanguageListModel(
      textFieldModel: null,
    );
    notifyListeners();
  }

  get isLoading => addStateState.isLoading || editStateState.isLoading;

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  StateRepository stateRepository;
  AddEditStateController(this.stateRepository);

  /// add state api
  UIState<AddEditStateResponseModel> addStateState = UIState<AddEditStateResponseModel>();
  Future<UIState<AddEditStateResponseModel>> addStateAPI(BuildContext context) async {
    addStateState.isLoading = true;
    addStateState.success = null;
    notifyListeners();

    List<Map<String, dynamic>> stateValues = listForTextField.map((lang) {
      return {
        'languageUuid': lang.uuid,
        'name': lang.textEditingController?.text ?? lang.fieldValue ?? ''
      };
    }).toList();

    Map<String, dynamic> request = {
      'stateValues': stateValues,
      'countryUuid': selectedCountry?.uuid
    };

    final result = await stateRepository.addStateApi(jsonEncode(request));

    result.when(
      success: (data) async {
        notifyListeners();
        addStateState.isLoading = false;
        addStateState.success = data;
      },
      failure: (NetworkExceptions error) {
        addStateState.isLoading = false;
      },
    );
    addStateState.isLoading = false;
    notifyListeners();
    return addStateState;
  }

  /// state details api
  UIState<StateDetailsResponseModel> stateDetailsState = UIState<StateDetailsResponseModel>();
  Future<UIState<StateDetailsResponseModel>> stateDetailsAPI(BuildContext context,String uuid) async {
    stateDetailsState.isLoading = true;
    stateDetailsState.success = null;
    notifyListeners();

    final result = await stateRepository.stateDetailsApi(uuid);

    result.when(
      success: (data) async {
        notifyListeners();
        stateDetailsState.isLoading = false;
        stateDetailsState.success = data;
        if(stateDetailsState.success?.status == ApiEndPoints.apiStatus_200){
          List<LanguageModel> preFillValueLanguageList = [];
          for(var language in stateDetailsState.success?.data?.stateValues??[]){
            preFillValueLanguageList.add(
              LanguageModel(
                uuid: language.languageUuid??'',
                fieldValue: language.name??'',
                name: language.languageName??'',
              )
            );

            listForTextField = DynamicLangFormManager.instance.getLanguageListModel(
              textFieldModel: preFillValueLanguageList,
            );
          }
        }
      },
      failure: (NetworkExceptions error) {
        stateDetailsState.isLoading = false;
      },
    );
    stateDetailsState.isLoading = false;
    notifyListeners();
    return stateDetailsState;
  }

  /// edit state api
  UIState<AddEditStateResponseModel> editStateState = UIState<AddEditStateResponseModel>();
  Future<UIState<AddEditStateResponseModel>> editStateAPI(BuildContext context,String? uuid) async {
    editStateState.isLoading = true;
    editStateState.success = null;
    notifyListeners();

    List<Map<String, dynamic>> stateValues = listForTextField.map((lang) {
      return {
        'languageUuid': lang.uuid,
        'name': lang.textEditingController?.text ?? lang.fieldValue ?? ''
      };
    }).toList();

    Map<String, dynamic> request = {
      'uuid': uuid,
      'stateValues': stateValues,
      'countryUuid': selectedCountry?.uuid
    };

    final result = await stateRepository.editStateApi(jsonEncode(request));

    result.when(
      success: (data) async {
        notifyListeners();
        editStateState.isLoading = false;
        editStateState.success = data;
      },
      failure: (NetworkExceptions error) {
        editStateState.isLoading = false;
      },
    );
    editStateState.isLoading = false;
    notifyListeners();
    return editStateState;
  }

}
