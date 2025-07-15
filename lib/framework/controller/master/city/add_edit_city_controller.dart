import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/master/city/contract/city_repository.dart';
import 'package:odigov3/framework/repository/master/city/model/add_edit_city_response_model.dart';
import 'package:odigov3/framework/repository/master/city/model/city_details_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/country_list_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/repository/master/state/model/state_list_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';


final addEditCityController = ChangeNotifierProvider(
      (ref) => getIt<AddEditCityController>(),
);

@injectable
class AddEditCityController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    formKey.currentState?.reset();
    selectedState = null;
    stateCtr.clear();
    cityCtr.clear();
    selectedCountry = null;
    countryCtr.clear();
    languageListTextFields.clear();
    addCityState.success = null;
    addCityState.isLoading = false;
    editCityState.success = null;
    editCityState.isLoading = false;
    cityDetailsState.success = null;
    cityDetailsState.isLoading = false;
    if (isNotify) {
      notifyListeners();
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController stateCtr = TextEditingController();
  TextEditingController cityCtr = TextEditingController();
  StateModel? selectedState;
  CountryModel? selectedCountry;
  TextEditingController countryCtr = TextEditingController();

  updateCountryDropdown(CountryModel? value){
    selectedCountry = value;
    notifyListeners();
  }

  updateStateDropdown(StateModel? value){
    selectedState = value;
    notifyListeners();
  }

  List<LanguageModel> languageListTextFields = [];
  /// Get LanguageList Model
  void getLanguageListModel() {
    languageListTextFields = DynamicLangFormManager.instance.getLanguageListModel(
      textFieldModel: null,
    );
    notifyListeners();
  }

  setPreFillCountryDropdown(List<CountryModel?> countryList,String? countryUuid){
    try{
      CountryModel? countryModel = countryList.where((state) => state?.uuid == countryUuid).firstOrNull;
      countryCtr.text = countryModel?.name ?? '';
      updateCountryDropdown(countryModel);
    }catch(e){
      AppConstants.constant.showLog('Exception in country prefill $e');
    }
  }

  setPreFillStateDropdown(List<StateModel?> stateList,String? stateUuid){
    print("SOGA-FJ96-W13R-5UVD");
    print("stateUuid asdfkldsfjasd;lf ${stateUuid} and  ${stateList.length}");
    try{
      StateModel? stateModel = stateList.where((state) => state?.uuid == stateUuid).firstOrNull;
      stateCtr.text = stateModel?.name ?? '';
      updateStateDropdown(stateModel);
    }catch(e){
      AppConstants.constant.showLog('Exception in state prefill $e');
    }
  }

  bool get isLoading => addCityState.isLoading || editCityState.isLoading;

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  CityRepository cityRepository;
  AddEditCityController(this.cityRepository);

  /// add city api
  UIState<AddEditCityResponseModel> addCityState = UIState<AddEditCityResponseModel>();
  Future<UIState<AddEditCityResponseModel>> addCityAPI(BuildContext context) async {
    addCityState.isLoading = true;
    addCityState.success = null;
    notifyListeners();

    List<Map<String, dynamic>> cityValues = languageListTextFields.map((lang) {
      return {
        'languageUuid': lang.uuid,
        'name': lang.textEditingController?.text ?? lang.fieldValue ?? ''
      };
    }).toList();

    Map<String, dynamic> request = {
      'stateUuid': selectedState?.uuid,
      'cityValues': cityValues,
    };

    final result = await cityRepository.addCityApi(jsonEncode(request));

    result.when(
      success: (data) async {
        notifyListeners();
        addCityState.isLoading = false;
        addCityState.success = data;
      },
      failure: (NetworkExceptions error) {
        addCityState.isLoading = false;
      },
    );
    addCityState.isLoading = false;
    notifyListeners();
    return addCityState;
  }

  /// city details api
  UIState<CityDetailsResponseModel> cityDetailsState = UIState<CityDetailsResponseModel>();
  Future<UIState<CityDetailsResponseModel>> cityDetailsAPI(BuildContext context,String uuid) async {
    cityDetailsState.isLoading = true;
    cityDetailsState.success = null;
    notifyListeners();

    final result = await cityRepository.cityDetailsApi(uuid);

    result.when(
      success: (data) async {
        notifyListeners();
        cityDetailsState.isLoading = false;
        cityDetailsState.success = data;
        if(cityDetailsState.success?.status == ApiEndPoints.apiStatus_200){
          List<LanguageModel> preFillValueLanguageList = [];
          for(var language in cityDetailsState.success?.data?.cityValues??[]){
            preFillValueLanguageList.add(
                LanguageModel(
                  uuid: language.languageUuid??'',
                  fieldValue: language.name??'',
                  name: language.languageName??'',
                )
            );

            languageListTextFields = DynamicLangFormManager.instance.getLanguageListModel(
              textFieldModel: preFillValueLanguageList,
            );
          }
        }
      },
      failure: (NetworkExceptions error) {
        cityDetailsState.isLoading = false;
      },
    );
    cityDetailsState.isLoading = false;
    notifyListeners();
    return cityDetailsState;
  }

  /// edit city api
  UIState<AddEditCityResponseModel> editCityState = UIState<AddEditCityResponseModel>();
  Future<UIState<AddEditCityResponseModel>> editCityAPI(BuildContext context,String? uuid) async {
    editCityState.isLoading = true;
    editCityState.success = null;
    notifyListeners();

    List<Map<String, dynamic>> cityValues = languageListTextFields.map((lang) {
      return {
        'languageUuid': lang.uuid,
        'name': lang.textEditingController?.text ?? lang.fieldValue ?? ''
      };
    }).toList();

    Map<String, dynamic> request = {
      'uuid': uuid,
      'stateUuid': selectedState?.uuid,
      'cityValues': cityValues,
    };

    final result = await cityRepository.editCityApi(jsonEncode(request));

    result.when(
      success: (data) async {
        notifyListeners();
        editCityState.isLoading = false;
        editCityState.success = data;
      },
      failure: (NetworkExceptions error) {
        editCityState.isLoading = false;
      },
    );
    editCityState.isLoading = false;
    notifyListeners();
    return editCityState;
  }

}
