// To parse this JSON data, do
//
//     final settingsListResponseModel = settingsListResponseModelFromJson(jsonString);

import 'dart:convert';

SettingsListResponseModel settingsListResponseModelFromJson(String str) => SettingsListResponseModel.fromJson(json.decode(str));

String settingsListResponseModelToJson(SettingsListResponseModel data) => json.encode(data.toJson());

class SettingsListResponseModel {
  int? pageNumber;
  List<SettingsData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  SettingsListResponseModel({
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

  factory SettingsListResponseModel.fromJson(Map<String, dynamic> json) => SettingsListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<SettingsData>.from(json['data']!.map((x) => SettingsData.fromJson(x))),
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

class SettingsData {
  String? uuid;
  String? fieldName;
  String? fieldValue;
  bool? encrypted;

  SettingsData({
    this.uuid,
    this.fieldName,
    this.fieldValue,
    this.encrypted,
  });

  factory SettingsData.fromJson(Map<String, dynamic> json) => SettingsData(
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
