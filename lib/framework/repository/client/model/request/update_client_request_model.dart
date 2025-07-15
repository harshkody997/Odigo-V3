// To parse this JSON data, do
//
//     final updateClientRequestModel = updateClientRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateClientRequestModel updateClientRequestModelFromJson(String str) => UpdateClientRequestModel.fromJson(json.decode(str));

String updateClientRequestModelToJson(UpdateClientRequestModel data) => json.encode(data.toJson());

class UpdateClientRequestModel {
  String? uuid;
  String? name;
  String? email;
  String? contactNumber;
  String? houseNumber;
  String? streetName;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? postalCode;

  UpdateClientRequestModel({
    this.uuid,
    this.name,
    this.email,
    this.contactNumber,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.postalCode,
  });

  factory UpdateClientRequestModel.fromJson(Map<String, dynamic> json) => UpdateClientRequestModel(
    uuid: json['uuid'],
    name: json['name'],
    email: json['email'],
    contactNumber: json['contactNumber'],
    houseNumber: json['houseNumber'],
    streetName: json['streetName'],
    addressLine1: json['addressLine1'],
    addressLine2: json['addressLine2'],
    landmark: json['landmark'],
    postalCode: json['postalCode'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'email': email,
    'contactNumber': contactNumber,
    'houseNumber': houseNumber,
    'streetName': streetName,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'landmark': landmark,
    'postalCode': postalCode,
  };
}
