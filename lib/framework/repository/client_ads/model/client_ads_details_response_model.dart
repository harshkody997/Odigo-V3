// To parse this JSON data, do
//
//     final clientAdsDetailsResponseModel = clientAdsDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

ClientAdsDetailsResponseModel clientAdsDetailsResponseModelFromJson(String str) => ClientAdsDetailsResponseModel.fromJson(json.decode(str));

String clientAdsDetailsResponseModelToJson(ClientAdsDetailsResponseModel data) => json.encode(data.toJson());

class ClientAdsDetailsResponseModel {
  String? message;
  ClientAdsDetailsData? data;
  int? status;

  ClientAdsDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory ClientAdsDetailsResponseModel.fromJson(Map<String, dynamic> json) => ClientAdsDetailsResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : ClientAdsDetailsData.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class ClientAdsDetailsData {
  String? uuid;
  String? clientUuid;
  String? clientName;
  String? name;
  List<FileElement>? files;
  int? createdAt;
  bool? active;
  bool? isArchive;
  dynamic archiveDate;
  String? adsMediaType;
  int? contentLength;
  String? status;
  dynamic rejectReason;

  ClientAdsDetailsData({
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

  factory ClientAdsDetailsData.fromJson(Map<String, dynamic> json) => ClientAdsDetailsData(
    uuid: json['uuid'],
    clientUuid: json['clientUuid'],
    clientName: json['clientName'],
    name: json['name'],
    files: json['files'] == null ? [] : List<FileElement>.from(json['files']!.map((x) => FileElement.fromJson(x))),
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
    'files': files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
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

class FileElement {
  String? originalFile;
  String? fileUrl;

  FileElement({
    this.originalFile,
    this.fileUrl,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    originalFile: json['originalFile'],
    fileUrl: json['fileUrl'],
  );

  Map<String, dynamic> toJson() => {
    'originalFile': originalFile,
    'fileUrl': fileUrl,
  };
}
