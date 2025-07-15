// To parse this JSON data, do
//
//     final addEditStateResponseModel = addEditStateResponseModelFromJson(jsonString);

import 'dart:convert';

AddEditStateResponseModel addEditStateResponseModelFromJson(String str) => AddEditStateResponseModel.fromJson(json.decode(str));

String addEditStateResponseModelToJson(AddEditStateResponseModel data) => json.encode(data.toJson());

class AddEditStateResponseModel {
  String? message;
  AddEditStateData? data;
  int? status;

  AddEditStateResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory AddEditStateResponseModel.fromJson(Map<String, dynamic> json) => AddEditStateResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : AddEditStateData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class AddEditStateData {
  String? uuid;
  List<StateValue>? stateValues;
  String? countryUuid;
  String? countryName;
  bool? active;

  AddEditStateData({
    this.uuid,
    this.stateValues,
    this.countryUuid,
    this.countryName,
    this.active,
  });

  factory AddEditStateData.fromJson(Map<String, dynamic> json) => AddEditStateData(
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
