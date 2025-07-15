// To parse this JSON data, do
//
//     final resendOtpRequestModel = resendOtpRequestModelFromJson(jsonString);

import 'dart:convert';

SendOtpRequestModel sendOtpRequestModelFromJson(String str) => SendOtpRequestModel.fromJson(json.decode(str));

String sendOtpRequestModelToJson(SendOtpRequestModel data) => json.encode(data.toJson());

class SendOtpRequestModel {
  String? uuid;
  String? email;
  String? contactNumber;
  String? userType;
  String? type;
  String? sendingType;
  bool? verifyBeforeGenerate;

  SendOtpRequestModel({
    this.uuid,
    this.email,
    this.contactNumber,
    this.userType,
    this.type,
    this.sendingType,
    this.verifyBeforeGenerate,
  });

  factory SendOtpRequestModel.fromJson(Map<String, dynamic> json) => SendOtpRequestModel(
    uuid: json['uuid'],
    email: json['email'],
    contactNumber: json['contactNumber'],
    userType: json['userType'],
    type: json['type'],
    sendingType: json['sendingType'],
    verifyBeforeGenerate: json['verifyBeforeGenerate'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid ?? '',
    'email': email ?? '',
    'contactNumber': contactNumber ?? '',
    'userType': userType ?? '',
    'type': type ?? '',
    'sendingType': sendingType ?? '',
    'verifyBeforeGenerate': verifyBeforeGenerate ?? false,
  };
}
