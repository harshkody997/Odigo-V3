// To parse this JSON data, do
//
//     final stateDetailsResponseModel = stateDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

StateDetailsResponseModel stateDetailsResponseModelFromJson(String str) => StateDetailsResponseModel.fromJson(json.decode(str));

String stateDetailsResponseModelToJson(StateDetailsResponseModel data) => json.encode(data.toJson());

class StateDetailsResponseModel {
  String? message;
  StateDetailsModel? data;
  int? status;

  StateDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory StateDetailsResponseModel.fromJson(Map<String, dynamic> json) => StateDetailsResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : StateDetailsModel.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class StateDetailsModel {
  String? uuid;
  List<StateValue>? stateValues;
  String? countryUuid;
  String? countryName;
  bool? active;

  StateDetailsModel({
    this.uuid,
    this.stateValues,
    this.countryUuid,
    this.countryName,
    this.active,
  });

  factory StateDetailsModel.fromJson(Map<String, dynamic> json) => StateDetailsModel(
    uuid: json["uuid"],
    stateValues: json["stateValues"] == null ? [] : List<StateValue>.from(json["stateValues"]!.map((x) => StateValue.fromJson(x))),
    countryUuid: json["countryUuid"],
    countryName: json["countryName"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "stateValues": stateValues == null ? [] : List<dynamic>.from(stateValues!.map((x) => x.toJson())),
    "countryUuid": countryUuid,
    "countryName": countryName,
    "active": active,
  };
}

class StateValue {
  String? languageUuid;
  String? languageName;
  String? uuid;
  String? name;

  StateValue({
    this.languageUuid,
    this.languageName,
    this.uuid,
    this.name,
  });

  factory StateValue.fromJson(Map<String, dynamic> json) => StateValue(
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
