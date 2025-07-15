// To parse this JSON data, do
//
//     final updateDestinationUserPasswordRequestModel = updateDestinationUserPasswordRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateDestinationUserPasswordRequestModel updateDestinationUserPasswordRequestModelFromJson(String str) => UpdateDestinationUserPasswordRequestModel.fromJson(json.decode(str));

String updateDestinationUserPasswordRequestModelToJson(UpdateDestinationUserPasswordRequestModel data) => json.encode(data.toJson());

class UpdateDestinationUserPasswordRequestModel {
  String? uuid;
  String? password;

  UpdateDestinationUserPasswordRequestModel({
    this.uuid,
    this.password,
  });

  factory UpdateDestinationUserPasswordRequestModel.fromJson(Map<String, dynamic> json) => UpdateDestinationUserPasswordRequestModel(
    uuid: json["uuid"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "password": password,
  };
}
