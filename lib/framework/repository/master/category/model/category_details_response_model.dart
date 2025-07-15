// To parse this JSON data, do
//
//     final categoryDetailsResponseModel = categoryDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

CategoryDetailsResponseModel categoryDetailsResponseModelFromJson(String str) => CategoryDetailsResponseModel.fromJson(json.decode(str));

String categoryDetailsResponseModelToJson(CategoryDetailsResponseModel data) => json.encode(data.toJson());

class CategoryDetailsResponseModel {
  String? message;
  CategoryDetailsModel? data;
  int? status;

  CategoryDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory CategoryDetailsResponseModel.fromJson(Map<String, dynamic> json) => CategoryDetailsResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : CategoryDetailsModel.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class CategoryDetailsModel {
  String? uuid;
  List<CategoryValue>? categoryValues;
  bool? active;
  dynamic businessCategoryImage;
  dynamic originalBusinessCategoryImage;
  dynamic categoryImageUrl;

  CategoryDetailsModel({
    this.uuid,
    this.categoryValues,
    this.active,
    this.businessCategoryImage,
    this.originalBusinessCategoryImage,
    this.categoryImageUrl,
  });

  factory CategoryDetailsModel.fromJson(Map<String, dynamic> json) => CategoryDetailsModel(
    uuid: json["uuid"],
    categoryValues: json["categoryValues"] == null ? [] : List<CategoryValue>.from(json["categoryValues"]!.map((x) => CategoryValue.fromJson(x))),
    active: json["active"],
    businessCategoryImage: json["businessCategoryImage"],
    originalBusinessCategoryImage: json["originalBusinessCategoryImage"],
    categoryImageUrl: json["categoryImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "categoryValues": categoryValues == null ? [] : List<dynamic>.from(categoryValues!.map((x) => x.toJson())),
    "active": active,
    "businessCategoryImage": businessCategoryImage,
    "originalBusinessCategoryImage": originalBusinessCategoryImage,
    "categoryImageUrl": categoryImageUrl,
  };
}

class CategoryValue {
  String? languageUuid;
  String? languageName;
  String? uuid;
  String? name;

  CategoryValue({
    this.languageUuid,
    this.languageName,
    this.uuid,
    this.name,
  });

  factory CategoryValue.fromJson(Map<String, dynamic> json) => CategoryValue(
    languageUuid: json["languageUuid"],
    languageName: json["languageName"],
    uuid: json["uuid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "languageUuid": languageUuid,
    "languageName": languageName,
    "uuid": uuid,
    "name": name,
  };
}
