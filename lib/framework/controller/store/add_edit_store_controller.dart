import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/controller/store/store_controller.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/contract/dashboard_repository.dart';
import 'package:odigov3/framework/repository/dashboard/model/category_data_list_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/repository/store/contract/store_repository.dart';
import 'package:odigov3/framework/repository/store/model/add_store_response_model.dart';
import 'package:odigov3/framework/repository/store/model/request_model/add_store_request_model.dart';
import 'package:odigov3/framework/repository/store/model/store_detail_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';
import 'package:http_parser/http_parser.dart';

final addEditStoreController = ChangeNotifierProvider((ref) => getIt<AddEditStoreController>());

@injectable
class AddEditStoreController extends ChangeNotifier {
  AddEditStoreController(this.storeRepository, this.dashboardRepository);
  final StoreRepository storeRepository;
  DashboardRepository dashboardRepository;


  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    addEditStoreFormKey.currentState?.reset();
    selectedBusinessCategories.clear();
    selectedImage = null;
    listForTextField.clear();
    languageModel = null;
    storeDetailState.isLoading = false;
    storeDetailState.success = null;
    addEditStoreState.isLoading = false;
    addEditStoreState.success = null;
    uploadStoreImageState.isLoading = false;
    uploadStoreImageState.success = null;
    categoryDataListState.isLoading = true;
    categoryDataListState.success = null;
    categoryList.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  GlobalKey<FormState> addEditStoreFormKey = GlobalKey<FormState>();

  List<CategoryDataListDto> selectedBusinessCategories = [];

  void updateSelectedCategory(CategoryDataListDto category, bool? checked) {
    if (checked == true) {
      selectedBusinessCategories.add(category);
    } else {
      selectedBusinessCategories.remove(category);
    }
    notifyListeners();
  }

  void addAllCategory(bool? checked, List<CategoryDataListDto> businessCategoriesList) {
    if (checked == true) {
      selectedBusinessCategories.addAll(businessCategoriesList);
    } else {
      selectedBusinessCategories.removeWhere(businessCategoriesList.contains);
    }
    selectedBusinessCategories = selectedBusinessCategories.toSet().toList(); // remove duplicates
    notifyListeners();
  }

  /// For uploading image
  Uint8List? selectedImage;

  /// dynamic name field
  List<LanguageModel> listForTextField = [];
  List<LanguageModel>? languageModel;

  /// Get LanguageList Model
  void getLanguageListModel(bool? isEdit) {
    listForTextField = DynamicLangFormManager.instance.getLanguageListModel(textFieldModel: languageModel);
    notifyListeners();
  }

  /// api call
  Future<void> addEditStoreApiCall(BuildContext context, WidgetRef ref, {String? storeUuid}) async {
    if (addEditStoreFormKey.currentState?.validate() == true && selectedBusinessCategories.isNotEmpty) {
      await addEditStoreApi(context, storeUuid: storeUuid);
      if(addEditStoreState.success?.status == ApiEndPoints.apiStatus_200){
        if(selectedImage != null) {
          await uploadStoreImageApi(context, uuid: storeUuid ?? (addEditStoreState.success?.data?.uuid ?? ''));
          if(uploadStoreImageState.success?.status == ApiEndPoints.apiStatus_200){
            ref.read(storeController).storeListApi(context);
            ref.read(navigationStackController).pop();
          }
        }
        else {
          ref.read(storeController).storeListApi(context);
          ref.read(navigationStackController).pop();
        }
      }
    }
  }


  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  /// ---------------------------- Api Integration ---------------------------------///

  ///----------------- Store details Api------------------------------->
  var storeDetailState = UIState<StoreDetailResponseModel>();

