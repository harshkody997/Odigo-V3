// To parse this JSON data, do
//
//     final notificationListResponseModel = notificationListResponseModelFromJson(jsonString);

import 'dart:convert';

NotificationListResponseModel notificationListResponseModelFromJson(String str) => NotificationListResponseModel.fromJson(json.decode(str));

String notificationListResponseModelToJson(NotificationListResponseModel data) => json.encode(data.toJson());

class NotificationListResponseModel {
  int? pageNumber;
  List<NotificationData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  NotificationListResponseModel({
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

  factory NotificationListResponseModel.fromJson(Map<String, dynamic> json) => NotificationListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<NotificationData>.from(json['data']!.map((x) => NotificationData.fromJson(x))),
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

class NotificationData {
  int? id;
  String? uuid;
  String? message;
  int? createdAt;
  String? module;
  dynamic moduleId;
  dynamic moduleUuid;
  dynamic orderType;
  dynamic storeId;
  dynamic chatType;

  NotificationData({
    this.id,
    this.uuid,
    this.message,
    this.createdAt,
    this.module,
    this.moduleId,
    this.moduleUuid,
    this.orderType,
    this.storeId,
    this.chatType,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    id: json['id'],
    uuid: json['uuid'],
    message: json['message'],
   // createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    createdAt: json['createdAt'],
    module: json['module'],
    moduleId: json['moduleId'],
    moduleUuid: json['moduleUuid'],
    orderType: json['orderType'],
    storeId: json['storeId'],
    chatType: json['chatType'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'uuid': uuid,
    'message': message,
    'createdAt': createdAt,
    'module': module,
    'moduleId': moduleId,
    'moduleUuid': moduleUuid,
    'orderType': orderType,
    'storeId': storeId,
    'chatType': chatType,
  };
}
