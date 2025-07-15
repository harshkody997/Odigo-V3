// To parse this JSON data, do
//
//     final storeListResponseModel = storeListResponseModelFromJson(jsonString);

import 'dart:convert';

StoreListResponseModel storeListResponseModelFromJson(String str) => StoreListResponseModel.fromJson(json.decode(str));

String storeListResponseModelToJson(StoreListResponseModel data) => json.encode(data.toJson());

class StoreListResponseModel {
  int? pageNumber;
  List<StoreData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  StoreListResponseModel({
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

  factory StoreListResponseModel.fromJson(Map<String, dynamic> json) => StoreListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<StoreData>.from(json['data'].map((x) => StoreData.fromJson(x))),
    hasNextPage: json['hasNextPage'],
    totalPages: json['totalPages'],
    hasPreviousPage: json['hasPreviousPage'],
    pageSize: json['pageSize'],
    message: json['message'],
    totalCount: json['totalCount'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber,
    'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    'hasNextPage': hasNextPage,
    'totalPages': totalPages,
    'hasPreviousPage': hasPreviousPage,
    'pageSize': pageSize,
    'message': message,
    'totalCount': totalCount,
    'status': status,
  };
}

class StoreData {
  String? uuid;
  String? name;
  List<BusinessCategory>? businessCategories;
  int? floorNumber;
  bool? active;
  bool? isValidate;
  String? storeImageUrl;
  bool? isLocationAssigned;

  StoreData({
    this.uuid,
    this.name,
    this.businessCategories,
    this.floorNumber,
    this.active,
    this.isValidate,
    this.storeImageUrl,
    this.isLocationAssigned,
  });

  factory StoreData.fromJson(Map<String, dynamic> json) => StoreData(
    uuid: json['uuid'],
    name: json['name'],
    businessCategories: json['businessCategories'] == null
        ? []
        : List<BusinessCategory>.from(json['businessCategories'].map((x) => BusinessCategory.fromJson(x))),
    floorNumber: json['floorNumber'],
    active: json['active'],
    isValidate: json['isValidate'],
    storeImageUrl: json['storeImageUrl'],
    isLocationAssigned: json['isLocationAssigned'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'businessCategories': businessCategories == null ? [] : List<dynamic>.from(businessCategories!.map((x) => x.toJson())),
    'floorNumber': floorNumber,
    'active': active,
    'isValidate': isValidate,
    'storeImageUrl': storeImageUrl,
    'isLocationAssigned': isLocationAssigned,
  };
}

class BusinessCategory {
  String? uuid;
  String? name;
  bool? active;
  String? categoryImageUrl;
  dynamic categoryImage;
  dynamic originalCategoryImage;

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
