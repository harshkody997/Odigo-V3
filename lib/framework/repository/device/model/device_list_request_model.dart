// To parse this JSON data, do
//
//     final deviceListRequestModel = deviceListRequestModelFromJson(jsonString);

import 'dart:convert';

DeviceListRequestModel deviceListRequestModelFromJson(String str) => DeviceListRequestModel.fromJson(json.decode(str));

String deviceListRequestModelToJson(DeviceListRequestModel data) => json.encode(data.toJson());

class DeviceListRequestModel {
  String? searchKeyword;
  bool? inStock;
  String? destinationUuid;
  bool? activeRecords;
  bool? isArchive;

  DeviceListRequestModel({
    this.searchKeyword,
    this.inStock,
    this.destinationUuid,
    this.activeRecords,
    this.isArchive,
  });

  factory DeviceListRequestModel.fromJson(Map<String, dynamic> json) => DeviceListRequestModel(
    searchKeyword: json["searchKeyword"],
    inStock: json["inStock"],
    destinationUuid: json["destinationUuid"],
    activeRecords: json["activeRecords"],
    isArchive: json["isArchive"],
  );

  Map<String, dynamic> toJson() => {
    "searchKeyword": searchKeyword,
    "inStock": inStock,
    "destinationUuid": destinationUuid,
    "activeRecords": activeRecords,
    "isArchive": isArchive,
  };
}
