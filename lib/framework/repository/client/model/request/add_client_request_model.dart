// To parse this JSON data, do
//
//     final addClientRequestModel = addClientRequestModelFromJson(jsonString);

import 'dart:convert';

AddClientRequestModel addClientRequestModelFromJson(String str) =>
    AddClientRequestModel.fromJson(json.decode(str));

String addClientRequestModelToJson(AddClientRequestModel data) => json.encode(data.toJson());

class AddClientRequestModel {
  String? name;
  String? email;
  String? contactNumber;
  String? houseNumber;
  String? streetName;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? cityUuid;
  String? stateUuid;
  String? countryUuid;
  String? postalCode;

  AddClientRequestModel({
    this.name,
    this.email,
    this.contactNumber,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.cityUuid,
    this.stateUuid,
    this.countryUuid,
    this.postalCode,
  });

  factory AddClientRequestModel.fromJson(Map<String, dynamic> json) => AddClientRequestModel(
    name: json['name'],
    email: json['email'],
    contactNumber: json['contactNumber'],
    houseNumber: json['houseNumber'],
    streetName: json['streetName'],
    addressLine1: json['addressLine1'],
    addressLine2: json['addressLine2'],
    landmark: json['landmark'],
    cityUuid: json['cityUuid'],
    stateUuid: json['stateUuid'],
    countryUuid: json['countryUuid'],
    postalCode: json['postalCode'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'contactNumber': contactNumber,
    'houseNumber': houseNumber,
    'streetName': streetName,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'landmark': landmark,
    'cityUuid': cityUuid,
    'stateUuid': stateUuid,
    'countryUuid': countryUuid,
    'postalCode': postalCode,
  };
}
