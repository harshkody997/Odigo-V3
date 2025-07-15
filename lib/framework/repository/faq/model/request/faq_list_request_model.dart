// To parse this JSON data, do
//
//     final faqListRequestModel = faqListRequestModelFromJson(jsonString);

import 'dart:convert';

FaqListRequestModel faqListRequestModelFromJson(String str) => FaqListRequestModel.fromJson(json.decode(str));

String faqListRequestModelToJson(FaqListRequestModel data) => json.encode(data.toJson());

class FaqListRequestModel {
  String? searchKeyword;
  String? platformType;
  bool? activeRecords;

  FaqListRequestModel({
    this.searchKeyword,
    this.platformType,
    this.activeRecords,
  });

  factory FaqListRequestModel.fromJson(Map<String, dynamic> json) => FaqListRequestModel(
    searchKeyword: json['searchKeyword'],
    platformType: json['platformType'],
    activeRecords: json['activeRecords'],
  );

  Map<String, dynamic> toJson() => {
    'searchKeyword': searchKeyword,
    'platformType': platformType,
    'activeRecords': activeRecords,
  };
}
