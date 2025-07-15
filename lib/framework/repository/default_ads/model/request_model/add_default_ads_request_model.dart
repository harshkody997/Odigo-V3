// To parse this JSON data, do
//
//     final addDefaultAdsRequestModel = addDefaultAdsRequestModelFromJson(jsonString);

import 'dart:convert';

AddDefaultAdsRequestModel addDefaultAdsRequestModelFromJson(String str) => AddDefaultAdsRequestModel.fromJson(json.decode(str));

String addDefaultAdsRequestModelToJson(AddDefaultAdsRequestModel data) => json.encode(data.toJson());

class AddDefaultAdsRequestModel {
  String? destinationUuid;
  String? name;
  String? adsMediaType;

  AddDefaultAdsRequestModel({
    this.destinationUuid,
    this.name,
    this.adsMediaType,
  });

  factory AddDefaultAdsRequestModel.fromJson(Map<String, dynamic> json) => AddDefaultAdsRequestModel(
    destinationUuid: json['destinationUuid'],
    name: json['name'],
    adsMediaType: json['adsMediaType'],
  );

  Map<String, dynamic> toJson() => {
    'destinationUuid': destinationUuid,
    'name': name,
    'adsMediaType': adsMediaType,
  };
}
