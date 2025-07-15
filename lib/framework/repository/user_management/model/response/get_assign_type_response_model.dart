// To parse this JSON data, do
//
//     final getAssignTypeResponseModel = getAssignTypeResponseModelFromJson(jsonString);

import 'dart:convert';

GetAssignTypeResponseModel getAssignTypeResponseModelFromJson(String str) =>
    GetAssignTypeResponseModel.fromJson(json.decode(str));

String getAssignTypeResponseModelToJson(GetAssignTypeResponseModel data) => json.encode(data.toJson());

class GetAssignTypeResponseModel {
  int? pageNumber;
  List<AssignType>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  GetAssignTypeResponseModel({
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

  factory GetAssignTypeResponseModel.fromJson(Map<String, dynamic> json) => GetAssignTypeResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<AssignType>.from(json["data"]!.map((x) => AssignType.fromJson(x))),
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

class AssignType {
  String? uuid;
  String? name;
  String? userType;
  String? createdBy;
  int? createdAt;
  String? description;
  String? updatedBy;
  int? updatedAt;
  bool? active;

  AssignType({
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

  factory AssignType.fromJson(Map<String, dynamic> json) => AssignType(
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
