// To parse this JSON data, do
//
//     final addUserRequestModel = addUserRequestModelFromJson(jsonString);

import 'dart:convert';

AddUserRequestModel addUserRequestModelFromJson(String str) => AddUserRequestModel.fromJson(json.decode(str));

String addUserRequestModelToJson(AddUserRequestModel data) => json.encode(data.toJson());

class AddUserRequestModel {
  String? name;
  String? contactNumber;
  String? email;
  String? roleUuid;
  String? password;

  AddUserRequestModel({this.name, this.contactNumber, this.email, this.roleUuid, this.password});

  factory AddUserRequestModel.fromJson(Map<String, dynamic> json) => AddUserRequestModel(
    name: json['name'],
    contactNumber: json['contactNumber'],
    email: json['email'],
    roleUuid: json['roleUuid'],
    password: json['password'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'contactNumber': contactNumber,
    'email': email,
    'roleUuid': roleUuid,
    'password': password,
  };
}
