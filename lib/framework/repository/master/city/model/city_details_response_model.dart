// To parse this JSON data, do
//
//     final cityDetailsResponseModel = cityDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

CityDetailsResponseModel cityDetailsResponseModelFromJson(String str) => CityDetailsResponseModel.fromJson(json.decode(str));

String cityDetailsResponseModelToJson(CityDetailsResponseModel data) => json.encode(data.toJson());

class CityDetailsResponseModel {
  String? message;
  CityDetailsModel? data;
  int? status;

  CityDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory CityDetailsResponseModel.fromJson(Map<String, dynamic> json) => CityDetailsResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : CityDetailsModel.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class CityDetailsModel {
  String? uuid;
  List<CityValue>? cityValues;
  String? stateUuid;
  String? stateName;
  String? countryUuid;
  String? countryName;
  bool? active;

  CityDetailsModel({
    this.uuid,
    this.cityValues,
    this.stateUuid,
    this.stateName,
    this.countryUuid,
    this.countryName,
    this.active,
  });

  factory CityDetailsModel.fromJson(Map<String, dynamic> json) => CityDetailsModel(
    uuid: json["uuid"],
    cityValues: json["cityValues"] == null ? [] : List<CityValue>.from(json["cityValues"]!.map((x) => CityValue.fromJson(x))),
    stateUuid: json["stateUuid"],
    stateName: json["stateName"],
    countryUuid: json["countryUuid"],
    countryName: json["countryName"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "cityValues": cityValues == null ? [] : List<dynamic>.from(cityValues!.map((x) => x.toJson())),
    "stateUuid": stateUuid,
    "stateName": stateName,
    "countryUuid": countryUuid,
    "countryName": countryName,
    "active": active,
  };
}

class CityValue {
  String? languageUuid;
  String? languageName;
  String? uuid;
  String? name;

  CityValue({
    this.languageUuid,
    this.languageName,
    this.uuid,
    this.name,
  });

  factory CityValue.fromJson(Map<String, dynamic> json) => CityValue(
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
