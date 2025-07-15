// To parse this JSON data, do
//
//     final destinationUserListResponseModel = destinationUserListResponseModelFromJson(jsonString);

import 'dart:convert';

DestinationUserListResponseModel destinationUserListResponseModelFromJson(String str) => DestinationUserListResponseModel.fromJson(json.decode(str));

String destinationUserListResponseModelToJson(DestinationUserListResponseModel data) => json.encode(data.toJson());

class DestinationUserListResponseModel {
  int? pageNumber;
  List<DestinationUserData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  String? message;
  int? totalCount;
  int? status;

  DestinationUserListResponseModel({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.message,
    this.totalCount,
    this.status,
  });

  factory DestinationUserListResponseModel.fromJson(Map<String, dynamic> json) => DestinationUserListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<DestinationUserData>.from(json["data"]!.map((x) => DestinationUserData.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    message: json["message"],
    totalCount: json["totalCount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "hasNextPage": hasNextPage,
    "totalPages": totalPages,
    "hasPreviousPage": hasPreviousPage,
    "message": message,
    "totalCount": totalCount,
    "status": status,
  };
}

class DestinationUserData {
  String? uuid;
  String? destinationUuid;
  String? destinationName;
  String? name;
  String? email;
  String? contactNumber;
  dynamic password;
  bool? active;

  DestinationUserData({
    this.uuid,
    this.destinationUuid,
    this.destinationName,
    this.name,
    this.email,
    this.contactNumber,
    this.password,
    this.active,
  });

  factory DestinationUserData.fromJson(Map<String, dynamic> json) => DestinationUserData(
    uuid: json["uuid"],
    destinationUuid: json["destinationUuid"],
    destinationName: json["destinationName"],
    name: json["name"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    password: json["password"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "destinationUuid": destinationUuid,
    "destinationName": destinationName,
    "name": name,
    "email": email,
    "contactNumber": contactNumber,
    "password": password,
    "active": active,
  };
}
