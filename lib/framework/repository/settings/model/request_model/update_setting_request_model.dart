// To parse this JSON data, do
//
//     final updateSettingsRequestModel = updateSettingsRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateSettingsRequestModel updateSettingsRequestModelFromJson(String str) => UpdateSettingsRequestModel.fromJson(json.decode(str));

String updateSettingsRequestModelToJson(UpdateSettingsRequestModel data) => json.encode(data.toJson());

class UpdateSettingsRequestModel {
  String? uuid;
  String? fieldName;
  String? fieldValue;
  bool? encrypted;

  UpdateSettingsRequestModel({
    this.uuid,
    this.fieldName,
    this.fieldValue,
    this.encrypted,
  });

  factory UpdateSettingsRequestModel.fromJson(Map<String, dynamic> json) => UpdateSettingsRequestModel(
    uuid: json['uuid'],
    fieldName: json['fieldName'],
    fieldValue: json['fieldValue'],
    encrypted: json['encrypted'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'fieldName': fieldName,
    'fieldValue': fieldValue,
    'encrypted': encrypted,
  };
}
