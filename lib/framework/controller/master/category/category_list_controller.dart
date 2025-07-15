import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/import_export/contract/import_export_repository.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/category/contract/category_repository.dart';
import 'package:odigov3/framework/repository/master/category/model/category_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';


final categoryListController = ChangeNotifierProvider(
      (ref) => getIt<CategoryListController>(),
);

@injectable
class CategoryListController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    categoryList.clear();
    pageNo = 1;
    searchCtr.clear();
    statusTapIndex = -1;
    categoryListState.success = null;
    categoryListState.isLoading = false;
    categoryListState.isLoadMore = false;
    changeCategoryStatusState.isLoading = false;
    changeCategoryStatusState.success = null;
    importCategoryState.isLoading = false;
    sampleFileExportState.isLoading = false;
    fileExportState.isLoading = false;
    fileExportState.success = null;
    importCategoryState.success = null;
    sampleFileExportState.success = null;
    totalCount = null;
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    if (isNotify) {
      notifyListeners();
    }
  }

  clearCategoryList(){
    pageNo = 1;
    categoryListState.success = null;
    categoryListState.isLoading = false;
    categoryListState.isLoadMore = false;
    totalCount = null;
    notifyListeners();
  }

  TextEditingController searchCtr = TextEditingController();
  List<CategoryModel> categoryList = [];
  int pageNo = 1;
  Timer? debounce;
  int statusTapIndex = -1;
  int? totalCount;
  /// Filter key
  GlobalKey filterKey = GlobalKey();


  updateStatusIndex(int value){
    statusTapIndex = value;
    notifyListeners();
  }

  FilePickerResult? filePickerResult;
  Uint8List? fileBytes;

  updateFilePicked(FilePickerResult file){
    filePickerResult = file;
    fileBytes = filePickerResult?.files.first.bytes;
    notifyListeners();
  }

  clearFileData(){
    importCategoryState.isLoading = false;
    sampleFileExportState.isLoading = false;
    fileExportState.isLoading = false;
    fileExportState.success = null;
    importCategoryState.success = null;
    sampleFileExportState.success = null;
    filePickerResult = null;
    fileBytes = null;
    notifyListeners();
  }

  CommonEnumTitleValueModel? selectedFilter = commonActiveDeActiveList[0];
  CommonEnumTitleValueModel? selectedTempFilter = commonActiveDeActiveList[0];
  updateTempSelectedStatus(CommonEnumTitleValueModel? value){
    selectedTempFilter = value;
    notifyListeners();
  }

  updateSelectedStatus(CommonEnumTitleValueModel? value){
    selectedFilter = value;
    notifyListeners();
  }

  resetFilter(){
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    notifyListeners();
  }

  bool get isFilterSelected => selectedFilter != selectedTempFilter;

  bool get isClearFilterCall => (selectedFilter == selectedTempFilter && selectedTempFilter != commonActiveDeActiveList[0]);

  bool get isFilterApplied => selectedFilter != null && selectedFilter != commonActiveDeActiveList[0];


