// To parse this JSON data, do
//
//     final clientAdsListRequestModel = clientAdsListRequestModelFromJson(jsonString);

import 'dart:convert';

ClientAdsListRequestModel clientAdsListRequestModelFromJson(String str) => ClientAdsListRequestModel.fromJson(json.decode(str));

String clientAdsListRequestModelToJson(ClientAdsListRequestModel data) => json.encode(data.toJson());

class ClientAdsListRequestModel {
  String? odigoCilentUuid;
  bool? activeRecords;
  bool? isArchive;
  String? status;
  String? searchKeyword;

  ClientAdsListRequestModel({
    this.odigoCilentUuid,
    this.activeRecords,
    this.isArchive,
    this.status,
    this.searchKeyword,
  });

  factory ClientAdsListRequestModel.fromJson(Map<String, dynamic> json) => ClientAdsListRequestModel(
    odigoCilentUuid: json["odigoCilentUuid"],
    activeRecords: json["activeRecords"],
    isArchive: json["isArchive"],
    status: json["status"],
    searchKeyword: json["searchKeyword"],
  );

  Map<String, dynamic> toJson() => {
    "odigoCilentUuid": odigoCilentUuid,
    "activeRecords": activeRecords,
    "isArchive": isArchive,
    "status": status,
    "searchKeyword": searchKeyword,
  };
}
