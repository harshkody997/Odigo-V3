// To parse this JSON data, do
//
//     final addClientAdsResponseModel = addClientAdsResponseModelFromJson(jsonString);

import 'dart:convert';

AddClientAdsResponseModel addClientAdsResponseModelFromJson(String str) => AddClientAdsResponseModel.fromJson(json.decode(str));

String addClientAdsResponseModelToJson(AddClientAdsResponseModel data) => json.encode(data.toJson());

class AddClientAdsResponseModel {
  String? message;
  Data? data;
  int? status;

  AddClientAdsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory AddClientAdsResponseModel.fromJson(Map<String, dynamic> json) => AddClientAdsResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class Data {
  String? uuid;
  String? clientUuid;
  String? clientName;
  String? name;
  List<dynamic>? files;
  int? createdAt;
  bool? active;
  bool? isArchive;
  dynamic archiveDate;
  String? adsMediaType;
  int? contentLength;
  String? status;
  dynamic rejectReason;

  Data({
    this.uuid,
    this.clientUuid,
    this.clientName,
    this.name,
    this.files,
    this.createdAt,
    this.active,
    this.isArchive,
    this.archiveDate,
    this.adsMediaType,
    this.contentLength,
    this.status,
    this.rejectReason,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    uuid: json['uuid'],
    clientUuid: json['clientUuid'],
    clientName: json['clientName'],
    name: json['name'],
    files: json['files'] == null ? [] : List<dynamic>.from(json['files']!.map((x) => x)),
    createdAt: json['createdAt'],
    active: json['active'],
    isArchive: json['isArchive'],
    archiveDate: json['archiveDate'],
    adsMediaType: json['adsMediaType'],
    contentLength: json['contentLength'],
    status: json['status'],
    rejectReason: json['rejectReason'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'clientUuid': clientUuid,
    'clientName': clientName,
    'name': name,
    'files': files == null ? [] : List<dynamic>.from(files!.map((x) => x)),
    'createdAt': createdAt,
    'active': active,
    'isArchive': isArchive,
    'archiveDate': archiveDate,
    'adsMediaType': adsMediaType,
    'contentLength': contentLength,
    'status': status,
    'rejectReason': rejectReason,
  };
}
