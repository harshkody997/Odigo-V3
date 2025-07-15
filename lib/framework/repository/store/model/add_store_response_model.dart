// To parse this JSON data, do
//
//     final addStoreResponseModel = addStoreResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/store/model/store_detail_response_model.dart';

AddStoreResponseModel addStoreResponseModelFromJson(String str) => AddStoreResponseModel.fromJson(json.decode(str));

String addStoreResponseModelToJson(AddStoreResponseModel data) => json.encode(data.toJson());

class AddStoreResponseModel {
  String? message;
  AddStoreData? data;
  int? status;

  AddStoreResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory AddStoreResponseModel.fromJson(Map<String, dynamic> json) => AddStoreResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : AddStoreData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class AddStoreData {
  String? uuid;
  List<StoreValue>? storeValues;
  List<String>? categoryUuids;
  String? storeImageUrl;
  bool? active;

  AddStoreData({
    this.uuid,
    this.storeValues,
    this.categoryUuids,
    this.storeImageUrl,
    this.active,
  });

  factory AddStoreData.fromJson(Map<String, dynamic> json) => AddStoreData(
    uuid: json["uuid"],
    storeValues: json["storeValues"] == null ? [] : List<StoreValue>.from(json["storeValues"]!.map((x) => StoreValue.fromJson(x))),
    categoryUuids: json["categoryUuids"] == null ? [] : List<String>.from(json["categoryUuids"]!.map((x) => x)),
    storeImageUrl: json["storeImageUrl"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "storeValues": storeValues == null ? [] : List<dynamic>.from(storeValues!.map((x) => x.toJson())),
    "categoryUuids": categoryUuids == null ? [] : List<dynamic>.from(categoryUuids!.map((x) => x)),
    "storeImageUrl": storeImageUrl,
    "active": active,
  };
}