  Future<void> storeDetailApi(BuildContext context, String storeUuid) async {
    storeDetailState.isLoading = true;
    storeDetailState.success = null;
    notifyListeners();

    final result = await storeRepository.storeDetailApi(storeUuid: storeUuid);

    result.when(
      success: (data) async {
        storeDetailState.success = data;
        languageModel = [];
        for (StoreValue? item in (storeDetailState.success?.data?.storeValues ?? [])) {
          languageModel?.add(LanguageModel(uuid: item?.languageUuid, name: item?.languageName, fieldValue: item?.name));
        }
      },
      failure: (NetworkExceptions error) {
        //String errorMsg = NetworkExceptions.getErrorMessage(error);
        //       showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    storeDetailState.isLoading = false;
    notifyListeners();
  }

  ///----------------- Add Edit Store Api------------------------------->
  UIState<AddStoreResponseModel> addEditStoreState = UIState<AddStoreResponseModel>();

  Future<void> addEditStoreApi(BuildContext context, {String? storeUuid}) async {
    addEditStoreState.isLoading = true;
    addEditStoreState.success = null;
    notifyListeners();

    List<StoreValueForAdd> storeNameValues = listForTextField.map((lang) {
      return StoreValueForAdd(
        languageUuid: lang.uuid,
        name: lang.textEditingController?.text ?? lang.fieldValue ?? ''
      );
    }).toList();

    List<String> categoryUuidList = selectedBusinessCategories.map((e) => e.uuid ?? '').toList();
    
    AddStoreRequestModel addStoreRequestModel = AddStoreRequestModel(
      uuid: storeUuid,
      storeValues: storeNameValues,
      categoryUuids: categoryUuidList
    );
    String request = addStoreRequestModelToJson(addStoreRequestModel);

    final result = await storeRepository.addEditStoreApi(request, storeUuid == null);

    result.when(
      success: (data) async {
        addEditStoreState.success = data;
      },
      failure: (NetworkExceptions error) {
        //String errorMsg = NetworkExceptions.getErrorMessage(error);
        //       showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    addEditStoreState.isLoading = false;
    notifyListeners();
  }

  ///----------------- Upload Image Api------------------------------->
  UIState<CommonResponseModel> uploadStoreImageState = UIState<CommonResponseModel>();

  Future<void> uploadStoreImageApi(BuildContext context, {required String uuid}) async {
    if (selectedImage != null) {
      uploadStoreImageState.isLoading = true;
      uploadStoreImageState.success = null;
      notifyListeners();

      final today = DateTime.now();
      final formattedDate = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}";
      final fileName = 'store_image_$formattedDate.jpeg';


      FormData? formData;
      MultipartFile image = MultipartFile.fromBytes(selectedImage!, filename: fileName, contentType: MediaType('image', 'jpeg'));
      formData = FormData.fromMap({'file': image});

      final result = await storeRepository.uploadStoreImage(formData, uuid);
      result.when(
        success: (data) async {
          uploadStoreImageState.success = data;
        },
        failure: (NetworkExceptions error) {
          //String errorMsg = NetworkExceptions.getErrorMessage(error);
          //       showCommonErrorDialog(context: context, message: errorMsg);
        },
      );

      uploadStoreImageState.isLoading = false;
      notifyListeners();
    }
  }


  ///-----------------------------------------Category data list for name and uuid api --------------------------------------------------------------
  var categoryDataListState = UIState<CategoryDataListResponseModel>();
  List<CategoryDataListDto> categoryList = [];

  Future categoryDataListApi(BuildContext context) async {
    categoryDataListState.isLoading = true;
    categoryDataListState.success = null;
    notifyListeners();

    Map<String,dynamic> request = {
      'activeRecords': true
    };

    final result = await dashboardRepository.categoryDataListApi(jsonEncode(request), 1, pageSize: AppConstants.pageSize10000);

    result.when(success: (data) async {
      categoryDataListState.success = data;
      categoryList.clear();
      categoryList.addAll(categoryDataListState.success?.data ?? []);
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    categoryDataListState.isLoading = false;
    notifyListeners();
  }

}
