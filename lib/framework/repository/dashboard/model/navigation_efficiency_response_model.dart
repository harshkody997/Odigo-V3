// To parse this JSON data, do
//
//     final navigationEfficiencyResponseModel = navigationEfficiencyResponseModelFromJson(jsonString);

import 'dart:convert';

NavigationEfficiencyResponseModel navigationEfficiencyResponseModelFromJson(String str) => NavigationEfficiencyResponseModel.fromJson(json.decode(str));

String navigationEfficiencyResponseModelToJson(NavigationEfficiencyResponseModel data) => json.encode(data.toJson());

class NavigationEfficiencyResponseModel {
  String? message;
  double? data;
  int? status;

  NavigationEfficiencyResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory NavigationEfficiencyResponseModel.fromJson(Map<String, dynamic> json) => NavigationEfficiencyResponseModel(
    message: json['message'],
    data: json['data']?.toDouble(),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data,
    'status': status,
  };
}
