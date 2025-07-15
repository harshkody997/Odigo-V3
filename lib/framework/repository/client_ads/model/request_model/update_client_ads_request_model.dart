// To parse this JSON data, do
//
//     final updateClientAdsRequestModel = updateClientAdsRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateClientAdsRequestModel updateClientAdsRequestModelFromJson(String str) => UpdateClientAdsRequestModel.fromJson(json.decode(str));

String updateClientAdsRequestModelToJson(UpdateClientAdsRequestModel data) => json.encode(data.toJson());

class UpdateClientAdsRequestModel {
  String? uuid;
  String? name;

  UpdateClientAdsRequestModel({
    this.uuid,
    this.name,
  });

  factory UpdateClientAdsRequestModel.fromJson(Map<String, dynamic> json) => UpdateClientAdsRequestModel(
    uuid: json["uuid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
  };
}
