import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/api_result.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/import_export/contract/import_export_repository.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/device/contract/device_repositiry.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/repository/device/model/device_list_model.dart';
import 'package:odigov3/framework/repository/device/model/device_list_request_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'dart:html' as html;
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';



final deviceController = ChangeNotifierProvider(
      (ref) => getIt<DeviceController>(),
);

@injectable
class DeviceController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool? isNotify}) {
    devicesList.clear();
    deviceListState.isLoading = true;
    pageNo = 1;
    deviceListState.isLoading = true;
    deviceListState.isLoadMore = false;
    deviceListState.success = null;
    updateDeviceState.success = null;
    updateDeviceState.isLoading = false;
    deleteDeviceState.success = null;
    deleteDeviceState.isLoading = false;
    selectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null) ;
    tempSelectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null) ;
    tempSelectedAvailability = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null) ;
    selectedAvailabilityStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null) ;
    searchCtr.clear();
    if (isNotify??false) {
      notifyListeners();
    }
  }


  /// Device list
  List<DeviceData>  devicesList = [];


  /// Search Controller
  TextEditingController searchCtr = TextEditingController();

  /// page no
  int pageNo = 1;

  /// Filter key
  GlobalKey filterKey = GlobalKey();


  /// filters
  CommonEnumTitleValueModel tempSelectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  CommonEnumTitleValueModel tempSelectedAvailability= CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  CommonEnumTitleValueModel selectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  CommonEnumTitleValueModel selectedAvailabilityStatus =CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);

  /// update temp status filter
  void changeTempSelectedStatus(CommonEnumTitleValueModel value){
    tempSelectedStatus = value;
    notifyListeners();
  }

  /// update temp availability filter
  void changeTempSelectedAvailability(CommonEnumTitleValueModel value){
    tempSelectedAvailability = value;
    notifyListeners();
  }

  /// Apply filters
  void applyFilters(){
     selectedStatus = tempSelectedStatus;
     selectedAvailabilityStatus = tempSelectedAvailability;
    notifyListeners();
  }

  /// Prefill selected filters
  void prefillFilters(){
    tempSelectedStatus = selectedStatus;
    tempSelectedAvailability = selectedAvailabilityStatus;
  }

  /// Clear filters
  void clearFilters(){
    tempSelectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    tempSelectedAvailability = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    selectedAvailabilityStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    selectedStatus = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  }

  /// Availability filter list
  List<CommonEnumTitleValueModel> availabilityStatusList = [
    CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null),
    CommonEnumTitleValueModel(title: LocaleKeys.keyAvailable,value: true),
    CommonEnumTitleValueModel(title: LocaleKeys.keyAssigned, value: false),
  ];

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  DeviceRepository deviceRepository;
  ImportExportRepository importExportRepository;
  DeviceController(this.deviceRepository,this.importExportRepository);


  /// Device List API
  UIState<DeviceListResponseModel> deviceListState = UIState<DeviceListResponseModel>();
  Future<void> deviceListApi(bool pagination, {bool? inStock, bool? isActive,String? destinationUuid}) async {

    if ((deviceListState.success?.hasNextPage ?? false) && pagination) {
      pageNo = pageNo + 1;
    }

    if (!pagination) {
      pageNo = 1;
      deviceListState.isLoading = true;
      devicesList.clear();
    } else {
      deviceListState.isLoadMore = true;
      deviceListState.success = null;
    }

    notifyListeners();

    String request = deviceListRequestModelToJson(DeviceListRequestModel(
      searchKeyword: searchCtr.text,
      inStock: selectedAvailabilityStatus.value,
      activeRecords: selectedStatus.value,
      destinationUuid : destinationUuid ?? null,
      isArchive: false,
    ));

    final result = await deviceRepository.deviceListApi(request,pageNo);
    result.when(success: (data) async {
      deviceListState.success = data;
      devicesList.addAll(deviceListState.success?.data ?? []);
    }, failure: (NetworkExceptions error) {
    });
    deviceListState.isLoading = false;
    deviceListState.isLoadMore = false;
    notifyListeners();
  }
  ///Update Device Status
  UIState<CommonResponseModel> updateDeviceState = UIState<CommonResponseModel>();
  int deviceUpdatingIndex = -1;
  Future<void> updateDeviceStatusApi({required String deviceUuid, required bool status}) async {
    updateDeviceState.success = null;
    updateDeviceState.isLoading = true;
    deviceUpdatingIndex = devicesList.indexWhere((element) => element.uuid == deviceUuid);
    notifyListeners();
    final result = await deviceRepository.updateStatusDeviceApi(deviceUuid,status);
    result.when(success: (data) async {
      updateDeviceState.success = data;
      devicesList.where((element) => element.uuid == deviceUuid).firstOrNull?.active = status;
    }, failure: (NetworkExceptions error) {
    });
    updateDeviceState.isLoading = false;
    notifyListeners();
  }

  /// Delete device
  UIState<CommonResponseModel> deleteDeviceState = UIState<CommonResponseModel>();
  Future<void> deleteDeviceApi({required String deviceUuid}) async {
    deleteDeviceState.isLoading = true;
    deleteDeviceState.success = null;
    notifyListeners();
    final result = await deviceRepository.deleteDeviceApi(deviceUuid);
    result.when(success: (data) async {
      deleteDeviceState.success = data;
      deviceListApi(false);
    }, failure: (NetworkExceptions error) {
    });
    updateDeviceState.isLoading = false;
    notifyListeners();
  }


  ///Export Device
  UIState deviceExportState = UIState();
  Future<void> exportDeviceApi(BuildContext context) async {
    deviceExportState.isLoading = true;
    notifyListeners();
    String request = deviceListRequestModelToJson(DeviceListRequestModel(
      searchKeyword: searchCtr.text,
      inStock: selectedAvailabilityStatus.value,
      activeRecords: selectedStatus.value,
      isArchive: false,
    ));
    ApiResult apiResult = await importExportRepository.exportApi(request: request,endPoint: ApiEndPoints.exportDevices);
    apiResult.when(
      success: (bytes) {
      try {
        final blob = html.Blob(
          [
            bytes.data,
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
          ],
        );
        final urls = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = urls
          ..style.display = 'none'
          ..download = '${'devices'}_${DateTime.now()}.xlsx';
        html.document.body!.children.add(anchor);
        anchor.click();
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(urls);
        Future.delayed(Duration(seconds: 2));
        showToast(context: context,isSuccess:true,message:LocaleKeys.keyFileExportedSuccessMsg.localized,showAtBottom: true);
      } catch (e) {
        if(context.mounted){
          showToast(context: context,isSuccess:false,message:LocaleKeys.keySomeThingWentWrong.localized);
        }
      }
    },
      failure: (error) {},);
    deviceExportState.isLoading = false;
    notifyListeners();
  }

  GlobalKey robotDetailsDialogKey = GlobalKey();

}
