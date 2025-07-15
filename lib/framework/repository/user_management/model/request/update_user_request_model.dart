// To parse this JSON data, do
//
//     final updateUserRequestModel = updateUserRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateUserRequestModel updateUserRequestModelFromJson(String str) => UpdateUserRequestModel.fromJson(json.decode(str));

String updateUserRequestModelToJson(UpdateUserRequestModel data) => json.encode(data.toJson());

class UpdateUserRequestModel {
  String? uuid;
  String? name;
  String? contactNumber;
  String? email;
  String? roleUuid;

  UpdateUserRequestModel({this.uuid, this.name, this.contactNumber, this.email, this.roleUuid});

  factory UpdateUserRequestModel.fromJson(Map<String, dynamic> json) => UpdateUserRequestModel(
    uuid: json['uuid'],
    name: json['name'],
    contactNumber: json['contactNumber'],
    email: json['email'],
    roleUuid: json['roleUuid'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'contactNumber': contactNumber,
    'email': email,
    'roleUuid': roleUuid,
  };
}
