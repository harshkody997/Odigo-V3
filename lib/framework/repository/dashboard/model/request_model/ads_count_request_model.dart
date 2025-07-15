// To parse this JSON data, do
//
//     final adsCountRequestModel = adsCountRequestModelFromJson(jsonString);

import 'dart:convert';

AdsCountRequestModel adsCountRequestModelFromJson(String str) => AdsCountRequestModel.fromJson(json.decode(str));

String adsCountRequestModelToJson(AdsCountRequestModel data) => json.encode(data.toJson());

class AdsCountRequestModel {
  int? year;
  int? month;
  String? destinationUuid;
  String? odigoClientUuid;

  AdsCountRequestModel({
    this.year,
    this.month,
    this.destinationUuid,
    this.odigoClientUuid
  });

  factory AdsCountRequestModel.fromJson(Map<String, dynamic> json) => AdsCountRequestModel(
    year: json['year'],
    month: json['month'],
    destinationUuid: json['destinationUuid'],
    odigoClientUuid: json['odigoClientUuid'],
  );

  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'destinationUuid': destinationUuid,
    'odigoClientUuid': odigoClientUuid,
  };
}
