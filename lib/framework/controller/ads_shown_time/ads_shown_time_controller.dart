import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/ads_shown_time/contract/ads_show_time_repository.dart';
import 'package:odigov3/framework/repository/ads_shown_time/model/ads_shown_time_request_model.dart';
import 'package:odigov3/framework/repository/ads_shown_time/model/ads_shown_time_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/repository/import_export/contract/import_export_repository.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'dart:html' as html;

import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';


final adsShownTimeController = ChangeNotifierProvider(
      (ref) => getIt<AdsShownTimeController>(),
);

@injectable
class AdsShownTimeController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = true}) {
    selectDestinationCtr.clear();
    selectedDestination = null;
    adsShownTimeList = [];
    searchCtr.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  /// Filter key
  GlobalKey filterKey = GlobalKey();

  /// TextEditing Controllers
  TextEditingController selectDestinationCtr = TextEditingController();
  TextEditingController searchCtr = TextEditingController();

  /// Selected destination
  DestinationData? selectedDestination;
  /// update destination selection
  void updateSelectedDestination(DestinationData? selectedDestination) {
    this.selectedDestination = selectedDestination;
    selectDestinationCtr.text = selectedDestination?.name ?? '';
    notifyListeners();
  }



  /// Scroll Controller
  ScrollController scrollController = ScrollController();



  /// Purchase Type Status Filter list
  List<CommonEnumTitleValueModel> purchaseTypeList = [
    CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null),
    CommonEnumTitleValueModel(title: LocaleKeys.keyPremium,value: PurchaseType.PREMIUM.name),
    CommonEnumTitleValueModel(title: LocaleKeys.keyFiller, value: PurchaseType.FILLER.name)
  ];

  /// Filter objects
  CommonEnumTitleValueModel selectedPurchaseType = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
  CommonEnumTitleValueModel tempSelectedPurchaseType =CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);

  /// update Purchase Type filter
  void changePurchaseTypeSelectedStatus(CommonEnumTitleValueModel value){
    tempSelectedPurchaseType = value;
    notifyListeners();
  }

  /// Apply filter
  void applyFilters(){
    selectedStartDate = tempSelectedStartDate;
    selectedEndDate = tempSelectedEndDate;
    selectedPurchaseType=tempSelectedPurchaseType;
    notifyListeners();
  }

  /// Prefill selected filters
  void prefillFilters(){
    dateController.clear();
    tempSelectedStartDate = selectedStartDate;
    tempSelectedEndDate = selectedEndDate;
    tempSelectedPurchaseType=selectedPurchaseType;
    dateController.text = formatDateRange([tempSelectedStartDate, tempSelectedEndDate]);
  }

  /// Clear filters
  void clearFilters(){
    selectedPurchaseType = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    tempSelectedPurchaseType = CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null);
    selectedStartDate = null;
    selectedEndDate = null;
    tempSelectedEndDate = null;
    tempSelectedStartDate = null;
    dateController.clear();
  }

  /// date filter controller
  TextEditingController dateController = TextEditingController();

  ///Start Date
  DateTime? selectedStartDate;
  DateTime? tempSelectedStartDate;

  ///End Date
  DateTime? selectedEndDate;
  DateTime? tempSelectedEndDate;

  ///Change Selected Date value
  changeDateValue(List<DateTime?> value) {
    ///Set Start Date
    tempSelectedStartDate = value.first;

    ///Set End Date
    tempSelectedEndDate = value.last;

    ///Set value in dateController to show in field like 13 Mar,2025 - 16 Mar,2025
    dateController.text = formatDateRange([tempSelectedStartDate, tempSelectedEndDate]);
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  AdsShowTimeRepository adsShownTimeRepository;
  final ImportExportRepository importExportRepository;

  AdsShownTimeController(this.adsShownTimeRepository,this.importExportRepository);

  var adsShownTimeListState = UIState<AdsShownTimeListResponseModel>();
  List<AdsShownTime> adsShownTimeList =[];

  Future<void> adsShownTimeListApi(BuildContext context, {bool isForPagination = false, String? searchKeyword, int? pageSize}) async {
    int pageNo = 1;
    bool apiCall = true;
    if(!isForPagination){
      pageNo = 1;
      adsShownTimeList.clear();
      adsShownTimeListState.isLoading = true;
      adsShownTimeListState.success = null;
    }
    else if(adsShownTimeListState.success?.hasNextPage ?? false){
      pageNo = (adsShownTimeListState.success?.pageNumber ?? 0) + 1;
      adsShownTimeListState.isLoadMore = true;
      adsShownTimeListState.success = null;
    }
    else{
      apiCall = false;
    }
    notifyListeners();

    if(apiCall) {
      String request = adsShownTimeListRequestModelToJson(AdsShownTimeListRequestModel(
          searchKeyword: searchKeyword,
          destinationUuid: selectedDestination?.uuid,
          purchaseType: selectedPurchaseType.value,
          fromDate:selectedStartDate != null?DateFormat('yyyy-MM-dd').format(selectedStartDate!).toString(): null ,
          toDate:selectedEndDate != null?DateFormat('yyyy-MM-dd').format(selectedEndDate!).toString(): null
      ));

      final result = await adsShownTimeRepository.adsShownTimeListApi(request: request, pageNumber: pageNo);

      result.when(success: (data) async {
        adsShownTimeListState.success = data;
        adsShownTimeList.addAll(adsShownTimeListState.success?.data ?? []);
      }, failure: (NetworkExceptions error) {

      });

      adsShownTimeListState.isLoading = false;
      adsShownTimeListState.isLoadMore = false;
      notifyListeners();
    }
  }

  UIState exportAdsShownTimeState = UIState();

  ///Export File
  Future<void> exportAdsShownTimeApi({required String? fileName, required BuildContext context}) async {
    exportAdsShownTimeState.isLoading = true;

    String request = adsShownTimeListRequestModelToJson(AdsShownTimeListRequestModel(
        searchKeyword: searchCtr.text,
        destinationUuid: selectedDestination?.uuid,
        purchaseType: selectedPurchaseType.value,
        fromDate:selectedStartDate != null?DateFormat('yyyy-MM-dd').format(selectedStartDate!).toString(): null ,
        toDate:selectedEndDate != null?DateFormat('yyyy-MM-dd').format(selectedEndDate!).toString(): null
    ));
    ApiResult apiResult = await importExportRepository.exportApi(request: request,endPoint: ApiEndPoints.exportAdsShownTime);
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
        exportAdsShownTimeState.isLoading = false;
        Future.delayed(Duration(seconds: 2));
        showToast(context: context,isSuccess:true,message:LocaleKeys.keyFileExportedSuccessMsg.localized,showAtBottom: true);
      } catch (e) {
        if(context.mounted){
          showToast(context: context,isSuccess:false,message:LocaleKeys.keySomeThingWentWrong.localized);
        }
      }
    },
      failure: (error) {},);
    exportAdsShownTimeState.isLoading = false;
    notifyListeners();
  }




}
