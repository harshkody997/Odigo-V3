// To parse this JSON data, do
//
//     final forgotPasswordRequestModel = forgotPasswordRequestModelFromJson(jsonString);

import 'dart:convert';

ForgotPasswordRequestModel forgotPasswordRequestModelFromJson(String str) => ForgotPasswordRequestModel.fromJson(json.decode(str));

String forgotPasswordRequestModelToJson(ForgotPasswordRequestModel data) => json.encode(data.toJson());

class ForgotPasswordRequestModel {
  String? email;
  String? userType;
  String? type;
  String? sendingType;

  ForgotPasswordRequestModel({
    this.email,
    this.userType,
    this.type,
    this.sendingType,
  });

  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) => ForgotPasswordRequestModel(
    email: json['email'],
    userType: json['userType'],
    type: json['type'],
    sendingType: json['sendingType'],
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'userType': userType,
    'type': type,
    'sendingType': sendingType,
  };
}
