// To parse this JSON data, do
//
//     final defaultAdsListRequestModel = defaultAdsListRequestModelFromJson(jsonString);

import 'dart:convert';

DefaultAdsListRequestModel defaultAdsListRequestModelFromJson(String str) => DefaultAdsListRequestModel.fromJson(json.decode(str));

String defaultAdsListRequestModelToJson(DefaultAdsListRequestModel data) => json.encode(data.toJson());

class DefaultAdsListRequestModel {
  String? searchKeyword;
  String? destinationUuid;
  bool? activeRecords;
  bool? isArchive;

  DefaultAdsListRequestModel({
    this.searchKeyword,
    this.destinationUuid,
    this.activeRecords,
    this.isArchive,
  });

  factory DefaultAdsListRequestModel.fromJson(Map<String, dynamic> json) => DefaultAdsListRequestModel(
    searchKeyword: json["searchKeyword"],
    destinationUuid: json["destinationUuid"],
    activeRecords: json["activeRecords"],
    isArchive: json["isArchive"],
  );

  Map<String, dynamic> toJson() => {
    "searchKeyword": searchKeyword,
    "destinationUuid": destinationUuid,
    "activeRecords": activeRecords,
    "isArchive": isArchive,
  };
}
