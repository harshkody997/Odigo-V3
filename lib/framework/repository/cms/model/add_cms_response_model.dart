// To parse this JSON data, do
//
//     final addCmsResponseModel = addCmsResponseModelFromJson(jsonString);

import 'dart:convert';

AddCmsResponseModel addCmsResponseModelFromJson(String str) => AddCmsResponseModel.fromJson(json.decode(str));

String addCmsResponseModelToJson(AddCmsResponseModel data) => json.encode(data.toJson());

class AddCmsResponseModel {
  String? message;
  CmsData? data;
  int? status;

  AddCmsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory AddCmsResponseModel.fromJson(Map<String, dynamic> json) => AddCmsResponseModel(
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
  List<AddCmsValue>? cmsValues;
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
    cmsValues: json['cmsValues'] == null ? [] : List<AddCmsValue>.from(json['cmsValues']!.map((x) => AddCmsValue.fromJson(x))),
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

class AddCmsValue {
  String? languageUuid;
  String? languageName;
  String? uuid;
  String? fieldValue;

  AddCmsValue({
    this.languageUuid,
    this.languageName,
    this.uuid,
    this.fieldValue,
  });

  factory AddCmsValue.fromJson(Map<String, dynamic> json) => AddCmsValue(
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
