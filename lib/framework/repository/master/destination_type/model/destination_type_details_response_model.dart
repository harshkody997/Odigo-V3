// To parse this JSON data, do
//
//     final destinationTypeDetailsResponseModel = destinationTypeDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

DestinationTypeDetailsResponseModel destinationTypeDetailsResponseModelFromJson(String str) => DestinationTypeDetailsResponseModel.fromJson(json.decode(str));

String destinationTypeDetailsResponseModelToJson(DestinationTypeDetailsResponseModel data) => json.encode(data.toJson());

class DestinationTypeDetailsResponseModel {
  String message;
  DestinationTypeDetailsModel data;
  int status;

  DestinationTypeDetailsResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory DestinationTypeDetailsResponseModel.fromJson(Map<String, dynamic> json) => DestinationTypeDetailsResponseModel(
    message: json['message'],
    data: DestinationTypeDetailsModel.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data.toJson(),
    'status': status,
  };
}

class DestinationTypeDetailsModel {
  String uuid;
  List<DestinationTypeValue> destinationTypeValues;
  bool active;

  DestinationTypeDetailsModel({
    required this.uuid,
    required this.destinationTypeValues,
    required this.active,
  });

  factory DestinationTypeDetailsModel.fromJson(Map<String, dynamic> json) => DestinationTypeDetailsModel(
    uuid: json['uuid'],
    destinationTypeValues: List<DestinationTypeValue>.from(json['destinationTypeValues'].map((x) => DestinationTypeValue.fromJson(x))),
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'destinationTypeValues': List<dynamic>.from(destinationTypeValues.map((x) => x.toJson())),
    'active': active,
  };
}

class DestinationTypeValue {
  String languageUuid;
  String languageName;
  String uuid;
  String name;

  DestinationTypeValue({
    required this.languageUuid,
    required this.languageName,
    required this.uuid,
    required this.name,
  });

  factory DestinationTypeValue.fromJson(Map<String, dynamic> json) => DestinationTypeValue(
    languageUuid: json['languageUuid'],
    languageName: json['languageName'],
    uuid: json['uuid'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'languageUuid': languageUuid,
    'languageName': languageName,
    'uuid': uuid,
    'name': name,
  };
}
