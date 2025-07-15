import 'dart:convert';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/category/contract/category_repository.dart';
import 'package:odigov3/framework/repository/master/category/model/add_edit_category_response_model.dart';
import 'package:odigov3/framework/repository/master/category/model/category_details_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';


final addEditCategoryController = ChangeNotifierProvider(
      (ref) => getIt<AddEditCategoryController>(),
);

@injectable
class AddEditCategoryController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    formKey.currentState?.reset();
    listForTextField.clear();
    addCategoryState.success = null;
    addCategoryState.isLoading = false;
    categoryDetailsState.success = null;
    categoryDetailsState.isLoading = false;
    editCategoryState.success = null;
    editCategoryState.isLoading = false;
    uploadCategoryImageState.success = null;
    uploadCategoryImageState.isLoading = false;
    categoryImage = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  final formKey = GlobalKey<FormState>();
  List<LanguageModel> listForTextField = [];
  Uint8List? categoryImage;

  /// Get LanguageList Model
  void getLanguageListModel() {
    listForTextField = DynamicLangFormManager.instance.getLanguageListModel(
      textFieldModel: null,
    );
    notifyListeners();
  }

  get isLoading => addCategoryState.isLoading || editCategoryState.isLoading || uploadCategoryImageState.isLoading;


  @override
  void notifyListeners() {
    super.notifyListeners();
  }

/*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  CategoryRepository categoryRepository;
  AddEditCategoryController(this.categoryRepository);

  /// add edit category api
  UIState<AddEditCategoryResponseModel> addCategoryState = UIState<AddEditCategoryResponseModel>();
  Future<UIState<AddEditCategoryResponseModel>> addCategoryAPI(BuildContext context) async {
    addCategoryState.isLoading = true;
    addCategoryState.success = null;
    notifyListeners();

    List<Map<String, dynamic>> stateValues = listForTextField.map((lang) {
      return {
        'languageUuid': lang.uuid,
        'name': lang.textEditingController?.text ?? lang.fieldValue ?? ''
      };
    }).toList();

    Map<String, dynamic> request = {
      'categoryValues': stateValues,
    };

    final result = await categoryRepository.addCategoryApi(jsonEncode(request));

    result.when(
      success: (data) async {
        notifyListeners();
        addCategoryState.isLoading = false;
        addCategoryState.success = data;
      },
      failure: (NetworkExceptions error) {
        addCategoryState.isLoading = false;
      },
    );
    addCategoryState.isLoading = false;
    notifyListeners();
    return addCategoryState;
  }

  /// category details api
  UIState<CategoryDetailsResponseModel> categoryDetailsState = UIState<CategoryDetailsResponseModel>();
  Future<UIState<CategoryDetailsResponseModel>> categoryDetailsAPI(BuildContext context,String uuid) async {
    categoryDetailsState.isLoading = true;
    categoryDetailsState.success = null;
    notifyListeners();

    final result = await categoryRepository.categoryDetailsApi(uuid);

    result.when(
      success: (data) async {
        notifyListeners();
        categoryDetailsState.isLoading = false;
        categoryDetailsState.success = data;
        if(categoryDetailsState.success?.status == ApiEndPoints.apiStatus_200){
          List<LanguageModel> preFillValueLanguageList = [];
          for(var language in categoryDetailsState.success?.data?.categoryValues??[]){
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
        categoryDetailsState.isLoading = false;
      },
    );
    categoryDetailsState.isLoading = false;
    notifyListeners();
    return categoryDetailsState;
  }

  /// edit category api
  UIState<AddEditCategoryResponseModel> editCategoryState = UIState<AddEditCategoryResponseModel>();
  Future<UIState<AddEditCategoryResponseModel>> editCategoryAPI(BuildContext context,String? uuid) async {
    editCategoryState.isLoading = true;
    editCategoryState.success = null;
    notifyListeners();

    List<Map<String, dynamic>> stateValues = listForTextField.map((lang) {
      return {
        'languageUuid': lang.uuid,
        'name': lang.textEditingController?.text ?? lang.fieldValue ?? ''
      };
    }).toList();

    Map<String, dynamic> request = {
      'uuid': uuid,
      'categoryValues': stateValues,
    };

    final result = await categoryRepository.editCategoryApi(jsonEncode(request));

    result.when(
      success: (data) async {
        notifyListeners();
        editCategoryState.isLoading = false;
        editCategoryState.success = data;
      },
      failure: (NetworkExceptions error) {
        editCategoryState.isLoading = false;
      },
    );
    editCategoryState.isLoading = false;
    notifyListeners();
    return editCategoryState;
  }

  /// upload category image api
  UIState<CommonResponseModel> uploadCategoryImageState = UIState<CommonResponseModel>();
  Future<UIState<CommonResponseModel>> uploadCategoryImageApi(BuildContext context,String uuid) async {
    if (categoryImage != null) {
      uploadCategoryImageState.isLoading = true;
      uploadCategoryImageState.success = null;
      notifyListeners();


      final today = DateTime.now();
      final formattedDate = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}";
      final fileName = 'category_image_$formattedDate.jpeg';

      FormData? formData;
      MultipartFile companyPic = MultipartFile.fromBytes(categoryImage!, filename: fileName, contentType: MediaType('image', 'jpeg'));
      formData = FormData.fromMap({'file': companyPic});

      final result = await categoryRepository.uploadCategoryImageApi(uuid, formData);
      result.when(
        success: (data) async {
          uploadCategoryImageState.success = data;
          uploadCategoryImageState.isLoading = false;
        },
        failure: (NetworkExceptions error) {
          uploadCategoryImageState.isLoading = false;
        },
      );

      uploadCategoryImageState.isLoading = false;
      notifyListeners();
    }
    return uploadCategoryImageState;
  }

}
