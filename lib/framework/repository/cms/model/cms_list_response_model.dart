// To parse this JSON data, do
//
//     final cmsListResponseModel = cmsListResponseModelFromJson(jsonString);

import 'dart:convert';

CmsListResponseModel cmsListResponseModelFromJson(String str) => CmsListResponseModel.fromJson(json.decode(str));

String cmsListResponseModelToJson(CmsListResponseModel data) => json.encode(data.toJson());

class CmsListResponseModel {
  int? pageNumber;
  List<CmsData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  CmsListResponseModel({
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

  factory CmsListResponseModel.fromJson(Map<String, dynamic> json) => CmsListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<CmsData>.from(json['data']!.map((x) => CmsData.fromJson(x))),
    hasNextPage: json['hasNextPage'],
    totalPages: json['totalPages'],
    hasPreviousPage: json['hasPreviousPage'],
    pageSize: json['pageSize'],
    message: json['message'],
    totalCount: json['totalCount'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber,
    'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    'hasNextPage': hasNextPage,
    'totalPages': totalPages,
    'hasPreviousPage': hasPreviousPage,
    'pageSize': pageSize,
    'message': message,
    'totalCount': totalCount,
    'status': status,
  };
}

class CmsData {
  String? uuid;
  String? cmsType;
  String? platformType;
  List<CmsValue>? cmsValues;
  int? updatedAt;
  bool? active;

  CmsData({
    this.uuid,
    this.cmsType,
    this.platformType,
    this.cmsValues,
    this.updatedAt,
    this.active,
  });

  factory CmsData.fromJson(Map<String, dynamic> json) => CmsData(
    uuid: json['uuid'],
    cmsType: json['cmsType'],
    platformType: json['platformType'],
    cmsValues: json['cmsValues'] == null ? [] : List<CmsValue>.from(json['cmsValues']!.map((x) => CmsValue.fromJson(x))),
    updatedAt: json['updatedAt'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'cmsType': cmsType,
    'platformType': platformType,
    'cmsValues': cmsValues == null ? [] : List<dynamic>.from(cmsValues!.map((x) => x.toJson())),
    'updatedAt': updatedAt,
    'active': active,
  };
}

class CmsValue {
  String? languageUuid;
  String? languageName;
  String? uuid;
  String? fieldValue;

  CmsValue({
    this.languageUuid,
    this.languageName,
    this.uuid,
    this.fieldValue,
  });

  factory CmsValue.fromJson(Map<String, dynamic> json) => CmsValue(
    languageUuid: json['languageUuid'],
    languageName: json['languageName'],
    uuid: json['uuid'],
    fieldValue: json['fieldValue'],
  );

  Map<String, dynamic> toJson() => {
    'languageUuid': languageUuid,
    'languageName': languageName,
    'uuid': uuid,
    'fieldValue': fieldValue,
  };
}
