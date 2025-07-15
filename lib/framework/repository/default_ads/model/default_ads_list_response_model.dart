// To parse this JSON data, do
//
//     final defaultAdsListResponseModel = defaultAdsListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/client_ads/model/client_ads_list_response_model.dart';

DefaultAdsListResponseModel defaultAdsListResponseModelFromJson(String str) => DefaultAdsListResponseModel.fromJson(json.decode(str));

String defaultAdsListResponseModelToJson(DefaultAdsListResponseModel data) => json.encode(data.toJson());

class DefaultAdsListResponseModel {
  int? pageNumber;
  List<DefaultAdsListData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  DefaultAdsListResponseModel({
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

  factory DefaultAdsListResponseModel.fromJson(Map<String, dynamic> json) => DefaultAdsListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<DefaultAdsListData>.from(json["data"]!.map((x) => DefaultAdsListData.fromJson(x))),
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

class DefaultAdsListData {
  String? uuid;
  String? name;
  String? destinationUuid;
  String? destinationName;
  bool? isArchive;
  int? createdAt;
  String? adsMediaType;
  bool? active;
  List<ClientAdsListFileDto>? files;


  DefaultAdsListData({
    this.uuid,
    this.name,
    this.destinationUuid,
    this.destinationName,
    this.isArchive,
    this.createdAt,
    this.adsMediaType,
    this.active,
    this.files,
  });

  factory DefaultAdsListData.fromJson(Map<String, dynamic> json) => DefaultAdsListData(
    uuid: json["uuid"],
    name: json["name"],
    destinationUuid: json["destinationUuid"],
    destinationName: json["destinationName"],
    isArchive: json["isArchive"],
    createdAt: json["createdAt"],
    adsMediaType: json["adsMediaType"],
    active: json["active"],
    files: json["files"] == null ? [] : List<ClientAdsListFileDto>.from(json["files"]!.map((x) => ClientAdsListFileDto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "destinationUuid": destinationUuid,
    "destinationName": destinationName,
    "isArchive": isArchive,
    "createdAt": createdAt,
    "adsMediaType": adsMediaType,
    "active": active,
    "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
  };
}
