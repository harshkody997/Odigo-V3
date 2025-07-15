// To parse this JSON data, do
//
//     final getLanguageListResponseModel = getLanguageListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

GetLanguageListResponseModel getLanguageListResponseModelFromJson(String str) => GetLanguageListResponseModel.fromJson(json.decode(str));

String getLanguageListResponseModelToJson(GetLanguageListResponseModel data) => json.encode(data.toJson());

class GetLanguageListResponseModel {
  int? pageNumber;
  List<LanguageModel>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  GetLanguageListResponseModel({
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

  factory GetLanguageListResponseModel.fromJson(Map<String, dynamic> json) => GetLanguageListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<LanguageModel>.from(json['data']!.map((x) => LanguageModel.fromJson(x))),
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

class LanguageModel {
  String? uuid;
  String? name;
  String? code;
  bool? isRtl;
  // bool? isDefault;
  bool? active;
  TextEditingController? textEditingController;
  FocusNode? focusNode;
  String? fieldValue;

  LanguageModel({
    this.uuid,
    this.name,
    this.code,
    this.isRtl,
    // this.isDefault,
    this.active,
    this.textEditingController,
    this.fieldValue,
    this.focusNode
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
    uuid: json['uuid'],
    name: json['name'],
    code: json['code'],
    isRtl: json['isRTL'],
    // isDefault: json["isDefault"],
    active: json['active'],
    textEditingController: json['textEditingController'],
    fieldValue: json['fieldValue'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'code': code,
    'isRTL': isRtl,
    // "isDefault": isDefault,
    'active': active,
    'textEditingController':textEditingController,
    'fieldValue' : fieldValue,
  };
}
