// To parse this JSON data, do
//
//     final cityListResponseModel = cityListResponseModelFromJson(jsonString);

import 'dart:convert';

CityListResponseModel cityListResponseModelFromJson(String str) => CityListResponseModel.fromJson(json.decode(str));

String cityListResponseModelToJson(CityListResponseModel data) => json.encode(data.toJson());

class CityListResponseModel {
  int? pageNumber;
  List<CityModel>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  CityListResponseModel({
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

  factory CityListResponseModel.fromJson(Map<String, dynamic> json) => CityListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<CityModel>.from(json["data"]!.map((x) => CityModel.fromJson(x))),
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

class CityModel {
  String? uuid;
  String? name;
  String? stateUuid;
  String? stateName;
  String? countryUuid;
  String? countryName;
  bool? active;

  CityModel({
    this.uuid,
    this.name,
    this.stateUuid,
    this.stateName,
    this.countryUuid,
    this.countryName,
    this.active,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    uuid: json["uuid"],
    name: json["name"],
    stateUuid: json["stateUuid"],
    stateName: json["stateName"],
    countryUuid: json["countryUuid"],
    countryName: json["countryName"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "stateUuid": stateUuid,
    "stateName": stateName,
    "countryUuid": countryUuid,
    "countryName": countryName,
    "active": active,
  };
}
