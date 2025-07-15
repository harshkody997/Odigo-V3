import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/ads_sequence/contract/ads_sequence_repository.dart';
import 'package:odigov3/framework/repository/ads_sequence/model/ads_sequence_history_response_model.dart';
import 'package:odigov3/framework/repository/ads_sequence/model/ads_sequence_preview_list_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';

@LazySingleton(as: AdsSequenceRepository, env: [Env.production, Env.debug])
class AdsSequenceApiRepository implements AdsSequenceRepository{
  final DioClient apiClient;
  AdsSequenceApiRepository(this.apiClient);

  @override
  Future previewAdsSequenceListApi(String destinationUuid)  async{
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getAdsSequencePreview(destinationUuid: destinationUuid));
      AdsSequencePreviewListResponseModel responseModel = adsSequencePreviewListResponseModelFromJson(response.toString());
//       AdsSequencePreviewListResponseModel responseModel = adsSequencePreviewListResponseModelFromJson('''{
//     "message": "ads.sequence.preview.message",
//     "data": [
//         {
//             "uuid": "JDTU-GE4P-FNKN-KXIV",
//             "odigoClientUuid": "S8KX-GAYE-5OS7-RO22",
//             "odigoClientName": "Rashid Rajput",
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": "M63I-N0CT-85I0-Z5JA",
//             "slotType": "PURCHASE",
//             "slotNumber": 1,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "W6V3-AEH9-ZMRP-5YS1",
//             "odigoClientUuid": "U3EZ-06KP-A2RA-3V8G",
//             "odigoClientName": "Smit Patel",
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": "4YJP-4ZGF-INJ9-ZBVV",
//             "slotType": "PURCHASE",
//             "slotNumber": 2,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "VUZI-0476-CGCD-AENP",
//             "odigoClientUuid": "RKRF-HGYU-2UTP-LWEZ",
//             "odigoClientName": "Honey Singh",
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": "CJQJ-YDIS-QC37-3MWM",
//             "slotType": "PURCHASE",
//             "slotNumber": 3,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "C4NE-ENN5-CCJQ-ORJ7",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 4,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "0KMW-IDY1-601S-RYTA",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 5,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "S7L5-D8XF-3CHF-Z396",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 6,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "AYFO-L2RN-YY2T-MS14",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 7,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "I45J-FD86-TXLB-2BRE",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 8,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "COAB-CDG3-T2EC-SQF9",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 9,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "73M1-MOWN-P60K-DXK8",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 10,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "3O04-MK0T-SZ5F-GFXF",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 11,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "XLSY-H0FW-QLOX-Z54G",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 12,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "G0SK-1OHG-IN7O-OZER",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 13,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "N4IP-ZT6N-QOYH-P6QT",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 14,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "B1NI-EKLF-CYII-A27X",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 15,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "FJRC-VE6Y-IULL-PRMW",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 16,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "O3HE-ASIV-9FUT-2P81",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 17,
//             "previewDate": "2025-07-05"
//         },
//         {
//             "uuid": "LNRM-VDWN-UK1C-2K2J",
//             "odigoClientUuid": null,
//             "odigoClientName": null,
//             "destinationUuid": "EJ8H-AT4Z-1U0M-3TGE",
//             "destinationName": "Kody Technolab",
//             "purchaseUuid": null,
//             "slotType": "DEFAULT",
//             "slotNumber": 18,
//             "previewDate": "2025-07-05"
//         }
//     ],
//     "status": 200
// }''');
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future updateAdsSequenceApi(String request) async{
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateAdsSequence, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future adsSequenceHistoryListApi(String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.sequenceHistoryList, request);
      SequenceHistoryListResponseModel responseModel = sequenceHistoryListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}