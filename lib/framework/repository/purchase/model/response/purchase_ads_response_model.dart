// To parse this JSON data, do
//
//     final purchaseAdsResponseModel = purchaseAdsResponseModelFromJson(jsonString);

import 'dart:convert';

PurchaseAdsResponseModel purchaseAdsResponseModelFromJson(String str) => PurchaseAdsResponseModel.fromJson(json.decode(str));

String purchaseAdsResponseModelToJson(PurchaseAdsResponseModel data) => json.encode(data.toJson());

class PurchaseAdsResponseModel {
  String? message;
  List<PurchaseAdsData>? data;
  int? status;

  PurchaseAdsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory PurchaseAdsResponseModel.fromJson(Map<String, dynamic> json) => PurchaseAdsResponseModel(
    message: json['message'],
    data: json['data'] == null ? [] : List<PurchaseAdsData>.from(json['data']!.map((x) => PurchaseAdsData.fromJson(x))),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    'status': status,
  };
}

class PurchaseAdsData {
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
  bool? selected;

  PurchaseAdsData({
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
    this.selected=false
  });

  factory PurchaseAdsData.fromJson(Map<String, dynamic> json) => PurchaseAdsData(
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
