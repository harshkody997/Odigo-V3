// To parse this JSON data, do
//
//     final cmsResponseModel = cmsResponseModelFromJson(jsonString);

import 'dart:convert';

CmsResponseModel cmsResponseModelFromJson(String str) => CmsResponseModel.fromJson(json.decode(str));

String cmsResponseModelToJson(CmsResponseModel data) => json.encode(data.toJson());

class CmsResponseModel {
  String? message;
  CmsData? data;
  int? status;

  CmsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory CmsResponseModel.fromJson(Map<String, dynamic> json) => CmsResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : CmsData.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class CmsData {
  String? uuid;
  String? cmsType;
  String? platformType;
  bool? active;
  String? fieldValue;
  int? updatedAt;

  CmsData({
    this.uuid,
    this.cmsType,
    this.platformType,
    this.active,
    this.fieldValue,
    this.updatedAt,
  });

  factory CmsData.fromJson(Map<String, dynamic> json) => CmsData(
    uuid: json['uuid'],
    cmsType: json['cmsType'],
    platformType: json['platformType'],
    active: json['active'],
    fieldValue: json['fieldValue'],
    updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'cmsType': cmsType,
    'platformType': platformType,
    'active': active,
    'fieldValue': fieldValue,
    'updatedAt': updatedAt,
  };
}
