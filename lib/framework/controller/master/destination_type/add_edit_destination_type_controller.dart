import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/master/category/model/category_details_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/repository/master/destination_type/contract/destination_type_repository.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/add_edit_destination_type_response_model.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/destination_type_details_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';


final addEditDestinationTypeController = ChangeNotifierProvider(
      (ref) => getIt<AddEditDestinationTypeController>(),
);

@injectable
class AddEditDestinationTypeController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    formKey.currentState?.reset();
    listForTextField.clear();
    destinationTypeCtr.clear();
    addDestinationTypeState.isLoading = false;
    addDestinationTypeState.success = null;
    editDestinationTypeState.isLoading = false;
    editDestinationTypeState.success = null;
    destinationTypeDetailsState.isLoading = false;
    destinationTypeDetailsState.success = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController destinationTypeCtr = TextEditingController();
  List<LanguageModel> listForTextField = [];

  /// Get LanguageList Model
  void getLanguageListModel() {
    listForTextField = DynamicLangFormManager.instance.getLanguageListModel(
      textFieldModel: null,
    );
    notifyListeners();
  }

  bool get isLoading => addDestinationTypeState.isLoading || editDestinationTypeState.isLoading;

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  DestinationTypeRepository destinationTypeRepository;
  AddEditDestinationTypeController(this.destinationTypeRepository);

  /// add edit category api
  UIState<AddEditDestinationTypeResponseModel> addDestinationTypeState = UIState<AddEditDestinationTypeResponseModel>();
  Future<UIState<AddEditDestinationTypeResponseModel>> addDestinationTypeAPI(BuildContext context) async {
    addDestinationTypeState.isLoading = true;
    addDestinationTypeState.success = null;
    notifyListeners();

    List<Map<String, dynamic>> stateValues = listForTextField.map((lang) {
      return {
        'languageUuid': lang.uuid,
        'name': lang.textEditingController?.text ?? lang.fieldValue ?? ''
      };
    }).toList();

    Map<String, dynamic> request = {
      'destinationTypeValues': stateValues,
    };

    final result = await destinationTypeRepository.addDestinationTypeApi(jsonEncode(request));

    result.when(
      success: (data) async {
        notifyListeners();
        addDestinationTypeState.isLoading = false;
        addDestinationTypeState.success = data;
      },
      failure: (NetworkExceptions error) {
        addDestinationTypeState.isLoading = false;
      },
    );
    addDestinationTypeState.isLoading = false;
    notifyListeners();
    return addDestinationTypeState;
  }

  /// destination type details api
  UIState<DestinationTypeDetailsResponseModel> destinationTypeDetailsState = UIState<DestinationTypeDetailsResponseModel>();
  Future<UIState<DestinationTypeDetailsResponseModel>> destinationTypeDetailsAPI(BuildContext context,String uuid) async {
    destinationTypeDetailsState.isLoading = true;
    destinationTypeDetailsState.success = null;
    notifyListeners();

    final result = await destinationTypeRepository.destinationTypeDetailsApi(uuid);

    result.when(
      success: (data) async {
        notifyListeners();
        destinationTypeDetailsState.isLoading = false;
        destinationTypeDetailsState.success = data;
        if(destinationTypeDetailsState.success?.status == ApiEndPoints.apiStatus_200){
          List<LanguageModel> preFillValueLanguageList = [];
          for(var language in destinationTypeDetailsState.success?.data.destinationTypeValues??[]){
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
        destinationTypeDetailsState.isLoading = false;
      },
    );
    destinationTypeDetailsState.isLoading = false;
    notifyListeners();
    return destinationTypeDetailsState;
  }

  /// edit category api
  UIState<AddEditDestinationTypeResponseModel> editDestinationTypeState = UIState<AddEditDestinationTypeResponseModel>();
  Future<UIState<AddEditDestinationTypeResponseModel>> editDestinationTypeAPI(BuildContext context,String? uuid) async {
    editDestinationTypeState.isLoading = true;
    editDestinationTypeState.success = null;
    notifyListeners();

    List<Map<String, dynamic>> stateValues = listForTextField.map((lang) {
      return {
        'languageUuid': lang.uuid,
        'name': lang.textEditingController?.text ?? lang.fieldValue ?? ''
      };
    }).toList();

    Map<String, dynamic> request = {
      'uuid': uuid,
      'destinationTypeValues': stateValues,
    };

    final result = await destinationTypeRepository.editDestinationTypeApi(jsonEncode(request));

    result.when(
      success: (data) async {
        notifyListeners();
        editDestinationTypeState.isLoading = false;
        editDestinationTypeState.success = data;
      },
      failure: (NetworkExceptions error) {
        editDestinationTypeState.isLoading = false;
      },
    );
    editDestinationTypeState.isLoading = false;
    notifyListeners();
    return editDestinationTypeState;
  }

}
