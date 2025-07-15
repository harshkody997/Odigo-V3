// To parse this JSON data, do
//
//     final robotDataListResponseModel = robotDataListResponseModelFromJson(jsonString);

import 'dart:convert';

RobotDataListResponseModel robotDataListResponseModelFromJson(String str) => RobotDataListResponseModel.fromJson(json.decode(str));

String robotDataListResponseModelToJson(RobotDataListResponseModel data) => json.encode(data.toJson());

class RobotDataListResponseModel {
  int? pageNumber;
  List<RobotDataListDto>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  String? message;
  int? totalCount;
  int? status;

  RobotDataListResponseModel({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.message,
    this.totalCount,
    this.status,
  });

  factory RobotDataListResponseModel.fromJson(Map<String, dynamic> json) => RobotDataListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<RobotDataListDto>.from(json["data"]!.map((x) => RobotDataListDto.fromJson(x))),
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

class RobotDataListDto {
  String? uuid;
  String? hostName;
  String? serialNumber;

  RobotDataListDto({
    this.uuid,
    this.hostName,
    this.serialNumber,
  });

  factory RobotDataListDto.fromJson(Map<String, dynamic> json) => RobotDataListDto(
    uuid: json["uuid"],
    hostName: json["hostName"],
    serialNumber: json["serialNumber"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "hostName": hostName,
    "serialNumber": serialNumber,
  };
}
