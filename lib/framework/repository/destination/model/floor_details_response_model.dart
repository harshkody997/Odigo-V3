// To parse this JSON data, do
//
//     final floorDetailsResponseModel = floorDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/destination/model/request/update_floor_request_model.dart';

FloorDetailsResponseModel floorDetailsResponseModelFromJson(String str) => FloorDetailsResponseModel.fromJson(json.decode(str));

String floorDetailsResponseModelToJson(FloorDetailsResponseModel data) => json.encode(data.toJson());

class FloorDetailsResponseModel {
  String? message;
  FloorDetailsDto? data;
  int? status;

  FloorDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory FloorDetailsResponseModel.fromJson(Map<String, dynamic> json) => FloorDetailsResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : FloorDetailsDto.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class FloorDetailsDto {
  String? uuid;
  int? floorNumber;
  List<DestinationFloorValue>? destinationFloorValues;
  bool? active;

  FloorDetailsDto({
    this.uuid,
    this.floorNumber,
    this.destinationFloorValues,
    this.active,
  });

  factory FloorDetailsDto.fromJson(Map<String, dynamic> json) => FloorDetailsDto(
    uuid: json["uuid"],
    floorNumber: json["floorNumber"],
    destinationFloorValues: json["destinationFloorValues"] == null ? [] : List<DestinationFloorValue>.from(json["destinationFloorValues"]!.map((x) => DestinationFloorValue.fromJson(x))),
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "floorNumber": floorNumber,
    "destinationFloorValues": destinationFloorValues == null ? [] : List<dynamic>.from(destinationFloorValues!.map((x) => x.toJson())),
    "active": active,
  };
}