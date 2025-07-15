// To parse this JSON data, do
//
//     final addDefaultAdsResponseModel = addDefaultAdsResponseModelFromJson(jsonString);

import 'dart:convert';

AddDefaultAdsResponseModel addDefaultAdsResponseModelFromJson(String str) =>
    AddDefaultAdsResponseModel.fromJson(json.decode(str));

String addDefaultAdsResponseModelToJson(AddDefaultAdsResponseModel data) => json.encode(data.toJson());

class AddDefaultAdsResponseModel {
  String? message;
  DefaultAdData? data;
  int? status;

  AddDefaultAdsResponseModel({this.message, this.data, this.status});

  factory AddDefaultAdsResponseModel.fromJson(Map<String, dynamic> json) => AddDefaultAdsResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : DefaultAdData.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {'message': message, 'data': data?.toJson(), 'status': status};
}

class DefaultAdData {
  String? uuid;
  String? name;
  String? destinationUuid;
  String? destinationName;
  List<dynamic>? files;
  int? createdAt;
  bool? active;
  bool? isArchive;
  dynamic archiveDate;
  String? adsMediaType;
  int? totalContentLength;

  DefaultAdData({
    this.uuid,
    this.name,
    this.destinationUuid,
    this.destinationName,
    this.files,
    this.createdAt,
    this.active,
    this.isArchive,
    this.archiveDate,
    this.adsMediaType,
    this.totalContentLength,
  });

  factory DefaultAdData.fromJson(Map<String, dynamic> json) => DefaultAdData(
    uuid: json['uuid'],
    name: json['name'],
    destinationUuid: json['destinationUuid'],
    destinationName: json['destinationName'],
    files: json['files'] == null ? [] : List<dynamic>.from(json['files']!.map((x) => x)),
    createdAt: json['createdAt'],
    active: json['active'],
    isArchive: json['isArchive'],
    archiveDate: json['archiveDate'],
    adsMediaType: json['adsMediaType'],
    totalContentLength: json['totalContentLength'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'destinationUuid': destinationUuid,
    'destinationName': destinationName,
    'files': files == null ? [] : List<dynamic>.from(files!.map((x) => x)),
    'createdAt': createdAt,
    'active': active,
    'isArchive': isArchive,
    'archiveDate': archiveDate,
    'adsMediaType': adsMediaType,
    'totalContentLength': totalContentLength,
  };
}
