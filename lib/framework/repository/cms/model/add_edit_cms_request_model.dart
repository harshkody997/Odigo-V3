// To parse this JSON data, do
//
//     final addEditCmsRequestModel = addEditCmsRequestModelFromJson(jsonString);

import 'dart:convert';

AddEditCmsRequestModel addEditCmsRequestModelFromJson(String str) => AddEditCmsRequestModel.fromJson(json.decode(str));

String addEditCmsRequestModelToJson(AddEditCmsRequestModel data) => json.encode(data.toJson());

class AddEditCmsRequestModel {
  String? uuid;
  String? cmsType;
  String? platformType;
  List<AddCmsValues>? cmsValues;

  AddEditCmsRequestModel({
    this.uuid,
    this.cmsType,
    this.platformType,
    this.cmsValues,
  });

  factory AddEditCmsRequestModel.fromJson(Map<String, dynamic> json) => AddEditCmsRequestModel(
    uuid: json['uuid'],
    cmsType: json['cmsType'],
    platformType: json['platformType'],
    cmsValues: json['cmsValues'] == null ? [] : List<AddCmsValues>.from(json['cmsValues']!.map((x) => AddCmsValues.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'cmsType': cmsType,
    'platformType': platformType,
    'cmsValues': cmsValues == null ? [] : List<dynamic>.from(cmsValues!.map((x) => x.toJson())),
  };
}

class AddCmsValues {
  String? languageUuid;
  String? fieldValue;

  AddCmsValues({
    this.languageUuid,
    this.fieldValue,
  });

  factory AddCmsValues.fromJson(Map<String, dynamic> json) => AddCmsValues(
    languageUuid: json['languageUuid'],
    fieldValue: json['fieldValue'],
  );

  Map<String, dynamic> toJson() => {
    'languageUuid': languageUuid,
    'fieldValue': fieldValue,
  };
}
