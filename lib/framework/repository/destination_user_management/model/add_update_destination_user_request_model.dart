// To parse this JSON data, do
//
//     final addUpdateDestinationUserRequestModel = addUpdateDestinationUserRequestModelFromJson(jsonString);

import 'dart:convert';

AddUpdateDestinationUserRequestModel addUpdateDestinationUserRequestModelFromJson(String str) => AddUpdateDestinationUserRequestModel.fromJson(json.decode(str));

String addUpdateDestinationUserRequestModelToJson(AddUpdateDestinationUserRequestModel data) => json.encode(data.toJson());

class AddUpdateDestinationUserRequestModel {
  String? uuid;
  String? destinationUuid;
  String? name;
  String? email;
  String? contactNumber;
  String? password;

  AddUpdateDestinationUserRequestModel({
    this.uuid,
    this.destinationUuid,
    this.name,
    this.email,
    this.contactNumber,
    this.password,
  });

  factory AddUpdateDestinationUserRequestModel.fromJson(Map<String, dynamic> json) => AddUpdateDestinationUserRequestModel(
    uuid: json["uuid"],
    name: json["name"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "destinationUuid": destinationUuid,
    "name": name,
    "email": email,
    "contactNumber": contactNumber,
    "password": password,
  };
}
