// To parse this JSON data, do
//
//     final updateFloorRequestModel = updateFloorRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateFloorRequestModel updateFloorRequestModelFromJson(String str) => UpdateFloorRequestModel.fromJson(json.decode(str));

String updateFloorRequestModelToJson(UpdateFloorRequestModel data) => json.encode(data.toJson());

class UpdateFloorRequestModel {
  String? uuid;
  int? floorNumber;
  List<DestinationFloorValue>? destinationFloorValues;
  bool? active;

  UpdateFloorRequestModel({
    this.uuid,
    this.floorNumber,
    this.destinationFloorValues,
    this.active,
  });

  factory UpdateFloorRequestModel.fromJson(Map<String, dynamic> json) => UpdateFloorRequestModel(
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

class DestinationFloorValue {
  String? languageUuid;
  String? languageName;
  String? uuid;
  String? name;

  DestinationFloorValue({
    this.languageUuid,
    this.languageName,
    this.uuid,
    this.name,
  });

  factory DestinationFloorValue.fromJson(Map<String, dynamic> json) => DestinationFloorValue(
    languageUuid: json["languageUuid"],
    languageName: json["languageName"],
    uuid: json["uuid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "languageUuid": languageUuid,
    "languageName": languageName,
    "uuid": uuid,
    "name": name,
  };
}
