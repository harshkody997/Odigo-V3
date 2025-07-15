// To parse this JSON data, do
//
//     final stateListResponseModel = stateListResponseModelFromJson(jsonString);

import 'dart:convert';

StateListResponseModel stateListResponseModelFromJson(String str) => StateListResponseModel.fromJson(json.decode(str));

String stateListResponseModelToJson(StateListResponseModel data) => json.encode(data.toJson());

class StateListResponseModel {
  int? pageNumber;
  List<StateModel>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  StateListResponseModel({
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

  factory StateListResponseModel.fromJson(Map<String, dynamic> json) => StateListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<StateModel>.from(json["data"]!.map((x) => StateModel.fromJson(x))),
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

class StateModel {
  String? uuid;
  String? name;
  String? countryUuid;
  String? countryName;
  bool? active;

  StateModel({
    this.uuid,
    this.name,
    this.countryUuid,
    this.countryName,
    this.active,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
    uuid: json["uuid"],
    name: json["name"],
    countryUuid: json["countryUuid"],
    countryName: json["countryName"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "countryUuid": countryUuid,
    "countryName": countryName,
    "active": active,
  };
}
