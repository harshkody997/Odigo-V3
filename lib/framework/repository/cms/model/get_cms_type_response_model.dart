// To parse this JSON data, do
//
//     final getCmsTypeResponseModel = getCmsTypeResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:html_editor_enhanced/html_editor.dart';

GetCmsTypeResponseModel getCmsTypeResponseModelFromJson(String str) => GetCmsTypeResponseModel.fromJson(json.decode(str));

String getCmsTypeResponseModelToJson(GetCmsTypeResponseModel data) => json.encode(data.toJson());

class GetCmsTypeResponseModel {
  String? message;
  Data? data;
  int? status;

  GetCmsTypeResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory GetCmsTypeResponseModel.fromJson(Map<String, dynamic> json) => GetCmsTypeResponseModel(
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
  String? cmsType;
  String? platformType;
  List<CmsValue>? cmsValues;
  int? updatedAt;
  bool? active;
  bool? isEdit;

  Data({
    this.uuid,
    this.cmsType,
    this.platformType,
    this.cmsValues,
    this.updatedAt,
    this.active,
    this.isEdit,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
  HtmlEditorController? controller;

  CmsValue({
    required this.languageUuid,
    required this.languageName,
    required this.uuid,
    required this.fieldValue,
    HtmlEditorController? controller,
  }) : controller = controller ?? HtmlEditorController(); // ensures non-null

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
