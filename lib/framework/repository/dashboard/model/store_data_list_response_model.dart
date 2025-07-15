// To parse this JSON data, do
//
//     final storeDataListResponseModel = storeDataListResponseModelFromJson(jsonString);

import 'dart:convert';

StoreDataListResponseModel storeDataListResponseModelFromJson(String str) => StoreDataListResponseModel.fromJson(json.decode(str));

String storeDataListResponseModelToJson(StoreDataListResponseModel data) => json.encode(data.toJson());

class StoreDataListResponseModel {
  int? pageNumber;
  List<StoreDataListDto>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  StoreDataListResponseModel({
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

  factory StoreDataListResponseModel.fromJson(Map<String, dynamic> json) => StoreDataListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<StoreDataListDto>.from(json["data"]!.map((x) => StoreDataListDto.fromJson(x))),
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

class StoreDataListDto {
  String? uuid;
  String? name;

  StoreDataListDto({
    this.uuid,
    this.name,
  });

  factory StoreDataListDto.fromJson(Map<String, dynamic> json) => StoreDataListDto(
    uuid: json["uuid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
  };
}
