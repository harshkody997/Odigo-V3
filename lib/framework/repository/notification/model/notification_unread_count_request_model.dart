// To parse this JSON data, do
//
//     final notificationUnReadCountRequestModel = notificationUnReadCountRequestModelFromJson(jsonString);

import 'dart:convert';

NotificationUnReadCountRequestModel notificationUnReadCountRequestModelFromJson(String str) => NotificationUnReadCountRequestModel.fromJson(json.decode(str));

String notificationUnReadCountRequestModelToJson(NotificationUnReadCountRequestModel data) => json.encode(data.toJson());

class NotificationUnReadCountRequestModel {
    dynamic fromDate;
    dynamic toDate;
    dynamic currentDate;
    dynamic receiverId;
    bool? isRead;

    NotificationUnReadCountRequestModel({
        this.fromDate,
        this.toDate,
        this.currentDate,
        this.receiverId,
        this.isRead,
    });

    factory NotificationUnReadCountRequestModel.fromJson(Map<String, dynamic> json) => NotificationUnReadCountRequestModel(
        fromDate: json['fromDate'],
        toDate: json['toDate'],
        currentDate: json['currentDate'],
        receiverId: json['receiverId'],
        isRead: json['isRead'],
    );

    Map<String, dynamic> toJson() => {
        'fromDate': fromDate,
        'toDate': toDate,
        'currentDate': currentDate,
        'receiverId': receiverId,
        'isRead': isRead,
    };
}
