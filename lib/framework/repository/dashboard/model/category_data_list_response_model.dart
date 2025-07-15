// To parse this JSON data, do
//
//     final categoryDataListResponseModel = categoryDataListResponseModelFromJson(jsonString);

import 'dart:convert';

CategoryDataListResponseModel categoryDataListResponseModelFromJson(String str) => CategoryDataListResponseModel.fromJson(json.decode(str));

String categoryDataListResponseModelToJson(CategoryDataListResponseModel data) => json.encode(data.toJson());

class CategoryDataListResponseModel {
  int? pageNumber;
  List<CategoryDataListDto>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  CategoryDataListResponseModel({
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

  factory CategoryDataListResponseModel.fromJson(Map<String, dynamic> json) => CategoryDataListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<CategoryDataListDto>.from(json["data"]!.map((x) => CategoryDataListDto.fromJson(x))),
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

class CategoryDataListDto {
  String? uuid;
  String? name;

  CategoryDataListDto({
    this.uuid,
    this.name,
  });

  factory CategoryDataListDto.fromJson(Map<String, dynamic> json) => CategoryDataListDto(
    uuid: json["uuid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
  };
}
