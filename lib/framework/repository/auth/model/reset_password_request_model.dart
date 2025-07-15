// To parse this JSON data, do
//
//     final resetPasswordRequestModel = resetPasswordRequestModelFromJson(jsonString);

import 'dart:convert';

ResetPasswordRequestModel resetPasswordRequestModelFromJson(String str) => ResetPasswordRequestModel.fromJson(json.decode(str));

String resetPasswordRequestModelToJson(ResetPasswordRequestModel data) => json.encode(data.toJson());

class ResetPasswordRequestModel {
  String email;
  String userType;
  String type;
  String? otp;
  String? password;
  String? sendingType;
  bool? verifyBeforeGenerate;

  ResetPasswordRequestModel({
    required this.email,
    required this.userType,
    required this.type,
     this.otp,
     this.password,
     this.sendingType,
     this.verifyBeforeGenerate,
  });

  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) => ResetPasswordRequestModel(
    email: json['email'],
    userType: json['userType'],
    type: json['type'],
    otp: json['otp'],
    password: json['password'],
    sendingType: json['sendingType'],
    verifyBeforeGenerate: json['verifyBeforeGenerate'],
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'userType': userType,
    'type': type,
    'otp': otp,
    'password': password,
    'sendingType': sendingType,
    'verifyBeforeGenerate': verifyBeforeGenerate,
  };
}
