// To parse this JSON data, do
//
//     final defaultAdsDetailsResponseModel = defaultAdsDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/client_ads/model/client_ads_details_response_model.dart';

DefaultAdsDetailsResponseModel defaultAdsDetailsResponseModelFromJson(String str) => DefaultAdsDetailsResponseModel.fromJson(json.decode(str));

String defaultAdsDetailsResponseModelToJson(DefaultAdsDetailsResponseModel data) => json.encode(data.toJson());

class DefaultAdsDetailsResponseModel {
  String? message;
  DefaultAdsDetailsData? data;
  int? status;

  DefaultAdsDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory DefaultAdsDetailsResponseModel.fromJson(Map<String, dynamic> json) => DefaultAdsDetailsResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : DefaultAdsDetailsData.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class DefaultAdsDetailsData {
  String? uuid;
  String? name;
  String? destinationUuid;
  String? destinationName;
  List<FileElement>? files;
  int? createdAt;
  bool? active;
  bool? isArchive;
  dynamic archiveDate;
  String? adsMediaType;
  int? totalContentLength;

  DefaultAdsDetailsData({
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

  factory DefaultAdsDetailsData.fromJson(Map<String, dynamic> json) => DefaultAdsDetailsData(
    uuid: json['uuid'],
    name: json['name'],
    destinationUuid: json['destinationUuid'],
    destinationName: json['destinationName'],
    files: json['files'] == null ? [] : List<FileElement>.from(json['files']!.map((x) => FileElement.fromJson(x))),
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
    'files': files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
    'createdAt': createdAt,
    'active': active,
    'isArchive': isArchive,
    'archiveDate': archiveDate,
    'adsMediaType': adsMediaType,
    'totalContentLength': totalContentLength,
  };
}
