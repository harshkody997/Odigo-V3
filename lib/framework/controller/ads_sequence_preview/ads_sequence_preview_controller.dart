import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/ads_sequence/contract/ads_sequence_repository.dart';
import 'package:odigov3/framework/repository/ads_sequence/model/ads_sequence_preview_list_response_model.dart';
import 'package:odigov3/framework/repository/ads_sequence/model/update_ads_sequence_request_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import '../../dependency_injection/inject.dart';


final adsSequencePreviewController = ChangeNotifierProvider(
      (ref) => getIt<AdsSequencePreviewController>(),
);

@injectable
class AdsSequencePreviewController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = true}) {
    selectDestinationCtr.clear();
    selectedDestination = null;
    isReArrangeableEnable = false;
    sequencePreviewList = [];
    reOrderSequencePreviewList = [];
    if (isNotify) {
      notifyListeners();
    }
  }

  /// TextEditing Controllers
  TextEditingController selectDestinationCtr = TextEditingController();

  /// Selected destination
  DestinationData? selectedDestination;
  /// update destination selection
  void updateSelectedDestination(DestinationData? selectedDestination) {
    this.selectedDestination = selectedDestination;
    selectDestinationCtr.text = selectedDestination?.name ?? '';
    notifyListeners();
  }

  /// Re - Arrangeable status
  bool isReArrangeableEnable = false;
  void updateReArrangeableStatus(bool value){
    isReArrangeableEnable = value;
    notifyListeners();
  }


  /// Sequence Preview list
  List<SequencePreviewDto> sequencePreviewList = [];

  /// Reordered Sequence list
  List<SequencePreviewDto> reOrderSequencePreviewList = [];

  /// re-order previre list
  void reorderPreviewList(int oldIndex, int newIndex) {
    final item = reOrderSequencePreviewList.removeAt(oldIndex);
    reOrderSequencePreviewList.insert(newIndex>oldIndex?newIndex-1:newIndex, item);
    notifyListeners();
  }

  /// Scroll Controller
  ScrollController scrollController = ScrollController();

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  AdsSequenceRepository adsSequenceRepository;
  AdsSequencePreviewController(this.adsSequenceRepository);

  /// Sequence Preview List API
  UIState<AdsSequencePreviewListResponseModel> sequencePreviewListState = UIState<AdsSequencePreviewListResponseModel>();
  Future<void> adsSequencePreviewListApi() async {
    sequencePreviewList = [];
    reOrderSequencePreviewList = [];
    sequencePreviewListState.isLoading = true;
    sequencePreviewListState.success = null;
    notifyListeners();

    final result = await adsSequenceRepository.previewAdsSequenceListApi((Session.getEntityType() != RoleType.DESTINATION.name) && (Session.getEntityType() != RoleType.DESTINATION_USER.name)?selectedDestination?.uuid??'':'');
    result.when(success: (data) async {
      sequencePreviewListState.success = data;
      sequencePreviewList.addAll(sequencePreviewListState.success?.data ?? []);
      reOrderSequencePreviewList.addAll(sequencePreviewListState.success?.data ?? []);
    }, failure: (NetworkExceptions error) {});
    sequencePreviewListState.isLoading = false;
    notifyListeners();
  }

  /// Update Sequence api
  UIState<CommonResponseModel> updateSequenceState = UIState<CommonResponseModel>();
  Future<void> updateAdsSequenceApi() async {
    updateSequenceState.isLoading = true;
    updateSequenceState.success = null;
    notifyListeners();

    List<AdsSequencePreviewUpdateDto> updatedSequence= [];
    for(int i = 0;i<reOrderSequencePreviewList.length;i++){
      updatedSequence.add(AdsSequencePreviewUpdateDto(
        uuid: reOrderSequencePreviewList[i].uuid,
        slotNumber:i+1,
      ));
    }

    String request =  updateSequencePreviewRequestModelToJson(UpdateSequencePreviewRequestModel(
      destinationUuid: selectedDestination?.uuid,
      adsSequencePreviewUpdateDtOs: updatedSequence,
    ));

    final result = await adsSequenceRepository.updateAdsSequenceApi(request);
    result.when(success: (data) async {
      updateSequenceState.success = data;
      updatedSequence = [];
    }, failure: (NetworkExceptions error) {});
    updateSequenceState.isLoading = false;
    notifyListeners();
  }
}
