abstract class AdsSequenceRepository{

  /// Ads Sequence Preview List api
  Future previewAdsSequenceListApi(String destinationUuid);

  /// Update Ads Sequence
  Future updateAdsSequenceApi(String request);

  /// Ads Sequence History List Api
  Future adsSequenceHistoryListApi(String request);

}