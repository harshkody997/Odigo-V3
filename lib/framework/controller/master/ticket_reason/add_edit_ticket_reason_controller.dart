import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/repository/master/ticket_reason/contract/ticket_reason_repository.dart';
import 'package:odigov3/framework/repository/master/ticket_reason/model/add_edit_ticket_reason_response_model.dart';
import 'package:odigov3/framework/repository/master/ticket_reason/model/ticket_reason_details_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';


final addEditTicketReasonController = ChangeNotifierProvider(
      (ref) => getIt<AddEditTicketReasonController>(),
);

@injectable
class AddEditTicketReasonController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    formKey.currentState?.reset();
    selectedPlatformType = null;
    platformTypeCtr.clear();
    ticketReasonCtr.clear();
    languageListTextFields.clear();
    addTicketReasonState.success = null;
    addTicketReasonState.isLoading = false;
    ticketReasonDetailsState.success = null;
    ticketReasonDetailsState.isLoading = false;
    editTicketReasonState.success = null;
    editTicketReasonState.isLoading = false;
    if (isNotify) {
      notifyListeners();
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController platformTypeCtr = TextEditingController();
  TextEditingController ticketReasonCtr = TextEditingController();
  TicketReasonPlatformType? selectedPlatformType;
  List<TicketReasonPlatformType> platformTypeList = [TicketReasonPlatformType.DESTINATION,TicketReasonPlatformType.CLIENT];

  updatePlatformTypeDropdown(TicketReasonPlatformType? value){
    selectedPlatformType = value;
    notifyListeners();
  }

  List<LanguageModel> languageListTextFields = [];
  /// Get LanguageList Model
  void getLanguageListModel() {
    languageListTextFields = DynamicLangFormManager.instance.getLanguageListModel(
      textFieldModel: null,
    );
    print("asdfasdfdsadfsdafds languageListTextFields ${languageListTextFields}");
    notifyListeners();
  }

  bool get isLoading => addTicketReasonState.isLoading || editTicketReasonState.isLoading;

  void setPrefillData() {
    List<LanguageModel> preFillValueLanguageList = [];
    TicketReasonPlatformType? ticketReasonPlatformType = ticketReasonDetailsState.success?.data?.platformType?.ticketReasonPlatformTypeToString();
    updatePlatformTypeDropdown(ticketReasonPlatformType);
    platformTypeCtr.text = ticketReasonPlatformType?.text??'';
    for(var language in ticketReasonDetailsState.success?.data?.ticketReasonValues??[]){
      preFillValueLanguageList.add(
          LanguageModel(
            uuid: language.languageUuid??'',
            fieldValue: language.reason??'',
            name: language.languageName??'',
          )
      );
      languageListTextFields = DynamicLangFormManager.instance.getLanguageListModel(
        textFieldModel: preFillValueLanguageList,
      );
    }
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  TicketReasonRepository ticketReasonRepository;
  AddEditTicketReasonController(this.ticketReasonRepository);

  /// add ticket reason api
  UIState<AddEditTicketReasonResponseModel> addTicketReasonState = UIState<AddEditTicketReasonResponseModel>();
  Future<UIState<AddEditTicketReasonResponseModel>> addTicketReasonAPI(BuildContext context) async {
    addTicketReasonState.isLoading = true;
    addTicketReasonState.success = null;
    notifyListeners();

    List<Map<String, dynamic>> ticketReasonValues = languageListTextFields.map((lang) {
      return {
        'languageUuid': lang.uuid,
        'reason': lang.textEditingController?.text ?? lang.fieldValue ?? ''
      };
    }).toList();

    Map<String, dynamic> request = {
      'platformType': selectedPlatformType?.name,
      'ticketReasonValues': ticketReasonValues,
    };

    final result = await ticketReasonRepository.addTicketReasonApi(jsonEncode(request));

    result.when(
      success: (data) async {
        notifyListeners();
        addTicketReasonState.isLoading = false;
        addTicketReasonState.success = data;
      },
      failure: (NetworkExceptions error) {
        addTicketReasonState.isLoading = false;
      },
    );
    addTicketReasonState.isLoading = false;
    notifyListeners();
    return addTicketReasonState;
  }

  /// ticket reason details api
  UIState<TicketReasonDetailsResponseModel> ticketReasonDetailsState = UIState<TicketReasonDetailsResponseModel>();
  Future<UIState<TicketReasonDetailsResponseModel>> ticketReasonDetailsAPI(BuildContext context,String uuid) async {
    ticketReasonDetailsState.isLoading = true;
    ticketReasonDetailsState.success = null;
    notifyListeners();

    final result = await ticketReasonRepository.ticketReasonDetailsApi(uuid);

    result.when(
      success: (data) async {
        notifyListeners();
        ticketReasonDetailsState.isLoading = false;
        ticketReasonDetailsState.success = data;
        if(ticketReasonDetailsState.success?.status == ApiEndPoints.apiStatus_200){
          setPrefillData();
        }
      },
      failure: (NetworkExceptions error) {
        ticketReasonDetailsState.isLoading = false;
      },
    );
    ticketReasonDetailsState.isLoading = false;
    notifyListeners();
    return ticketReasonDetailsState;
  }

  /// edit ticket reason api
  UIState<AddEditTicketReasonResponseModel> editTicketReasonState = UIState<AddEditTicketReasonResponseModel>();
  Future<UIState<AddEditTicketReasonResponseModel>> editTicketReasonAPI(BuildContext context,String? uuid) async {
    editTicketReasonState.isLoading = true;
    editTicketReasonState.success = null;
    notifyListeners();

    List<Map<String, dynamic>> ticketReasonValues = languageListTextFields.map((lang) {
      return {
        'languageUuid': lang.uuid,
        'reason': lang.textEditingController?.text ?? lang.fieldValue ?? ''
      };
    }).toList();

    Map<String, dynamic> request = {
      'uuid': uuid,
      'platformType': selectedPlatformType?.name,
      'ticketReasonValues': ticketReasonValues,
    };

    final result = await ticketReasonRepository.editTicketReasonApi(jsonEncode(request));

    result.when(
      success: (data) async {
        notifyListeners();
        editTicketReasonState.isLoading = false;
        editTicketReasonState.success = data;
      },
      failure: (NetworkExceptions error) {
        editTicketReasonState.isLoading = false;
      },
    );
    editTicketReasonState.isLoading = false;
    notifyListeners();
    return editTicketReasonState;
  }
}
