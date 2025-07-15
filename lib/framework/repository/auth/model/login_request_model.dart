// To parse this JSON data, do
//
//     final loginRequestModel = loginRequestModelFromJson(jsonString);

import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) => LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) => json.encode(data.toJson());

class LoginRequestModel {
  String? email;
  String? password;
  String? userType;

  LoginRequestModel({
    this.email,
    this.password,
    this.userType,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) => LoginRequestModel(
    email: json["email"],
    password: json["password"],
    userType: json["userType"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "userType": userType,
  };
}
