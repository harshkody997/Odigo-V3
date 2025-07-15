// To parse this JSON data, do
//
//     final addEditDestinationTypeResponseModel = addEditDestinationTypeResponseModelFromJson(jsonString);

import 'dart:convert';

AddEditDestinationTypeResponseModel addEditDestinationTypeResponseModelFromJson(String str) => AddEditDestinationTypeResponseModel.fromJson(json.decode(str));

String addEditDestinationTypeResponseModelToJson(AddEditDestinationTypeResponseModel data) => json.encode(data.toJson());

class AddEditDestinationTypeResponseModel {
  String message;
  AddEditDestinationTypeModel data;
  int status;

  AddEditDestinationTypeResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory AddEditDestinationTypeResponseModel.fromJson(Map<String, dynamic> json) => AddEditDestinationTypeResponseModel(
    message: json['message'],
    data: AddEditDestinationTypeModel.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data.toJson(),
    'status': status,
  };
}

class AddEditDestinationTypeModel {
  String uuid;
  List<DestinationTypeValue> destinationTypeValues;
  bool active;

  AddEditDestinationTypeModel({
    required this.uuid,
    required this.destinationTypeValues,
    required this.active,
  });

  factory AddEditDestinationTypeModel.fromJson(Map<String, dynamic> json) => AddEditDestinationTypeModel(
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