/*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  CategoryRepository categoryRepository;
  ImportExportRepository importExportRepository;
  CategoryListController(this.categoryRepository,this.importExportRepository);

  /// category list api
  UIState<CategoryListResponseModel> categoryListState = UIState<CategoryListResponseModel>();
  Future<UIState<CategoryListResponseModel>> getCategoryListAPI(BuildContext context,{bool pagination = false, int? pageSize,bool? activeRecords,String? stateUuid, String? searchKeyword}) async {
    if((categoryListState.success?.hasNextPage ?? false) && pagination){
      pageNo = pageNo + 1;
    }

    if (pageNo == 1) {
      categoryListState.isLoading = true;
      categoryList.clear();
    } else {
      categoryListState.isLoadMore = true;
    }
    categoryListState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {
      'searchKeyword':searchKeyword ?? searchCtr.text,
      'activeRecords':activeRecords,
    };
    final result = await categoryRepository.getCategoryListAPI(pageNo, pageSize ?? AppConstants.pageSize,jsonEncode(request));

    result.when(
      success: (data) async {
        categoryListState.success = data;
        categoryList.addAll(categoryListState.success?.data ?? []);
        totalCount = categoryListState.success?.totalCount;
        categoryListState.isLoading = false;
        categoryListState.isLoadMore = false;
      },
      failure: (NetworkExceptions error) {
        categoryListState.isLoading = false;
        categoryListState.isLoadMore = false;
      },
    );
    categoryListState.isLoading = false;
    categoryListState.isLoadMore = false;
    notifyListeners();
    return categoryListState;
  }


  /// change category status api
  UIState<CommonResponseModel> changeCategoryStatusState = UIState<CommonResponseModel>();
  Future changeCategoryStatusAPI(BuildContext context,String uuid,bool status,int index) async {
    changeCategoryStatusState.isLoading = true;
    changeCategoryStatusState.success = null;
    notifyListeners();

    final result = await categoryRepository.changeCategoryStatusApi(uuid,status);

    result.when(
      success: (data) async {
        notifyListeners();
        changeCategoryStatusState.isLoading = false;
        changeCategoryStatusState.success = data;
        if(changeCategoryStatusState.success?.status == ApiEndPoints.apiStatus_200){
          categoryList[index].active = status;
        }
      },
      failure: (NetworkExceptions error) {
        changeCategoryStatusState.isLoading = false;
      },
    );
    changeCategoryStatusState.isLoading = false;
    notifyListeners();
  }

  UIState sampleFileExportState = UIState();

  ///Export Sample File
  Future<void> sampleExportMethod({required String? fileName,required BuildContext context}) async {
    sampleFileExportState.isLoading = true;
    notifyListeners();
    ApiResult apiResult = await importExportRepository.exportSample(endPoint: ApiEndPoints.sampleCategory);
    apiResult.when(success: (bytes) {
      try {
        final blob = html.Blob(
          [
            bytes.data,
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
          ],
        );
        final urls = html.Url.createObjectUrlFromBlob(blob);
        final anchor =
        html.document.createElement('a') as html.AnchorElement
          ..href = urls
          ..style.display = 'none'
          ..download = 'Sample_${fileName}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
        html.document.body!.children.add(anchor);
        // download
        anchor.click();
        // cleanup
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(urls);
        sampleFileExportState.isLoading = false;
        Future.delayed(Duration(seconds: 2));
        showToast(context: context,isSuccess:true,message:LocaleKeys.keySampleFileDownloadSuccessMsg.localized,showAtBottom: true);
      } catch (e) {
        if(context.mounted){
          showToast(context: context,isSuccess:false,message:LocaleKeys.keySomeThingWentWrong.localized,);
        }
      }
    },
      failure: (error) {
        sampleFileExportState.isLoading = false;
      },);
    notifyListeners();
  }

  UIState fileExportState = UIState();
  ///Export File
  Future<void> fileExportMethod({required String? fileName, required BuildContext context}) async {
    fileExportState.isLoading = true;

    Map<String, dynamic> requestModel = {
      'searchKeyword': searchCtr.text,
    };
    final  request = jsonEncode(requestModel);
    ApiResult apiResult = await importExportRepository.exportApi(request: request,endPoint: ApiEndPoints.categoryExport);
    apiResult.when(success: (bytes) {
      try {
        final blob = html.Blob(
          [
            bytes.data,
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
          ],
        );
        final urls = html.Url.createObjectUrlFromBlob(blob);
        final anchor =
        html.document.createElement('a') as html.AnchorElement
          ..href = urls
          ..style.display = 'none'
          ..download = '${fileName}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
        html.document.body!.children.add(anchor);
        // download
        anchor.click();
        // cleanup
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(urls);
        fileExportState.isLoading = false;
        showToast(context: context,isSuccess:true,message:LocaleKeys.keyFileExportedSuccessMsg.localized,showAtBottom: true);
      } catch (e) {
        if(context.mounted){
          showToast(context: context,isSuccess:false,message:LocaleKeys.keySomeThingWentWrong.localized);
        }
      }
    },
      failure: (error) {
        fileExportState.isLoading = false;
      },);
    notifyListeners();
  }


  UIState<CommonResponseModel> importCategoryState = UIState<CommonResponseModel>();

  Future<void> importTicketReasonApi(BuildContext context,{required Uint8List document,required String? fileName}) async {

    importCategoryState.isLoading = true;
    importCategoryState.success = null;
    notifyListeners();
    FormData? formData;

    MultipartFile file = MultipartFile.fromBytes(
      document,
      filename: '${fileName}.xlsx',
      contentType: MediaType('file', 'xlsx'),
    );

    formData = FormData.fromMap({
      'file': file,
    });
    final result = await importExportRepository.importApi(formData,endPoint: ApiEndPoints.categoryImport,);
    result.when(success: (bytes) async {
      List<String>? contentType = bytes.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        // Decode Uint8List to String, then to JSON
        try {
          String jsonString = utf8.decode(bytes.data);
          CommonResponseModel response = commonResponseModelFromJson(jsonString);

          importCategoryState.isLoading = false;
        } catch (e) {
          importCategoryState.isLoading = false;
          return const ApiResult.failure(
            error: NetworkExceptions.defaultError('Invalid JSON response'),
          );
        }
      } else {
        if (context.mounted) Navigator.pop(context);

        try {
          final blob = html.Blob(
            [
              bytes.data,
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            ],
          );
          final urls = html.Url.createObjectUrlFromBlob(blob);
          final anchor =
          html.document.createElement('a') as html.AnchorElement
            ..href = urls
            ..style.display = 'none'
            ..download = '${fileName}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
          html.document.body!.children.add(anchor)
          ;
          // download
          anchor.click();
          // cleanup
          html.document.body!.children.remove(anchor)
          ;
          html.Url.revokeObjectUrl(urls);
          importCategoryState.isLoading = false;
          Future.delayed(Duration(seconds: 2));
          showToast(context: context,isSuccess:true,message:LocaleKeys.keyFileImportedSuccessMsg.localized,showAtBottom: true);
          clearCategoryList();
          getCategoryListAPI(context);
        } catch (e) {
          if(context.mounted){
            showToast(context: context,isSuccess:false,message:LocaleKeys.keySomeThingWentWrong.localized,);
          }
        }
      }
    },
      failure: (error) {
        importCategoryState.isLoading = false;
      },);
    notifyListeners();

  }




}
