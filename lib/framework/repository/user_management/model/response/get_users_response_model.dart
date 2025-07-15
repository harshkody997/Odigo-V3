// To parse this JSON data, do
//
//     final getUserListResponseModel = getUserListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/user_management/model/response/users_data.dart';

GetUserListResponseModel getUserListResponseModelFromJson(String str) =>
    GetUserListResponseModel.fromJson(json.decode(str));

String getUserListResponseModelToJson(GetUserListResponseModel data) => json.encode(data.toJson());

class GetUserListResponseModel {
  int? pageNumber;
  List<UserData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  String? message;
  int? totalCount;
  int? status;

  GetUserListResponseModel({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.message,
    this.totalCount,
    this.status,
  });

  factory GetUserListResponseModel.fromJson(Map<String, dynamic> json) => GetUserListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<UserData>.from(json['data']!.map((x) => UserData.fromJson(x))),
    hasNextPage: json['hasNextPage'],
    totalPages: json['totalPages'],
    hasPreviousPage: json['hasPreviousPage'],
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
    'message': message,
    'totalCount': totalCount,
    'status': status,
  };
}
