// To parse this JSON data, do
//
//     final storeDetailResponseModel = storeDetailResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/store/model/store_list_response_model.dart';

StoreDetailResponseModel storeDetailResponseModelFromJson(String str) => StoreDetailResponseModel.fromJson(json.decode(str));

String storeDetailResponseModelToJson(StoreDetailResponseModel data) => json.encode(data.toJson());

class StoreDetailResponseModel {
  String? message;
  StoreDetailData? data;
  int? status;

  StoreDetailResponseModel({this.message, this.data, this.status});

  factory StoreDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      StoreDetailResponseModel(message: json['message'], data: json['data'] == null ? null : StoreDetailData.fromJson(json['data']), status: json['status']);

  Map<String, dynamic> toJson() => {'message': message, 'data': data?.toJson(), 'status': status};
}

class StoreDetailData {
  String? uuid;
  List<StoreValue>? storeValues;
  bool? active;
  List<BusinessCategory>? categories;
  List<String>? categoryUuids;
  String? storeImageUrl;

  StoreDetailData({this.uuid, this.storeValues, this.active, this.categories, this.categoryUuids, this.storeImageUrl});

  factory StoreDetailData.fromJson(Map<String, dynamic> json) => StoreDetailData(
    uuid: json['uuid'],
    storeValues: json['storeValues'] == null ? [] : List<StoreValue>.from(json['storeValues'].map((x) => StoreValue.fromJson(x))),
    active: json['active'],
    categories: json['categories'] == null ? [] : List<BusinessCategory>.from(json['categories'].map((x) => BusinessCategory.fromJson(x))),
    categoryUuids: json['categoryUuids'] == null ? [] : List<String>.from(json['categoryUuids'].map((x) => x.toString())),
    storeImageUrl: json['storeImageUrl'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'storeValues': storeValues == null ? [] : List<dynamic>.from(storeValues!.map((x) => x.toJson())),
    'active': active,
    'categories': categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    'categoryUuids': categoryUuids,
    'storeImageUrl': storeImageUrl,
  };
}

class StoreValue {
  String? languageUuid;
  String? languageName;
  String? uuid;
  String? name;

  StoreValue({this.languageUuid, this.languageName, this.uuid, this.name});

  factory StoreValue.fromJson(Map<String, dynamic> json) =>
      StoreValue(languageUuid: json['languageUuid'], languageName: json['languageName'], uuid: json['uuid'], name: json['name']);

  Map<String, dynamic> toJson() => {'languageUuid': languageUuid, 'languageName': languageName, 'uuid': uuid, 'name': name};
}
