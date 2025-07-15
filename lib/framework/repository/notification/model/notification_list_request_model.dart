// To parse this JSON data, do
//
//     final notificationListRequestModel = notificationListRequestModelFromJson(jsonString);

import 'dart:convert';

NotificationListRequestModel notificationListRequestModelFromJson(String str) => NotificationListRequestModel.fromJson(json.decode(str));

String notificationListRequestModelToJson(NotificationListRequestModel data) => json.encode(data.toJson());

class NotificationListRequestModel {
  dynamic fromDate;
  dynamic toDate;
  dynamic currentDate;
  bool? isRead;

  NotificationListRequestModel({
    this.fromDate,
    this.toDate,
    this.currentDate,
    this.isRead,
  });

  factory NotificationListRequestModel.fromJson(Map<String, dynamic> json) => NotificationListRequestModel(
    fromDate: json['fromDate'],
    toDate: json['toDate'],
    currentDate: json['currentDate'],
    isRead: json['isRead'],
  );

  Map<String, dynamic> toJson() => {
    'fromDate': fromDate,
    'toDate': toDate,
    'currentDate': currentDate,
    'isRead': isRead,
  };
}
