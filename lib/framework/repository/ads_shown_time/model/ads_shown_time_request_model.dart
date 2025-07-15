// To parse this JSON data, do
//
//     final adsShownTimeListRequestModel = adsShownTimeListRequestModelFromJson(jsonString);

import 'dart:convert';

AdsShownTimeListRequestModel adsShownTimeListRequestModelFromJson(String str) => AdsShownTimeListRequestModel.fromJson(json.decode(str));

String adsShownTimeListRequestModelToJson(AdsShownTimeListRequestModel data) => json.encode(data.toJson());

class AdsShownTimeListRequestModel {
  String? searchKeyword;
  String? odigoClientUuid;
  dynamic destinationUuid;
  String? purchaseType;
  String? purchaseUuid;
  String? robotUuid;
  String? adsUuid;
  String? fromDate;
  String? toDate;

  AdsShownTimeListRequestModel({
    this.searchKeyword,
    this.odigoClientUuid,
    this.destinationUuid,
    this.purchaseType,
    this.purchaseUuid,
    this.robotUuid,
    this.adsUuid,
    this.fromDate,
    this.toDate,
  });

  factory AdsShownTimeListRequestModel.fromJson(Map<String, dynamic> json) => AdsShownTimeListRequestModel(
    searchKeyword: json["searchKeyword"],
    odigoClientUuid: json["odigoClientUuid"],
    destinationUuid: json["destinationUuid"],
    purchaseType: json["purchaseType"],
    purchaseUuid: json["purchaseUuid"],
    robotUuid: json["robotUuid"],
    adsUuid: json["adsUuid"],
    fromDate: json["fromDate"],
    toDate: json["toDate"],
  );

  Map<String, dynamic> toJson() => {
    "searchKeyword": searchKeyword,
    "odigoClientUuid": odigoClientUuid,
    "destinationUuid": destinationUuid,
    "purchaseType": purchaseType,
    "purchaseUuid": purchaseUuid,
    "robotUuid": robotUuid,
    "adsUuid": adsUuid,
    "fromDate": fromDate,
    "toDate": toDate,
  };
}
