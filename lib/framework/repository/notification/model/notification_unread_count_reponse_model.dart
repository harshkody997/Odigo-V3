// To parse this JSON data, do
//
//     final notificationUnReadCountResponseModel = notificationUnReadCountResponseModelFromJson(jsonString);

import 'dart:convert';

NotificationUnReadCountResponseModel notificationUnReadCountResponseModelFromJson(String str) => NotificationUnReadCountResponseModel.fromJson(json.decode(str));

String notificationUnReadCountResponseModelToJson(NotificationUnReadCountResponseModel data) => json.encode(data.toJson());

class NotificationUnReadCountResponseModel {
  String? message;
  int? data;
  int? status;

  NotificationUnReadCountResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory NotificationUnReadCountResponseModel.fromJson(Map<String, dynamic> json) => NotificationUnReadCountResponseModel(
    message: json['message'],
    data: json['data'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data,
    'status': status,
  };
}
