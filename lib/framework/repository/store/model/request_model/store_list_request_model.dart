// To parse this JSON data, do
//
//     final storeListRequestModel = storeListRequestModelFromJson(jsonString);

import 'dart:convert';

StoreListRequestModel storeListRequestModelFromJson(String str) => StoreListRequestModel.fromJson(json.decode(str));

String storeListRequestModelToJson(StoreListRequestModel data) => json.encode(data.toJson());

class StoreListRequestModel {
  String? searchKeyword;
  bool? activeRecords;
  List<String>? categoryUuids;

  StoreListRequestModel({
    this.searchKeyword,
    this.activeRecords,
    this.categoryUuids,
  });

  factory StoreListRequestModel.fromJson(Map<String, dynamic> json) => StoreListRequestModel(
    searchKeyword: json["searchKeyword"],
    activeRecords: json["activeRecords"],
    categoryUuids: json["categoryUuids"] == null ? [] : List<String>.from(json["categoryUuids"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "searchKeyword": searchKeyword,
    "activeRecords": activeRecords,
    "categoryUuids": categoryUuids == null ? [] : List<dynamic>.from(categoryUuids!.map((x) => x)),
  };
}
