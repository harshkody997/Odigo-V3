// To parse this JSON data, do
//
//     final notificationFilterModel = notificationFilterModelFromJson(jsonString);

import 'dart:convert';
import 'package:odigov3/framework/repository/notification/model/notification_list_response_model.dart';

NotificationFilterModel notificationFilterModelFromJson(String str) => NotificationFilterModel.fromJson(json.decode(str));

String notificationFilterModelToJson(NotificationFilterModel data) => json.encode(data.toJson());

class NotificationFilterModel {
  String? notificationDay;
  List<NotificationData>? notificationDayData;

  NotificationFilterModel({
    this.notificationDay,
    this.notificationDayData,
  });

  factory NotificationFilterModel.fromJson(Map<String, dynamic> json) => NotificationFilterModel(
    notificationDay: json['notificationDay'],
    notificationDayData: json['notificationDayData'] == null ? [] : List<NotificationData>.from(json['notificationDayData']!.map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'notificationDay': notificationDay,
    'notificationDayData': notificationDayData == null ? [] : List<dynamic>.from(notificationDayData!.map((x) => x.toJson())),
  };
}

