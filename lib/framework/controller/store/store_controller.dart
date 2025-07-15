import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/import_export/contract/import_export_repository.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/store/contract/store_repository.dart';
import 'package:odigov3/framework/repository/store/model/request_model/store_list_request_model.dart';
import 'package:odigov3/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'dart:html' as html;

import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

final storeController = ChangeNotifierProvider(
      (ref) => getIt<StoreController>(),
);

@injectable
class StoreController extends ChangeNotifier {
  StoreController(this.storeRepository,this.importExportRepository);
  final StoreRepository storeRepository;
  final ImportExportRepository importExportRepository;


  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    storeListState.isLoading = true;
    storeListState.success = null;
    storeList.clear();
    changeStoreStatusState.success = null;
    changeStoreStatusState.isLoading = false;
    statusTapIndex = -1;
    searchCtr.clear();
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    if (isNotify) {
      notifyListeners();
    }
  }

  disposeStoreDestinationController(){
    storeListState.isLoading = true;
    storeListState.success = null;
    storeList.clear();
    notifyListeners();
  }

  int statusTapIndex = -1;

  updateStatusIndex(int value){
    statusTapIndex = value;
    notifyListeners();
  }

  void notify(){
    notifyListeners();
  }

  /// Search Controller
  TextEditingController searchCtr = TextEditingController();
  /// Filter key
  GlobalKey filterKey = GlobalKey();

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

  /// ----------------------------------------------- Api Integration ----------------------------------------------------///

  ///-----------------Store List Api------------------------------->
  var storeListState = UIState<StoreListResponseModel>();
  List<StoreData?> storeList =[];

  Future<UIState<StoreListResponseModel>> storeListApi(BuildContext context, {bool isForPagination = false, String? searchKeyword, int? pageSize, bool? activeRecords, String? categoryUuid}) async {
    int pageNo = 1;
    bool apiCall = true;
    if(!isForPagination){
      pageNo = 1;
      storeList.clear();
      storeListState.isLoading = true;
      storeListState.success = null;
    }
    else if(storeListState.success?.hasNextPage ?? false){
      pageNo = (storeListState.success?.pageNumber ?? 0) + 1;
      storeListState.isLoadMore = true;
      storeListState.success = null;
    }
    else{
      apiCall = false;
    }
    notifyListeners();

    if(apiCall) {
      String request = storeListRequestModelToJson(StoreListRequestModel(
        searchKeyword: searchKeyword,
        activeRecords: activeRecords ?? selectedFilter?.value,
        categoryUuids: categoryUuid!=null ? [categoryUuid] : null
      ));

      final result = await storeRepository.storeListApi(request: request, pageNumber: pageNo, dataSize: pageSize ?? AppConstants.pageSize);

      result.when(success: (data) async {
        storeListState.success = data;
        storeList.addAll(storeListState.success?.data ?? []);
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      });

      storeListState.isLoading = false;
      storeListState.isLoadMore = false;
      notifyListeners();
    }
    return storeListState;

  }

