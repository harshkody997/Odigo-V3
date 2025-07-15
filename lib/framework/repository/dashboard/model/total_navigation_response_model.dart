// To parse this JSON data, do
//
//     final totalNavigationRequestResponseModel = totalNavigationRequestResponseModelFromJson(jsonString);

import 'dart:convert';

TotalNavigationResponseModel totalNavigationResponseModelFromJson(String str) => TotalNavigationResponseModel.fromJson(json.decode(str));

String totalNavigationResponseModelToJson(TotalNavigationResponseModel data) => json.encode(data.toJson());

class TotalNavigationResponseModel {
  String? message;
  Map<String, NavRequestData>? data;
  int? status;

  TotalNavigationResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory TotalNavigationResponseModel.fromJson(Map<String, dynamic> json) => TotalNavigationResponseModel(
    message: json["message"],
    data: Map.from(json["data"]!).map((k, v) => MapEntry<String, NavRequestData>(k, NavRequestData.fromJson(v))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "status": status,
  };
}

class NavRequestData {
  String? dayOfWeek;
  double? success;
  double? failure;
  double? total;

  NavRequestData({
    this.dayOfWeek,
    this.success,
    this.failure,
    this.total,
  });

  factory NavRequestData.fromJson(Map<String, dynamic> json) => NavRequestData(
    dayOfWeek: json["dayOfWeek"],
    success: json["success"],
    failure: json["failure"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "dayOfWeek": dayOfWeek,
    "success": success,
    "failure": failure,
    "total": total,
  };
}
