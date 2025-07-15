// To parse this JSON data, do
//
//     final clientAdsListResponseModel = clientAdsListResponseModelFromJson(jsonString);

import 'dart:convert';

ClientAdsListResponseModel clientAdsListResponseModelFromJson(String str) => ClientAdsListResponseModel.fromJson(json.decode(str));

String clientAdsListResponseModelToJson(ClientAdsListResponseModel data) => json.encode(data.toJson());

class ClientAdsListResponseModel {
  int? pageNumber;
  List<ClientAdsListDto>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  ClientAdsListResponseModel({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.pageSize,
    this.message,
    this.totalCount,
    this.status,
  });

  factory ClientAdsListResponseModel.fromJson(Map<String, dynamic> json) => ClientAdsListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<ClientAdsListDto>.from(json["data"]!.map((x) => ClientAdsListDto.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    pageSize: json["pageSize"],
    message: json["message"],
    totalCount: json["totalCount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "hasNextPage": hasNextPage,
    "totalPages": totalPages,
    "hasPreviousPage": hasPreviousPage,
    "pageSize": pageSize,
    "message": message,
    "totalCount": totalCount,
    "status": status,
  };
}

class ClientAdsListDto {
  String? uuid;
  String? clientUuid;
  String? clientName;
  String? name;
  List<ClientAdsListFileDto>? files;
  int? createdAt;
  bool? active;
  bool? isArchive;
  int? archiveDate;
  String? adsMediaType;
  int? contentLength;
  String? status;
  String? rejectReason;
  bool? isSelected;

  ClientAdsListDto({
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
    this.isSelected=false
  });

  factory ClientAdsListDto.fromJson(Map<String, dynamic> json) => ClientAdsListDto(
    uuid: json["uuid"],
    clientUuid: json["clientUuid"],
    clientName: json["clientName"],
    name: json["name"],
    files: json["files"] == null ? [] : List<ClientAdsListFileDto>.from(json["files"]!.map((x) => ClientAdsListFileDto.fromJson(x))),
    createdAt: json["createdAt"],
    active: json["active"],
    isArchive: json["isArchive"],
    archiveDate: json["archiveDate"],
    adsMediaType: json["adsMediaType"],
    contentLength: json["contentLength"],
    status: json["status"],
    rejectReason: json["rejectReason"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "clientUuid": clientUuid,
    "clientName": clientName,
    "name": name,
    "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
    "createdAt": createdAt,
    "active": active,
    "isArchive": isArchive,
    "archiveDate": archiveDate,
    "adsMediaType": adsMediaType,
    "contentLength": contentLength,
    "status": status,
    "rejectReason": rejectReason,
  };
}

class ClientAdsListFileDto {
  String? originalFile;
  String? fileUrl;

  ClientAdsListFileDto({
    this.originalFile,
    this.fileUrl,
  });

  factory ClientAdsListFileDto.fromJson(Map<String, dynamic> json) => ClientAdsListFileDto(
    originalFile: json["originalFile"],
    fileUrl: json["fileUrl"],
  );

  Map<String, dynamic> toJson() => {
    "originalFile": originalFile,
    "fileUrl": fileUrl,
  };
}
