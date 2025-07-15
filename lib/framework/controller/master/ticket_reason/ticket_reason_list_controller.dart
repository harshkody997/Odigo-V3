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
import 'package:odigov3/framework/repository/master/ticket_reason/contract/ticket_reason_repository.dart';
import 'package:odigov3/framework/repository/master/ticket_reason/model/ticket_reason_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'dart:html' as html;

import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';


final ticketReasonListController = ChangeNotifierProvider(
      (ref) => getIt<TicketReasonListController>(),
);

@injectable
class TicketReasonListController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    searchCtr.clear();
    statusTapIndex = -1;
    pageNo = 1;
    ticketReasonList.clear();
    ticketReasonListState.success = null;
    ticketReasonListState.isLoading = false;
    ticketReasonListState.isLoadMore = false;
    filePickerResult = null;
    fileBytes = null;
    importTicketReasonState.isLoading = false;
    sampleFileExportState.isLoading = false;
    fileExportState.isLoading = false;
    fileExportState.success = null;
    importTicketReasonState.success = null;
    sampleFileExportState.success = null;
    totalCount = null;
    selectedFilter = commonActiveDeActiveList[0];
    selectedTempFilter = commonActiveDeActiveList[0];
    if (isNotify) {
      notifyListeners();
    }
  }

  clearTicketReasonList(){
    pageNo = 1;
    ticketReasonList.clear();
    ticketReasonListState.success = null;
    ticketReasonListState.isLoading = false;
    ticketReasonListState.isLoadMore = false;
    totalCount = null;
    notifyListeners();
  }

  TextEditingController searchCtr = TextEditingController();
  List<TicketReasonModel> ticketReasonList = [];
  int statusTapIndex = -1;
  bool statusValue = false;
  int pageNo = 1;
  Timer? debounce;
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
    filePickerResult = null;
    fileBytes = null;
    importTicketReasonState.isLoading = false;
    sampleFileExportState.isLoading = false;
    fileExportState.isLoading = false;
    fileExportState.success = null;
    importTicketReasonState.success = null;
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
  TicketReasonRepository ticketReasonRepository;
  ImportExportRepository importExportRepository;
  TicketReasonListController(this.ticketReasonRepository,this.importExportRepository);

  /// ticket reason list api
  UIState<TicketReasonListResponseModel> ticketReasonListState = UIState<TicketReasonListResponseModel>();
  Future<UIState<TicketReasonListResponseModel>> getTicketReasonListAPI(BuildContext context,{bool pagination = false, int? pageSize,bool? activeRecords,String? platformType}) async {
    if((ticketReasonListState.success?.hasNextPage ?? false) && pagination){
      pageNo = pageNo + 1;
    }

    if (pageNo == 1) {
      ticketReasonListState.isLoading = true;
      ticketReasonList.clear();
    } else {
      ticketReasonListState.isLoadMore = true;
    }
    ticketReasonListState.success = null;

    notifyListeners();

    Map<String, dynamic> request = {
      'searchKeyword':searchCtr.text,
      'activeRecords':activeRecords,
      'platformType': platformType
    };

    final result = await ticketReasonRepository.getTicketReasonListApi(pageNo, pageSize ?? AppConstants.pageSize,jsonEncode(request));

    result.when(
      success: (data) async {
        ticketReasonListState.success = data;
        ticketReasonList.addAll(ticketReasonListState.success?.data ?? []);
        totalCount = ticketReasonListState.success?.totalCount;
        ticketReasonListState.isLoading = false;
        ticketReasonListState.isLoadMore = false;
      },
      failure: (NetworkExceptions error) {
        ticketReasonListState.isLoading = false;
        ticketReasonListState.isLoadMore = false;
      },
    );
    ticketReasonListState.isLoading = false;
    ticketReasonListState.isLoadMore = false;
    notifyListeners();
    return ticketReasonListState;
  }

  /// change ticket reason status api
  UIState<CommonResponseModel> changeStateStatusState = UIState<CommonResponseModel>();
  Future changeStateStatusAPI(BuildContext context,String uuid,bool status,int index) async {
    changeStateStatusState.isLoading = true;
    changeStateStatusState.success = null;
    notifyListeners();

    final result = await ticketReasonRepository.changeTicketReasonStatusApi(uuid,status);

    result.when(
      success: (data) async {
        notifyListeners();
        changeStateStatusState.isLoading = false;
        changeStateStatusState.success = data;
        if(changeStateStatusState.success?.status == ApiEndPoints.apiStatus_200){
          ticketReasonList[index].active = status;
        }
      },
      failure: (NetworkExceptions error) {
        changeStateStatusState.isLoading = false;
      },
    );
    changeStateStatusState.isLoading = false;
    notifyListeners();
  }

  UIState<CommonResponseModel> importTicketReasonState = UIState<CommonResponseModel>();

  Future<void> importTicketReasonApi(BuildContext context,{required Uint8List document,required String? fileName}) async {

    importTicketReasonState.isLoading = true;
    importTicketReasonState.success = null;
    notifyListeners();
    FormData? formData;
    // Uint8List? companyImage = DynamicForm.dynamicForm.getImageFromFieldName(editCompanyFormState.success?.data, 'companyImage');

    MultipartFile file = MultipartFile.fromBytes(
      document,
      filename: 'ticket_reason.xlsx',
      contentType: MediaType('file', 'xlsx'),
    );

    formData = FormData.fromMap({
      'file': file,
    });
    final result = await importExportRepository.importApi(formData,endPoint: ApiEndPoints.importTicketReason);
    result.when(success: (bytes) async {


      List<String>? contentType = bytes.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        // Decode Uint8List to String, then to JSON
        try {
          String jsonString = utf8.decode(bytes.data);
          // CommonResponseModel response = commonResponseModelFromJson(jsonString);

          importTicketReasonState.isLoading = false;
        } catch (e) {
          importTicketReasonState.isLoading = false;
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
          importTicketReasonState.isLoading = false;
          Future.delayed(Duration(seconds: 2));
          showToast(context: context,isSuccess:true,message:LocaleKeys.keyFileImportedSuccessMsg.localized,showAtBottom: true);
          clearTicketReasonList();
          getTicketReasonListAPI(context);
        } catch (e) {
          if(context.mounted){
            showToast(context: context,isSuccess:false,message:LocaleKeys.keySomeThingWentWrong.localized);
          }
        }
      }
    },
      failure: (error) {
        importTicketReasonState.isLoading = false;
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
    ApiResult apiResult = await importExportRepository.exportApi(request: request,endPoint: ApiEndPoints.exportTicketReason);
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
    ApiResult apiResult = await importExportRepository.exportSample(endPoint: ApiEndPoints.sampleTicketReason);
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
