// To parse this JSON data, do
//
//     final adsShownTimeListResponseModel = adsShownTimeListResponseModelFromJson(jsonString);

import 'dart:convert';

AdsShownTimeListResponseModel adsShownTimeListResponseModelFromJson(String str) => AdsShownTimeListResponseModel.fromJson(json.decode(str));

String adsShownTimeListResponseModelToJson(AdsShownTimeListResponseModel data) => json.encode(data.toJson());

class AdsShownTimeListResponseModel {
  int? pageNumber;
  List<AdsShownTime>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  AdsShownTimeListResponseModel({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.pageSize,
    this.message,
    this.totalCount,
    this.status,
  });

  factory AdsShownTimeListResponseModel.fromJson(Map<String, dynamic> json) => AdsShownTimeListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<AdsShownTime>.from(json["data"]!.map((x) => AdsShownTime.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    pageSize: json["pageSize"],
    message: json["message"],
    totalCount: json["totalCount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "hasNextPage": hasNextPage,
    "totalPages": totalPages,
    "hasPreviousPage": hasPreviousPage,
    "pageSize": pageSize,
    "message": message,
    "totalCount": totalCount,
    "status": status,
  };
}

class AdsShownTime {
  String? uuid;
  String? purchaseUuid;
  String? purchaseType;
  String? destinationUuid;
  String? destinationName;
  String? odigoClientUuid;
  String? odigoClientName;
  String? adsUuid;
  String? adsName;
  String? robotUuid;
  String? robotSerialNumber;
  int? adsShowTime;
  String? timeZone;
  int? createdAt;
  int? transactionTimeAtZone;
  bool? active;

  AdsShownTime({
    this.uuid,
    this.purchaseUuid,
    this.purchaseType,
    this.destinationUuid,
    this.destinationName,
    this.odigoClientUuid,
    this.odigoClientName,
    this.adsUuid,
    this.adsName,
    this.robotUuid,
    this.robotSerialNumber,
    this.adsShowTime,
    this.timeZone,
    this.createdAt,
    this.transactionTimeAtZone,
    this.active,
  });

  factory AdsShownTime.fromJson(Map<String, dynamic> json) => AdsShownTime(
    uuid: json["uuid"],
    purchaseUuid: json["purchaseUuid"],
    purchaseType: json["purchaseType"],
    destinationUuid: json["destinationUuid"],
    destinationName: json["destinationName"],
    odigoClientUuid: json["odigoClientUuid"],
    odigoClientName: json["odigoClientName"],
    adsUuid: json["adsUuid"],
    adsName: json["adsName"],
    robotUuid: json["robotUuid"],
    robotSerialNumber: json["robotSerialNumber"],
    adsShowTime: json["adsShowTime"],
    timeZone: json["timeZone"],
    createdAt: json["createdAt"],
    transactionTimeAtZone: json["transactionTimeAtZone"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "purchaseUuid": purchaseUuid,
    "purchaseType": purchaseType,
    "destinationUuid": destinationUuid,
    "destinationName": destinationName,
    "odigoClientUuid": odigoClientUuid,
    "odigoClientName": odigoClientName,
    "adsUuid": adsUuid,
    "adsName": adsName,
    "robotUuid": robotUuid,
    "robotSerialNumber": robotSerialNumber,
    "adsShowTime": adsShowTime,
    "timeZone": timeZone,
    "createdAt": createdAt,
    "transactionTimeAtZone": transactionTimeAtZone,
    "active": active,
  };
}
