import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/controller/faq/faq_controller.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/faq/contract/faq_repository.dart';
import 'package:odigov3/framework/repository/faq/model/request/add_edit_faq_request_model.dart';
import 'package:odigov3/framework/repository/faq/model/response/faq_details_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';

final addEditFaqController = ChangeNotifierProvider((ref) => getIt<AddEditFaqController>());

@injectable
class AddEditFaqController extends ChangeNotifier {
  AddEditFaqController(this.faqRepository);
  final FaqRepository faqRepository;

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    addEditFaqFormKey.currentState?.reset();
    faqDetailState.isLoading = false;
    faqDetailState.success = null;
    questionTextFieldList.clear();
    answerTextFieldList.clear();
    questionDataFillModel = null;
    answerDataFillModel = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  GlobalKey<FormState> addEditFaqFormKey = GlobalKey<FormState>();

  /// dynamic name field
  List<LanguageModel> questionTextFieldList = [];
  List<LanguageModel>? questionDataFillModel;
  List<LanguageModel> answerTextFieldList = [];
  List<LanguageModel>? answerDataFillModel;

  /// Get LanguageList Model
  void getLanguageListModel() {
    questionTextFieldList = DynamicLangFormManager.instance.getLanguageListModel(textFieldModel: questionDataFillModel);
    answerTextFieldList = DynamicLangFormManager.instance.getLanguageListModel(textFieldModel: answerDataFillModel);
  }


  /// api call
  Future<void> addEditFaqApiCall(BuildContext context, WidgetRef ref, {String? faqUuid}) async {
    if (addEditFaqFormKey.currentState?.validate() == true) {
      await addEditFaqApi(context, ref, faqUuid: faqUuid);
      if(addEditFaqState.success?.status == ApiEndPoints.apiStatus_200){
        ref.read(faqController).faqListApi(context);
        ref.read(navigationStackController).pop();
      }
    }
  }
 
  /// ---------------------------- Api Integration ---------------------------------///


  ///----------------- Faq details Api------------------------------->
  var faqDetailState = UIState<FaqDetailsResponseModel>();

  Future<void> faqDetailApi(BuildContext context, String faqUuid) async {
    faqDetailState.isLoading = true;
    faqDetailState.success = null;
    notifyListeners();

    final result = await faqRepository.faqDetailsApi(faqUuid);

    result.when(
      success: (data) async {
        faqDetailState.success = data;
        questionDataFillModel = [];
        answerDataFillModel = [];
        for (FaqValue? item in (faqDetailState.success?.data?.faqValues ?? [])) {
          questionDataFillModel?.add(LanguageModel(uuid: item?.languageUuid, name: item?.languageName, fieldValue: item?.question));
          answerDataFillModel?.add(LanguageModel(uuid: item?.languageUuid, name: item?.languageName, fieldValue: item?.answer));
        }
      },
      failure: (NetworkExceptions error) {
        //String errorMsg = NetworkExceptions.getErrorMessage(error);
        //       showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    faqDetailState.isLoading = false;
    notifyListeners();
  }

  ///----------------- Add Edit Faq Api------------------------------->
  UIState<CommonResponseModel> addEditFaqState = UIState<CommonResponseModel>();

  Future<void> addEditFaqApi(BuildContext context, WidgetRef ref, {String? faqUuid}) async {
    addEditFaqState.isLoading = true;
    addEditFaqState.success = null;
    notifyListeners();

    List<FaqValueForAdd> faqNameValues = [];

    for(int i = 0;i<questionTextFieldList.length;i++){
      faqNameValues.add(FaqValueForAdd(
        languageUuid: questionTextFieldList[i].uuid,
        question: questionTextFieldList[i].textEditingController?.text ?? questionTextFieldList[i].fieldValue ?? '',
        answer: answerTextFieldList[i].textEditingController?.text ?? answerTextFieldList[i].fieldValue ?? ''
      ));
    }

    final faqRead = ref.read(faqController);
    AddEditFaqRequestModel addFaqRequestModel = AddEditFaqRequestModel(
        platformType: (faqRead.selectedFaqType == FaqType.Destinations) ? 'DESTINATION' : 'CLIENT',
        uuid: faqUuid,
        faqValues: faqNameValues,
    );

    String request = addEditFaqRequestModelToJson(addFaqRequestModel);

    final result = await faqRepository.addEditFaqApi(request, faqUuid == null);

    result.when(
      success: (data) async {
        addEditFaqState.success = data;
      },
      failure: (NetworkExceptions error) {
        //String errorMsg = NetworkExceptions.getErrorMessage(error);
        //       showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    addEditFaqState.isLoading = false;
    notifyListeners();
  }

}
