// To parse this JSON data, do
//
//     final userListRequestModel = userListRequestModelFromJson(jsonString);

import 'dart:convert';

UserListRequestModel userListRequestModelFromJson(String str) => UserListRequestModel.fromJson(json.decode(str));

String userListRequestModelToJson(UserListRequestModel data) => json.encode(data.toJson());

class UserListRequestModel {
  String? uuid;
  String? firstName;
  String? lastName;
  String? email;
  String? contactNumber;
  String? roleUuid;
  String? password;
  String? status;

  UserListRequestModel({
    this.uuid,
    this.firstName,
    this.lastName,
    this.email,
    this.contactNumber,
    this.roleUuid,
    this.password,
    this.status,
  });

  factory UserListRequestModel.fromJson(Map<String, dynamic> json) => UserListRequestModel(
    uuid: json["uuid"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    roleUuid: json["roleUuid"],
    password: json["password"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "contactNumber": contactNumber,
    "roleUuid": roleUuid,
    "password": password,
    "status": status,
  };
}
