// To parse this JSON data, do
//
//     final categoryListResponseModel = categoryListResponseModelFromJson(jsonString);

import 'dart:convert';

CategoryListResponseModel categoryListResponseModelFromJson(String str) => CategoryListResponseModel.fromJson(json.decode(str));

String categoryListResponseModelToJson(CategoryListResponseModel data) => json.encode(data.toJson());

class CategoryListResponseModel {
  int? pageNumber;
  List<CategoryModel>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  CategoryListResponseModel({
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

  factory CategoryListResponseModel.fromJson(Map<String, dynamic> json) => CategoryListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<CategoryModel>.from(json["data"]!.map((x) => CategoryModel.fromJson(x))),
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

class CategoryModel {
  String? uuid;
  String? name;
  bool? active;
  String? categoryImageUrl;
  String? categoryImage;
  String? originalCategoryImage;

  CategoryModel({
    this.uuid,
    this.name,
    this.active,
    this.categoryImageUrl,
    this.categoryImage,
    this.originalCategoryImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    uuid: json["uuid"],
    name: json["name"],
    active: json["active"],
    categoryImageUrl: json["categoryImageUrl"],
    categoryImage: json["categoryImage"],
    originalCategoryImage: json["originalCategoryImage"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "active": active,
    "categoryImageUrl": categoryImageUrl,
    "categoryImage": categoryImage,
    "originalCategoryImage": originalCategoryImage,
  };
}
