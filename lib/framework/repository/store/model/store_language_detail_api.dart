// To parse this JSON data, do
//
//     final storeLanguageDetailResponseModel = storeLanguageDetailResponseModelFromJson(jsonString);

import 'dart:convert';

StoreLanguageDetailResponseModel storeLanguageDetailResponseModelFromJson(String str) => StoreLanguageDetailResponseModel.fromJson(json.decode(str));

String storeLanguageDetailResponseModelToJson(StoreLanguageDetailResponseModel data) => json.encode(data.toJson());

class StoreLanguageDetailResponseModel {
  String? message;
  StoreLanguageDetailData? data;
  int? status;

  StoreLanguageDetailResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory StoreLanguageDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      StoreLanguageDetailResponseModel(
        message: json['message'],
        data: json['data'] == null ? null : StoreLanguageDetailData.fromJson(json['data']),
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class StoreLanguageDetailData {
  String? uuid;
  String? name;
  List<BusinessCategory>? businessCategories;
  dynamic floorNumber;
  bool? active;
  String? storeImageUrl;

  StoreLanguageDetailData({
    this.uuid,
    this.name,
    this.businessCategories,
    this.floorNumber,
    this.active,
    this.storeImageUrl,
  });

  factory StoreLanguageDetailData.fromJson(Map<String, dynamic> json) => StoreLanguageDetailData(
    uuid: json['uuid'],
    name: json['name'],
    businessCategories: json['businessCategories'] == null
        ? []
        : List<BusinessCategory>.from(
        json['businessCategories'].map((x) => BusinessCategory.fromJson(x))),
    floorNumber: json['floorNumber'],
    active: json['active'],
    storeImageUrl: json['storeImageUrl'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'businessCategories': businessCategories == null
        ? []
        : List<dynamic>.from(businessCategories!.map((x) => x.toJson())),
    'floorNumber': floorNumber,
    'active': active,
    'storeImageUrl': storeImageUrl,
  };
}

class BusinessCategory {
  String? uuid;
  String? name;
  bool? active;
  String? categoryImageUrl;
  String? categoryImage;
  String? originalCategoryImage;

  BusinessCategory({
    this.uuid,
    this.name,
    this.active,
    this.categoryImageUrl,
    this.categoryImage,
    this.originalCategoryImage,
  });

  factory BusinessCategory.fromJson(Map<String, dynamic> json) => BusinessCategory(
    uuid: json['uuid'],
    name: json['name'],
    active: json['active'],
    categoryImageUrl: json['categoryImageUrl'],
    categoryImage: json['categoryImage'],
    originalCategoryImage: json['originalCategoryImage'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'active': active,
    'categoryImageUrl': categoryImageUrl,
    'categoryImage': categoryImage,
    'originalCategoryImage': originalCategoryImage,
  };
}

