// To parse this JSON data, do
//
//     final addClientResponseModel = addClientResponseModelFromJson(jsonString);

import 'dart:convert';

AddClientResponseModel addClientResponseModelFromJson(String str) => AddClientResponseModel.fromJson(json.decode(str));

String addClientResponseModelToJson(AddClientResponseModel data) => json.encode(data.toJson());

class AddClientResponseModel {
  String? message;
  Data? data;
  int? status;

  AddClientResponseModel({this.message, this.data, this.status});

  factory AddClientResponseModel.fromJson(Map<String, dynamic> json) => AddClientResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {'message': message, 'data': data?.toJson(), 'status': status};
}

class Data {
  String? uuid;
  String? name;
  String? email;
  String? contactNumber;
  String? password;
  String? houseNumber;
  String? streetName;
  dynamic addressLine1;
  dynamic addressLine2;
  String? landmark;
  String? cityUuid;
  String? stateUuid;
  String? countryUuid;
  String? countryName;
  String? countryCurrency;
  String? countryCode;
  String? stateName;
  String? cityName;
  String? postalCode;
  int? wallet;
  bool? active;

  Data({
    this.uuid,
    this.name,
    this.email,
    this.contactNumber,
    this.password,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.cityUuid,
    this.stateUuid,
    this.countryUuid,
    this.countryName,
    this.countryCurrency,
    this.countryCode,
    this.stateName,
    this.cityName,
    this.postalCode,
    this.wallet,
    this.active,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    uuid: json['uuid'],
    name: json['name'],
    email: json['email'],
    contactNumber: json['contactNumber'],
    password: json['password'],
    houseNumber: json['houseNumber'],
    streetName: json['streetName'],
    addressLine1: json['addressLine1'],
    addressLine2: json['addressLine2'],
    landmark: json['landmark'],
    cityUuid: json['cityUuid'],
    stateUuid: json['stateUuid'],
    countryUuid: json['countryUuid'],
    countryName: json['countryName'],
    countryCurrency: json['countryCurrency'],
    countryCode: json['countryCode'],
    stateName: json['stateName'],
    cityName: json['cityName'],
    postalCode: json['postalCode'],
    wallet: json['wallet'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'email': email,
    'contactNumber': contactNumber,
    'password': password,
    'houseNumber': houseNumber,
    'streetName': streetName,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'landmark': landmark,
    'cityUuid': cityUuid,
    'stateUuid': stateUuid,
    'countryUuid': countryUuid,
    'countryName': countryName,
    'countryCurrency': countryCurrency,
    'countryCode': countryCode,
    'stateName': stateName,
    'cityName': cityName,
    'postalCode': postalCode,
    'wallet': wallet,
    'active': active,
  };
}
