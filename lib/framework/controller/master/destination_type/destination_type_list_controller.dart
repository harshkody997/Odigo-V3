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
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/import_export/contract/import_export_repository.dart';
import 'package:odigov3/framework/repository/master/destination_type/contract/destination_type_repository.dart';
import 'package:odigov3/framework/repository/master/destination_type/model/destination_type_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'dart:html' as html;

import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

final destinationTypeListController = ChangeNotifierProvider((ref) => getIt<DestinationTypeListController>());

@injectable
class DestinationTypeListController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    searchCtr.clear();
    statusTapIndex = -1;
    destinationTypeList.clear();
    destinationTypeListState.success = null;
    destinationTypeListState.isLoading = false;
    destinationTypeListState.isLoadMore = false;
    changeDestinationStatusState.isLoading = false;
    changeDestinationStatusState.success = null;
    pageNo = 1;
    filePickerResult = null;
    fileBytes = null;
    importDestinationTypeState.isLoading = false;
    sampleFileExportState.isLoading = false;
    fileExportState.isLoading = false;
    fileExportState.success = null;
    importDestinationTypeState.success = null;
    sampleFileExportState.success = null;
    totalCount = null;
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    if (isNotify) {
      notifyListeners();
    }
  }

  clearDestinationTypeList() {
    destinationTypeList.clear();
    destinationTypeListState.success = null;
    destinationTypeListState.isLoading = false;
    destinationTypeListState.isLoadMore = false;
    pageNo = 1;
    totalCount = null;
    notifyListeners();
  }

  TextEditingController searchCtr = TextEditingController();
  Timer? debounce;
  List<DestinationType> destinationTypeList = [];
  int statusTapIndex = -1;
  bool statusValue = false;
  int pageNo = 1;
  int? totalCount;
  /// Filter key
  GlobalKey filterKey = GlobalKey();

  updateStatusIndex(int value) {
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
    filePickerResult = null;
    fileBytes = null;
    importDestinationTypeState.isLoading = false;
    sampleFileExportState.isLoading = false;
    fileExportState.isLoading = false;
    fileExportState.success = null;
    importDestinationTypeState.success = null;
    sampleFileExportState.success = null;
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

  DestinationTypeRepository destinationTypeRepository;
  ImportExportRepository importExportRepository;

  DestinationTypeListController(this.destinationTypeRepository,this.importExportRepository);

  /// destinationType list api
  UIState<DestinationTypeListResponseModel> destinationTypeListState = UIState<DestinationTypeListResponseModel>();

  Future getDestinationTypeListAPI(BuildContext context, {bool pagination = false, int? pageSize, bool? activeRecords}) async {
    if ((destinationTypeListState.success?.hasNextPage ?? false) && pagination) {
      pageNo = pageNo + 1;
    }

    if (pageNo == 1) {
      destinationTypeListState.isLoading = true;
      destinationTypeList.clear();
    } else {
      destinationTypeListState.isLoadMore = true;
    }
    destinationTypeListState.success = null;

    notifyListeners();

    Map<String, dynamic> request = {'searchKeyword': searchCtr.text, 'activeRecords': activeRecords};

    final result = await destinationTypeRepository.getDestinationTypeListApi(pageNo,pageSize ?? AppConstants.pageSize,null,jsonEncode(request));

    result.when(
      success: (data) async {
        destinationTypeListState.success = data;
        destinationTypeList.addAll(destinationTypeListState.success?.data ?? []);
        totalCount = destinationTypeListState.success?.totalCount;
        destinationTypeListState.isLoading = false;
        destinationTypeListState.isLoadMore = false;
      },
      failure: (NetworkExceptions error) {
        destinationTypeListState.isLoading = false;
        destinationTypeListState.isLoadMore = false;
      },
    );
    destinationTypeListState.isLoading = false;
    destinationTypeListState.isLoadMore = false;
    notifyListeners();
  }


  /// change destinationType status api
  UIState<CommonResponseModel> changeDestinationStatusState = UIState<CommonResponseModel>();
  Future changeDestinationStatusAPI(BuildContext context, String uuid, bool status, int index) async {
    changeDestinationStatusState.isLoading = true;
    changeDestinationStatusState.success = null;
    notifyListeners();

    final result = await destinationTypeRepository.changeDestinationTypeStatusApi(uuid, status);

    result.when(
      success: (data) async {
        notifyListeners();
        changeDestinationStatusState.isLoading = false;
        changeDestinationStatusState.success = data;
        if (changeDestinationStatusState.success?.status == ApiEndPoints.apiStatus_200) {
          destinationTypeList[index].active = status;
        }
      },
      failure: (NetworkExceptions error) {
        changeDestinationStatusState.isLoading = false;
      },
    );
    changeDestinationStatusState.isLoading = false;
    notifyListeners();
  }

  UIState<CommonResponseModel> importDestinationTypeState = UIState<CommonResponseModel>();

  Future<void> importTicketReasonApi(BuildContext context,{required Uint8List document,required String? fileName}) async {

    importDestinationTypeState.isLoading = true;
    importDestinationTypeState.success = null;
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
    final result = await importExportRepository.importApi(formData,endPoint: ApiEndPoints.importDestinationType);
    result.when(success: (bytes) async {


      List<String>? contentType = bytes.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        // Decode Uint8List to String, then to JSON
        try {
          String jsonString = utf8.decode(bytes.data);
          CommonResponseModel response = commonResponseModelFromJson(jsonString);

          importDestinationTypeState.isLoading = false;
        } catch (e) {
          importDestinationTypeState.isLoading = false;
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
          importDestinationTypeState.isLoading = false;
          Future.delayed(Duration(seconds: 2));
          showToast(context: context,isSuccess:true,message:LocaleKeys.keyFileImportedSuccessMsg.localized,showAtBottom: true);
          clearDestinationTypeList();
          getDestinationTypeListAPI(context);
        } catch (e) {
          if(context.mounted){
            showToast(context: context,isSuccess:false,message:LocaleKeys.keySomeThingWentWrong.localized);
          }
        }
      }
    },
      failure: (error) {
        importDestinationTypeState.isLoading = false;
      },);
    notifyListeners();

  }

  UIState fileExportState = UIState();

  ///Export File
  Future<void> fileExportMethod({required String? fileName,required BuildContext context}) async {
    fileExportState.isLoading = true;

    Map<String, dynamic> requestModel = {
      'searchKeyword': searchCtr.text,
    };
    final  request = jsonEncode(requestModel);
    ApiResult apiResult = await importExportRepository.exportApi(request: request,endPoint: ApiEndPoints.exportDestinationType,);
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
        Future.delayed(Duration(seconds: 2));
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


  UIState sampleFileExportState = UIState();

  ///Export Sample File
  Future<void> sampleExportMethod({required String? fileName, required BuildContext context}) async {
    sampleFileExportState.isLoading = true;
    notifyListeners();
    ApiResult apiResult = await importExportRepository.exportSample(endPoint: ApiEndPoints.sampleDestinationType);
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
}
