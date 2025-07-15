// To parse this JSON data, do
//
//     final updateDefaultAdsRequestModel = updateDefaultAdsRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateDefaultAdsRequestModel updateDefaultAdsRequestModelFromJson(String str) => UpdateDefaultAdsRequestModel.fromJson(json.decode(str));

String updateDefaultAdsRequestModelToJson(UpdateDefaultAdsRequestModel data) => json.encode(data.toJson());

class UpdateDefaultAdsRequestModel {
  String? uuid;
  String? name;

  UpdateDefaultAdsRequestModel({
    this.uuid,
    this.name,
  });

  factory UpdateDefaultAdsRequestModel.fromJson(Map<String, dynamic> json) => UpdateDefaultAdsRequestModel(
    uuid: json['uuid'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
  };
}
