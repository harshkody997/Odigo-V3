// To parse this JSON data, do
//
//     final floorListResponseModel = floorListResponseModelFromJson(jsonString);

import 'dart:convert';

FloorListResponseModel floorListResponseModelFromJson(String str) => FloorListResponseModel.fromJson(json.decode(str));

String floorListResponseModelToJson(FloorListResponseModel data) => json.encode(data.toJson());

class FloorListResponseModel {
  String? message;
  List<FloorListDto>? data;
  int? status;

  FloorListResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory FloorListResponseModel.fromJson(Map<String, dynamic> json) => FloorListResponseModel(
    message: json["message"],
    data: json["data"] == null ? [] : List<FloorListDto>.from(json["data"]!.map((x) => FloorListDto.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status,
  };
}

class FloorListDto {
  String? uuid;
  String? name;
  int? floorNumber;
  bool? active;

  FloorListDto({
    this.uuid,
    this.name,
    this.floorNumber,
    this.active,
  });

  factory FloorListDto.fromJson(Map<String, dynamic> json) => FloorListDto(
    uuid: json["uuid"],
    name: json["name"],
    floorNumber: json["floorNumber"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "floorNumber": floorNumber,
    "active": active,
  };
}
