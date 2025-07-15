// To parse this JSON data, do
//
//     final roleListResponseModel = roleListResponseModelFromJson(jsonString);

import 'dart:convert';

RoleListResponseModel roleListResponseModelFromJson(String str) => RoleListResponseModel.fromJson(json.decode(str));

String roleListResponseModelToJson(RoleListResponseModel data) => json.encode(data.toJson());

class RoleListResponseModel {
  int? pageNumber;
  List<RoleModel>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  RoleListResponseModel({
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

  factory RoleListResponseModel.fromJson(Map<String, dynamic> json) => RoleListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<RoleModel>.from(json["data"]!.map((x) => RoleModel.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    pageSize: json["pageSize"],
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
    "pageSize": pageSize,
    "message": message,
    "totalCount": totalCount,
    "status": status,
  };
}

class RoleModel {
  String? uuid;
  String? name;
  String? userType;
  String? createdBy;
  int? createdAt;
  String? description;
  String? updatedBy;
  int? updatedAt;
  bool? active;

  RoleModel({
    this.uuid,
    this.name,
    this.userType,
    this.createdBy,
    this.createdAt,
    this.description,
    this.updatedBy,
    this.updatedAt,
    this.active,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
    uuid: json["uuid"],
    name: json["name"],
    userType: json["userType"],
    createdBy: json["createdBy"],
    createdAt: json["createdAt"],
    description: json["description"],
    updatedBy: json["updatedBy"],
    updatedAt: json["updatedAt"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "userType": userType,
    "createdBy": createdBy,
    "createdAt": createdAt,
    "description": description,
    "updatedBy": updatedBy,
    "updatedAt": updatedAt,
    "active": active,
  };
}
