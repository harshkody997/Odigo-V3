// To parse this JSON data, do
//
//     final updatePurchaseAdsRequestModel = updatePurchaseAdsRequestModelFromJson(jsonString);

import 'dart:convert';

UpdatePurchaseAdsRequestModel updatePurchaseAdsRequestModelFromJson(String str) => UpdatePurchaseAdsRequestModel.fromJson(json.decode(str));

String updatePurchaseAdsRequestModelToJson(UpdatePurchaseAdsRequestModel data) => json.encode(data.toJson());

class UpdatePurchaseAdsRequestModel {
  String? uuid;
  List<String>? adsUuids;

  UpdatePurchaseAdsRequestModel({
    this.uuid,
    this.adsUuids,
  });

  factory UpdatePurchaseAdsRequestModel.fromJson(Map<String, dynamic> json) => UpdatePurchaseAdsRequestModel(
    uuid: json['uuid'],
    adsUuids: json['adsUuids'] == null ? [] : List<String>.from(json['adsUuids']!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'adsUuids': adsUuids == null ? [] : List<dynamic>.from(adsUuids!.map((x) => x)),
  };
}
