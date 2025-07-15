// To parse this JSON data, do
//
//     final addStoreRequestModel = addStoreRequestModelFromJson(jsonString);

import 'dart:convert';

AddStoreRequestModel addStoreRequestModelFromJson(String str) => AddStoreRequestModel.fromJson(json.decode(str));

String addStoreRequestModelToJson(AddStoreRequestModel data) => json.encode(data.toJson());

class AddStoreRequestModel {
  String? uuid;
  List<StoreValueForAdd>? storeValues;
  List<String>? categoryUuids;

  AddStoreRequestModel({
    this.uuid,
    this.storeValues,
    this.categoryUuids,
  });

  factory AddStoreRequestModel.fromJson(Map<String, dynamic> json) => AddStoreRequestModel(
    uuid: json["uuid"],
    storeValues: json["storeValues"] == null ? [] : List<StoreValueForAdd>.from(json["storeValues"]!.map((x) => StoreValueForAdd.fromJson(x))),
    categoryUuids: json["categoryUuids"] == null ? [] : List<String>.from(json["categoryUuids"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "storeValues": storeValues == null ? [] : List<dynamic>.from(storeValues!.map((x) => x.toJson())),
    "categoryUuids": categoryUuids == null ? [] : List<dynamic>.from(categoryUuids!.map((x) => x)),
  };
}

class StoreValueForAdd {
  String? languageUuid;
  String? name;

  StoreValueForAdd({
    this.languageUuid,
    this.name,
  });

  factory StoreValueForAdd.fromJson(Map<String, dynamic> json) => StoreValueForAdd(
    languageUuid: json["languageUuid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "languageUuid": languageUuid,
    "name": name,
  };
}
