// To parse this JSON data, do
//
//     final deviceDetailsResponseModel = deviceDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/device/model/device_list_model.dart';

DeviceDetailsResponseModel deviceDetailsResponseModelFromJson(String str) => DeviceDetailsResponseModel.fromJson(json.decode(str));

String deviceDetailsResponseModelToJson(DeviceDetailsResponseModel data) => json.encode(data.toJson());

class DeviceDetailsResponseModel {
  String? message;
  DeviceData? data;
  int? status;

  DeviceDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory DeviceDetailsResponseModel.fromJson(Map<String, dynamic> json) => DeviceDetailsResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : DeviceData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}