///-----------------Change Store Status Api------------------------------->
  var changeStoreStatusState = UIState<CommonResponseModel>();

  Future<void> changeStoreStatusApi(BuildContext context, {required String storeUuid, required bool isActive, required int index}) async {
    changeStoreStatusState.isLoading = true;
    changeStoreStatusState.success = null;
    notifyListeners();

    final result = await storeRepository.changeStoreStatusApi(storeUuid: storeUuid, isActive: isActive);

    result.when(success: (data) async {
      changeStoreStatusState.success = data;
      if(changeStoreStatusState.success?.status == ApiEndPoints.apiStatus_200) {
        storeList[index]?.active = isActive;
      }
    },
        failure: (NetworkExceptions error) {
          //String errorMsg = NetworkExceptions.getErrorMessage(error);
          //       showCommonErrorDialog(context: context, message: errorMsg);
        });

    changeStoreStatusState.isLoading = false;
    notifyListeners();
  }

  Future<List<int>> generateFloorList(String floorValue) async {
    final number = int.tryParse(floorValue) ?? 0;
    final list = List.generate(number, (index) => index + 1);
    return list;
  }



  FilePickerResult? filePickerResult;
  Uint8List? fileBytes;

  updateFilePicked(FilePickerResult file){
    filePickerResult = file;
    fileBytes = filePickerResult?.files.first.bytes;
    notifyListeners();
  }

  clearFileData(){
    filePickerResult = null;
    fileBytes = null;
    notifyListeners();
  }

  ///-----------------Import Store Api------------------------------->
  UIState<CommonResponseModel> importStoreState = UIState<CommonResponseModel>();
  Future<void> importStoreApi(BuildContext context,{required Uint8List document,required String? fileName}) async {

    importStoreState.isLoading = true;
    importStoreState.success = null;
    notifyListeners();
    FormData? formData;
    // Uint8List? companyImage = DynamicForm.dynamicForm.getImageFromFieldName(editCompanyFormState.success?.data, 'companyImage');

    MultipartFile file = MultipartFile.fromBytes(
      document,
      filename: 'store.xlsx',
      contentType: MediaType('file', 'xlsx'),
    );

    formData = FormData.fromMap({
      'file': file,
    });
    final result = await importExportRepository.importApi(formData,endPoint: ApiEndPoints.importStore);
    result.when(success: (bytes) async {


      List<String>? contentType = bytes.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        // Decode Uint8List to String, then to JSON
        try {
          String jsonString = utf8.decode(bytes.data);
          CommonResponseModel response = commonResponseModelFromJson(jsonString);

          importStoreState.isLoading = false;
        } catch (e) {
          importStoreState.isLoading = false;
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
          importStoreState.isLoading = false;
          Future.delayed(Duration(seconds: 2));
          showToast(context: context,isSuccess:true,message:LocaleKeys.keyFileImportedSuccessMsg.localized);
        } catch (e) {
          if(context.mounted){
            showToast(context: context,isSuccess:false,message:LocaleKeys.keySomeThingWentWrong.localized);
          }
        }
      }
    },
      failure: (error) {},);

    importStoreState.isLoading = false;
    notifyListeners();

  }

  UIState exportStoreState = UIState();

  ///Export File
  Future<void> exportStoreApi({required String? fileName, required BuildContext context}) async {
    exportStoreState.isLoading = true;

    Map<String, dynamic> requestModel = {
      'searchKeyword': searchCtr.text,
    };
    final  request = jsonEncode(requestModel);
    ApiResult apiResult = await importExportRepository.exportApi(request: request,endPoint: ApiEndPoints.exportStore);
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
        exportStoreState.isLoading = false;
        Future.delayed(Duration(seconds: 2));
        showToast(context: context,isSuccess:true,message:LocaleKeys.keyFileExportedSuccessMsg.localized,showAtBottom: true);
      } catch (e) {
        if(context.mounted){
          showToast(context: context,isSuccess:false,message:LocaleKeys.keySomeThingWentWrong.localized);
        }
      }
    },
      failure: (error) {},);
    exportStoreState.isLoading = false;
    notifyListeners();
  }


  UIState storeSampleDownloadState = UIState();

  ///Export Sample File
  Future<void> storeSampleDownloadApi({required String? fileName,required BuildContext context}) async {
    storeSampleDownloadState.isLoading = true;
    notifyListeners();
    ApiResult apiResult = await importExportRepository.exportSample(endPoint: ApiEndPoints.sampleStore);
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
        storeSampleDownloadState.isLoading = false;
        Future.delayed(Duration(seconds: 2));
        showToast(context: context,isSuccess:true,message:LocaleKeys.keySampleFileDownloadSuccessMsg.localized,showAtBottom: true);
      } catch (e) {
        if(context.mounted){
          showToast(context: context,isSuccess:false,message:LocaleKeys.keySomeThingWentWrong.localized,);
        }
      }
    },
      failure: (error) {},);
    notifyListeners();
  }


}

