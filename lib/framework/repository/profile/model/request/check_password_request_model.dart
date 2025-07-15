// To parse this JSON data, do
//
//     final checkPasswordRequestModel = checkPasswordRequestModelFromJson(jsonString);

import 'dart:convert';

CheckPasswordRequestModel checkPasswordRequestModelFromJson(String str) => CheckPasswordRequestModel.fromJson(json.decode(str));

String checkPasswordRequestModelToJson(CheckPasswordRequestModel data) => json.encode(data.toJson());

class CheckPasswordRequestModel {
  String? password;

  CheckPasswordRequestModel({
    this.password,
  });

  factory CheckPasswordRequestModel.fromJson(Map<String, dynamic> json) => CheckPasswordRequestModel(
    password: json['password'],
  );

  Map<String, dynamic> toJson() => {
    'password': password,
  };
}
