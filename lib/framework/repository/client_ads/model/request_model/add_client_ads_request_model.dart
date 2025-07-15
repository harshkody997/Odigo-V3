// To parse this JSON data, do
//
//     final addClientAdsRequestModel = addClientAdsRequestModelFromJson(jsonString);

import 'dart:convert';

AddClientAdsRequestModel addClientAdsRequestModelFromJson(String str) => AddClientAdsRequestModel.fromJson(json.decode(str));

String addClientAdsRequestModelToJson(AddClientAdsRequestModel data) => json.encode(data.toJson());

class AddClientAdsRequestModel {
  String? odigoClientUuid;
  String? name;
  String? adsMediaType;

  AddClientAdsRequestModel({
    this.odigoClientUuid,
    this.name,
    this.adsMediaType,
  });

  factory AddClientAdsRequestModel.fromJson(Map<String, dynamic> json) => AddClientAdsRequestModel(
    odigoClientUuid: json['odigoClientUuid'],
    name: json['name'],
    adsMediaType: json['adsMediaType'],
  );

  Map<String, dynamic> toJson() => {
    'odigoClientUuid': odigoClientUuid,
    'name': name,
    'adsMediaType': adsMediaType,
  };
}
